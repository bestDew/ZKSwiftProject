//
//  UIColor+ZKExtension.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2018/12/29.
//  Copyright © 2018 bestdew. All rights reserved.
//

import UIKit

public extension UIColor {
    
    convenience init?(hexString: String) {
        self.init(hexString: hexString, alpha: 1.0)
    }
    
    convenience init?(hexString: String, alpha: CGFloat) {
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
        
        if cString.count != 6 {
            return nil
        }
        
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
        
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    
    class func random() -> UIColor {
        let r = CGFloat.random()
        let g = CGFloat.random()
        let b = CGFloat.random()
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}

