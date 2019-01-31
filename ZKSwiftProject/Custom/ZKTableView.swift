//
//  ZKBaseTableView.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2019/1/13.
//  Copyright © 2019 bestdew. All rights reserved.
//

import UIKit

class ZKTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        estimatedRowHeight = 0
        estimatedSectionHeaderHeight = 0
        estimatedSectionFooterHeight = 0
        delaysContentTouches = false
        canCancelContentTouches = true
        backgroundColor = UIColor(hexString: "#FAFAFA")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view.isKind(of: UIControl.self) {
            return true
        }
        return super.touchesShouldCancel(in: view)
    }
}
