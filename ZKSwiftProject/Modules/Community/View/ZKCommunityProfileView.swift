//
//  ZKCommunityTimelineProfileView.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2019/1/11.
//  Copyright © 2019 bestdew. All rights reserved.
//

import UIKit
import Kingfisher

class ZKCommunityProfileView: UIView {
    
    var layout: ZKTimelineLayout? {
        didSet {
            guard let layout = layout else { return }
            
            frame = layout.profileViewFrame
            avatarImageView.frame = layout.avatarImageViewFrame
            followButton.frame = layout.followButtonFrame
            followBorder.frame = layout.followBorderFrame
            userNameLabel.frame = layout.userNameLabelFrame
            userNameLabel.textLayout = layout.userNameTextLayout
            dateSourceLabel.frame = layout.dateSourceLabelFrame
            dateSourceLabel.textLayout = layout.dateSourceTextLayout
            
            var placeholder: UIImage? {
                if layout.status.user.gender == 1 {
                    return UIImage(named: "placeholder_user_man")
                } else if layout.status.user.gender == 2 {
                    return UIImage(named: "placeholder_user_woman")
                } else {
                    return nil
                }
            }
            avatarImageView.kf.setImage(with: URL(string: layout.status.user.icon), placeholder: placeholder, options: [.transition(.fade(0.2)), .processor(RoundCornerImageProcessor(cornerRadius: 100))])
        }
    }
    
    private var isFollow: Bool = false {
        didSet {
            if isFollow {
                followButton.isSelected = true
                followBorder.borderColor = kGrayColor.cgColor
            } else {
                followButton.isSelected = false
                followBorder.borderColor = kThemeColor.cgColor
            }
        }
    }

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var userNameLabel: YYLabel = {
        let label = YYLabel()
        label.displaysAsynchronously = true
        label.ignoreCommonProperties = true
        label.fadeOnHighlight = false
        label.fadeOnAsynchronouslyDisplay = false
        label.lineBreakMode = .byClipping
        return label
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = kThemeFont(14)
        button.setTitle("+关注", for: .normal)
        button.setTitle("已关注", for: .selected)
        button.setTitleColor(kThemeColor, for: .normal)
        button.setTitleColor(kGrayColor, for: .selected)
        button.addTarget(self, action: #selector(followButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var followBorder: CALayer = {
        let border = CALayer()
        border.cornerRadius = 3
        border.borderWidth = CGFloatFromPixel(1.5)
        border.borderColor = kThemeColor.cgColor
        return border
    }()
    
    private lazy var dateSourceLabel: YYLabel = {
        let label = YYLabel()
        label.displaysAsynchronously = true
        label.ignoreCommonProperties = true
        label.fadeOnHighlight = false
        label.fadeOnAsynchronouslyDisplay = false
        label.highlightTapAction = ({ containerView, text, range, rect in
            print("\(range)->\((text as NSAttributedString).string)")
        })
        return label
    }()
    
    private var trackingTouch: Bool = false
    
    // MARK: - override
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(avatarImageView)
        addSubview(userNameLabel)
        addSubview(dateSourceLabel)
        addSubview(followButton)
        followButton.layer.addSublayer(followBorder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Action
    @objc private func followButtonAction(_ button: UIButton) {
        isFollow = !isFollow
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.randomElement() else { return }
        
        let point = touch.location(in: self)
        if avatarImageView.frame.contains(point) {
            trackingTouch = true
            avatarImageView.scale()
        } else {
            if let textBoundingRect = userNameLabel.textLayout?.textBoundingRect {
                let textX = userNameLabel.x + textBoundingRect.origin.x
                let textY = userNameLabel.y + textBoundingRect.origin.y
                let textRect = CGRect(origin: CGPoint(x: textX, y: textY), size: textBoundingRect.size)
                trackingTouch = textRect.contains(point)
            } else {
                trackingTouch = false
            }
        }
        if !trackingTouch {
            super.touchesBegan(touches, with: event)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        if trackingTouch {
            if !avatarImageView.transform.isIdentity {
                avatarImageView.restoreScale()
            }
            print("did click user!")
        } else {
            super.touchesEnded(touches, with: event)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

        if trackingTouch {
            if !avatarImageView.transform.isIdentity {
                avatarImageView.restoreScale()
            }
        } else {
            super.touchesCancelled(touches, with: event)
        }
    }
}
