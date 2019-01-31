//
//  ZKCGUtilities.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2019/1/14.
//  Copyright © 2019 bestdew. All rights reserved.
//

import Foundation

public let CGFloatFromPixel: (CGFloat) -> CGFloat = { float in
    return float / kScreenScale
}

public let CGFloatPixelFloor: (CGFloat) -> CGFloat = { float in
    return floor(float * kScreenScale) / kScreenScale
}

public let UIEdgeInsetPixelFloor: (UIEdgeInsets) -> UIEdgeInsets = { insets in
    var tempInsets = UIEdgeInsets.zero
    tempInsets.top = CGFloatPixelFloor(insets.top)
    tempInsets.left = CGFloatPixelFloor(insets.left)
    tempInsets.bottom = CGFloatPixelFloor(insets.bottom)
    tempInsets.right = CGFloatPixelFloor(insets.right)
    return tempInsets
}
