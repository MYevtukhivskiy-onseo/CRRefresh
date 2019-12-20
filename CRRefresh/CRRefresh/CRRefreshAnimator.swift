//
//  CRRefreshAnimator.swift
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

import UIKit

class CRRefreshAnimator: CRRefreshProtocol {
    
    var view: UIView
    
    var insets: UIEdgeInsets
    
    var trigger: CGFloat = 60.0
    
    var execute: CGFloat = 60.0
    
    var endDelay: CGFloat = 0
    
    var hold: CGFloat   = 60
    
    init() {
        view = UIView()
        insets = UIEdgeInsets.zero
    }
    
    func refreshBegin(view: CRRefreshComponent) {}
    
    func refreshWillEnd(view: CRRefreshComponent) {}
    
    func refreshEnd(view: CRRefreshComponent, finish: Bool) {}
    
    func refresh(view: CRRefreshComponent, progressDidChange progress: CGFloat) {}
    
    func refresh(view: CRRefreshComponent, stateDidChange state: CRRefreshState) {}
}
