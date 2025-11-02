//
//  DictionaryService.swift
//  Word Scanner
//
//  Created by Navya Bajwa on 2025-11-01.
//

import Foundation

class DictionaryService {
    static let shared = DictionaryService()
    
    private let baseURL = "https://api.dictionaryapi.dev/api/v2/entries/en"
    
    private init() {}
    
    func searchWord(_ word: String) async throws -> [Definition] {
        let urlString = "\(baseURL)/\(word)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Check response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        // Handle 404 (word not found)
        if httpResponse.statusCode == 404 {
            throw DictionaryError.wordNotFound
        }
                
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
                
        // Decode JSON
        let decoder = JSONDecoder()
        let entries = try decoder.decode([Definition].self, from: data)
                
        return entries
  
    }
    
}

enum DictionaryError: LocalizedError {
    case wordNotFound
    
    var errorDescription: String? {
        switch self {
        case .wordNotFound:
            return "Word not found in dictionary"
        }
    }
}
