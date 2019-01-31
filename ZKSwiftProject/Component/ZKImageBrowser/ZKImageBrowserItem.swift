//
//  ZKImageBrowserItem.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2019/1/19.
//  Copyright © 2019 bestdew. All rights reserved.
//

import Foundation

class ZKImageBrowserItem {
    
    var originalImageURL: URL?
    var thumbnailImageView: UIImageView
    var placeholder: UIImage {
        get {
            if let image = thumbnailImageView.image {
                return image
            } else {
                return UIImage(named: "placeholder_image")!
            }
        }
    }
    
    init(thumbnailImageView: UIImageView, originalImageURL: URL?) {
        self.thumbnailImageView = thumbnailImageView
        self.originalImageURL = originalImageURL
    }
}
