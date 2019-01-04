//
//  ZKBannerCell.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2019/1/1.
//  Copyright © 2019 bestdew. All rights reserved.
//

import UIKit

class ZKBannerCell: ZKCycleScrollViewCell {

    private(set) var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8.0
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = CGRect(x: 12.0, y: 12.0, width: contentView.width - 24.0, height: contentView.height - 32.0)
    }
}
