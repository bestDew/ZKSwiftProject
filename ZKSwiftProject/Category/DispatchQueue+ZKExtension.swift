//
//  DispatchQueue+ZKExtension.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2019/1/5.
//  Copyright © 2019 bestdew. All rights reserved.
//

import Foundation

public extension DispatchQueue {
    
    private static var onceTokenTracker: [String] = []
    
    /// 保证整个生命周期内只执行一次
    ///
    /// - Parameters:
    ///   - token: token
    ///   - closure: 要执行的代码块
    public static func once(_ token: String, closure: () -> Void) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        if onceTokenTracker.contains(token) { return }
        closure()
    }
}
