//
//  main.swift
//  TextParser
//
//  Created by Haoran Wang on 2023/9/3.
//

import Foundation
import NaturalLanguage
import ArgumentParser

@main
struct App: ParsableCommand {
    @Argument(help: "The text you want to analyze")
    var input: [String]
    
    @Flag(name: .shortAndLong, help: "Show detected language")
    var detectLanguage: Bool = false
    
    @Flag(name: .shortAndLong, help: "Print how positive or negative the input is")
    var sentimentAnalysis: Bool = false
    
    @Flag(name: .shortAndLong, help: "Show the stem form of each word in the input")
    var lemmatize: Bool = false
    
    @Flag(name: .shortAndLong, help: "Print alternative word for each word in the input")
    var alternatives: Bool = false
    
    @Flag(name: .shortAndLong, help: "Print names of people, place and organization in the input")
    var names: Bool = false
    
    @Option(name: .shortAndLong, help: "The maximum number of alternatives to suggest")
    var maxAlternatives = 10
    
    static var configuration: CommandConfiguration {
        CommandConfiguration(commandName: "analyze", abstract: "Analyzes input text using a range of natural language approaches.")
    }
    
    mutating func run() {
        
        if !(detectLanguage || sentimentAnalysis || lemmatize || alternatives || names) {
            detectLanguage = true
            sentimentAnalysis = true
            lemmatize = true
            alternatives = true
            names = true
        }
        
        let text = input.joined(separator: " ")
        
        if detectLanguage {
            let language = NLLanguageRecognizer.dominantLanguage(for: text) ?? .undetermined
            print("\nDetected language: \(language.rawValue)")
        }
        
        
        if sentimentAnalysis {
            print("\nSentiment analysis: \(sentiment(for: text))")
        }
        
        lazy var lemma = lemmatize(string: text)

        if lemmatize {
            print("\nFound the following lemma:")
            print("\t", lemma.formatted(.list(type: .and)))
        }
        
        if alternatives {
            let embedding = text.components(separatedBy: " ")
            print("\nFound the following alternatives:")
            for word in lemma {
                print("\t\(word)", embeddings(for: word).formatted(.list(type: .and)))
            }
        }
        
        if names {
            let entities = entities(for: text)
            print("\nFound the following entities:")
            for entity in entities {
                print("\t\(entity)")
            }
        }
        
    }
    
    func sentiment(for string: String) -> Double {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = string
        let (sentiment, _) = tagger.tag(at: string.startIndex, unit: .paragraph, scheme: .sentimentScore)
        return Double(sentiment?.rawValue ?? "0") ?? 0
    }
    
    func embeddings(for word: String) -> [String] {
        var result = [String]()
        if let embedding = NLEmbedding.wordEmbedding(for: .english) {
            let similarWords = embedding.neighbors(for: word, maximumCount: maxAlternatives)
            for word in similarWords {
                result.append("\(word.0) > \(word.1)")
            }
        }
        return result
    }
    
    func lemmatize(string: String) -> [String] {
        let tagger = NLTagger(tagSchemes: [.lemma])
        tagger.string = string
        var result = [String]()
        tagger.enumerateTags(in: string.startIndex..<string.endIndex, unit: .word, scheme: .lemma) { tag, range in
            let stemForm = tag?.rawValue ?? String(string[range]).trimmingCharacters(in: .whitespaces)
            if stemForm.isEmpty == false {
                result.append(stemForm)
            }
            return true
        }
        return result
    }
    
    func entities(for string: String) -> [String]{
        let tagger = NLTagger(tagSchemes: [.nameType])
        tagger.string = string
        var result = [String]()
        tagger.enumerateTags(in: string.startIndex..<string.endIndex, unit: .word, scheme: .nameType, options: .joinNames) { tag, range in
            guard let tag = tag else { return true }
            let match = String(string[range])
            switch tag {
            case .placeName: result.append("Place: \(match)")
            case .personalName: result.append("Person: \(match)")
            case .organizationName: result.append("Organization: \(match)")
            default: break
            }
            return true
        }
        
        return result
    }
}

