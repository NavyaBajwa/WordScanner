//
//  CameraManager.swift
//  Word Scanner
//
//  Created by Navya Bajwa on 2025-11-02.
//

import AVFoundation
import UIKit
internal import Combine

class CameraManager: NSObject, ObservableObject {
    @Published var session = AVCaptureSession()
    @Published var capturedImage: UIImage?
    @Published var permissionGranted = false
    
    private let output = AVCapturePhotoOutput()
    private var isSessionConfigured = false
    
    override init() {
        super.init()
        checkPermissions()
    }
    
    func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            permissionGranted = true
            setupCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    self.permissionGranted = granted
                    if granted {
                        self.setupCamera()
                    }
                }
            }
        default:
            permissionGranted = false
        }
    }
    
    func setupCamera() {
        guard !isSessionConfigured else { return }
        
        session.beginConfiguration()
        session.sessionPreset = .photo
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Failed to get camera device")
            session.commitConfiguration()
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            
            if session.canAddInput(input) {
                session.addInput(input)
            } else {
                print("Could not add camera input")
                session.commitConfiguration()
                return
            }
            
            if session.canAddOutput(output) {
                session.addOutput(output)
            } else {
                print("Could not add photo output")
                session.commitConfiguration()
                return
            }
            
            session.commitConfiguration()
            isSessionConfigured = true
            print("Camera setup complete")
            
        } catch {
            print("Error setting up camera: \(error.localizedDescription)")
            session.commitConfiguration()
        }
    }
    
    func startSession() {
        guard permissionGranted else {
            print("Camera permission not granted")
            return
        }
        
        guard isSessionConfigured else {
            print("Camera session not configured yet")
            return
        }
        
        if !session.isRunning {
            DispatchQueue.global(qos: .userInitiated).async {
                self.session.startRunning()
                print("Camera session started")
            }
        }
    }
    
    func stopSession() {
        if session.isRunning {
            DispatchQueue.global(qos: .userInitiated).async {
                self.session.stopRunning()
                print("Camera session stopped")
            }
        }
    }
    
    func capturePhoto() {
        print("Capture photo called")
        
        guard session.isRunning else {
            print("Cannot capture - session not running")
            return
        }
        
        let settings = AVCapturePhotoSettings()
        
        // Make sure we can capture with these settings
        guard output.availablePhotoCodecTypes.contains(.jpeg) else {
            print("JPEG codec not available")
            return
        }
        
        settings.flashMode = .off
        
        let delegate = PhotoCaptureDelegate { [weak self] image in
            DispatchQueue.main.async {
                self?.capturedImage = image
                print("Photo captured successfully")
            }
        }
        
        // Keep a strong reference to prevent deallocation
        objc_setAssociatedObject(self, "PhotoDelegate", delegate, .OBJC_ASSOCIATION_RETAIN)
        
        output.capturePhoto(with: settings, delegate: delegate)
    }
}

class PhotoCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    private let completion: (UIImage?) -> Void
    
    init(completion: @escaping (UIImage?) -> Void) {
        self.completion = completion
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error.localizedDescription)")
            completion(nil)
            return
        }
        
        guard let data = photo.fileDataRepresentation() else {
            print("No photo data available")
            completion(nil)
            return
        }
        
        guard let image = UIImage(data: data) else {
            print("Could not create image from data")
            completion(nil)
            return
        }
        
        print("Photo processed successfully")
        completion(image)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        print("Will capture photo")
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        print("Did capture photo")
    }
}
