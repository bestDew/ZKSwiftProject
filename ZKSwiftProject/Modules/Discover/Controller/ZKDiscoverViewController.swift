//
//  ZKDiscoverViewController.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2018/12/29.
//  Copyright © 2018 bestdew. All rights reserved.
//

import UIKit

class ZKDiscoverViewController: ZKViewController {

    fileprivate var imageGroup = [String]()
    fileprivate lazy var cycleScrollView: ZKCycleScrollView = {
        let cycleScrollView = ZKCycleScrollView(frame: CGRect(x: 0, y: kTopMargin, width: view.bounds.width, height: kFitWidth(200)))
        cycleScrollView.delegate = self
        cycleScrollView.dataSource = self
        cycleScrollView.backgroundColor = .white
        cycleScrollView.register(cellClass: ZKBannerCell.self)
        cycleScrollView.pageControlTransform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        return cycleScrollView
    }()
    fileprivate lazy var pageControl: CHIPageControlJaloro = {
        let pageControl = CHIPageControlJaloro()
        pageControl.tintColor = UIColor(hexString: "#E8E8EA")!
        pageControl.currentPageTintColor = kThemeColor
        pageControl.numberOfPages = imageGroup.count
        pageControl.isHidden = true
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for index in 1...6 {
            imageGroup.append("ad_\(index)")
        }
        view.addSubview(cycleScrollView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cycleScrollView.adjustWhenViewWillAppear()
    }
}

extension ZKDiscoverViewController: ZKCycleScrollViewDelegate {
    
    func cycleScrollView(_ cycleScrollView: ZKCycleScrollView, didSelectItemAt indexPath: IndexPath) {
        print("点击了：\(indexPath)")
    }
    
    func cycleScrollViewDidScroll(_ cycleScrollView: ZKCycleScrollView) {
        let total =  CGFloat(imageGroup.count - 1) * cycleScrollView.bounds.width
        let offset = cycleScrollView.contentOffset.x.truncatingRemainder(dividingBy:(cycleScrollView.bounds.width * CGFloat(imageGroup.count)))
        let percent = Double(offset / total)
        let progress = percent * Double(imageGroup.count - 1)
        pageControl.progress = progress
    }
}

extension ZKDiscoverViewController: ZKCycleScrollViewDataSource {
    
    func numberOfItems(in cycleScrollView: ZKCycleScrollView) -> Int {
        return imageGroup.count
    }
    
    func cycleScrollView(_ cycleScrollView: ZKCycleScrollView, cellForItemAt indexPath: IndexPath) -> ZKCycleScrollViewCell {
        let cell = cycleScrollView.dequeueReusableCell(for: indexPath) as! ZKBannerCell
        cell.imageView.image = UIImage(named: imageGroup[indexPath.item])
        return cell
    }
    
    func customPageControl(for cycleScrollView: ZKCycleScrollView) -> UIView {
        return pageControl
    }
}

