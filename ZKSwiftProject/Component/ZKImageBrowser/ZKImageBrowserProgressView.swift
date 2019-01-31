//
//  ZKImageBrowserProgressView.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2019/1/18.
//  Copyright © 2019 bestdew. All rights reserved.
//

import UIKit

class ZKImageBrowserProgressView: UIView {

    enum Style: Int {
        case ring  /// 环形
        case pie   /// 饼形
    }
    
    var progress: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
            if progress >= 1 {
                removeFromSuperview()
            }
        }
    }
    var style: ZKImageBrowserProgressView.Style = .ring
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            layer.cornerRadius = 25
            super.frame = CGRect(origin: newValue.origin, size: CGSize(width: 50, height: 50))
        }
    }
    
    convenience init(frame: CGRect, style: ZKImageBrowserProgressView.Style) {
        self.init(frame: frame)
        self.style = style
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let centerX = rect.width * 0.5
        let centerY = rect.height * 0.5
        
        UIColor.white.set()
        
        switch style {
        case .pie:
            let radius = min(centerX, centerY) - 10
            let w = radius * 2 + 10
            let h = w
            let x = (rect.width - bounds.width) * 0.5
            let y = (rect.height - bounds.height) * 0.5
            context.addEllipse(in: CGRect(x: x, y: y, width: w, height: h))
            context.fillPath()
            
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).set()
            context.move(to: CGPoint(x: centerX, y: centerY))
            context.addLine(to: CGPoint(x: centerX, y: 0))
            let to = -.pi * 0.5 + progress * .pi * 2 + 0.001
            context.addArc(center: CGPoint(x: centerX, y: centerY), radius: radius, startAngle: -.pi * 0.5, endAngle: to, clockwise: true)
            context.closePath()
            
            context.fillPath()
        default:
            context.setLineWidth(4)
            context.setLineCap(.round)
            let to = -.pi * 0.5 + progress * .pi * 2 + 0.05
            let radius = min(rect.width, rect.height) * 0.5 - 10
            context.addArc(center: CGPoint(x: centerX, y: centerY), radius: radius, startAngle: -.pi * 0.5, endAngle: to, clockwise: false)
            context.strokePath()
        }
    }
}
