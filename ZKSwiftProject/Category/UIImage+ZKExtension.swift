//
//  UIImage+ZKExtension.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2019/1/5.
//  Copyright © 2019 bestdew. All rights reserved.
//

import UIKit

public extension UIImage {
    
    /// 通过颜色生成图片
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - size: 图片尺寸
    convenience public init?(color: UIColor, size: CGSize) {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(size)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(color.cgColor)
        context.fill(rect)
        guard let image = UIGraphicsGetImageFromCurrentImageContext(), let imageRef = image.cgImage else { return nil }
        self.init(cgImage: imageRef)
    }
    
    /// 获取图片某一点上的颜色
    ///
    /// - Parameter point: 目标点比例位置（范围：0 ~ 1）
    /// - Returns: 该点的颜色
    public func color(at point: CGPoint) -> UIColor? {
        guard let imageRef = cgImage else { return nil }
        
        let realPointX = Int(CGFloat(imageRef.width) * point.x) + 1
        let realPointY = Int(CGFloat(imageRef.height) * point.y) + 1
        let rect = CGRect(x: 0, y: 0, width: CGFloat(imageRef.width), height: CGFloat(imageRef.height))
        let realPoint = CGPoint(x: realPointX, y: realPointY)
        guard rect.contains(realPoint) else { return nil }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        let pixelData = UnsafeMutablePointer<UInt8>.allocate(capacity: 4)
        guard let context = CGContext(data: pixelData, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo) else { return nil }
        
        context.setBlendMode(.copy)
        context.translateBy(x:  -CGFloat(realPointX), y: CGFloat(realPointY - imageRef.height))
        context.draw(imageRef, in: rect)
        let red = CGFloat(pixelData[0]) / 255
        let green = CGFloat(pixelData[1]) / 255
        let blue = CGFloat(pixelData[2]) / 255
        let alpha = CGFloat(pixelData[3]) / 255
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
}


public extension UIImage {
    
    /// 按比例缩放图片
    ///
    /// - Parameter scale: 缩放比例
    /// - Returns: 缩放后的图片
    public func resize(with scale: CGFloat) -> UIImage {
        let newSize = size.applying(CGAffineTransform(scaleX: scale, y: scale))
        return resize(to: newSize)
    }
    
    /// 图片缩放到指定尺寸
    ///
    /// - Parameter newSize: 目标尺寸
    /// - Returns: 缩放后的图片
    public func resize(to newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        defer {
            UIGraphicsEndImageContext()
        }
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        return newImage
    }
}
