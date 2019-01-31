//
//  Array+ZKExtension.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2019/1/5.
//  Copyright © 2019 bestdew. All rights reserved.
//

import Foundation

// MARK: - 相关操作
public extension Array {
    
    /// 替换数组元素
    ///
    /// - Parameters:
    ///   - index: 元素下标
    ///   - element: 要替换成的元素
    public mutating func replaceElement(at index: Int, with element: Element) {
        if index > count - 1 || index < 0 { return }
        replaceSubrange(index ..< index + 1, with: [element])
    }
    
    /// 获取多个随机元素
    ///
    /// - Parameters:
    ///   - size: 元素个数
    ///   - shouldRepeat: 是否允许重复（默认 false）
    /// - Returns: 随机元素数组
    public func randomElements(size: Int, shouldRepeat: Bool = false) -> [Element]? {
        guard count > 0 else { return nil }
        var randomElements: [Element] = []
        if shouldRepeat {
            for _ in 0 ..< size {
                if let randomElement = randomElement() {
                    randomElements.append(randomElement)
                }
            }
        } else {
            var copyElements = self
            for _ in 0 ..< size {
                if copyElements.isEmpty { break }
                let randomIndex = Int(arc4random_uniform(UInt32(copyElements.count)))
                randomElements.append(copyElements[randomIndex])
                copyElements.remove(at: randomIndex)
            }
        }
        return randomElements
    }
}

// MARK: - Equatable
public extension Array where Element: Equatable {
    
    /// 删除元素
    ///
    /// - Parameter elements: 要删除的元素（可变参数）
    public mutating func remove(_ elements: Element...) {
        remove(elements)
    }
    
    /// 删除元素
    ///
    /// - Parameter elements: 要删除的元素（数组）
    public mutating func remove(_ elements: [Element]) {
        for element in elements {
            if let index = index(of: element) {
                remove(at: index)
            }
        }
    }
}

// MARK: - Codable
public extension Array where Element: Codable {
    
    /// 转换为 JSON 字符串
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
            let array = try? JSONDecoder().decode(Array.self, from: jsonData) else {
                return nil
        }
        self = array
    }
}
