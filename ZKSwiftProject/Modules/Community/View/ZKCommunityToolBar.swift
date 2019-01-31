//
//  ZKCommunityToolBar.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2019/1/13.
//  Copyright © 2019 bestdew. All rights reserved.
//

import UIKit

class ZKCommunityToolBar: UIView {
    
    var layout: ZKTimelineLayout? {
        didSet {
            guard let layout = layout else { return }
            
            frame = layout.toolBarFrame
            let reweetTitle = layout.status.repostCount > 0 ? " \(layout.status.rewardCount)" : " 转发"
            reweetButton.setTitle(reweetTitle, for: .normal)
            let commentTitle = layout.status.commentCount > 0 ? " \(layout.status.commentCount)" : " 评论"
            commentButton.setTitle(commentTitle, for: .normal)
            let rewardTitle = layout.status.rewardCount > 0 ? " \(layout.status.rewardCount)" : " 打赏"
            rewardButton.setTitle(rewardTitle, for: .normal)
            let attitudeTitle = layout.status.attitudeCount > 0 ? " \(layout.status.attitudeCount)" : " 赞"
            attitudeButton.setTitle(attitudeTitle, for: .normal)
        }
    }
    
    private lazy var reweetButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = kThemeFont(14)
        button.adjustsImageWhenHighlighted = false
        button.setTitleColor(UIColor(hexString: "#87898C"), for: .normal)
        button.setTitle(" 转发", for: .normal)
        button.setImage(UIImage(named: "timeline_icon_retweet"), for: .normal)
        button.setBackgroundImage(UIImage(color: UIColor(hexString: "f0f0f0")!), for: .highlighted)
        button.addTarget(self, action: #selector(reweetButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = kThemeFont(14)
        button.adjustsImageWhenHighlighted = false
        button.setTitleColor(UIColor(hexString: "#87898C"), for: .normal)
        button.setTitle(" 评论", for: .normal)
        button.setImage(UIImage(named: "timeline_icon_comment"), for: .normal)
        button.setBackgroundImage(UIImage(color: UIColor(hexString: "f0f0f0")!), for: .highlighted)
        button.addTarget(self, action: #selector(commentButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var rewardButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = kThemeFont(14)
        button.adjustsImageWhenHighlighted = false
        button.setTitleColor(UIColor(hexString: "#87898C"), for: .normal)
        button.setTitle(" 打赏", for: .normal)
        button.setImage(UIImage(named: "timeline_icon_share"), for: .normal)
        button.setBackgroundImage(UIImage(color: UIColor(hexString: "f0f0f0")!), for: .highlighted)
        button.addTarget(self, action: #selector(rewardButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var attitudeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = kThemeFont(14)
        button.adjustsImageWhenHighlighted = false
        button.setTitleColor(UIColor(hexString: "#87898C"), for: .normal)
        button.setTitle(" 赞", for: .normal)
        button.setImage(UIImage(named: "timeline_icon_unlike"), for: .normal)
        button.setImage(UIImage(named: "timeline_icon_like"), for: .selected)
        button.setBackgroundImage(UIImage(color: UIColor(hexString: "f0f0f0")!), for: .highlighted)
        button.addTarget(self, action: #selector(attitudeButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var topLine: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(white: 0.3, alpha: 0.1).cgColor
        return layer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(reweetButton)
        addSubview(commentButton)
        addSubview(rewardButton)
        addSubview(attitudeButton)
        layer.addSublayer(topLine)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let buttonWidth: CGFloat = width / 4
        reweetButton.frame = CGRect(x: 0, y: topLine.frame.maxY, width: buttonWidth, height: height)
        commentButton.frame = CGRect(x: reweetButton.frame.maxX, y: topLine.frame.maxY, width: buttonWidth, height: height)
        rewardButton.frame = CGRect(x: commentButton.frame.maxX, y: topLine.frame.maxY, width: buttonWidth, height: height)
        attitudeButton.frame = CGRect(x: rewardButton.frame.maxX, y: topLine.frame.maxY, width: buttonWidth, height: height)
        let topLineW = width - ZKTimelineLayout.ContainerPadding * 2
        topLine.frame = CGRect(x: ZKTimelineLayout.ContainerPadding, y: 0, width: topLineW, height: CGFloatFromPixel(1))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func reweetButtonAction(_ button: UIButton) {
        print("转发")
    }
    
    @objc private func commentButtonAction(_ button: UIButton) {
        print("评论")
    }
    
    @objc private func rewardButtonAction(_ button: UIButton) {
        print("打赏")
    }
    
    @objc private func attitudeButtonAction(_ button: UIButton) {
        button.isSelected = !button.isSelected
    }
}
