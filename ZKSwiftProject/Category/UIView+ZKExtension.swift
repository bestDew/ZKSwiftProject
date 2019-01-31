//
//  UIView+ZKExtension.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2018/12/29.
//  Copyright © 2018 bestdew. All rights reserved.
//

import UIKit

// MARK: - Layout
public extension UIView {
    
    public var x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }
    
    public var y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
    
    public var width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }
    
    public var height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }
    
    public var size: CGSize {
        get {
            return frame.size
        }
        set {
            frame.size = newValue
        }
    }
}

// MARK: - 相关操作
public extension UIView {
    
    /// 获取所属的视图控制器
    public var viewController: UIViewController? {
        var nextView: UIView? = self
        while nextView?.superview != nil {
            nextView = nextView?.superview
            if let nextResponder = nextView?.next, let viewController = nextResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    /// 移除指定类型视图
    ///
    /// - Parameter subviewClass: 视图类型，默认为 UIView
    public func removeSubviews(_ subviewClass: AnyClass = UIView.self) {
        for subview in self.subviews {
            if subview.isKind(of: subviewClass) {
                subview.removeFromSuperview()
            }
        }
    }
    
    public func snapshotImage(_ rect: CGRect = .zero, scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        // 获取整个区域图片
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        drawHierarchy(in: frame, afterScreenUpdates: true)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        // 如果不裁剪图片，直接返回整张图片
        if rect.equalTo(.zero) || rect.equalTo(bounds) {
            return image
        }
        // 按照给定的矩形区域进行裁剪
        guard let sourceImageRef = image.cgImage else { return nil }
        let newRect = rect.applying(CGAffineTransform(scaleX: scale, y: scale))
        guard let newImageRef = sourceImageRef.cropping(to: newRect) else { return nil }
        // 将 CGImageRef 转换为 UIImage
        let newImage = UIImage(cgImage: newImageRef, scale: scale, orientation: .up)
        return newImage
    }
}

// MARK: - Scale with animation
public extension UIView {
    
    public func scale() {
        let options: UIView.AnimationOptions = [.beginFromCurrentState, .allowUserInteraction]
        UIView.animate(withDuration: 0.15, delay: 0, options: options, animations: {
            self.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }, completion: nil)
    }
    
    public func restoreScale() {
        let options: UIView.AnimationOptions = [.beginFromCurrentState, .allowUserInteraction]
        UIView.animate(withDuration: 0.15, delay: 0, options: options, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}
