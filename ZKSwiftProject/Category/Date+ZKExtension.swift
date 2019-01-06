//
//  Date+ZKExtension.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2019/1/4.
//  Copyright © 2019 bestdew. All rights reserved.
//

import Foundation

// MARK: - 日期简单处理
public extension Date {
    
    /// 时间戳
    public var timestamp: TimeInterval {
        return timeIntervalSince1970
    }
    
    /// 通过时间戳创建实例
    public init(timestamp: TimeInterval) {
        self.init(timeIntervalSince1970: timestamp)
    }
    
    /// 年
    public var year: Int {
        return NSCalendar.current.component(.year, from: self)
    }
    
    /// 月
    public var month: Int {
        return NSCalendar.current.component(.month, from: self)
    }
    
    /// 日
    public var day: Int {
        return NSCalendar.current.component(.day, from: self)
    }
    
    /// 时
    public var hour: Int {
        return NSCalendar.current.component(.hour, from: self)
    }
    
    /// 分
    public var minute: Int {
        return NSCalendar.current.component(.minute, from: self)
    }
    
    /// 秒
    public var second: Int {
        return NSCalendar.current.component(.second, from: self)
    }
    
    /// 星期几（数字 1 ~ 7）
    public var weekday: Int {
        return NSCalendar.current.component(.weekday, from: self)
    }
    
    /// 星期几，中文名称（星期一、星期二...星期日）
    public var weekdayName: String {
        guard let name = Weekday(rawValue: weekday)?.description else {
            fatalError("Error: weekday:\(weekday)")
        }
        return name
    }
    
    /// 是否是今天
    public var isToday: Bool {
        return NSCalendar.current.isDateInToday(self)
    }
    
    /// 是否昨天
    public var isYesterday: Bool {
        return NSCalendar.current.isDateInYesterday(self)
    }
}

// MARK: - 日期格式化
public extension Date {
    
    /// 时间格式化成字符串
    ///
    /// - Parameter dateFormat: 格式
    /// - Returns: 时间字符串
    public func string(with dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: self)
    }
    
    /// 通过字符串创建实例
    ///
    /// - Parameters:
    ///   - string: 时间字符串
    ///   - dateFormat: 格式
    public init?(string: String, dateFormat: String = "yyyy-MM-dd HH:mm:ss") {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        guard let date = formatter.date(from: string) else { return nil }
        self = date
    }
    
    /// 类似微信聊天消息的时间格式化，静态方法
    ///
    /// - Parameters:
    ///   - timestamp: 时间戳
    ///   - showHour: 是否显示时分
    /// - Returns: 格式化后的字符串
    public static func stringWithFormat(timestamp: TimeInterval, showHour: Bool = true) -> String {
        let date = Date(timestamp: timestamp)
        return date.stringWithFormat(showHour: showHour)
    }
    
    /// 类似微信聊天消息的时间格式化，实例方法
    public func stringWithFormat(showHour: Bool = true) -> String {
        let dateFormatter = DateFormatter()
        if isToday { // 今天
            dateFormatter.dateFormat = "HH:mm"
        } else if isYesterday { // 昨天
            dateFormatter.dateFormat = showHour ? "昨天 HH:mm" : "昨天"
        } else if numberOfdays(to: Date()) < 7 { // 一周内
            dateFormatter.dateFormat = showHour ? "\(weekdayName) HH:mm" : "\(weekdayName)"
        } else {
            if year == Date().year { // 今年
                dateFormatter.dateFormat = showHour ? "MM月dd日 HH:mm" : "MM月dd日"
            } else {
                dateFormatter.dateFormat = showHour ? "yyyy年MM月dd日 HH:mm" : "yyyy年MM月dd日"
            }
        }
        return dateFormatter.string(from: self)
    }
    
    /// 获取两个时间相隔天数
    ///
    /// - Parameter date: 截止日期
    /// - Returns: 相隔天数
    public func numberOfdays(to date: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: self, to: date)
        return components.day ?? 0
    }
}

// MARK: - Weekday 简单封装
enum Weekday: Int {
    
    case sunday    = 1
    case monday    = 2
    case tuesday   = 3
    case wednesday = 4
    case thursday  = 5
    case friday    = 6
    case saturday  = 7
    
    init?(weekdayString: String) {
        switch weekdayString {
        case Weekday.sunday.description:     self = .sunday
        case Weekday.monday.description:     self = .monday
        case Weekday.tuesday.description:    self = .tuesday
        case Weekday.wednesday.description:  self = .wednesday
        case Weekday.thursday.description:   self = .thursday
        case Weekday.friday.description:     self = .friday
        case Weekday.saturday.description:   self = .saturday
        default: return nil
        }
    }
    
    var description: String {
        switch self {
        case .sunday:     return "星期日"
        case .monday:     return "星期一"
        case .tuesday:    return "星期二"
        case .wednesday:  return "星期三"
        case .thursday:   return "星期四"
        case .friday:     return "星期五"
        case .saturday:   return "星期六"
        }
    }
}
