//
//  ZKMacro.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2018/12/29.
//  Copyright © 2018 bestdew. All rights reserved.
//

import UIKit

// App Info
public let kAppBundleInfoVersion = Bundle.main.infoDictionary ?? Dictionary()
public let kAppBundleVersion = (kAppBundleInfoVersion["CFBundleShortVersionString" as String] as? String ) ?? ""
public let kAppBundleBuild = (kAppBundleInfoVersion["CFBundleVersion"] as? String ) ?? ""
public let kAppDisplayName = (kAppBundleInfoVersion["CFBundleDisplayName"] as? String ) ?? ""

// 是否是刘海屏
public var isNotchScreen: Bool {
    if #available(iOS 11, *) {
        guard let window = UIApplication.shared.delegate?.window, let unwrapedWindow = window else {
            return false
        }
        if unwrapedWindow.safeAreaInsets.left > 0.0 || unwrapedWindow.safeAreaInsets.bottom > 0.0 {
            print(unwrapedWindow.safeAreaInsets)
            return true
        }
    }
    return false
}

public let kScreenHeight: CGFloat    = UIScreen.main.bounds.size.height
public let kScreenWidth: CGFloat     = UIScreen.main.bounds.size.width
public let kStatusBarheight: CGFloat = UIApplication.shared.statusBarFrame.size.height
public let kTabBarHeight: CGFloat    = (isNotchScreen ? 83.0 : 49.0)
public let kTopMargin: CGFloat       = (isNotchScreen ? 88.0 : 64.0)
public let kBottomMargin: CGFloat    = (isNotchScreen ? 34.0 : 0.0)

public let kFitWidth: (CGFloat) -> CGFloat = { width in
    return width * kScreenWidth / 375
}
public let kFitHeight: (CGFloat) -> CGFloat = { height in
    return height * kScreenHeight / 667
}

// 是否 Debug 模式
public var isDebug: Bool {
    #if DEBUG
    return true
    #else
    return false
    #endif
}

// 是否是模拟器
public var isSimulator: Bool {
    #if targetEnvironment(simulator)
    return true
    #else
    return false
    #endif
}

// 点击了 tabBar 的通知名
public let kTabBarItemIndex = "TabBarItemIndex"
public let kTabBarItemTitle = "TabBarItemTitle"
public let kClickTabBarNotificationName = NSNotification.Name(rawValue:"ClickTabBarNotification.name")

// 过滤 null 对象
public let kFilterNullOfObj:((Any)->Any?) = {(obj: Any) -> Any? in
    if obj is NSNull {
        return nil
    }
    return obj
}

// 过滤 null 的字符串，当 nil 时返回一个初始化的空字符串
public let kFilterNullOfString:((Any)->String) = {(obj: Any) -> String in
    if obj is String {
        return obj as! String
    }
    return ""
}

// 过滤 null 的数组，当 nil 时返回一个初始化的空数组
public let kFilterNullOfArray:((Any)->Array<Any>) = {(obj: Any) -> Array<Any> in
    if obj is Array<Any> {
        return obj as! Array<Any>
    }
    return Array()
}

// 过滤 null 的字典，当为 nil 时返回一个初始化的字典
public let kFilterNullOfDictionary:((Any) -> Dictionary<AnyHashable, Any>) = {( obj: Any) -> Dictionary<AnyHashable, Any> in
    if obj is Dictionary<AnyHashable, Any> {
        return obj as! Dictionary<AnyHashable, Any>
    }
    return Dictionary()
}


