//
//  ZKDetailBannerCell.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2019/1/1.
//  Copyright © 2019 bestdew. All rights reserved.
//

import UIKit
import Kingfisher

class ZKDetailBannerCell: ZKCycleScrollViewCell {

    var imageUrl: String? {
        didSet {
            guard let URL = URL(string: imageUrl!) else { return }
            imageView.kf.setImage(with: URL, placeholder: nil, options: [.transition(.fade(0.2))])
        }
    }
    private var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView()
        imageView.backgroundColor = .gray
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = bounds
    }
}
