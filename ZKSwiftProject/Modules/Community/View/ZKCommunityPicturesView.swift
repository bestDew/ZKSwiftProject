//
//  ZKCommunityPicturesView.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2019/1/11.
//  Copyright © 2019 bestdew. All rights reserved.
//

import UIKit

private typealias ZKPicturesViewItemTapAction = ((_ item: ZKCommunityPicturesViewItem) -> Void)

private class ZKCommunityPicturesViewItem: UIImageView {
    
    var metaData: ZKTimelinePicture? {
        didSet {
            guard let thumbnailPic = metaData?.thumbnailPic else {
                image = nil
                return
            }
            kf.setImage(with: URL(string: thumbnailPic), placeholder: UIImage(named: "placeholder_image"), options: [.transition(.fade(0.2))])
            switch metaData?.type {
            case 1: typeImageView.image = UIImage(named: "timeline_image_longimage")
            case 2: typeImageView.image = UIImage(named: "timeline_image_gif")
            default: typeImageView.image = nil
            }
        }
    }
    
    var tapAction: ZKPicturesViewItemTapAction?
    
    private lazy var typeImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(image: UIImage?) {
        super.init(image: image)
        
        clipsToBounds = true
        layer.cornerRadius = 6
        contentMode = .scaleAspectFill
        isUserInteractionEnabled = true
        
        addSubview(typeImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        typeImageView.frame = CGRect(x: width - 22, y: height - 14, width: 22, height: 14)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        scale()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        restoreScale()
        if let tapAction = tapAction { tapAction(self) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        restoreScale()
    }
}

class ZKCommunityPicturesView: UIView {
    
    private var itemReusePool = [ZKCommunityPicturesViewItem]()
    
    var layout: ZKTimelineLayout? {
        didSet {
            guard let layout = layout else { return }
            isHidden = layout.status.type != 1
            guard let pictures = layout.status.pictures else { return }
            
            frame = layout.picturesViewFrame
            
            for (index, item) in itemReusePool.enumerated() {
                if index < pictures.count {
                    item.isHidden = false
                    item.metaData = pictures[index]
                    item.frame = layout.picturesViewItemFrames[index]
                } else {
                    item.isHidden = true
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addPicturesViewItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addPicturesViewItems() {
        for _ in 0 ..< 9 {
            let item = ZKCommunityPicturesViewItem(image: nil)
            item.isHidden = true
            item.tapAction = { [weak self] it in
                guard let strongSelf = self else { return }
                strongSelf.showImageBrowser(with: it)
            }
            addSubview(item)
            itemReusePool.append(item)
        }
    }
    
    private func showImageBrowser(with item: ZKCommunityPicturesViewItem) {
        guard let viewController = viewController else { return }
        guard let pictures = layout?.status.pictures else { return }
        
        var index = 0
        var browserItems = [ZKImageBrowserItem]()
        for (i, element) in itemReusePool.prefix(pictures.count).enumerated() {
            let browserItem = ZKImageBrowserItem(thumbnailImageView: element, originalImageURL: URL(string: element.metaData!.originalPic))
            browserItems.append(browserItem)
            if element === item { index = i }
        }
        let browser = ZKImageBrowserController(items: browserItems, currentIndex: index)
        browser.show(from: viewController, animated: true)
    }
}
