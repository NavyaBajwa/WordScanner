//
//  TextRecognitionService.swift
//  Word Scanner
//
//  Created by Navya Bajwa on 2025-11-19.
//

import SwiftUI
import Vision
internal import Combine

class TextRecognitionService: ObservableObject {
    
    @Published var recognizedText: String = ""
    
    func recognizeText(from image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        let handler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest { (request, error) in
            guard error == nil else { print(error?.localizedDescription ?? ""); return }
            
            guard let result = request.results as? [VNRecognizedTextObservation] else { return }
            
            let text = result.compactMap { result in result.topCandidates(1).first?.string}.joined(separator: " ")
            
            DispatchQueue.main.async {
                self.recognizedText = text
            }
        }
        
        request.recognitionLevel = .accurate
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("❌ Vision handler error:", error.localizedDescription)
                DispatchQueue.main.async {
                    self.recognizedText = ""
                }
            }
        }
    }
}
