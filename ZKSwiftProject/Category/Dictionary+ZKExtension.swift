//
//  Dictionary+ZKExtension.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2019/1/5.
//  Copyright © 2019 bestdew. All rights reserved.
//

import Foundation

// MARK: -  相关操作
public extension Dictionary {
    
    /// 从字典中添加元素
    public mutating func append(_ newDictionary: Dictionary) {
        for (key, value) in newDictionary {
            self[key] = value
        }
    }
    
    /// 判断是否存在 key
    public func hasKey(_ key: Key) -> Bool {
        return index(forKey: key) != nil
    }
    
    /// 批量删除元素（可变参数）
    public mutating func remove(_ keys: Key...) {
        remove(keys)
    }
    
    /// 批量删除元素（数组）
    public mutating func remove(_ keys: [Key]) {
        for key in keys {
            removeValue(forKey: key)
        }
    }
}

// MARK: - Codable
public extension Dictionary where Key: Codable, Value: Codable {
    
    /// 字典转 JSON 字符串
    public var jsonString: String? {
        guard let data = try? JSONEncoder().encode(self),
            let jsonString = String(data: data, encoding: .utf8) else {
                return nil
        }
        return jsonString
    }
    
    /// 通过 JSON 字符串创建实例
    public init?(jsonString: String) {
        guard let jsonData = jsonString.data(using: .utf8),
            let dictionary = try? JSONDecoder().decode(Dictionary.self, from: jsonData) else {
                return nil
        }
        self = dictionary
    }
}

