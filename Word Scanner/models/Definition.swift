//
//  Definition.swift
//  Word Scanner
//
//  Created by Navya Bajwa on 2025-11-01.
//

import Foundation

struct Definition: Codable, Identifiable {
    let id = UUID()
    let word: String
    let phonetic: String?
    let meanings: [MeaningInfo]?
    
    enum CodingKeys: CodingKey {
        case word
        case phonetic
        case meanings
    }
}

struct MeaningInfo: Codable, Identifiable {
    let id = UUID()
    let partOfSpeech: String
    let definitions: [DefinitionInfo]?
    
    enum CodingKeys: CodingKey {
        case partOfSpeech
        case definitions
    }
}

struct DefinitionInfo: Codable, Identifiable {
    let id = UUID()
    let definition: String
    let example: String?
    let synonyms: [String]?
    let antonyms: [String]?
    
    enum CodingKeys: CodingKey {
        case definition
        case example
        case synonyms
        case antonyms
    }
}

// we need CodingKeys because Normally, Swift's Codable automatically matches property names to JSON keys.
// But we added id properties that don't exist in the JSON:
// Your Swift struct has: id, word, phonetic, meanings
// The JSON only has: word, phonetic, meanings
// Without CodingKeys, Swift would try to decode id from the JSON and fail
