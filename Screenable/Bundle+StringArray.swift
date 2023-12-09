//
//  Bundle-StringArray.swift
//  Screenable
//
//  Created by user on 2023/11/18.
//

import Foundation

extension Bundle {
    func loadStringArray(from file: String) -> [String] {
        // more code to come
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        guard let string = try? String(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        return string.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
    }
}
