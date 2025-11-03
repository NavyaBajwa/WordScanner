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
    
    @State private var showEnterTextView: Bool = false
    
    var body: some View {
        TabView {
            VStack {
                // For logo and title
                HStack {
                    Image("paperMagnifyingGlass")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        //.offset(x: -10)
                        .padding(.bottom, 30)
                        .padding(.top, 15)
                    Text("WordLens")
                        .font(.system(size: 30, weight: .semibold, design: .rounded))
                        //.fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.bottom, 30)
                        .padding(.top, 15)
                }

                //Camera layer goes here
                
                // Button to capture photo
                Button(action: {
                    showEnterTextView = true
                    
                }) {
                    Label("scan", systemImage: "inset.filled.circle.dashed")
                        .foregroundColor(Color("myPrettyBlue"))
                }
                .labelStyle(.iconOnly)
                .font(.system(size: 40))
                .padding(.top, 25)
                
                // HStack for text field and image from gallery buttons
                HStack {
                    Button(action: {
                        showEnterTextView = true
                        
                    }) {
                        Label("scan", systemImage: "rectangle.and.pencil.and.ellipsis.rtl")
                            .foregroundColor(Color("myPrettyBlue"))
                    }
                    .labelStyle(.iconOnly)
                    .font(.system(size: 26))
                    .padding(.top, 25)
                    
                    Button(action: {
                        print("This is to get an image from your camera roll")
                        
                    }) {
                        Label("scan", systemImage: "photo.on.rectangle.angled")
                            .foregroundColor(Color("myPrettyBlue"))
                    }
                    .labelStyle(.iconOnly)
                    .font(.system(size: 26))
                    .padding(.top, 25)
                    
                }
                
            }
            .frame(maxHeight: .infinity, alignment: .topLeading)
            .padding(.top, 8)
            .tabItem {
                Label("Search", systemImage: "text.viewfinder")
            }
            
            .tag(0)
            
            // if text field button pressed, show enterTextView
            .sheet(isPresented: $showEnterTextView) {
                EnterTextView()
            }
            
            VStack {
                Text("My Dictionary")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Your saved words will appear here")
            }
            .tabItem {
                Label("Dictionary", systemImage: "book.pages")
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
                Label("History", systemImage: "clock.arrow.circlepath")
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
