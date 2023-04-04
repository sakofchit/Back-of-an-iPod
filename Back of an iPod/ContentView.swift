//
//  ContentView.swift
//  Back of an iPod
//
//  Created by Sakun on 3/30/23.
//

import SwiftUI
import AVFoundation
import CoreImage

struct CameraView: UIViewRepresentable{
    
    let videoDataOutputDelegate = VideoDataOutputDelegate()

    func makeUIView(context: Context) -> some UIView {
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high

        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { fatalError("Unable to access front camera.") }

        do {
            let input = try AVCaptureDeviceInput(device: frontCamera)
            captureSession.addInput(input)

            // set the frame rate of the front-facing camera to 60 fps
            let desiredFrameRate = CMTime(value: 1, timescale: 60)
            for format in frontCamera.formats {
                let ranges = format.videoSupportedFrameRateRanges
                guard let highestRange = ranges.max(by: { $0.maxFrameRate < $1.maxFrameRate }),
                      highestRange.maxFrameRate >= Double(desiredFrameRate.value) / Double(desiredFrameRate.timescale) else {
                    continue
                }
                try frontCamera.lockForConfiguration()
                frontCamera.activeFormat = format
                frontCamera.activeVideoMinFrameDuration = desiredFrameRate
                frontCamera.activeVideoMaxFrameDuration = desiredFrameRate
                frontCamera.unlockForConfiguration()
                break
            }
        } catch {
            fatalError("Unable to access front camera.")
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(videoDataOutputDelegate, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(videoOutput)

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.cornerRadius = 25
        previewLayer.frame = CGRect(x: 0, y: 0, width: 335, height: 550)
        
        let gradientLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        gradientLayer.videoGravity = .resizeAspectFill
        gradientLayer.frame = previewLayer.bounds.inset(by: UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25))
        gradientLayer.cornerRadius = 12

        let ciImageLayer = CIImageLayer()
        ciImageLayer.frame = previewLayer.bounds
        previewLayer.addSublayer(ciImageLayer)
        videoDataOutputDelegate.outputLayer = ciImageLayer
        
        let ciImageLayer2 = CIImageLayer2()
        ciImageLayer2.frame = gradientLayer.bounds
        gradientLayer.addSublayer(ciImageLayer2)
        videoDataOutputDelegate.outputLayer2 = ciImageLayer2

        let appleLogo = UIImageView(image: UIImage(named: "apple_logo"))
        appleLogo.contentMode = .scaleAspectFit
        appleLogo.frame = CGRect(x: 0, y: 0, width: 66, height: 78)
        appleLogo.center = CGPoint(x: previewLayer.position.x, y: previewLayer.position.y - 50)

        let iPodText = UILabel()
        iPodText.text = "iPod"
        iPodText.font = UIFont.systemFont(ofSize: 48, weight: .semibold)
        iPodText.textColor = .white
        iPodText.sizeToFit()
        iPodText.center = CGPoint(x: previewLayer.position.x, y: previewLayer.position.y + 35)
        
        let storageCap = UILabel()
        storageCap.text = "120GB"
        storageCap.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        storageCap.textColor = .white
        storageCap.sizeToFit()
        storageCap.layer.borderWidth = 1.0
        storageCap.layer.cornerRadius = 5.0
        storageCap.layer.borderColor = UIColor.white.cgColor
        storageCap.frame = storageCap.frame.inset(by: UIEdgeInsets(top: 23, left: 55, bottom: 23, right: 55))
        storageCap.center = CGPoint(x: previewLayer.position.x, y: previewLayer.position.y + 150)
        storageCap.textAlignment = .center
        
        let serialNo = UILabel()
        serialNo.text = "Serial No.: 2Z6070GUSDV"
        serialNo.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        serialNo.textColor = .white
        serialNo.sizeToFit()
        serialNo.center = CGPoint(x: previewLayer.position.x, y: previewLayer.position.y + 180)
        serialNo.textAlignment = .center
        
        let desc = UILabel()
        desc.text = "Designed by Apple in California. Assembled in China. Model No.: A1238"
        desc.font = UIFont.systemFont(ofSize: 6, weight: .regular)
        desc.textColor = .white
        desc.sizeToFit()
        desc.center = CGPoint(x: previewLayer.position.x, y: previewLayer.position.y + 190)
        desc.textAlignment = .center
        
        let emcNo = UILabel()
        emcNo.text = "EMC No.: 2173 Rated 5-30V ⎓ 1A Max. TM and © 2008 Apple Inc. All rights reserved."
        emcNo.font = UIFont.systemFont(ofSize: 6, weight: .regular)
        emcNo.textColor = .white
        emcNo.sizeToFit()
        emcNo.center = CGPoint(x: previewLayer.position.x, y: previewLayer.position.y + 200)
        emcNo.textAlignment = .center
        
        let idkWhatTheseAreCalled = UIImageView(image: UIImage(named: "fcc"))
        idkWhatTheseAreCalled.contentMode = .scaleAspectFit
        idkWhatTheseAreCalled.frame = CGRect(x: 0, y: 0, width: 145, height: 25.5)
        idkWhatTheseAreCalled.center = CGPoint(x: previewLayer.position.x, y: previewLayer.position.y + 225)
        

        let previewView = UIView(frame: CGRect(x: 0, y: 0, width: 335, height: 550))
        previewView.layer.addSublayer(previewLayer)
        
        // Create an image view with the desired image
        let shine = UIImageView(image: UIImage(named: "test-shine"))
        shine.contentMode = .scaleAspectFill
        shine.frame = previewView.bounds
        shine.layer.cornerRadius = 25
        shine.layer.masksToBounds = true

        //previewView.layer.insertSublayer(shadowLayer, above: previewLayer)
        previewView.layer.insertSublayer(gradientLayer, above: previewLayer)
        previewView.addSubview(shine)
        previewView.addSubview(appleLogo)
        previewView.addSubview(iPodText)
        previewView.addSubview(storageCap)
        previewView.addSubview(serialNo)
        previewView.addSubview(desc)
        previewView.addSubview(emcNo)
        previewView.addSubview(idkWhatTheseAreCalled)

        let view = UIView(frame: CGRect(x: 0, y: 0, width: 335, height: 550))
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 4
        view.layer.cornerRadius = 25
        view.addSubview(previewView)

        // move startRunning() to a background thread
        DispatchQueue.global(qos: .userInitiated).async {
            captureSession.startRunning()
        }
        
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        }
}


struct ContentView: View {
    var body: some View {
        ZStack {
            Color.white
            CameraView()
                .frame(width: 335, height: 550)
                .statusBar(hidden: true)
            
        }.edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
