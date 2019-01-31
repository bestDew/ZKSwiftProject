//
//  ZKCommunityTagsView.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2019/1/13.
//  Copyright © 2019 bestdew. All rights reserved.
//

import UIKit

class ZKCommunityTagsView: UIView {
    
    var layout: ZKTimelineLayout? {
        didSet {
            guard let layout = layout else { return }
            
            frame = layout.tagsViewFrame
            hotButton.frame = layout.hotButtonFrame
            tagButton.frame = layout.tagButtonFrame
            bottomLine.frame = layout.bottomLineFrame
            
            if let tagTitle = layout.status.tag?.fullText  {
                tagButton.setTitle(tagTitle, for: .normal)
            }
        }
    }
    
    private lazy var hotButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = kThemeFont(ZKTimelineLayout.TagFontSize)
        button.layer.cornerRadius = ZKTimelineLayout.TagButtonHeight / 2.0
        button.adjustsImageWhenHighlighted = false
        button.contentHorizontalAlignment = .left
        button.layer.backgroundColor = UIColor(hexString: "#FFE2E0")?.cgColor
        button.setTitle(" 热帖", for: .normal)
        button.setTitleColor(UIColor(hexString: "#FF554C"), for: .normal)
        button.setImage(UIImage(named: "ic_热门帖子"), for: .normal)
        button.addTarget(self, action: #selector(hotButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var tagButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = kThemeFont(ZKTimelineLayout.TagFontSize)
        button.layer.cornerRadius = ZKTimelineLayout.TagButtonHeight / 2.0
        button.layer.backgroundColor = UIColor(hexString: "#FFEFE0")?.cgColor
        button.setTitleColor(UIColor(hexString: "#FF9340"), for: .normal)
        button.addTarget(self, action: #selector(tagButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var bottomLine: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = kSeparatorColor.cgColor
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(hotButton)
        addSubview(tagButton)
        layer.addSublayer(bottomLine)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func hotButtonAction(_ button: UIButton) {
        print("did click hotButton!")
    }
    
    @objc private func tagButtonAction(_ button: UIButton) {
        print("did click tagButton!")
    }
}
