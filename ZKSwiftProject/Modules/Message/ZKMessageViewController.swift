//
//  ZKMessageViewController.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2018/12/29.
//  Copyright © 2018 bestdew. All rights reserved.
//

import UIKit

class ZKMessageViewController: ZKBaseViewController {

    fileprivate var textGroup = [String]()
    fileprivate lazy var cycleScrollView: ZKCycleScrollView = {
        let cycleScrollView = ZKCycleScrollView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 30))
        cycleScrollView.center = view.center
        cycleScrollView.delegate = self
        cycleScrollView.dataSource = self
        cycleScrollView.showsPageControl = false
        cycleScrollView.scrollDirection = .vertical
        cycleScrollView.backgroundColor = .white
        cycleScrollView.register(cellClass: ZKCycleScrollTextCell.self)
        
        return cycleScrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textGroup = ["郭xx 抽中了 200积分",
                     "白xx 抽中了 100积分",
                     "李xx 抽中了 100积分",
                     "王xx 抽中了 500积分",
                     "刘xx 抽中了 600积分",
                     "张xx 抽中了 350积分"]
        view.addSubview(cycleScrollView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cycleScrollView.adjustWhenViewWillAppear()
    }
}

extension ZKMessageViewController: ZKCycleScrollViewDelegate {
    
    func cycleScrollView(_ cycleScrollView: ZKCycleScrollView, didSelectItemAt indexPath: IndexPath) {
        print("点击了：\(indexPath)")
    }
}

extension ZKMessageViewController: ZKCycleScrollViewDataSource {
    
    func numberOfItems(in cycleScrollView: ZKCycleScrollView) -> Int {
        return textGroup.count
    }
    
    func cycleScrollView(_ cycleScrollView: ZKCycleScrollView, cellForItemAt indexPath: IndexPath) -> ZKCycleScrollViewCell {
        let cell = cycleScrollView.dequeueReusableCell(for: indexPath) as! ZKCycleScrollTextCell
        cell.label.text = textGroup[indexPath.item]
        
        return cell
    }
}

