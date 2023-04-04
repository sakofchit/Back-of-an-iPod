//
//  CIImageLayer.swift
//  Back of an iPod
//
//  Created by Sakun on 4/2/23.
//

import SwiftUI
import AVFoundation
import CoreImage

// display the camera output with CI filter applied.
class CIImageLayer: CALayer {
    var image: CIImage? {
        didSet {
            DispatchQueue.main.async {
                self.setNeedsDisplay()
            }
        }
    }
    
    override func draw(in ctx: CGContext) {
        guard let image = image else { return }
        ctx.clear(bounds)
        ctx.setFillColor(UIColor.black.cgColor)
        ctx.fill(bounds)
        
        let ciContext = CIContext(cgContext: ctx, options: nil)
        ciContext.draw(image, in: bounds, from: image.extent)
    }
}

class CIImageLayer2: CALayer {
    var image: CIImage? {
        didSet {
            DispatchQueue.main.async {
                self.setNeedsDisplay()
            }
        }
    }
    
    override func draw(in ctx: CGContext) {
        guard let image = image else { return }
        ctx.clear(bounds)
        ctx.setFillColor(UIColor.black.cgColor)
        ctx.fill(bounds)
        
        let ciContext = CIContext(cgContext: ctx, options: nil)
        ciContext.draw(image, in: bounds, from: image.extent)
    }
}
