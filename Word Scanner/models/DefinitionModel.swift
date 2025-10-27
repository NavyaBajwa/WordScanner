//
//  DefinitionModel.swift
//  Word Scanner
//
//  Created by Navya Bajwa on 2025-10-23.
//

import Foundation

struct DefinitionModel: Codable, Identifiable {
    let id: String
    let meta: Meta? // meta contians multiple pieces of info, so I have to make its own struct
    let hwi: Headword?
    let fl: String? // functional label (part of speach)
    let def: [DefinitionSection]?
    //let shortdef: [String]
    //let partofspeach: String
    
    var word: String {meta?.id ?? id}
    var partOfSpeech: String {fl ?? "unknown"}
    var audioFileName: String? {hwi?.prs?.first?.sound?.audio}
    // the .first means it will take the sound of the first pronunciation
    
    // Extract all definitions with examples
    var detailedDefinitions: [DefinitionEntry] {
        guard let def = def else { return [] }
        var results: [DefinitionEntry] = []
        
        for section in def {
            guard let sseq = section.sseq else { continue }
            for senseGroup in sseq {
                for senseWrapper in senseGroup {
                    let sense = senseWrapper.sense
                    guard let details = sense.dt else { continue }
                    
                    var definitionText: String?
                    var exampleSentence: String?
                    
                    for item in details {
                        if let text = item.text {
                            definitionText = cleanMWTags(text)
                        } else if let vis = item.vis?.first?.t {
                            exampleSentence = cleanMWTags(vis)
                        }
                    }
                    
                    if let defText = definitionText {
                        results.append(DefinitionEntry(definition: defText, example: exampleSentence))
                    }
                }
            }
        }
        return results
    }
}


// defined these from the info in the meta {} in the Merriam-Webster dict api reference
struct Meta: Codable {
    let id: String
    let uuid: String?
    let sort: String?
    let src: String?
    let section: String?
    let stems: [String]? // Word variations
    let offensive: Bool?
    let syns: [[String]]? // Synonyms grouped by sense
    let ants: [[String]]? // Antonyms grouped by sense
}

struct Headword: Codable {
    let hw: String?
    let prs: [Pronunciation]?
}

struct Pronunciation: Codable {
    let mw: String?
    let sound: Sound?
}

struct Sound: Codable {
    let audio: String?
    let ref: String?
    let stat: String?
}

struct DefinitionSection: Codable {
    let sseq: [[SenseWrapper]]?
}

struct SenseWrapper: Codable {
    let senseType: String
    let sense: SenseDetail

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        senseType = try container.decode(String.self)
        sense = try container.decode(SenseDetail.self)
    }
}

struct SenseDetail: Codable {
    let sn: String?
    let dt: [DefinitionText]?
}

struct DefinitionText: Codable {
    let text: String?
    let vis: [VisualExample]?

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let first = try container.decode(String.self)
        if first == "text" {
            text = try container.decode(String.self)
            vis = nil
        } else if first == "vis" {
            vis = try container.decode([VisualExample].self)
            text = nil
        } else {
            text = nil
            vis = nil
        }
    }
}

struct VisualExample: Codable {
    let t: String?
}

struct DefinitionEntry: Identifiable {
    let id = UUID()
    let definition: String
    let example: String?
}

func cleanMWTags(_ input: String) -> String {
    var output = input
    // Remove Merriam-Webster formatting tags like {bc}, {it}, {wi}, etc.
    let regex = try! NSRegularExpression(pattern: "\\{.*?\\}", options: [])
    output = regex.stringByReplacingMatches(in: output, range: NSRange(location: 0, length: output.utf16.count), withTemplate: "")
    return output.trimmingCharacters(in: .whitespacesAndNewlines)
}

extension DefinitionModel {
    var synonyms: [String] {
        meta?.syns?.flatMap { $0 } ?? []
    }
        
    var antonyms: [String] {
        meta?.ants?.flatMap { $0 } ?? []
    }
    // .flatMap: syns is a nested arra [[String]] like:
    // [ ["sample", "instance", "case"],     // Group 1
    // ["illustration", "specimen"] ]         // Group 2
    // flatMap takes nested arrays and "flattens" them into one array
    //{ $0 } means "for each item, return it as-is"
    // after flatMap: ["sample", "instance", "illustration"]
}
