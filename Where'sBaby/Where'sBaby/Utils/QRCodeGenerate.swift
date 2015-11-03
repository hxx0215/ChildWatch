//
//  QRCodeGenerate.swift
//  Where'sBaby
//
//  Created by shadowPriest on 15/10/26.
//  Copyright © 2015年 coolLH. All rights reserved.
//

import UIKit

class QRCodeGenerate: NSObject {
    static func generateQRCode(content:String,size:CGFloat)->UIImage{
        return imageWithCIImage(generateFromString(content), size: size)
    }
    private static func generateFromString(content:String)->CIImage?{
        let data = content.dataUsingEncoding(NSUTF8StringEncoding)
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        qrFilter?.setValue(data, forKey: "inputMessage")
        qrFilter?.setValue("M", forKey: "inputCorrectionLevel")
        
        
        guard let invert = CIFilter(name: "CIColorInvert") else { return nil }
        invert.setDefaults()
        invert.setValue(qrFilter?.outputImage, forKey: "inputImage")
        
        guard let maskFilter = CIFilter(name: "CIMaskToAlpha") else { return nil }
        maskFilter.setDefaults()
        maskFilter.setValue(invert.outputImage, forKey: "inputImage")
        
        invert.setValue(maskFilter.outputImage, forKey: "inputImage")
        return invert.outputImage
    }
    private static func imageWithCIImage(ciimage: CIImage?,size: CGFloat)->UIImage{
        if let image = ciimage{
            let extent = CGRectIntegral(image.extent)
            let scale = min(size / extent.size.width, size / extent.size.height)
            let context = CIContext(options: nil)
            let bitmapImage = context.createCGImage(image, fromRect: extent)
            UIGraphicsBeginImageContext(CGSizeMake(size, size))
            let c = UIGraphicsGetCurrentContext()
            CGContextSetInterpolationQuality(c, .None)
            CGContextTranslateCTM(c, 0.0, size)
            CGContextScaleCTM(c,scale,-scale)
            CGContextDrawImage(c,extent,bitmapImage)
            if let scaledImage = CGBitmapContextCreateImage(c){
                UIGraphicsEndImageContext()
                return UIImage(CGImage: scaledImage)
            }else{
                return UIImage()
            }
        }
        return UIImage()
    }

}
