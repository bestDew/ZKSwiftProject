//
//  ZKImageBrowserController.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2019/1/16.
//  Copyright © 2019 bestdew. All rights reserved.
//

import UIKit
import Photos

class ZKImageBrowserController: UIViewController {
    
    private(set) var index: Int = 0
    var items: [ZKImageBrowserItem]
    
    private var targetRect = CGRect.zero
    private var scrollView = UIScrollView()
    private var pageControl = UIPageControl()
    private var visualEffectView = UIVisualEffectView()
    private var animatedImageView: UIImageView = UIImageView()
    private let fromViewControllerStatusBarHidden = UIApplication.shared.isStatusBarHidden
    private lazy var statusBar: UIView = {
        let statusBar = (UIApplication.shared.value(forKey: "statusBarWindow") as! UIWindow).value(forKey: "statusBar") as! UIView
        return statusBar
    }()
    private var lastOffsetX: CGFloat = 0
    private var currentItem: ZKImageBrowserItem?
    
    init(items: [ZKImageBrowserItem], currentIndex: Int = 0) {
        self.items = items
        super.init(nibName: nil, bundle: nil)
        self.index = currentIndex
        self.currentItem = items[currentIndex]
        
        self.modalPresentationStyle = .custom
        self.modalTransitionStyle = .crossDissolve
        
        guard let item = self.currentItem else { return }
        self.animatedImageView.contentMode = item.thumbnailImageView.contentMode
        self.animatedImageView.clipsToBounds = item.thumbnailImageView.clipsToBounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        addGestureRecognizers()
    }
    
    func setIndex(_ index: Int, animated: Bool) {
        guard items.count > 0 else { return }
        
        let idx = min(max(index, 0), items.count)
        let offset = CGPoint(x: scrollView.width * CGFloat(idx), y: 0)
        scrollView.setContentOffset(offset, animated: animated)
    }
    
    func show(from viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        if animated {
            prepareForAnimation(true)
            
            viewController.present(self, animated: false) {
                DispatchQueue.main.async {
                    self.currentItem?.thumbnailImageView.alpha = 0
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .beginFromCurrentState, animations: {
                        self.pageControl.alpha = 1
                        self.visualEffectView.alpha = 1
                        if !self.fromViewControllerStatusBarHidden {
                            self.statusBar.alpha = 0
                        }
                        self.animatedImageView.frame = self.targetRect
                        self.animatedImageView.layer.cornerRadius = 0
                    }, completion: { _ in
                        self.hidePageControl(true)
                        self.scrollView.isHidden = false
                        self.animatedImageView.removeFromSuperview()
                        if let completion = completion { completion() }
                    })
                }
            }
        } else {
            pageControl.alpha = 1
            visualEffectView.alpha = 1
            scrollView.isHidden = false
            hidePageControl(true)
            currentItem?.thumbnailImageView.alpha = 0
            if !fromViewControllerStatusBarHidden {
                statusBar.alpha = 0
            }
            viewController.present(self, animated: false, completion: completion)
        }
    }
    
    func hide(animated flag: Bool, completion: (() -> Void)? = nil) {
        if flag {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .beginFromCurrentState, animations: {
                self.pageControl.alpha = 0
                self.visualEffectView.alpha = 0
                if !self.fromViewControllerStatusBarHidden {
                    self.statusBar.alpha = 1
                }
                if (self.currentItem?.thumbnailImageView.superview) != nil  {
                    self.animatedImageView.transform = self.view.transform.inverted()
                }
                self.animatedImageView.frame = self.targetRect
                self.animatedImageView.layer.cornerRadius = self.currentItem?.thumbnailImageView.layer.cornerRadius ?? 0
            }) { _ in
                self.currentItem?.thumbnailImageView.alpha = 1
                super.dismiss(animated: false, completion: completion)
            }
        } else {
            currentItem?.thumbnailImageView.alpha = 1
            if !fromViewControllerStatusBarHidden {
                statusBar.alpha = 1
            }
            super.dismiss(animated: false, completion: completion)
        }
    }
    
    private func prepareForAnimation(_ isShow: Bool) {
        guard let currentItem = currentItem else { return }
        
        if isShow {
            animatedImageView.image = currentItem.placeholder
            animatedImageView.layer.cornerRadius = currentItem.thumbnailImageView.layer.cornerRadius
            if let sourceView = currentItem.thumbnailImageView.superview {
                let convertRect = sourceView.convert(currentItem.thumbnailImageView.frame, to: view)
                animatedImageView.frame = convertRect
            } else {
                animatedImageView.frame = CGRect(origin: view.center, size: CGSize.zero)
            }
            view.addSubview(animatedImageView)
        } else {
            let currentCell = scrollView.subviews[index] as! ZKImageBrowserCell
            animatedImageView.image = currentCell.imageView.image
            let x = currentCell.imageView.x - currentCell.scrollOffset.x
            let y = currentCell.imageView.y - currentCell.scrollOffset.y
            animatedImageView.frame = CGRect(origin: CGPoint(x: x, y: y), size: currentCell.zoomImageSize)
            view.addSubview(animatedImageView)
            
            scrollView.isHidden = true
            
            if let imageContainerView = currentItem.thumbnailImageView.superview {
                targetRect = imageContainerView.convert(currentItem.thumbnailImageView.frame, to: view)
            } else {
                targetRect = CGRect(origin: view.center, size: CGSize.zero)
            }
        }
    }
    
    private func hidePageControl(_ isHide: Bool) {
        let delay = isHide ? 0.8 : 0
        UIView.animate(withDuration: 0.3, delay: delay, options: .beginFromCurrentState, animations: {
            self.pageControl.alpha = isHide ? 0 : 1
        }, completion: nil)
    }
    
    private func bounceToOriginPosition() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .beginFromCurrentState, animations: {
            self.animatedImageView.transform = CGAffineTransform.identity
            if !self.fromViewControllerStatusBarHidden {
                self.statusBar.alpha = 0
            }
            self.visualEffectView.alpha = 1
        }) { _ in
            self.scrollView.isHidden = false
            self.animatedImageView.removeFromSuperview()
        }
    }
    
    private func addSubviews() {
        visualEffectView.effect = UIBlurEffect(style: .dark)
        visualEffectView.frame = view.bounds
        visualEffectView.alpha = 0
        view.addSubview(visualEffectView)
        
        scrollView.frame = view.bounds
        scrollView.isHidden = true
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.isMultipleTouchEnabled = true
        scrollView.delaysContentTouches = false
        scrollView.canCancelContentTouches = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: view.width * CGFloat(items.count), height: view.height)
        scrollView.contentOffset = CGPoint(x: view.width * CGFloat(index), y: 0)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        view.addSubview(scrollView)
        
        pageControl.frame = CGRect(x: 0, y: view.height - 34, width: view.width, height: 10)
        pageControl.alpha = 0
        pageControl.numberOfPages = items.count
        pageControl.currentPage = index
        pageControl.hidesForSinglePage = true
        view.addSubview(pageControl)
        
        let currentItem = items[index]
        let contentMode = currentItem.thumbnailImageView.contentMode
        let clipsToBounds = currentItem.thumbnailImageView.clipsToBounds
        
        for (i, item) in items.enumerated() {
            let x = view.width * CGFloat(i)
            let cell = ZKImageBrowserCell(frame: CGRect(x: x, y: 0, width: view.width, height: view.height), item: item)
            cell.imageView.contentMode = contentMode
            cell.imageView.clipsToBounds = clipsToBounds
            cell.willEndDragging = { [weak self] (velocity, offset, size) in
                guard let strongSelf = self else { return }
                if offset.y >= 0 && offset.y <= size.height - strongSelf.view.height { return }
                if abs(velocity.y) > 0.5 {
                    strongSelf.prepareForAnimation(false)
                    strongSelf.hide(animated: true)
                }
            }
            scrollView.addSubview(cell)
            if i == index { targetRect = cell.imageView.frame }
        }
        lastOffsetX = scrollView.contentOffset.x
    }
    
    private func addGestureRecognizers() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapAction(_:)))
        view.addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction(_:)))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(_:)))
        view.addGestureRecognizer(longPress)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        view.addGestureRecognizer(panGesture)
        
        singleTap.require(toFail: doubleTap)
        singleTap.require(toFail: longPress)
        singleTap.require(toFail: panGesture)
    }
    
    // MARK: - Action
    @objc private func singleTapAction(_ singleTap: UITapGestureRecognizer) {
        prepareForAnimation(false)
        hide(animated: true)
    }
    
    @objc private func doubleTapAction(_ doubleTap: UITapGestureRecognizer) {
        let currentCell = scrollView.subviews[index] as! ZKImageBrowserCell
        if currentCell.scrollView.zoomScale > 1 {
            currentCell.scrollView.setZoomScale(1, animated: true)
        } else {
            let touchPoint = doubleTap.location(in: view)
            let scaleX = touchPoint.x + currentCell.scrollView.contentOffset.x
            let scaleY = touchPoint.y + currentCell.scrollView.contentOffset.y
            currentCell.scrollView.zoom(to: CGRect(x: scaleX, y: scaleY, width: 10, height: 10), animated: true)
        }
    }
    
    @objc private func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        let point = panGesture.translation(in: view)
        let velocity = panGesture.velocity(in: view)
        
        switch panGesture.state {
        case .began:
            prepareForAnimation(false)
        case .changed:
            let delt = max(1 - abs(point.y) / view.height, 0)
            let multiple = max(delt, 0.5)
            let translation = CGAffineTransform(translationX: point.x / multiple, y: point.y / multiple)
            let scale = CGAffineTransform(scaleX: multiple, y: multiple)
            
            animatedImageView.transform = translation.concatenating(scale)
            visualEffectView.alpha = multiple
            if !fromViewControllerStatusBarHidden {
                statusBar.alpha = 1 - multiple
            }
        case .ended:
            if abs(point.y) > 220 || abs(velocity.y) > 500 { // 退出图片浏览器
                hide(animated: true)
            } else { // 回到原来位置
                bounceToOriginPosition()
            }
        default:
            break
        }
    }
    
    @objc private func longPressAction(_ longPress: UILongPressGestureRecognizer) {
        let currentCell = scrollView.subviews[index] as! ZKImageBrowserCell
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let saveAction = UIAlertAction(title: "保存图片", style: .default) { _ in
            guard let image = currentCell.imageView.image else { return }
            self.saveImage(image)
        }
        sheet.addAction(saveAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        sheet.addAction(cancelAction)
        present(sheet, animated: true, completion: nil)
    }
    
    // MARK: - 保存图片
    private func saveImage(_ image: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                if status == .notDetermined || status == .authorized {
                    UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
                } else {
                    let alert = UIAlertController(title: "无法保存", message: "请在iPhone的\"设置-隐私-照片\"选项中，允许访问你的照片", preferredStyle: .alert)
                    let action = UIAlertAction(title: "👌", style: .cancel, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc private func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if let error = error {
            print(error)
        } else {
            print("保存成功！")
        }
    }

    deinit {
        print("销毁！")
    }
}

extension ZKImageBrowserController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        index = min(max(Int((scrollView.contentOffset.x + scrollView.width * 0.5) / scrollView.width), 0), items.count)
        pageControl.currentPage = index
        
        let multiple = scrollView.contentOffset.x / scrollView.width
        let toIndex = scrollView.contentOffset.x > lastOffsetX ? Int(ceil(multiple)) : Int(floor(multiple))
        guard toIndex >= 0 && toIndex < items.count else { return }
        let toItem = items[toIndex]
        toItem.thumbnailImageView.alpha = 1 - abs(scrollView.contentOffset.x - lastOffsetX) / scrollView.width
        currentItem?.thumbnailImageView.alpha = 1 - toItem.thumbnailImageView.alpha
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate { hidePageControl(true) }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        hidePageControl(true)
        currentItem = items[index];
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        hidePageControl(false)
        currentItem = items[index];
        lastOffsetX = scrollView.contentOffset.x
    }
}
