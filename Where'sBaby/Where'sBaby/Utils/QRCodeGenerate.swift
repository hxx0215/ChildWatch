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
        return qrFilter?.outputImage
    }
    private static func imageWithCIImage(ciimage: CIImage?,size: CGFloat)->UIImage{
        if let image = ciimage{
            let extent = CGRectIntegral(image.extent)
            let scale = min(size / extent.size.width, size / extent.size.height)
            let width = extent.size.width * scale
            let height = extent.size.height * scale
            let cs = CGColorSpaceCreateDeviceGray()
            let bitmapRef = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, cs, CGImageAlphaInfo.None.rawValue)
            let context = CIContext(options: nil)
            let bitmapImage = context.createCGImage(image, fromRect: extent)
            CGContextSetInterpolationQuality(bitmapRef, .None)
            CGContextScaleCTM(bitmapRef,scale,scale)
            CGContextDrawImage(bitmapRef,extent,bitmapImage)
            if let scaledImage = CGBitmapContextCreateImage(bitmapRef){
                return UIImage(CGImage: scaledImage)
            }else{
                return UIImage()
            }
        }
        return UIImage()
    }

}
