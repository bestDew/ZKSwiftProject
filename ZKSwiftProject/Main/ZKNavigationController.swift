//
//  ZKNavigationController.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2018/12/29.
//  Copyright © 2018 bestdew. All rights reserved.
//

import UIKit

class ZKNavigationController: UINavigationController {

    public var isEnablePopGesture = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addFullScreenGesture()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = true
        super.pushViewController(viewController, animated: animated)
        viewController.hidesBottomBarWhenPushed = false
        
        if children.count > 1 {
            let image = UIImage(named: "ic_new_return")?.withRenderingMode(.alwaysOriginal)
            let leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(leftBarButtonItemAction))
            viewController.navigationItem.leftBarButtonItem = leftBarButtonItem
        }
    }
    
    // MARK: - Private
    @objc private func leftBarButtonItemAction() {
        popViewController(animated: true)
    }
    
    private func addFullScreenGesture() {
        let target = interactivePopGestureRecognizer?.delegate
        let action = NSSelectorFromString("handleNavigationTransition:")
        let targetView = interactivePopGestureRecognizer?.view
        let panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: target, action: action)
        panGesture.delegate = self
        targetView?.addGestureRecognizer(panGesture)
        
        interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func removeNavigationBarLine() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }
}

extension ZKNavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if viewControllers.count <= 1 {
            return false
        }
        
        if value(forKey: "_isTransitioning") as! Bool {
            return false
        }
        // 解决手势冲突
        let gesture = gestureRecognizer as! UIPanGestureRecognizer
        let translation: CGPoint = gesture.translation(in: gesture.view)
        if translation.x < 0 {
            return false
        }
        return isEnablePopGesture
    }
}
