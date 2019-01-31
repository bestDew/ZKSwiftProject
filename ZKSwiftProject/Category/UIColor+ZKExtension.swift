//
//  UIColor+ZKExtension.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2018/12/29.
//  Copyright © 2018 bestdew. All rights reserved.
//

import UIKit

public extension UIColor {
    
    /// r、g、b、a 元组（范围：0 ~ 255）
    public typealias RGBAValue = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    
    /// 获取 r，g，b，a 的值
    public var rgbaValue: RGBAValue {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red * 255, green * 255, blue * 255, alpha)
    }
    
    /// 是否是深色
    public var isDark: Bool {
        if (rgbaValue.red * 0.299 + rgbaValue.green * 0.587 + rgbaValue.blue * 0.114 >= 192) {
            return false
        } else {
            return true
        }
    }
    
    /// 获取反色
    public var nvertColor: UIColor {
        return UIColor(red: 255 - rgbaValue.red, green: 255 - rgbaValue.green, blue: 255 - rgbaValue.blue, alpha: rgbaValue.alpha)
    }
    
    /// 亮色高亮
    public var lightTypeHighlightColor: UIColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s - 0.4, brightness: b, alpha: a)
    }
    
    /// 暗色高亮
    public var darkTypeHighlightColor: UIColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: b - 0.2, alpha: a)
    }

    convenience public init?(hexString: String) {
        self.init(hexString: hexString, alpha: 1)
    }
    
    convenience public init?(hexString: String, alpha: CGFloat) {
        // 删除字符串中的空格
        var cString = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased();
        // 如果是 0x 或 0X 开头的，则截取字符串，从索引为 2 的位置开始，直到末尾
        if cString.hasPrefix("0x") || cString.hasPrefix("0X") {
            cString = String(cString.suffix(cString.count - 2))
        }
        // 如果是 # 开头的，则截取字符串，从索引为 1 的位置开始，直到末尾
        if cString.hasPrefix("#") {
            cString = String(cString.suffix(cString.count - 1))
        }
        
        guard cString.count == 6 else { return nil }
        
        // r
        let rString = String(cString.prefix(2))
        // g
        let index1 = cString.index(cString.startIndex, offsetBy: 2)
        let index2 = cString.index(cString.startIndex, offsetBy: 3)
        let gString = String(cString[index1...index2])
        // b
        let bString = String(cString.suffix(2))
        
        var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: alpha)
    }
    
    class public func random() -> UIColor {
        let r = CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        let g = CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        let b = CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
}

