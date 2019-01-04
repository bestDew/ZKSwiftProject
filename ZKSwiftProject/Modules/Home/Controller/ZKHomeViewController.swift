//
//  ZKHomeViewController.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2018/12/29.
//  Copyright © 2018 bestdew. All rights reserved.
//

import UIKit

class ZKHomeViewController: ZKBaseViewController {

    fileprivate let kCellReuseId = "UITableViewCell"
    fileprivate var imageGroup = [String]()
    fileprivate lazy var cycleScrollView: ZKCycleScrollView = {
        let cycleScrollView = ZKCycleScrollView(frame: CGRect(x: 0.0, y: kTopMargin, width: view.bounds.width, height: kFitWidth(200.0)))
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
        pageControl.currentPageTintColor = UIColor(hexString: "#EF8833")!
        pageControl.numberOfPages = imageGroup.count
        pageControl.isHidden = true
        
        return pageControl
    }()
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 66.0
        tableView.estimatedRowHeight = 0.0
        tableView.estimatedSectionHeaderHeight = 0.0
        tableView.estimatedSectionFooterHeight = 0.0
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kCellReuseId)
        
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        deselectRow(with: animated)
        cycleScrollView.adjustWhenViewWillAppear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for index in 1...6 {
            imageGroup.append("ad_\(index)")
        }
        tableView.tableHeaderView = cycleScrollView
        view.addSubview(tableView)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceived(notification:)), name: kClickTabBarNotificationName, object: tabBarController)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func didReceived(notification: Notification) {
        let userInfo = notification.userInfo!
        print("\(userInfo[kTabBarItemTitle]!)")
    }
    
    private func deselectRow(with animated: Bool) {
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
        guard let coordinator = transitionCoordinator else {
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
                self.tableView.deselectRow(at: selectedIndexPath, animated: true)
            },
            completion: { context in
                guard context.isCancelled else { return }
                self.tableView.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)
            }
        )
    }
}

extension ZKHomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellReuseId, for: indexPath)
        cell.textLabel?.text = "我是第\(indexPath.row)个"
        
        return cell
    }
}

extension ZKHomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ZKHomeDetailViewController()
        vc.userInfo = ["key" : 2333]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ZKHomeViewController: ZKCycleScrollViewDelegate {
    
    func cycleScrollView(_ cycleScrollView: ZKCycleScrollView, didSelectItemAt indexPath: IndexPath) {
        print("点击了：\(indexPath)")
    }
    
    func cycleScrollViewDidScroll(_ cycleScrollView: ZKCycleScrollView) {
        let total =  CGFloat(imageGroup.count - 1) * cycleScrollView.bounds.width
        let offset = cycleScrollView.contentOffset.x.truncatingRemainder(dividingBy:(cycleScrollView.bounds.width * (CGFloat)(imageGroup.count)))
        let percent = Double(offset / total)
        let progress = percent * Double(imageGroup.count - 1)
        pageControl.progress = progress
    }
}

extension ZKHomeViewController: ZKCycleScrollViewDataSource {
    
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

