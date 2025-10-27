//
//  ContentView.swift
//  Word Scanner
//
//  Created by Navya Bajwa on 2025-10-22.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var enteredWord: String = ""
    @State private var showDefinition: Bool = false
    @State private var wordToDefine: String = ""
    
    var body: some View {
        TabView {
            VStack {
                HStack {
                    Image("paperMagnifyingGlass")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        //.offset(x: -10)
                        .padding(.bottom, 20)
                    Text("WordLens")
                        .font(.system(size: 30, weight: .semibold, design: .rounded))
                        //.fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.bottom, 20)
                }
                //.paddng()
                GroupBox() {
                    TextField("Enter a word", text: $enteredWord)
                        .offset(x: 15, y: 10)
                        .frame(height: 535, alignment: .top)
                        //.foregroundStyle(.black)
                        .font(.body .pointSize(21) .italic())
                }
                .frame(width: 420, alignment: .init(horizontal: .center, vertical: .top))
                //.cornerRadius(30)
                .backgroundStyle(.myPrettyBlue.opacity(0.1))
                //.shadow(radius: 17)
                
                Button(action: {
                    print("user entered: \(enteredWord)")
                    wordToDefine = enteredWord
                    showDefinition = true
                    enteredWord = ""
                }) {
                    Label("scan", systemImage: "camera.circle")
                        .foregroundColor(Color("myPrettyBlue"))
                }
                .labelStyle(.iconOnly)
                .font(.system(size: 40))
                .padding(.top, 15)
                
            }
            .frame(maxHeight: .infinity, alignment: .topLeading)
            .padding(.top, 8)
            .tabItem {
                Label("Scan", systemImage: "camera.fill")
            }
            
            .tag(0)
            
            .sheet(isPresented: $showDefinition) {
                DefinitionView(word: wordToDefine, definition: "Placeholder definition: \(wordToDefine)", pronunciation: "pro-nun-ci-ation", partOfSpeech: "adjective", sentence: "sentence goes here"
)
            }
            
            VStack {
                Text("My Dictionary")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Your saved words will appear here")
            }
            .tabItem {
                Label("Dictionary", systemImage: "books.vertical")
            }
            .tag(1)
            // Later, I want the badge to save the number of words saved in the dictionary
            .badge(2)
            
            VStack {
                Text("History")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Your previous searched words will appear here")
            }
            .tabItem {
                Label("History", systemImage: "clock")
                // systemImage: memories
                // systemImage: repeat
            }
            .tag(2)
        }
        //.tint(.purple)
        .tint(.myPrettyBlue)
    
    }
}

#Preview {
    ContentView()
}
