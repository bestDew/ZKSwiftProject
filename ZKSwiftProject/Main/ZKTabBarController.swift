//
//  ZKTabBarController.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2018/12/29.
//  Copyright © 2018 bestdew. All rights reserved.
//

import UIKit

class ZKTabBarController: UITabBarController {

    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "tabbar_compose_icon_add"))
        imageView.contentMode = .center
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: 34.0, height: 34.0)
        imageView.center = CGPoint(x: kScreenWidth / 2, y: (kTabBarHeight - kBottomMargin) / 2)
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        
        addChildViewController()
        tabBar.addSubview(imageView)
    }
    
    private func addChildViewController() {
        // 微博
        let homeVC = ZKHomeViewController()
        let homeItem = UITabBarItem(title: "微博", image: originalImage(with: "tabbar_home"), selectedImage: originalImage(with: "tabbar_home_selected"))
        homeItem.setTitleTextAttributes([.foregroundColor:UIColor(hexString: "#EF8833")!], for: .selected)
        homeVC.tabBarItem = homeItem
        homeVC.navigationItem.title = "微博"
        let homeNav = ZKNavigationController(rootViewController: homeVC)
        // 消息
        let messageVC = ZKMessageViewController()
        let messageItem = UITabBarItem(title: "消息", image: originalImage(with: "tabbar_message_center"), selectedImage: originalImage(with: "tabbar_message_center_selected"))
        messageItem.setTitleTextAttributes([.foregroundColor:UIColor(hexString: "#EF8833")!], for: .selected)
        messageVC.tabBarItem = messageItem
        messageVC.navigationItem.title = "消息"
        let messageNav = ZKNavigationController(rootViewController: messageVC)
        // 中间加号按钮，创建一个空控制器
        let vc = UIViewController()
        let item = UITabBarItem(title: nil, image: originalImage(with: "tabbar_compose_button"), selectedImage: nil)
        item.imageInsets = UIEdgeInsets(top: 5.0, left: 0.0, bottom: -5.0, right: 0.0)
        vc.tabBarItem = item
        let nav = ZKNavigationController(rootViewController: vc)
        // 发现
        let discoverVC = ZKDiscoverViewController()
        let discoverItem = UITabBarItem(title: "发现", image: originalImage(with: "tabbar_discover"), selectedImage: originalImage(with: "tabbar_discover_selected"))
        discoverItem.setTitleTextAttributes([.foregroundColor:UIColor(hexString: "#EF8833")!], for: .selected)
        discoverVC.tabBarItem = discoverItem
        discoverVC.navigationItem.title = "发现"
        let discoverNav = ZKNavigationController(rootViewController: discoverVC)
        // 我的
        let mineVC = ZKMineViewController()
        let mineItem = UITabBarItem(title: "我的", image: originalImage(with: "tabbar_profile"), selectedImage: originalImage(with: "tabbar_profile_selected"))
        mineItem.setTitleTextAttributes([.foregroundColor:UIColor(hexString: "#EF8833")!], for: .selected)
        mineVC.tabBarItem = mineItem
        mineVC.navigationItem.title = "我的"
        let mineNav = ZKNavigationController(rootViewController: mineVC)
        
        viewControllers = [homeNav, messageNav, nav, discoverNav, mineNav]
    }
    
    private func originalImage(with name:String) -> UIImage? {
        return UIImage(named: name)?.withRenderingMode(.alwaysOriginal)
    }
}

extension ZKTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let title = viewController.tabBarItem.title ?? ""
        let index = viewControllers!.firstIndex(of: viewController)!
        if index == 2 { showMenuView() }
        NotificationCenter.default.post(name: kClickTabBarNotificationName, object: self, userInfo: [kTabBarItemIndex:index, kTabBarItemTitle:title])

        return (index != 2)
    }
    
    private func showMenuView() {
        
        let idea = ZKComposeItem(title: "文字", image: UIImage(named: "tabbar_compose_idea")) { [weak self] item in
            print("\(item.title!)")
            let currentVC = self!.selectedViewController as! ZKNavigationController
            let targetVC = ZKHomeDetailViewController()
            currentVC.pushViewController(targetVC, animated: true)
        }
        let photo = ZKComposeItem(title: "相册", image: UIImage(named: "tabbar_compose_photo")) { item in
            print("\(item.title!)")
        }
        let weibo = ZKComposeItem(title: "微博", image: UIImage(named: "tabbar_compose_weibo")) { item in
            print("\(item.title!)")
        }
        let signin = ZKComposeItem(title: "签到", image: UIImage(named: "tabbar_compose_lbs")) { item in
            print("\(item.title!)")
        }
        let review = ZKComposeItem(title: "点评", image: UIImage(named: "tabbar_compose_review")) { item in
            print("\(item.title!)")
        }
        let friend = ZKComposeItem(title: "好友", image: UIImage(named: "tabbar_compose_friend")) { item in
            print("\(item.title!)")
        }
        let wbcamera = ZKComposeItem(title: "相机", image: UIImage(named: "tabbar_compose_wbcamera")) { item in
            print("\(item.title!)")
        }
        let music = ZKComposeItem(title: "音乐", image: UIImage(named: "tabbar_compose_music")) { item in
            print("\(item.title!)")
        }
        let shooting = ZKComposeItem(title: "拍摄", image: UIImage(named: "tabbar_compose_shooting")) { item in
            print("\(item.title!)")
        }
        let items = [idea, photo, weibo, signin, review, friend,
                     wbcamera, music, shooting]
        let compose = ZKComposeController(items: items)
        compose.show(from: self, animated: true)
    }
}
