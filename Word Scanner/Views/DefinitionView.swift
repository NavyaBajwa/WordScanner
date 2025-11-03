//
//  DefinitionView.swift
//  Word Scanner
//
//  Created by Navya Bajwa on 2025-10-26.
//

import SwiftUI

struct DefinitionView: View {
    let searchWord: String  // ❌ Was: let searchWord = String (should be : not =)
    
    @State private var definition: Definition?
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = errorMessage {
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.myPrettyBlue)
                    Text("Error")
                        .font(.headline)
                    Text(error)
                        .foregroundColor(.myPrettyBlue)
                        .multilineTextAlignment(.center)
                    Button("Close") {
                        dismiss()
                    }
                    .font(.headline)
                    .foregroundColor(.blue)
                }
                .padding()
            } else if let def = definition {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text(def.word)
                                .font(.system(size: 39, weight: .semibold, design: .rounded))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Spacer()
                            Button(action: {
                            }) {
                                Label("audio", systemImage: "speaker.wave.2.circle.fill")
                                    .foregroundColor(Color("myPrettyBlue"))
                            }
                            .labelStyle(.iconOnly)
                            .font(.system(size: 38))
                        }
                        
                        if let phonetic = def.phonetic {
                            Text(phonetic)
                                .font(.body)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundStyle(.myGrey)
                        }
                        
                        Divider()
                        
                        // Meanings
                        if let meanings = def.meanings {
                            ForEach(meanings) { meaning in
                                VStack(alignment: .leading, spacing: 15) {
                                    Text(meaning.partOfSpeech)
                                        .font(.body)
                                        .foregroundStyle(.myGrey)
                                    
                                    // Definitions
                                    if let definitions = meaning.definitions {
                                        ForEach(Array(definitions.enumerated()), id: \.element.id) { index, defInfo in
                                            VStack(alignment: .leading, spacing: 8) {
                                                HStack(alignment: .top, spacing: 8) {
                                                    Text("\(index + 1).")
                                                        .font(.body.weight(.medium))
                                                    Text(defInfo.definition)
                                                        .font(.body.pointSize(20))
                                                        .multilineTextAlignment(.leading)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                }
                                                
                                                // Example
                                                if let example = defInfo.example {
                                                    Text(example)
                                                        .font(.body)
                                                        .multilineTextAlignment(.leading)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                        .foregroundStyle(.myGrey)
                                                        .padding(.leading, 20)
                                                }
                                                
                                                // Synonyms
                                                if let synonyms = defInfo.synonyms, !synonyms.isEmpty {
                                                    HStack(alignment: .top) {
                                                        Text("Similar:")
                                                            .font(.caption.weight(.semibold))
                                                        Text(synonyms.prefix(5).joined(separator: ", "))
                                                            .font(.system(size: 15))
                                                            .foregroundStyle(.myGrey)
                                                    }
                                                    .padding(.leading, 20)
                                                }
                                            }
                                            .padding(.bottom, 8)
                                        }
                                    }
                                }
                                .padding(.bottom, 10)
                            }
                        }
                        
                        Button("Close") {
                            dismiss()
                        }
                        .font(.headline)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding(.top)
                    }
                    .padding()
                }
            }
        }
        .task {
            await fetchDefinition()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
    
    func fetchDefinition() async {
        do {
            let results = try await DictionaryService.shared.searchWord(searchWord)
            if let first = results.first {
                definition = first
            } else {
                errorMessage = "No definition found"
            }
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}

#Preview {
    DefinitionView(searchWord: "ephemeral")
}
