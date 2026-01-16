# Word Scanner
Word Scanner is an iOS dictionary app that detects and extracts words directly from images using on-device OCR, then retrieves definitions in real time using a dictionary API.
Users can scan printed text with their camera or photo library, crop a specific word, and instantly view its definition.

## Features
- Image-to-word detection using Apple’s Vision OCR framework
- Interactive cropping interface for precise word selection
- Instant dictionary lookups via REST API integration
- Asynchronous processing pipeline for smooth camera, OCR, and network operations
- On-device text recognition (no image data leaves the device)

## Demo
### 1) Home Page
![home screen](Word%20Scanner/assets/homescreen.png)

### Select Image from Library
### 2a) Select Photo
![select photo](Word%20Scanner/assets/photoSelect.png)

### 2b) Crop Photo and Extract Text
![crop and extract](Word%20Scanner/assets/cropandextract.png)

### 2c) Definition Result
![def result](Word%20Scanner/assets/photoResult.png)

### Search Word via Text Field
### 3a) Enter Word
![def result](Word%20Scanner/assets/textSearch.png)

### 3b) Definition Result
![def result](Word%20Scanner/assets/textResult.png)
