//
//  ZKImageBrowserCell.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2019/1/16.
//  Copyright © 2019 bestdew. All rights reserved.
//

import UIKit

class ZKImageBrowserCell: UIView {
    
    var item: ZKImageBrowserItem
    let imageView = UIImageView()
    let scrollView = UIScrollView()
    var scrollOffset = CGPoint.zero
    var zoomImageSize = CGSize.zero
    var willEndDragging: ((CGPoint, CGPoint, CGSize) -> Void)?

    init(frame: CGRect, item: ZKImageBrowserItem) {
        self.item = item
        super.init(frame: frame)
        
        setUpSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpSubviews() {
        scrollView.frame = bounds
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3
        scrollView.clipsToBounds = true
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        adjustFrame(with: item.placeholder.size, animated: false)
        addSubview(scrollView)
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: item.originalImageURL, placeholder: item.placeholder, options: [.transition(.fade(0.2))]) { [weak self] (image, error, cacheType, imageURL) in
            guard let strongSelf = self else { return }
            if error == nil && image != nil {
                strongSelf.adjustFrame(with: image!.size, animated: true)
            } else {
                print("图片加载失败<URL = \(imageURL?.absoluteString ?? "")>")
            }
        }
        scrollView.addSubview(imageView)
    }

    private func adjustFrame(with imageSize: CGSize, animated: Bool) {
        let h = imageSize.height / imageSize.width * width
        let y = h > height ? 0 : (height - h) / 2
        scrollView.contentSize = CGSize(width: width, height: h)
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.imageView.frame = CGRect(x: 0, y: y, width: self.width, height: h)
            })
        } else {
            imageView.frame = CGRect(x: 0, y: y, width: width, height: h)
        }
        zoomImageSize = scrollView.contentSize
    }
}

extension ZKImageBrowserCell: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let contentSize = scrollView.contentSize
        let offsetX = scrollView.width > contentSize.width ? (scrollView.width - contentSize.width) * 0.5 : 0
        let offsetY = scrollView.height > contentSize.height ? (scrollView.height - contentSize.height) * 0.5 : 0
        imageView.center = CGPoint(x: contentSize.width * 0.5 + offsetX, y: contentSize.height * 0.5 + offsetY)
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollOffset = scrollView.contentOffset
        zoomImageSize = view?.frame.size ?? CGSize.zero
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollOffset = scrollView.contentOffset
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let willEndDragging = willEndDragging {
            willEndDragging(velocity, scrollView.contentOffset, scrollView.contentSize)
        }
    }
}
