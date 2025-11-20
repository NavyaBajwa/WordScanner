//
//  CropImageView.swift
//  Word Scanner
//
//  Created by Navya Bajwa on 2025-11-04.
//

import SwiftUI

struct CropView: View {
    @Environment(\.dismiss) private var dismiss
    
    var uiImage: UIImage
    
    @State private var cropRect: CGRect = .zero
    @State private var startPoint: CGPoint = .zero
    @State private var isProcessing: Bool = false
    //@State private var recognizedText: String = ""
    @State private var showDefinition: Bool = false
    
    @StateObject private var textRecognizer = TextRecognitionService()
    
    var body: some View {
        VStack {
            Text("Select the word")
                .font(.headline)
                .padding(.top)
            
            GeometryReader { geo in
                ZStack {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .overlay(cropRectangle)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    startPoint = value.startLocation
                                    cropRect = rect(from: value.location, in: geo)
                                }
                        )
                }
            }
            
            if isProcessing {
                ProgressView("Recognizing text...")
                    .padding()
            } else {
                Button("Crop & Extract Text") {
                    cropImage()
                }
                .padding()
                .font(.title2)
                .disabled(cropRect.width < 10 || cropRect.height < 10)
            }
        }
        .sheet(isPresented: $showDefinition) {
            DefinitionView(searchWord: textRecognizer.recognizedText)
                .onDisappear {
                    // Close CropView after DefinitionView is dismissed
                    dismiss()
                }
        }
        .onChange(of: textRecognizer.recognizedText) { _, newText in
            print("📝 Text recognized: '\(newText)'")
            if !newText.isEmpty {
                isProcessing = false
                showDefinition = true
            }
        }
    }
    
    private var cropRectangle: some View {
        Rectangle()
            .path(in: cropRect)
            .stroke(Color.blue, lineWidth: 2)
            .background(
                Rectangle()
                    .fill(Color.blue.opacity(0.15))
                    .frame(width: cropRect.width, height: cropRect.height)
                    .position(x: cropRect.midX, y: cropRect.midY)
            )
    }
    
    private func rect(from end: CGPoint, in geo: GeometryProxy) -> CGRect {
        let x = min(startPoint.x, end.x)
        let y = min(startPoint.y, end.y)
        let w = abs(startPoint.x - end.x)
        let h = abs(startPoint.y - end.y)

        let maxW = geo.size.width
        let maxH = geo.size.height
        
        return CGRect(
            x: max(0, x),
            y: max(0, y),
            width: min(w, maxW - x),
            height: min(h, maxH - y)
        )
    }
    
    private func cropImage() {
        guard cropRect.width > 10, cropRect.height > 10 else {
            print("⚠️ Crop area too small")
            return
        }
        
        print("🔷 Starting crop process...")
        isProcessing = true
        
        let imgSize = uiImage.size
        let displayedSize = UIScreen.main.bounds
        let scaleX = imgSize.width / displayedSize.width
        let scaleY = imgSize.height / displayedSize.height
        
        let adjustedRect = CGRect(
            x: cropRect.origin.x * scaleX,
            y: cropRect.origin.y * scaleY,
            width: cropRect.width * scaleX,
            height: cropRect.height * scaleY
        )
        
        guard let cgImage = uiImage.cgImage?.cropping(to: adjustedRect) else {
            print("❌ Cropping failed")
            isProcessing = false
            return
        }
        
        let cropped = UIImage(cgImage: cgImage)
        print("✅ Image cropped, running OCR...")
        
        // Run OCR on cropped image
        textRecognizer.recognizeText(from: cropped)
    }
}

