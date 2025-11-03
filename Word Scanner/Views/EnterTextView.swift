//
//  EnterTextView.swift
//  Word Scanner
//
//  Created by Navya Bajwa on 2025-11-02.
//

import SwiftUI

struct EnterTextView: View {
    @State private var enteredWord: String = ""
    @State private var wordToDefine: String = ""
    @State private var showDefinition: Bool = false
    
    @FocusState private var isTextFieldFocused: Bool
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            ZStack {
                Text("Search for a Word")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .padding(.bottom, 20)
                    .padding(.top, 25)
                
                Button("Close") {
                    dismiss()
                }
                    .font(.headline)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 20)
                    .padding(.top, 25)
                    .offset(x:151)
            }
            GroupBox() {
                TextField("Enter a word", text: $enteredWord)
                    .offset(x: 15, y: 15)
                    .frame(height: 60, alignment: .top)
                    //.foregroundStyle(.black)
                    .font(.body .pointSize(21) .italic())
                    .focused($isTextFieldFocused)
                    .onSubmit {
                        wordToDefine = enteredWord
                        showDefinition = true
                        enteredWord = ""
                    }
            }
            .frame(width: 375, alignment: .init(horizontal: .center, vertical: .top))
            .cornerRadius(30)
            .backgroundStyle(.myPrettyBlue.opacity(0.1))
        }
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isTextFieldFocused = true
            }
        }
        .sheet(isPresented: $showDefinition) {
            DefinitionView(searchWord: wordToDefine)
        }
    }
}

#Preview {
    EnterTextView()
}

