//
//  ViewController.swift
//  CRRefresh
//
//  Created by 王崇磊 on 2017/2/24.
//  Copyright © 2017年 王崇磊. All rights reserved.
//

import UIKit
import CRRefresh

class ViewController: BaseViewController {
    
    var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        return table
    }()
    
    var refreshs: [Refresh] = [
        Refresh(model: .init(icon: #imageLiteral(resourceName: "Image_1"), title: "NormalAnimator", subTitle: "普通刷新控件"), header: .normalHead),
        Refresh(model: .init(icon: #imageLiteral(resourceName: "Image_2"), title: "2NormalAnimator2", subTitle: "2Animator的刷新控件"), header: .normalHead),
        Refresh(model: .init(icon: #imageLiteral(resourceName: "Image_3"), title: "3NormalAnimator3", subTitle: "3Animator的刷新控件"), header: .normalHead),
        Refresh(model: .init(icon: #imageLiteral(resourceName: "Image_1"), title: "4NormalAnimator4", subTitle: "4Animator的刷新控件4"), header: .normalHead)
    ]


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configNavBar() {
        super.configNavBar()
        navTitle = "CRRefresh"
    }
    
    override func configView() {
        super.configView()
        tableView.frame = .init(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 64)
        tableView.register(UINib.init(nibName: "NormalCell", bundle: nil), forCellReuseIdentifier: "NormalCell")
        view.addSubview(tableView)
        tableView.delegate   = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: - Table view data source
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let refresh = refreshs[indexPath.row]
        let vc = RefreshController(refresh: refresh)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return refreshs.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NormalCell", for: indexPath) as! NormalCell
        let refresh = refreshs[indexPath.row]
        cell.config(refresh.model)
        return cell
    }
}

struct Refresh {
    var model: Model
    var header: Style
    
    struct Model {
        var icon: UIImage
        var title: String
        var subTitle: String
    }
    
    enum Style {
 
        case normalHead 
        
        func commont() -> CRRefreshProtocol {
            switch self {
            case .normalHead:
                return NormalHeaderAnimator() 
            }
        }
    }
}

