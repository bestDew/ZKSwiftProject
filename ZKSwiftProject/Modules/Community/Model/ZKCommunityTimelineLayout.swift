//
//  ZKCommunityTimelineLayout.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2019/1/12.
//  Copyright © 2019 bestdew. All rights reserved.
//

import Foundation

class ZKTimelineLayout: NSObject {
    
    /// 容器宽度
    static let ContainerWidth: CGFloat = kScreenWidth - 20
    /// 容器内边距
    static let ContainerPadding: CGFloat = 10
    /// 标签 item 高度
    static let TagButtonHeight: CGFloat = 20
    /// 标签文本字体大小
    static let TagFontSize: CGFloat = 14
    /// 头像大小
    static let AvatarSize: CGFloat = 40
    /// 用户名文本字体大小
    static let UserNameFontSize: CGFloat = 16
    /// 时间、手机型号、位置、浏览量文本字体大小
    static let DateSourceFontSize: CGFloat = 12
    /// 文本字体大小
    static let TextFontSize: CGFloat = 17
    /// 文本最大显示行数，当前限制最多显示 3 行，超过 3 行，以 '......全文' 结尾
    static let TextMaximumNumberOfLines: UInt = 3
    /// 图片间距
    static let PictureItemPadding: CGFloat = 5
    /// 文本内容下方留白
    static let TextBottomSpacing: CGFloat = 8
    
    /// 数据模型
    var status: ZKTimelineStatus
    
    /// 标签主视图
    var tagsViewFrame: CGRect = CGRect.zero
    /// 热门标签按钮
    var hotButtonFrame: CGRect = CGRect.zero
    /// 其他标签按钮
    var tagButtonFrame: CGRect = CGRect.zero
    /// 标签视图底部分割线
    var bottomLineFrame: CGRect = CGRect.zero
    
    /// 更多按钮
    var moreButtonFrame: CGRect = CGRect.zero
    
    /// 个人资料主视图
    var profileViewFrame: CGRect = CGRect.zero
    /// 头像
    var avatarImageViewFrame: CGRect = CGRect.zero
    /// 用户名
    var userNameLabelFrame: CGRect = CGRect.zero
    var userNameTextLayout: YYTextLayout?
    /// 关注按钮
    var followButtonFrame: CGRect = CGRect.zero
    var followBorderFrame: CGRect = CGRect.zero
    /// 时间+手机型号
    var dateSourceLabelFrame: CGRect = CGRect.zero
    var dateSourceTextLayout: YYTextLayout?
    
    /// 文本
    var statusLabelFrame: CGRect = CGRect.zero
    var statusTextLayout: YYTextLayout?
    
    /// 链接视图
    var linkViewFrame: CGRect = CGRect.zero
    var linkTextLayout: YYTextLayout?
    var linkTextLabelFrame: CGRect = CGRect.zero
    var linkImageViewFrame: CGRect = CGRect.zero
    
    /// 图片视图
    var picturesViewFrame: CGRect = CGRect.zero
    var picturesViewItemFrames: [CGRect] = [CGRect]()
    
    /// 位置
    var locationLabelFrame: CGRect = CGRect.zero
    var locationTextLayout: YYTextLayout?
    
    // 浏览量
    var viewCountLabelFrame: CGRect = CGRect.zero
    var viewCountTextLayout: YYTextLayout?
    
    // 工具栏
    var toolBarFrame: CGRect = CGRect.zero
    
    /// Cell 行高
    private(set) var rowHeight: CGFloat = 0
    
    /// 高亮背景
    private lazy var highlightBoder: YYTextBorder = {
        let boder = YYTextBorder(fill: kLinkFillColor, cornerRadius: 3)
        boder.insets = UIEdgeInsets(top: -2, left: 0, bottom: -2, right: 0)
        return boder
    }()
    
    init(status: ZKTimelineStatus) {
        self.status = status
        super.init()
        self.layout()
    }
    
    private func layout() {
        layoutTagsView()
        layoutProfileView()
        layoutStatusLabel()
        layoutLinkView()
        layoutPicturesView()
        layoutOtherLabels()
        layoutToolBar()
    }
}

// MARK: - 标签视图布局
extension ZKTimelineLayout {
    
    private func layoutTagsView() {
        if !status.isHot && status.tag == nil {
            moreButtonFrame = CGRect(x: ZKTimelineLayout.ContainerWidth - ZKTimelineLayout.ContainerPadding - ZKTimelineLayout.TagButtonHeight,
                                     y: ZKTimelineLayout.ContainerPadding + (ZKTimelineLayout.AvatarSize - ZKTimelineLayout.TagButtonHeight) / 2,
                                     width: ZKTimelineLayout.TagButtonHeight,
                                     height: ZKTimelineLayout.TagButtonHeight)
            return
        }
        tagsViewFrame = CGRect(x: 0,
                               y: 0,
                               width: ZKTimelineLayout.ContainerWidth,
                               height: ZKTimelineLayout.TagButtonHeight + ZKTimelineLayout.ContainerPadding * 2)
        let hotButtonW: CGFloat = status.isHot ? 63 : 0
        hotButtonFrame = CGRect(x: ZKTimelineLayout.ContainerPadding,
                                y: ZKTimelineLayout.ContainerPadding,
                                width: hotButtonW,
                                height: ZKTimelineLayout.TagButtonHeight)
        let tagButtonW = status.tag!.fullText.width(with: ZKTimelineLayout.TagButtonHeight, font: kThemeFont(ZKTimelineLayout.TagFontSize)) + 20
        let tagButtonP = status.isHot ? ZKTimelineLayout.ContainerPadding : 0
        tagButtonFrame = CGRect(x: hotButtonFrame.maxX + tagButtonP,
                                y: ZKTimelineLayout.ContainerPadding,
                                width: tagButtonW,
                                height: ZKTimelineLayout.TagButtonHeight)
        bottomLineFrame = CGRect(x: ZKTimelineLayout.ContainerPadding,
                                 y: tagsViewFrame.height - CGFloatFromPixel(1),
                                 width: tagsViewFrame.width - ZKTimelineLayout.ContainerPadding * 2,
                                 height: CGFloatFromPixel(1))
        moreButtonFrame = CGRect(x: ZKTimelineLayout.ContainerWidth - ZKTimelineLayout.ContainerPadding - ZKTimelineLayout.TagButtonHeight,
                                 y: ZKTimelineLayout.ContainerPadding,
                                 width: ZKTimelineLayout.TagButtonHeight,
                                 height: ZKTimelineLayout.TagButtonHeight)
    }
}

// MARK: - 个人资料视图布局
extension ZKTimelineLayout {
    
    private func layoutProfileView() {
        profileViewFrame = CGRect(x: ZKTimelineLayout.ContainerPadding,
                                  y: tagsViewFrame.maxY,
                                  width: ZKTimelineLayout.ContainerWidth - ZKTimelineLayout.ContainerPadding * 2,
                                  height: ZKTimelineLayout.AvatarSize + ZKTimelineLayout.ContainerPadding * 2)
        avatarImageViewFrame = CGRect(x: 0,
                                      y: ZKTimelineLayout.ContainerPadding,
                                      width: ZKTimelineLayout.AvatarSize,
                                      height: ZKTimelineLayout.AvatarSize)
        
        let followButtonX = tagsViewFrame.height > 0 ? profileViewFrame.width - 50 : profileViewFrame.width - (50 + ZKTimelineLayout.TagButtonHeight + ZKTimelineLayout.ContainerPadding)
        let followButtonY: CGFloat = ZKTimelineLayout.ContainerPadding + (ZKTimelineLayout.AvatarSize - 28) / 2
        followButtonFrame = CGRect(origin: CGPoint(x: followButtonX, y: followButtonY),
                                   size: CGSize(width: 50, height: 28))
        followBorderFrame = CGRect(origin: CGPoint.zero, size: followButtonFrame.size)
        
        let userNameLabelH: CGFloat = 24
        let userNameLabelW = followButtonFrame.origin.x - avatarImageViewFrame.maxX - ZKTimelineLayout.ContainerPadding * 2
        userNameLabelFrame = CGRect(x: avatarImageViewFrame.maxX + ZKTimelineLayout.ContainerPadding,
                                    y: ZKTimelineLayout.ContainerPadding,
                                    width: userNameLabelW,
                                    height: userNameLabelH)
        
        let userNameFont = UIFont.systemFont(ofSize: ZKTimelineLayout.UserNameFontSize)
        let userNameText = NSMutableAttributedString(string: status.user.userName)
        if status.user.gender == 1 {
            let manImage = UIImage(named: "ic_男_feed流")!
            let manText = NSMutableAttributedString.yy_attachmentString(withContent: manImage, contentMode: .center, attachmentSize: CGSize(width: userNameLabelH, height: userNameLabelH), alignTo: userNameFont, alignment: .center)
            userNameText.append(manText)
        }
        if status.user.gender == 2 {
            let womanImage = UIImage(named: "ic_女_feed流")!
            let womanText = NSMutableAttributedString.yy_attachmentString(withContent: womanImage, contentMode: .center, attachmentSize: CGSize(width: userNameLabelH, height: userNameLabelH), alignTo: userNameFont, alignment: .center)
            userNameText.append(womanText)
        }
        userNameText.yy_font = userNameFont
        userNameText.yy_color = kThemeColor
        userNameText.yy_lineBreakMode = .byCharWrapping
        
        let userNameContainer = YYTextContainer(size: CGSize(width: userNameLabelW, height: CGFloat.greatestFiniteMagnitude))
        userNameContainer.maximumNumberOfRows = 1
        userNameTextLayout = YYTextLayout(container: userNameContainer, text: userNameText)
        
        dateSourceLabelFrame = CGRect(x: userNameLabelFrame.origin.x,
                                      y: userNameLabelFrame.maxY,
                                      width: userNameLabelW,
                                      height: ZKTimelineLayout.AvatarSize - userNameLabelH)
        let sourceText = NSMutableAttributedString()
        var dateString: String! = status.createTime
        if let date = Date(string: dateString) {
            dateString = date.stringWithFormat()
        }
        let createText = NSMutableAttributedString(string: dateString)
        createText.yy_appendString(" ")
        createText.yy_font = kThemeFont(ZKTimelineLayout.DateSourceFontSize)
        createText.yy_color = kGrayColor
        sourceText.append(createText)
        
        if status.device != nil {
            let fromText = NSMutableAttributedString(string: "来自\(status.device!)")
            fromText.yy_font = kThemeFont(ZKTimelineLayout.DateSourceFontSize)
            fromText.yy_color = kGrayColor
            let range = NSRange(location: 2, length: status.device!.count)
            fromText.yy_setColor(kLinkTextColor, range: range)
            let highlight = YYTextHighlight()
            highlight.setBackgroundBorder(highlightBoder)
            fromText.yy_setTextHighlight(highlight, range: range)
            sourceText.append(fromText)
        }
        let sourceContainer = YYTextContainer(size: CGSize(width: userNameLabelW, height: CGFloat.greatestFiniteMagnitude))
        sourceContainer.maximumNumberOfRows = 1
        dateSourceTextLayout = YYTextLayout(container: sourceContainer, text: sourceText)
    }
}

// MARK: - 文本内容布局
extension ZKTimelineLayout {
    
    private func layoutStatusLabel() {
        guard let text = textFormat(with: ZKTimelineLayout.TextFontSize, textColor: kTextColor) else { return }
        if text.length <= 0 { return }
        
        let truncationToken = NSMutableAttributedString(string: "......全文")
        truncationToken.yy_color = kTextColor
        truncationToken.yy_font = UIFont.systemFont(ofSize: ZKTimelineLayout.TextFontSize)
        truncationToken.yy_setColor(kLinkTextColor, range: NSRange(location: 6, length: 2))

        let modifier = ZKTextLinePositionModifier()
        modifier.font = UIFont(name: "Heiti SC", size: ZKTimelineLayout.TextFontSize)
        
        let textContainerWidth = ZKTimelineLayout.ContainerWidth - ZKTimelineLayout.ContainerPadding * 2
        let textContainer = YYTextContainer(size: CGSize(width: textContainerWidth, height: CGFloat.greatestFiniteMagnitude))
        textContainer.linePositionModifier = modifier
        textContainer.maximumNumberOfRows = ZKTimelineLayout.TextMaximumNumberOfLines
        textContainer.truncationType = .end
        textContainer.truncationToken = truncationToken
        statusTextLayout = YYTextLayout(container: textContainer, text: text)
        
        guard let statusTextLayout = statusTextLayout else {
            statusLabelFrame = CGRect.zero
            return
        }
        
        let lineCount = min(statusTextLayout.rowCount, ZKTimelineLayout.TextMaximumNumberOfLines)
        let statusLabelH = modifier.heightFor(lineCount: lineCount) + ZKTimelineLayout.TextBottomSpacing
        statusLabelFrame = CGRect(x: ZKTimelineLayout.ContainerPadding,
                                  y: profileViewFrame.maxY,
                                  width: textContainerWidth,
                                  height: statusLabelH)
    }
    
    private func textFormat(with fontSize: CGFloat, textColor: UIColor) -> NSAttributedString? {
        guard let string = status.text else { return nil }
        
        let font = UIFont.systemFont(ofSize: fontSize)
        let text = NSMutableAttributedString(string: string)
        text.yy_font = font
        text.yy_color = textColor
        
        // 匹配文本中的链接
        let linkResults: [NSTextCheckingResult] = ZKStatusHelper.URLRegex!.matches(in: text.string, range: text.yy_rangeOfAll())
        // 获取字符串中匹配到的所有链接
        let strArray: [String] = linkResults.compactMap {
            if $0.range.location == NSNotFound || $0.range.length <= 1 {
                return nil
            } else {
                return (text.string as NSString).substring(with: $0.range)
            }
        }
        // 格式化链接字符串
        for str in strArray {
            
            let attachmentText = NSMutableAttributedString.yy_attachmentString(withContent: UIImage(named: "timeline_card_small_web"), contentMode: .scaleAspectFit, attachmentSize: CGSize(width: font.pointSize, height: font.pointSize), alignTo: font, alignment: .center)
            let fixedAttbutedText = NSMutableAttributedString(string: "网页链接")
            fixedAttbutedText.yy_font = font
            fixedAttbutedText.yy_color = kLinkTextColor
            attachmentText.append(fixedAttbutedText)
            let URLHighlight = YYTextHighlight()
            URLHighlight.setBackgroundBorder(highlightBoder)
            URLHighlight.userInfo = [kLinkTypeKey:ZKLinkeType.web, kLinkNameKey: str]
            attachmentText.yy_setTextHighlight(URLHighlight, range: attachmentText.yy_rangeOfAll())
            
            // 替换字符串
            let range: NSRange = (text.string as NSString).range(of: str)
            text.replaceCharacters(in: range, with: attachmentText)
        }
        
        // 匹配 @用户名
        let atResults: [NSTextCheckingResult] = ZKStatusHelper.AtRegex!.matches(in: text.string, range: text.yy_rangeOfAll())
        for at in atResults {
            if at.range.location == NSNotFound || at.range.length <= 1 { continue }
            if let _ = text.yy_attribute(YYTextHighlightAttributeName, at: UInt(at.range.location)) { continue }
            text.yy_setColor(kLinkTextColor, range: at.range)
            let atHighlight = YYTextHighlight()
            let atUserName = (text.string as NSString).substring(with: NSRange(location: at.range.location + 1, length: at.range.length - 1))
            atHighlight.setBackgroundBorder(highlightBoder)
            atHighlight.userInfo = [kLinkTypeKey:ZKLinkeType.at, kLinkNameKey: atUserName]
            text.yy_setTextHighlight(atHighlight, range: at.range)
        }
        
        // 匹配话题
        let topicResults: [NSTextCheckingResult] = ZKStatusHelper.TopicRegex!.matches(in: text.string, range: text.yy_rangeOfAll())
        for topic in topicResults {
            if topic.range.location == NSNotFound || topic.range.length <= 1 { continue }
            if let _ = text.yy_attribute(YYTextHighlightAttributeName, at: UInt(topic.range.location)) { continue }
            text.yy_setColor(kLinkTextColor, range: topic.range)
            let topicHighlight = YYTextHighlight()
            let topicText = (text.string as NSString).substring(with: NSRange(location: topic.range.location + 1, length: topic.range.length - 2))
            topicHighlight.setBackgroundBorder(highlightBoder)
            topicHighlight.userInfo = [kLinkTypeKey:ZKLinkeType.topic, kLinkNameKey: topicText]
            text.yy_setTextHighlight(topicHighlight, range: topic.range)
        }
        
        // 匹配表情
        var locationOffset: Int = 0
        let emoticonResults: [NSTextCheckingResult] = ZKStatusHelper.EmoticonRegex!.matches(in: text.string, range: text.yy_rangeOfAll())
        for emoticon in emoticonResults {
            if emoticon.range.location == NSNotFound || emoticon.range.length <= 1 { continue }
            var range = emoticon.range
            range.location -= locationOffset
            if let _ = text.yy_attribute(YYTextHighlightAttributeName, at: UInt(emoticon.range.location)) { continue }
            if let _ = text.yy_attribute(YYTextAttachmentAttributeName, at: UInt(emoticon.range.location)) { continue }
            
            let emoticonString = (text.string as NSString).substring(with: range)
            guard let imagePath = ZKStatusHelper.EmoticonDict[emoticonString] else { continue }
            guard let image = UIImage.init(contentsOfFile: imagePath) else { continue }
            guard let attachment = NSAttributedString.yy_attachmentString(withEmojiImage: image, fontSize: fontSize) else { continue }
            text.replaceCharacters(in: range, with: attachment)
            locationOffset += range.length - 1
        }
        
        return text
    }
}

// MARK: - 链接视图布局
extension ZKTimelineLayout {
    
    private func layoutLinkView() {
        if status.type != 0 { return }
        guard let link = status.link else { return }
        
        let linkViewH: CGFloat = 60
        let linkPadding: CGFloat = 5
        let linkViewW = ZKTimelineLayout.ContainerWidth - ZKTimelineLayout.ContainerPadding * 2
        let linkViewY = profileViewFrame.maxY + statusLabelFrame.height
        linkViewFrame = CGRect(x: ZKTimelineLayout.ContainerPadding, y: linkViewY, width: linkViewW, height: linkViewH)
        let imageViewS = linkViewH - ZKTimelineLayout.PictureItemPadding * 2
        linkImageViewFrame = CGRect(x: linkPadding, y: linkPadding, width: imageViewS, height: imageViewS)
        let linkTextLabelX = linkImageViewFrame.maxX + linkPadding
        let linkTextLabelW = linkViewFrame.width - linkTextLabelX - linkPadding
        linkTextLabelFrame = CGRect(x: linkTextLabelX, y: linkPadding, width: linkTextLabelW, height: imageViewS)
        
        guard let text = link.text else { return }
        
        let linkTextFontSize = ZKTimelineLayout.TextFontSize - 1
        let linkText = NSMutableAttributedString(string: text)
        linkText.yy_font = kThemeFont(linkTextFontSize)
        linkText.yy_color = kTextColor
        
        let modifier = ZKTextLinePositionModifier()
        modifier.font = UIFont(name: "Heiti SC", size: linkTextFontSize)
        // 暂时写死
        let linkTextContainer = YYTextContainer(size: linkTextLabelFrame.size)
        linkTextContainer.linePositionModifier = modifier
        linkTextContainer.maximumNumberOfRows = 2
        linkTextLayout = YYTextLayout(container: linkTextContainer, text: linkText)
    }
}

// MARK: - 图片视图布局
extension ZKTimelineLayout {
    
    private func layoutPicturesView() {
        if status.type != 1 { return }
        guard let pictures = status.pictures else { return }
        if pictures.count == 0 { return }

        let picturesViewW = ZKTimelineLayout.ContainerWidth - ZKTimelineLayout.ContainerPadding * 2
        let picturesViewY = profileViewFrame.maxY + statusLabelFrame.height
        
        if pictures.count == 1 {
            guard let model = pictures.first else { return }
            let scale = CGFloat(model.thumbnailPicHeight / model.thumbnailPicWidth)
            var rect = CGRect.zero
            if scale > 1 {
                rect = CGRect(x: 0, y: 0, width: picturesViewW * 0.5, height: picturesViewW * 0.7)
            } else {
                rect = CGRect(x: 0, y: 0, width: picturesViewW * 0.7, height: picturesViewW * 0.5)
            }
            picturesViewItemFrames.append(rect)
            picturesViewFrame = CGRect(x: ZKTimelineLayout.ContainerPadding, y: picturesViewY, width: picturesViewW, height: rect.height)
        } else if pictures.count > 1 && pictures.count < 10 {
            var height: CGFloat = 0
            let itemCountOfRow = pictures.count == 4 ? 2 : 3
            let itemSize = (picturesViewW - ZKTimelineLayout.PictureItemPadding * 2) / 3
            for (index, _) in pictures.enumerated() {
                let x = (itemSize + ZKTimelineLayout.PictureItemPadding) * CGFloat(index % itemCountOfRow)
                let y = (itemSize + ZKTimelineLayout.PictureItemPadding) * CGFloat(index / itemCountOfRow)
                let rect = CGRect(x: x, y: y, width: itemSize, height: itemSize)
                picturesViewItemFrames.append(rect)
                if index == pictures.count - 1 { height = rect.maxY}
            }
            picturesViewFrame = CGRect(x: ZKTimelineLayout.ContainerPadding, y: picturesViewY, width: picturesViewW, height: height)
        }
    }
}

// MARK: - 位置+浏览量
extension ZKTimelineLayout {
    
    var labelH: CGFloat { return 30 }
    var labelY: CGFloat {
        switch status.type {
        case 0: return profileViewFrame.maxY + statusLabelFrame.height + linkViewFrame.height
        case 1: return profileViewFrame.maxY + statusLabelFrame.height + picturesViewFrame.height
        default: return profileViewFrame.maxY + statusLabelFrame.height
        }
    }
    
    private func layoutOtherLabels() {
        
        let font = UIFont.systemFont(ofSize: ZKTimelineLayout.DateSourceFontSize)
        
        if status.viewCount > 0 {
            let viewCountImage = UIImage(named: "合并形状")
            let viewCountText = NSMutableAttributedString.yy_attachmentString(withContent: viewCountImage, contentMode: .left, attachmentSize: CGSize(width: 20, height: labelH), alignTo: font, alignment: .center)
            viewCountText.yy_font = font
            viewCountText.yy_color = kGrayColor
            viewCountText.yy_lineBreakMode = .byCharWrapping
            viewCountText.yy_appendString("\(status.viewCount)")
            
            let viewCountContainer = YYTextContainer(size: CGSize(width: CGFloat.greatestFiniteMagnitude, height: labelH))
            viewCountContainer.maximumNumberOfRows = 1
            viewCountTextLayout = YYTextLayout(container: viewCountContainer, text: viewCountText)
            
            if let viewCountTextLayout = viewCountTextLayout {
                let viewCountLabelW: CGFloat = viewCountTextLayout.textBoundingSize.width
                let viewCountLabelX: CGFloat = ZKTimelineLayout.ContainerWidth - ZKTimelineLayout.ContainerPadding - viewCountLabelW
                viewCountLabelFrame = CGRect(x: viewCountLabelX,
                                             y: labelY,
                                             width: viewCountLabelW,
                                             height: labelH)
            }
        }
        
        guard let location = status.location else { return }
        
        let locationLabelW = ZKTimelineLayout.ContainerWidth - ZKTimelineLayout.ContainerPadding * 3 - viewCountLabelFrame.width
        locationLabelFrame = CGRect(x: ZKTimelineLayout.ContainerPadding,
                                    y: labelY,
                                    width: locationLabelW,
                                    height: labelH)
        
        let locationImage = UIImage(named: "community_location_icon")
        let locationText = NSMutableAttributedString.yy_attachmentString(withContent: locationImage, contentMode: .left, attachmentSize: CGSize(width: 15, height: labelH), alignTo: font, alignment: .center)
        locationText.yy_font = font
        locationText.yy_color = kGrayColor
        locationText.yy_lineBreakMode = .byCharWrapping
        locationText.yy_appendString("\(location)")
        
        let locationContainer = YYTextContainer(size: locationLabelFrame.size)
        locationContainer.maximumNumberOfRows = 1
        locationTextLayout = YYTextLayout(container: locationContainer, text: locationText)
    }
}

// MARK: - 工具栏视图布局
extension ZKTimelineLayout {
    
    private func layoutToolBar() {
        let toolBarY = locationLabelFrame.height > 0 || viewCountLabelFrame.height > 0 ? labelY + labelH : labelY + ZKTimelineLayout.ContainerPadding
        toolBarFrame = CGRect(x: 0,
                              y: toolBarY,
                              width: ZKTimelineLayout.ContainerWidth,
                              height: 35)
        rowHeight = toolBarFrame.maxY + ZKTimelineLayout.ContainerPadding
    }
}

/// 修改文本 Line 位置
/// 将每行文本的高度和位置固定下来，不受中英文/Emoji字体的 ascent/descent 影响
/// ⚠️在 Heiti SC 中，ascent + descent = font.size
/// 但是在 PingFang SC 中，ascent + descent > font.size
/// 所以这里统一用 Heiti SC (0.86 ascent, 0.14 descent) 作为顶部和底部标准，保证不同系统下的显示一致性
/// 间距仍然用字体默认
class ZKTextLinePositionModifier: NSObject, YYTextLinePositionModifier {
    
    /// 基准字体
    var font: UIFont?
    /// 文本顶部留白
    var topPadding: CGFloat = 0
    /// 文本底部留白
    var bottomPadding: CGFloat = 0
    /// 行距倍数
    var lineHeightMultiple: CGFloat = 0
    
    override init() {
        super.init()
        
        if #available(iOS 9.0, *) {
            lineHeightMultiple = 1.34   // for PingFang SC
        } else {
            lineHeightMultiple = 1.3125 // for Heiti SC
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = ZKTextLinePositionModifier()
        copy.font = font
        copy.topPadding = topPadding
        copy.bottomPadding = bottomPadding
        copy.lineHeightMultiple = lineHeightMultiple
        return copy
    }
    
    func modifyLines(_ lines: [YYTextLine], fromText text: NSAttributedString, in container: YYTextContainer) {
        guard let font = font else { return }
        let ascent = font.pointSize * 0.86
        let lineHeight = font.pointSize * lineHeightMultiple
        for line in lines {
            var position = line.position
            position.y = topPadding + ascent + CGFloat(line.row) * lineHeight
            line.position = position
        }
    }
    
    func heightFor(lineCount: UInt) -> CGFloat {
        guard let font = font, lineCount > 0 else { return 0 }
        let ascent = font.pointSize * 0.86
        let descent = font.pointSize * 0.14
        let lineHeight = font.pointSize * lineHeightMultiple
        return topPadding + bottomPadding + ascent + descent + CGFloat(lineCount - 1) * lineHeight
    }
}
