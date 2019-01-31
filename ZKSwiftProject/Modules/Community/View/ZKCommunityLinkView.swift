//
//  ZKCommunityLinkView.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2019/1/11.
//  Copyright © 2019 bestdew. All rights reserved.
//

import UIKit

class ZKCommunityLinkView: UIView {
    
    var layout: ZKTimelineLayout? {
        didSet {
            guard let layout = layout else { return }
            isHidden = layout.status.type != 0
            guard let link = layout.status.link else { return }
            
            frame = layout.linkViewFrame
            imageView.frame = layout.linkImageViewFrame
            imageView.kf.setImage(with: URL(string: link.thumbnailPic), placeholder: UIImage(named: "placeholder_image"), options: [.transition(.fade(0.2))])
            textLabel.frame = layout.linkTextLabelFrame
            textLabel.textLayout = layout.linkTextLayout
        }
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var textLabel: YYLabel = {
        let label = YYLabel()
        label.displaysAsynchronously = true
        label.ignoreCommonProperties = true
        label.fadeOnHighlight = false
        label.fadeOnAsynchronouslyDisplay = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(textLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        scale()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        restoreScale()
        print("did click linkView!")
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        restoreScale()
    }
}
