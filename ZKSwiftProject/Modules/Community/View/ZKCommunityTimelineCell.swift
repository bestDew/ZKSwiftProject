//
//  ZKHomeTableViewCell.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2019/1/10.
//  Copyright © 2019 bestdew. All rights reserved.
//

import UIKit
import Kingfisher

class ZKCommunityTimelineCell: ZKableViewCell {
    
    var layout: ZKTimelineLayout? {
        didSet {
            guard let layout = layout else { return }
            
            tagsView.layout = layout
            profileView.layout = layout
            moreButton.frame = layout.moreButtonFrame
            statusLabel.frame = layout.statusLabelFrame
            statusLabel.textLayout = layout.statusTextLayout
            linkView.layout = layout
            picturesView.layout = layout
            viewCountLabel.frame = layout.viewCountLabelFrame
            viewCountLabel.textLayout = layout.viewCountTextLayout
            locationLabel.frame = layout.locationLabelFrame
            locationLabel.textLayout = layout.locationTextLayout
            toolBar.layout = layout
        }
    }
    
    private lazy var tagsView: ZKCommunityTagsView = {
        let view = ZKCommunityTagsView()
        return view
    }()
    
    private lazy var profileView: ZKCommunityProfileView = {
        let view = ZKCommunityProfileView()
        return view
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton(type: .custom)
        button.contentHorizontalAlignment = .right
        button.setImage(UIImage(named: "timeline_icon_more"), for: .normal)
        button.setImage(UIImage(named: "timeline_icon_more_highlighted"), for: .highlighted)
        button.addTarget(self, action: #selector(moreButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var statusLabel: YYLabel = {
        let label = YYLabel()
        label.displaysAsynchronously = true
        label.ignoreCommonProperties = true
        label.fadeOnHighlight = false
        label.fadeOnAsynchronouslyDisplay = false
        label.textVerticalAlignment = .top
        label.highlightTapAction = { [weak self] (containerView, text, range, rect) -> () in
            guard let strongSelf = self else { return }
            print("点击了链接")
        }
        return label
    }()
    
    private lazy var linkView: ZKCommunityLinkView = {
        let view = ZKCommunityLinkView()
        view.backgroundColor = UIColor(hexString: "#ECECEC")
        return view
    }()
    
    private lazy var picturesView: ZKCommunityPicturesView = {
        let view = ZKCommunityPicturesView()
        return view
    }()
    
    private lazy var locationLabel: YYLabel = {
        let label = YYLabel()
        label.displaysAsynchronously = true
        label.ignoreCommonProperties = true
        label.fadeOnHighlight = false
        label.fadeOnAsynchronouslyDisplay = false
        label.lineBreakMode = .byClipping
        return label
    }()
    
    private lazy var viewCountLabel: YYLabel = {
        let label = YYLabel()
        label.displaysAsynchronously = true
        label.ignoreCommonProperties = true
        label.fadeOnHighlight = false
        label.fadeOnAsynchronouslyDisplay = false
        label.lineBreakMode = .byClipping
        return label
    }()
    
    private lazy var toolBar: ZKCommunityToolBar = {
        let view = ZKCommunityToolBar()
        return view
    }()

    // MARK: - override
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        cardView.addSubview(tagsView)
        cardView.addSubview(profileView)
        cardView.addSubview(moreButton)
        cardView.addSubview(statusLabel)
        cardView.addSubview(linkView)
        cardView.addSubview(picturesView)
        cardView.addSubview(locationLabel)
        cardView.addSubview(viewCountLabel)
        cardView.addSubview(toolBar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func moreButtonAction(_ button: UIButton) {
        print("did click moreButton!")
    }
}
