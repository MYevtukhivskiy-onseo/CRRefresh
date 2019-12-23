//
//  CRRefreshProtocol.swift
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

protocol CRRefreshProtocol {
    
    /// Custom view
    var view: UIView { get }
    
    /// View insets
    var insets: UIEdgeInsets { set get }
    
    /// The height at which the refresh is triggered
    var trigger: CGFloat { set get }
    
    /// Height when the animation is executed
    var execute: CGFloat { set get }
    
    /// Delay time at the end of the animation, in seconds
    var endDelay: CGFloat { set get }
    
    /// Hover height when delayed
    var hold: CGFloat { set get }
    
    /// Start refreshing
    mutating func refreshBegin(view: CRRefreshComponent)
    
    /// Will end refresh
    mutating func refreshWillEnd(view: CRRefreshComponent)
    
    /// End refresh
    mutating func refreshEnd(view: CRRefreshComponent, finish: Bool)
    
    /// Refresh progress changes
    mutating func refresh(view: CRRefreshComponent, progressDidChange progress: CGFloat)
    
    /// Change of refresh status
    mutating func refresh(view: CRRefreshComponent, stateDidChange state: CRRefreshState)
}
