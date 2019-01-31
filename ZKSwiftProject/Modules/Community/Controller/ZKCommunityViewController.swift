//
//  ZKHomeViewController.swift
//  ZKSwiftProject
//
//  Created by bestdew on 2018/12/29.
//  Copyright © 2018 bestdew. All rights reserved.
//

import UIKit
import SwiftyJSON

class ZKCommunityViewController: ZKViewController {

    fileprivate var layouts = [ZKTimelineLayout]()
    fileprivate let kCellReuseId = "ZKCommunityTimelineCell"
    fileprivate lazy var tableView: ZKTableView = {
        let tableView = ZKTableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        tableView.register(ZKCommunityTimelineCell.self, forCellReuseIdentifier: kCellReuseId)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        readLocalData()
    }
    
    private func readLocalData() {
        DispatchQueue.global().async {
            guard let path = Bundle.main.path(forResource: "Community", ofType: "json") else {
                print("本地JSON文件不存在")
                return
            }
            guard let json = NSData(contentsOfFile: path) else {
                print("读取JSON文件失败")
                return
            }
            let jsonData = JSON(json)
            for (_, value) in jsonData["data"] {
                autoreleasepool {
                    let status = ZKTimelineStatus(jsonData: value)
                    let layout = ZKTimelineLayout(status: status)
                    self.layouts.append(layout)
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension ZKCommunityViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return layouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellReuseId, for: indexPath) as! ZKCommunityTimelineCell
        cell.layout = layouts[indexPath.row]
        return cell
    }
}

extension ZKCommunityViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return layouts[indexPath.row].rowHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ZKCommunityDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

