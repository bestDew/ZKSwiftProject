//
//  ZKCycleScrollTextCell.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2019/1/1.
//  Copyright © 2019 bestdew. All rights reserved.
//

import UIKit

class ZKCycleScrollTextCell: ZKCycleScrollViewCell {

    private(set) var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textAlignment = .center
        contentView.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = bounds
    }
}
