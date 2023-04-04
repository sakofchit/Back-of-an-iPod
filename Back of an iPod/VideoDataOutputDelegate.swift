//
//  VideoDataOutputDelegate.swift
//  Back of an iPod
//
//  Created by Sakun on 4/2/23.
//

import AVFoundation
import CoreImage

class VideoDataOutputDelegate: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    var outputLayer: CIImageLayer?
    var outputLayer2: CIImageLayer2?
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let rotatedImage = self.rotateImageToPortrait(ciImage)
        let stretchedImageEdges = self.stretchImageEdges(rotatedImage)
        let stretchedImageMain = self.stretchImage(rotatedImage)
        
        // apply the stretched image to the output layer
        outputLayer?.image = stretchedImageEdges
        outputLayer2?.image = stretchedImageMain
    }
    
    // the default cam is landscape for some reason, so I rotated it
    func rotateImageToPortrait(_ inputImage: CIImage) -> CIImage {
        let rotationFilter = CIFilter(name: "CIAffineTransform")!
        rotationFilter.setValue(inputImage, forKey: kCIInputImageKey)

        let transform = CGAffineTransform(rotationAngle: .pi / 2)
        rotationFilter.setValue(NSValue(cgAffineTransform: transform), forKey: kCIInputTransformKey)

        return rotationFilter.outputImage!
    }
    
    func stretchImageEdges(_ inputImage: CIImage) -> CIImage {
        let filter = CIFilter(name: "CIBumpDistortionLinear")!
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(200.0, forKey: kCIInputRadiusKey)
        filter.setValue(0.1, forKey: kCIInputScaleKey)
        filter.setValue(CIVector(x: inputImage.extent.width, y: inputImage.extent.height / 1.1), forKey: kCIInputCenterKey)
        
        let outputImage = filter.outputImage!
        
        // apply a slight Gaussian blur to the output image
        let blurFilter = CIFilter(name: "CIGaussianBlur")!
        blurFilter.setValue(outputImage, forKey: kCIInputImageKey)
        blurFilter.setValue(0.1, forKey: kCIInputRadiusKey)
        
        // crop the blurred image back to its original size
        let cropFilter = CIFilter(name: "CICrop")!
        cropFilter.setValue(blurFilter.outputImage!, forKey: kCIInputImageKey)
        
        // set the input rectangle to the original size of the image
        cropFilter.setValue(inputImage.extent, forKey: "inputRectangle")
        
        return cropFilter.outputImage!
    }

    
    func stretchImage(_ inputImage: CIImage) -> CIImage {
        let filter = CIFilter(name: "CIBumpDistortionLinear")!
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(300.0, forKey: kCIInputRadiusKey)
        filter.setValue(0.4, forKey: kCIInputScaleKey)
        filter.setValue(CIVector(x: inputImage.extent.width / 1.5, y: inputImage.extent.height / 1.1), forKey: kCIInputCenterKey)
        
        let outputImage = filter.outputImage!
        
        // apply a slight Gaussian blur to the output image
        let blurFilter = CIFilter(name: "CIGaussianBlur")!
        blurFilter.setValue(outputImage, forKey: kCIInputImageKey)
        blurFilter.setValue(0.1, forKey: kCIInputRadiusKey)
        
        // crop the blurred image back to its original size
        let cropFilter = CIFilter(name: "CICrop")!
        cropFilter.setValue(blurFilter.outputImage!, forKey: kCIInputImageKey)
        
        // set the input rectangle to the original size of the image
        cropFilter.setValue(inputImage.extent, forKey: "inputRectangle")
        
        return cropFilter.outputImage!
    }


}
