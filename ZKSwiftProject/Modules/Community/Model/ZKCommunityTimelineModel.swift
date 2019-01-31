//
//  ZKCommunityTimelineModel.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2019/1/11.
//  Copyright © 2019 bestdew. All rights reserved.
//

import Foundation
import SwiftyJSON

class ZKTimelineStatus: NSObject {
    /// 文本信息
    var text: String?
    /// 是否是热帖
    var isHot: Bool = false
    /// 设备信息
    var device: String?
    /// 位置信息
    var location: String?
    /// 发布时间
    var createTime: String!
    /// 帖子类型（0：链接，1：图片，2：视频）
    var type: Int = -1
    /// 浏览量
    var viewCount: UInt = 0
    /// 转帖数
    var repostCount: UInt = 0
    /// 评论数
    var commentCount: UInt = 0
    /// 打赏数
    var rewardCount: UInt = 0
    /// 点赞数
    var attitudeCount: UInt = 0
    /// 发帖人信息
    var user: ZKTimelineUser
    /// 链接信息
    var link: ZKTimelineLink?
    /// 视频信息
    var video: ZKTimelineVideo?
    /// 标签信息
    var tag: ZKTimelineTag?
    /// 图片信息
    var pictures: [ZKTimelinePicture]?
    
    init(jsonData: JSON) {
        text = jsonData["text"].string
        isHot = jsonData["isHot"].boolValue
        device = jsonData["device"].string
        location = jsonData["location"].string
        type = jsonData["type"].intValue
        createTime = jsonData["createTime"].stringValue
        viewCount = jsonData["viewCount"].uIntValue
        repostCount = jsonData["repostCount"].uIntValue
        commentCount = jsonData["commentCount"].uIntValue
        rewardCount = jsonData["rewardCount"].uIntValue
        attitudeCount = jsonData["attitudeCount"].uIntValue
        user = ZKTimelineUser(jsonData: jsonData["user"])
        
        if type == 0  {
            link = ZKTimelineLink(jsonData: jsonData["link"])
        }
        
        if type == 1 {
            var tempPictures = [ZKTimelinePicture]()
            for (_, value) in jsonData["images"] {
                let pictures = ZKTimelinePicture(jsonData: value)
                tempPictures.append(pictures)
            }
            pictures = tempPictures
        }
        
        if type == 2 {
            video = ZKTimelineVideo(jsonData: jsonData["video"])
        }
        
        if jsonData["label"].exists()  {
            tag = ZKTimelineTag(jsonData: jsonData["label"])
        }
    }
}

class ZKTimelineUser: NSObject {
    /// 用户头像
    var icon: String!
    /// 用户GUID
    var guid: String!
    /// 用户名
    var userName: String!
    /// 用户性别（0：未设置，1：男，2：女）
    var gender: Int = 0
    /// 是否已被我屏蔽
    var shielding: Bool = false
    /// 是否已被我关注
    var following: Bool = false
    
    init(jsonData: JSON) {
        icon = jsonData["icon"].stringValue
        guid = jsonData["guid"].stringValue
        userName = jsonData["userName"].stringValue
        gender = jsonData["gender"].intValue
        shielding = jsonData["shielding"].boolValue
        following = jsonData["following"].boolValue
    }
}


class ZKTimelinePicture: NSObject {
    /// 图片类型（0：普通，1：长图，2：GIF）
    var type: Int = 0
    /// 缩略图URL
    var thumbnailPic: String!
    /// 缩略图宽度
    var thumbnailPicWidth: Float = 0
    /// 缩略图高度
    var thumbnailPicHeight: Float = 0
    /// 原图URL
    var originalPic: String!
    /// 原图宽度
    var originalPicWidth: Float = 0
    /// 原图高度
    var originalPicHeight: Float = 0
    
    init(jsonData: JSON) {
        type = jsonData["type"].intValue
        thumbnailPic = jsonData["thumbnailPic"].stringValue
        thumbnailPicWidth = jsonData["thumbnailPicWidth"].floatValue
        thumbnailPicHeight = jsonData["thumbnailPicHeight"].floatValue
        originalPic = jsonData["originalPic"].stringValue
        originalPicWidth = jsonData["originalPicWidth"].floatValue
        originalPicHeight = jsonData["originalPicHeight"].floatValue
    }
}

class ZKTimelineLink: NSObject {
    /// 链接URL
    var url: String!
    /// 链接文本
    var text: String!
    /// 链接缩略图
    var thumbnailPic: String!
    /// 是否是FEED流文章
    var isFeed: Bool = false
    /// 链接FEED流文章ID
    var feedId: String!
    /// 链接FEED流文章URL
    var feedUrl: String!
    
    init(jsonData: JSON) {
        url = jsonData["url"].stringValue
        text = jsonData["text"].stringValue
        thumbnailPic = jsonData["thumbnailPic"].stringValue
        isFeed = jsonData["isFeed"].boolValue
        feedId = jsonData["feedId"].stringValue
        feedUrl = jsonData["feedUrl"].stringValue
    }
}

class ZKTimelineTag: NSObject {
    /// 标签ID
    var id: String!
    /// 标签文本
    var text: String!
    /// 拼接后的标签文本
    var fullText: String!
    
    init(jsonData: JSON) {
        id = jsonData["id"].stringValue
        text = jsonData["text"].stringValue
        fullText = "# " + text
    }
}

class ZKTimelineVideo: NSObject {
    /// 视频播放URL
    var videoUrl: String!
    /// 视频第一帧图片URL
    var imageUrl: String!
    /// 视频大小
    var videSize: UInt = 0
    /// 视频总时长
    var videDuration: UInt = 0
    
    init(jsonData: JSON) {
        videoUrl = jsonData["videoUrl"].stringValue
        videoUrl = jsonData["imageUrl"].stringValue
        videSize = jsonData["videSize"].uIntValue
        videDuration = jsonData["videDuration"].uIntValue
    }
}
