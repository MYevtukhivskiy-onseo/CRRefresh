//
//  RefreshController.swift
//  CRRefresh
//
// **************************************************
// *                                  _____         *
// *         __  _  __     ___        \   /         *
// *         \ \/ \/ /    / __\       /  /          *
// *          \  _  /    | (__       /  /           *
// *           \/ \/      \___/     /  /__          *
// *                               /_____/          *
// *                                                *
// **************************************************
//  Github  :https://github.com/imwcl
//  HomePage:http://imwcl.com
//  CSDN    :http://blog.csdn.net/wang631106979
//
//  Created by 王崇磊 on 16/9/14.
//  Copyright © 2016年 王崇磊. All rights reserved.
//
// @class RefreshController
// @abstract 刷新VC
// @discussion 刷新VC
//

import UIKit
import CRRefresh

class RefreshController: BaseViewController {
    
    var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        return table
    }()
    
    var count: Int = 10
    
    var refresh: Refresh
    
    init(refresh: Refresh) {
        self.refresh = refresh
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Public Methods
    override func configNavBar() {
        super.configNavBar()
        
        addNavDefaultBackButton()
        navTitle = refresh.model.title
    }
    
    override func configView() {
        super.configView()
        tableView.frame = .init(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 64)
        tableView.register(UINib.init(nibName: "RefreshCell", bundle: nil), forCellReuseIdentifier: "RefreshCell")
        view.addSubview(tableView)
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        let animator = NormalHeaderAnimator()
        tableView.cr.addHeadRefresh(animator: animator) { [weak self] in
            print("开始刷新")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self?.count = 10
                self?.tableView.cr.endHeaderRefresh() 
                self?.tableView.reloadData()
            })
        }
        
//        tableView.cr.beginHeaderRefresh()
         
    }
    
    //MARK: Override
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        tableView.tableHeaderView?.frame.size.height = 0
    }
    
}

// MARK: - Table view data source
extension RefreshController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
     
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
     
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RefreshCell", for: indexPath) as! RefreshCell
        return cell
    }
}
