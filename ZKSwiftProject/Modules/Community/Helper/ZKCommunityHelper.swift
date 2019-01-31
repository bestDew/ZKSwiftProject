//
//  ZKCommunityHelper.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2019/1/12.
//  Copyright © 2019 bestdew. All rights reserved.
//

import Foundation
import SwiftyJSON

class ZKStatusHelper {
    /// At regular. such as `@xxx`
    static let AtRegex = try? NSRegularExpression(pattern: "@[-_a-zA-Z0-9\\u4E00-\\u9FA5]+")
    /// Topic regular. such as `#LEWIS_MARNELL#`
    static let TopicRegex = try? NSRegularExpression(pattern: "#[^@#]+?#")
    /// Emoji regular. such as `[偷笑]`
    static let EmoticonRegex = try? NSRegularExpression(pattern: "\\[[^ \\[\\]]+?\\]")
    /// Source regular
    static let SourceRegex = try? NSRegularExpression(pattern: "(?<=>).*?(?=<)")
    /// URL regular
    static let URLRegex = try? NSRegularExpression(pattern: "([hH]ttp[s]{0,1})://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\-~!@#$%^&*+?:_/=<>]*)?")
    /// Domin regular
    static let DominNameRegex = try? NSRegularExpression(pattern: "\\b([a-z0-9]+(-[a-z0-9]+)*\\.)+[a-z]{2,}\\b")
    /// Emoticon dictionary
    static let EmoticonDict: [String:String] = {
        var tempDict = [String:String]()
        let bundlePath = Bundle.main.path(forResource: "EmoticonWeibo", ofType: "bundle")! as NSString
        let plistPath = bundlePath.appendingPathComponent("emoticons.plist")
        let resourceDict = NSDictionary(contentsOfFile: plistPath)!
        let packageArray = resourceDict["packages"] as! [NSDictionary]
        for emoticon in packageArray {
            autoreleasepool {
                let folderName = emoticon["id"] as! String
                let imageFolderPath = bundlePath.appendingPathComponent(folderName) as NSString
                let infoPlistPath = imageFolderPath.appendingPathComponent("EmotionsInfo.plist")
                let emoticonInfo = NSDictionary(contentsOfFile: infoPlistPath)!
                let jsonData = JSON(emoticonInfo)
                for (_, value) in jsonData["emoticons"] {
                    let imagePath = imageFolderPath.appendingPathComponent(value["png"].stringValue)
                    if imagePath.count == 0 { continue }
                    let cht = value["cht"].stringValue
                    if cht.count > 0 {
                        tempDict[cht] = imagePath
                    }
                    let chs = value["chs"].stringValue
                    if chs.count > 0 {
                        tempDict[chs] = imagePath
                    }
                }
            }
        }
        return tempDict
    }()
}
