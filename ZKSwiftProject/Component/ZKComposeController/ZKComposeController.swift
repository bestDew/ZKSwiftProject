//
//  ZKComposeController.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2019/1/2.
//  Copyright © 2019 bestdew. All rights reserved.
//

import UIKit

public class ZKComposeItem: NSObject {
    
    public typealias ZKComposeItemAction = (ZKComposeItem) -> Void
    
    public var title: String?
    public var image: UIImage?
    public var isEnabled: Bool = true
    public var action: ZKComposeItemAction?
    
    public convenience init(title: String?, image: UIImage?, action: ZKComposeItemAction?) {
        self.init()
        self.title = title
        self.image = image
        self.action = action
    }
}

public class ZKComposeController: UIViewController {
    
    private var page: Int = 0
    private var items = [ZKComposeItem]()
    private var buttons = [ZKComposeButton]()
    private var pageControl: UIPageControl?
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 49.0, height: 49.0)
        button.center = CGPoint(x: view.centerX, y: view.height - 24.5 - kBottomMargin)
        button.adjustsImageWhenHighlighted = false
        button.transform = CGAffineTransform.identity
        button.setImage(UIImage(named: "tabbar_compose_background_icon_add"), for: .normal)
        button.addTarget(self, action: #selector(closeButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    convenience public init(items: [ZKComposeItem]) {
        self.init()
        self.items += items
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addBlurEffect()
        addMenuItemButtons()
    }
    
    private func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = view.bounds
        view.addSubview(visualEffectView)
    }
    
    private func addMenuItemButtons() {
        
        let pages = Int(ceilf(Float(items.count) / 6))
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: CGFloat(pages) * view.width, height: view.height)
        view.addSubview(scrollView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
        scrollView.addGestureRecognizer(tapGesture)
        
        view.addSubview(closeButton)
        
        let margin = closeButton.y - 300.0
        let spacing = (scrollView.width - 240.0) / 4
        for (index, item) in items.enumerated() {
            let page = Int(index / 6)
            let x = spacing + CGFloat(index % 3) * (spacing + 80.0)  + CGFloat(page) * scrollView.width
            let y = CGFloat((index % 6) / 3) * 125.0 + margin
            let button = ZKComposeButton(type: .custom)
            button.frame = CGRect(x: x, y: y, width: 80.0, height: 105.0)
            button.tag = 10 + index
            button.isEnabled = item.isEnabled
            button.setTitle(item.title, for: .normal)
            button.setImage(item.image, for: .normal)
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
            button.setTitleColor(UIColor.darkText, for: .normal)
            button.transform = CGAffineTransform(translationX: 0.0, y: view.height - y)
            button.addTarget(self, action: #selector(itemButtonAction(_:)), for: .touchUpInside)
            scrollView.addSubview(button)
            
            buttons.append(button)
        }
        
        guard pages > 1 else { return }
        
        let w = CGFloat(pages * 15)
        let x = (view.width - w) / 2
        let y = closeButton.y - 30.0
        pageControl = UIPageControl(frame: CGRect(x: x, y: y, width: w, height: 20.0))
        pageControl!.numberOfPages = pages
        pageControl!.hidesForSinglePage = true
        pageControl!.pageIndicatorTintColor = UIColor(hexString: "#C0C0C0")!
        pageControl!.currentPageIndicatorTintColor = UIColor(hexString: "#EF8833")!
        view.addSubview(pageControl!)
    }
    
    @objc private func closeButtonAction(_ button: UIButton) {
        hide(animated: true)
    }
    
    @objc private func itemButtonAction(_ button: UIButton) {
        dismiss(animated: false) {
            let index = button.tag - 10
            let item = self.items[index]
            item.action?(item)
        }
    }
    
    @objc private func tapGestureAction(_ tap: UITapGestureRecognizer) {
        hide(animated: true)
    }

    public func show(from viewController: UIViewController, animated: Bool) {
        guard animated else {
            self.closeButton.transform = CGAffineTransform(rotationAngle: .pi / 4 * 3)
            for button in self.buttons { button.transform = CGAffineTransform.identity }
            viewController.present(self, animated: true, completion: nil)
            return
        }
        viewController.present(self, animated: false) {
            DispatchQueue.main.async {
                let options: UIView.AnimationOptions = [.curveLinear, .beginFromCurrentState]
                UIView.animate(withDuration: 0.3, delay: 0.0, options: options, animations: {
                    self.closeButton.transform = CGAffineTransform(rotationAngle: .pi / 4 * 3)
                }, completion: nil)
                for (index, button) in self.buttons.enumerated() {
                    if index < 6 {
                        let delay: TimeInterval = Double(index % 3) * 0.05
                        UIView.animate(withDuration: 0.4, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.05, options: options, animations: {
                            button.transform = CGAffineTransform.identity
                        }, completion: nil)
                    } else {
                        button.transform = CGAffineTransform.identity
                    }
                }
            }
        }
    }
    
    public func hide(animated flag: Bool) {
        guard flag else {
            dismiss(animated: true, completion: nil)
            return
        }
        let options: UIView.AnimationOptions = [.curveLinear, .beginFromCurrentState]
        UIView.animate(withDuration: 0.3, delay: 0.0, options: options, animations: {
            self.closeButton.transform = CGAffineTransform.identity
        }) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        let preCount = page * 6
        let sufCount = preCount + 5
        for (index, button) in self.buttons.enumerated() {
            if index < preCount || index > sufCount { continue }
            let ty = view.height - button.y
            let delay: TimeInterval = Double(3 - index % 3) * 0.05
            UIView.animate(withDuration: 0.4, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.05, options: options, animations: {
                button.transform = CGAffineTransform(translationX: 0.0, y: ty)
            }, completion: nil)
        }
    }
    
    public func addItem(_ item: ZKComposeItem) {
        guard items.contains(item) else {
            items.append(item)
            return
        }
    }
    
    deinit {
        print("销毁")
    }
}

extension ZKComposeController: UIScrollViewDelegate {
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        page = Int(scrollView.contentOffset.x / scrollView.width)
        pageControl?.currentPage = page
    }
}

fileprivate class ZKComposeButton: UIButton {
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let size = min(contentRect.width - 20.0, contentRect.height - 45.0)
        let newRect = CGRect(x: 10.0, y: 10.0, width: size, height: size)
        return newRect
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let newRect = CGRect(x: 0.0, y: contentRect.height - 30.0, width: contentRect.width, height: 30.0)
        return newRect
    }
}
