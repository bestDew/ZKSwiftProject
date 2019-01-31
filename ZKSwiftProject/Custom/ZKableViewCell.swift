//
//  ZKBaseTableViewCell.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2019/1/10.
//  Copyright © 2019 bestdew. All rights reserved.
//

import UIKit

class ZKableViewCell: UITableViewCell {
    
    var showTouchAnimation: Bool = true
    var contentInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    
    lazy private(set) var cardView: UIImageView = {
        let cardView = UIImageView()
        cardView.isUserInteractionEnabled = true
        cardView.layer.backgroundColor = UIColor.white.cgColor
        cardView.layer.cornerRadius = 6
        cardView.layer.shadowColor = UIColor.lightGray.cgColor
        cardView.layer.shadowOpacity = 0.3
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        return cardView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = UIColor(hexString: "#FAFAFA")
        contentView.addSubview(cardView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.addSubview(cardView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cardView.frame = CGRect(x: contentInsets.left,
                                y: contentInsets.top,
                                width: contentView.width - contentInsets.left - contentInsets.right,
                                height: contentView.height - contentInsets.top - contentInsets.bottom)
        cardView.layer.shadowPath = UIBezierPath(rect: cardView.bounds).cgPath
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        cardView.scale()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        cardView.restoreScale()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        cardView.restoreScale()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if cardView.frame.contains(point) {
            return super.hitTest(point, with: event)
        } else {
            return nil
        }
    }
}
