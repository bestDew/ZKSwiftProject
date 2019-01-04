//
//  ZKHomeDetailViewController.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2018/12/30.
//  Copyright © 2018 bestdew. All rights reserved.
//

import UIKit

class ZKHomeDetailViewController: ZKBaseViewController {

    fileprivate var imageGroup = [String]()
    fileprivate lazy var cycleScrollView: ZKCycleScrollView = {
        let cycleScrollView = ZKCycleScrollView(frame: CGRect(x: 0.0, y: kTopMargin, width: kScreenWidth, height: kFitWidth(80.0)))
        cycleScrollView.delegate = self
        cycleScrollView.dataSource = self
        cycleScrollView.backgroundColor = .clear
        cycleScrollView.register(cellClass: ZKDetailBannerCell.self)
        
        return cycleScrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "详情"
        view.backgroundColor = UIColor.random()
        
        imageGroup = ["http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20171101181927887.jpg", "http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20171114171645011.jpg", "http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20171114172009707.png"]
        view.addSubview(cycleScrollView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cycleScrollView.adjustWhenViewWillAppear()
    }
    
    deinit {
        print("销毁")
    }
}

extension ZKHomeDetailViewController: ZKCycleScrollViewDelegate {
    
    func cycleScrollView(_ cycleScrollView: ZKCycleScrollView, didSelectItemAt indexPath: IndexPath) {
        print("点击了：\(indexPath)")
    }
}

extension ZKHomeDetailViewController: ZKCycleScrollViewDataSource {
    
    func numberOfItems(in cycleScrollView: ZKCycleScrollView) -> Int {
        return imageGroup.count
    }
    
    func cycleScrollView(_ cycleScrollView: ZKCycleScrollView, cellForItemAt indexPath: IndexPath) -> ZKCycleScrollViewCell {
        let cell = cycleScrollView.dequeueReusableCell(for: indexPath) as! ZKDetailBannerCell
        cell.imageUrl = imageGroup[indexPath.item]
        
        return cell
    }
}

