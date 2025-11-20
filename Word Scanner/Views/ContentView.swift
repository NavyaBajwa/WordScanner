//
//  ContentView.swift
//  Word Scanner
//
//  Created by Navya Bajwa on 2025-10-22.
//

import SwiftUI
import PhotosUI

struct IdentifiableImage: Identifiable {
    let id = UUID()
    let image: UIImage
}

struct ContentView: View {
    @State private var enteredWord: String = ""
    @State private var showDefinition: Bool = false
    @State private var wordToDefine: String = ""
    
    @State private var showEnterTextView: Bool = false
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var croppedImage: UIImage?
    @State private var showCropView: Bool = false
    
    @StateObject private var textRecognizer = TextRecognitionService()
    @StateObject private var cameraManager = CameraManager()
    
    @State private var selectedImageWrapper: IdentifiableImage?
    
    var body: some View {
        TabView {
            searchTab
            dictionaryTab
            historyTab
        }
        .tint(.myPrettyBlue)
    }
    
    // MARK: - Search Tab
    var searchTab: some View {
        VStack {
            // Logo and title
            HStack {
                Image("paperMagnifyingGlass")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .padding(.bottom, 30)
                    .padding(.top, 15)
                Text("WordLens")
                    .font(.system(size: 30, weight: .semibold, design: .rounded))
                    .foregroundColor(.black)
                    .padding(.bottom, 30)
                    .padding(.top, 15)
            }

            // Camera preview
            CameraPreviewView(session: cameraManager.session)
                .frame(width: 350, height: 470)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color("myPrettyBlue").opacity(0.1), lineWidth: 2)
                )
                .onAppear {
                    cameraManager.startSession()
                }
                .onDisappear {
                    cameraManager.stopSession()
                }
            
            // Capture button
            Button(action: {
                cameraManager.capturePhoto()
            }) {
                Label("scan", systemImage: "circle.inset.filled")
                    .foregroundColor(Color("myPrettyBlue"))
            }
            .labelStyle(.iconOnly)
            .font(.system(size: 50))
            .padding(.top, 10)
            
            // Text entry and photo picker buttons
            HStack {
                Button(action: {
                    showEnterTextView = true
                }) {
                    Label("scan", systemImage: "rectangle.and.pencil.and.ellipsis.rtl")
                        .foregroundColor(Color("myPrettyBlue"))
                }
                .labelStyle(.iconOnly)
                .font(.system(size: 26))
                .padding(.top, 10)
                
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Label("scan", systemImage: "photo.on.rectangle.angled")
                        .foregroundColor(Color("myPrettyBlue"))
                }
                .labelStyle(.iconOnly)
                .font(.system(size: 26))
                .padding(.top, 10)
                
                Button(action: {
                    if let image = UIImage(named: "sampleWord") {
                        // Run OCR directly
                        //croppedImage = image
                        //textRecognizer.recognizeText(from: image)
                        
                        // Or open CropView
                        selectedImageWrapper = IdentifiableImage(image: image)
                    }
                }) {
                    Label("test", systemImage: "waveform.path.ecg.text.clipboard")
                }
                .labelStyle(.iconOnly)
                .font(.system(size: 26))
                .padding(.top, 10)
                
            }
        }
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .padding(.top, 8)
        .tabItem {
            Label("Search", systemImage: "text.viewfinder")
        }
        .tag(0)
        .sheet(isPresented: $showEnterTextView) {
            EnterTextView()
        }
        
        .sheet(item: $selectedImageWrapper) { wrapper in
            NavigationStack {
                CropView(uiImage: wrapper.image)
                    .navigationTitle("Crop Image")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") {
                                selectedImageWrapper = nil
                            }
                        }
                    }
            }
        }
        
        .onChange(of: cameraManager.capturedImage) { _, newValue in
            if let image = newValue {
                selectedImageWrapper = IdentifiableImage(image: image)
                cameraManager.capturedImage = nil
            }
        }
        
        .onChange(of: selectedItem) { _, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    selectedImageWrapper = IdentifiableImage(image: image)
                }
            }
        }

        .onChange(of: textRecognizer.recognizedText) { _, newText in
            if !newText.isEmpty {
                wordToDefine = newText
                showDefinition = true
                textRecognizer.recognizedText = "" // Reset for next OCR
                croppedImage = nil
            }
        }

        
        .sheet(isPresented: $showDefinition) {
            DefinitionView(searchWord: wordToDefine)
        }
    }
    
    // MARK: - Dictionary Tab
    var dictionaryTab: some View {
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
        .badge(2)
    }
    
    // MARK: - History Tab
    var historyTab: some View {
        VStack {
            Text("History")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Your previous searched words will appear here")
        }
        .tabItem {
            Label("History", systemImage: "clock.arrow.circlepath")
        }
        .tag(2)
    }
}

#Preview {
    ContentView()
}
