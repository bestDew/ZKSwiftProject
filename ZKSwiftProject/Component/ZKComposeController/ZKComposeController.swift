//
//  ZKComposeController.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2019/1/2.
//  Copyright © 2019 bestdew. All rights reserved.
//

import UIKit

public struct ZKComposeItem: Equatable {
    
    public typealias ZKComposeItemAction = (ZKComposeItem) -> Void
    
    public var title: String?
    public var image: UIImage?
    public var isEnabled: Bool = true
    public var action: ZKComposeItemAction?
    
    public static func == (lhs: ZKComposeItem, rhs: ZKComposeItem) -> Bool {
        return lhs.title == rhs.title && lhs.image == rhs.image
    }
    
    public init(title: String?, image: UIImage?, action: ZKComposeItemAction?) {
        self.title = title
        self.image = image
        self.action = action
        self.isEnabled = true
    }
}

public class ZKComposeController: UIViewController {
    
    private var pageIndex: Int = 0
    private var numberOfPages: Int = 0
    private var items = [ZKComposeItem]()
    private var buttons = [ZKComposeButton]()
    private var pageControl: CHIPageControlPuya?
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 49, height: 49)
        button.center = CGPoint(x: view.frame.midX, y: view.height - 24.5 - kBottomMargin)
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
        addItemButtons()
        addOtherViews()
    }
    
    private func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = view.bounds
        view.addSubview(visualEffectView)
    }
    
    private func addItemButtons() {
        numberOfPages = Int(ceilf(Float(items.count) / 6))
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: CGFloat(numberOfPages) * view.width, height: view.height)
        view.addSubview(scrollView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
        scrollView.addGestureRecognizer(tapGesture)
        
        let margin = closeButton.y - 300
        let spacing = (scrollView.width - 240) / 4
        for (index, item) in items.enumerated() {
            let page = Int(index / 6)
            let x = spacing + CGFloat(index % 3) * (spacing + 80)  + CGFloat(page) * scrollView.width
            let y = CGFloat((index % 6) / 3) * 125 + margin
            let button = ZKComposeButton(type: .custom)
            button.frame = CGRect(x: x, y: y, width: 80, height: 105)
            button.tag = 10 + index
            button.isEnabled = item.isEnabled
            button.setTitle(item.title, for: .normal)
            button.setImage(item.image, for: .normal)
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.setTitleColor(UIColor.darkText, for: .normal)
            if page > 0 {
                button.transform = CGAffineTransform.identity
            } else {
                button.transform = CGAffineTransform(translationX: 0, y: view.height - y)
            }
            button.addTarget(self, action: #selector(itemButtonAction(_:)), for: .touchUpInside)
            scrollView.addSubview(button)
            
            buttons.append(button)
        }
        
        guard numberOfPages > 1 else { return }
        
        let w = CGFloat(numberOfPages * 15)
        let x = (view.width - w) / 2
        let y = closeButton.y - 30
        pageControl = CHIPageControlPuya(frame: CGRect(x: x, y: y, width: w, height: 8))
        pageControl!.radius = 4
        pageControl!.numberOfPages = numberOfPages
        pageControl!.hidesForSinglePage = true
        pageControl!.tintColor = UIColor(hexString: "#C0C0C0")!
        pageControl!.currentPageTintColor = kThemeColor
        view.addSubview(pageControl!)
    }
    
    private func addOtherViews() {
        view.addSubview(closeButton)
        
        let dayLabel = UILabel(frame: CGRect(origin: CGPoint(x: 20, y: kTopMargin), size: CGSize.zero))
        dayLabel.font = UIFont.systemFont(ofSize: 45)
        dayLabel.textColor = UIColor.darkGray
        dayLabel.text = String(format: "%02d", Date().day)
        dayLabel.sizeToFit()
        view.addSubview(dayLabel)
        
        let weekLabel = UILabel(frame: CGRect(origin: CGPoint(x: dayLabel.frame.maxX + 12, y: kTopMargin + 10), size: CGSize.zero))
        weekLabel.font = UIFont.systemFont(ofSize: 12)
        weekLabel.textColor = UIColor.gray
        weekLabel.text = Date().weekdayName
        weekLabel.sizeToFit()
        view.addSubview(weekLabel)
        
        let yearLabel = UILabel(frame: CGRect(origin: CGPoint(x: weekLabel.x, y: weekLabel.frame.maxY + 5), size: CGSize.zero))
        yearLabel.font = UIFont.systemFont(ofSize: 12)
        yearLabel.textColor = UIColor.gray
        yearLabel.text = String(format: "%02d/%d", Date().month, Date().year)
        yearLabel.sizeToFit()
        view.addSubview(yearLabel)

        let weatherLabel = UILabel(frame: CGRect(origin: CGPoint(x: dayLabel.x + 3, y: dayLabel.frame.maxY + 3), size: CGSize.zero))
        weatherLabel.font = UIFont.systemFont(ofSize: 13)
        weatherLabel.textColor = UIColor.gray
        weatherLabel.text = "北京：多云 -5℃"
        weatherLabel.sizeToFit()
        view.addSubview(weatherLabel)
    }
    
    @objc private func closeButtonAction(_ button: UIButton) {
        hide(with: true)
    }
    
    @objc private func itemButtonAction(_ button: ZKComposeButton) {
        self.dismiss(animated: false) {
            let index = button.tag - 10
            let item = self.items[index]
            item.action?(item)
        }
    }
    
    @objc private func tapGestureAction(_ tap: UITapGestureRecognizer) {
        hide(with: true)
    }

    public func show(from viewController: UIViewController, animated: Bool) {
        if animated {
            viewController.present(self, animated: false) {
                DispatchQueue.main.async {
                    let options: UIView.AnimationOptions = [.curveLinear, .beginFromCurrentState]
                    UIView.animate(withDuration: 0.3, delay: 0, options: options, animations: {
                        self.closeButton.transform = CGAffineTransform(rotationAngle: .pi / 4 * 3)
                    }, completion: nil)
                    for (index, button) in self.buttons.prefix(6).enumerated() {
                        let delay: TimeInterval = Double(index) * 0.025
                        UIView.animate(withDuration: 0.5, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.05, options: options, animations: {
                            button.transform = CGAffineTransform.identity
                        }, completion: nil)
                    }
                }
            }
        } else {
            self.closeButton.transform = CGAffineTransform(rotationAngle: .pi / 4 * 3)
            for button in buttons.prefix(6) { button.transform = CGAffineTransform.identity}
            viewController.present(self, animated: true, completion: nil)
        }
    }
    
    public func hide(with animated: Bool) {
        if animated {
            let options: UIView.AnimationOptions = [.curveLinear, .beginFromCurrentState]
            UIView.animate(withDuration: 0.3, delay: 0, options: options, animations: {
                self.closeButton.transform = CGAffineTransform.identity
            }) { _ in
                self.dismiss(animated: true, completion: nil)
            }
            let preIndex = pageIndex * 6
            let sufIndex = min(preIndex + 5, buttons.count - 1)
            for (index, button) in buttons[preIndex...sufIndex].enumerated() {
                let ty = view.height - button.y
                let delay: TimeInterval = Double(sufIndex - preIndex - index) * 0.025
                UIView.animate(withDuration: 0.5, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.05, options: options, animations: {
                    button.transform = CGAffineTransform(translationX: 0, y: ty)
                }, completion: nil)
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    public func addItem(_ item: ZKComposeItem) {
        if !items.contains(item) { items.append(item) }
    }
}

extension ZKComposeController: UIScrollViewDelegate {
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageIndex = Int(scrollView.contentOffset.x / scrollView.width)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let total = CGFloat(numberOfPages - 1) * scrollView.bounds.width
        let offset = scrollView.contentOffset.x.truncatingRemainder(dividingBy:(scrollView.bounds.width * CGFloat(numberOfPages)))
        let percent = Double(offset / total)
        let progress = percent * Double(numberOfPages - 1)
        pageControl?.progress = progress
    }
}

private class ZKComposeButton: UIButton {
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let size = min(contentRect.width - 20, contentRect.height - 45)
        let newRect = CGRect(x: 10, y: 10, width: size, height: size)
        return newRect
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let newRect = CGRect(x: 0, y: contentRect.height - 30, width: contentRect.width, height: 30)
        return newRect
    }
}
