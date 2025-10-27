//
//  DefinitionView.swift
//  Word Scanner
//
//  Created by Navya Bajwa on 2025-10-26.
//

import SwiftUI

struct DefinitionView: View {
    var word: String
    var definition: String
    var pronunciation: String
    var partOfSpeech: String
    var sentence: String
    
    //let definitionModel: DefinitionModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack{
                Text(word)
                    .font(.system(size: 39, weight: .semibold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    //.offset(x:15)
                Spacer()
                Button(action: {
                }) {
                    Label("audio", systemImage: "speaker.wave.2.circle.fill")
                        .foregroundColor(Color("myPrettyBlue"))
                }
                .labelStyle(.iconOnly)
                .font(.system(size: 38))
                //.padding(.top, 15)
            }
            HStack{
                Text(pronunciation)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.myGrey)
                Spacer()
                Text(partOfSpeech)
                    .font(.body)
                    .foregroundStyle(.myGrey)
                    //.frame(maxWidth: .infinity, alignment: .leading)
            }
            Text(definition)
                .font(.body .pointSize(20))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                //.offset(x:15)
            Text(sentence)
                .font(.body)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.myGrey)
            
            Text("Similar:")
                .font(.body .pointSize(18))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            Button("Close") {
                dismiss()
                    
            }
            .font(.headline)
            .foregroundColor(.blue)
            //.offset(x:15)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        
    }
}

#Preview {
    DefinitionView(word: "Ephemeral", definition: "Lasting for a very short time.", pronunciation: "ep-eh-MER-al", partOfSpeech: "adjective", sentence: "fashions are ephemeral")
}
