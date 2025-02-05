//
//  CRRefreshHeaderView.swift
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

class CRRefreshHeaderView: CRRefreshComponent {
    
    /// OffsetY before recording
    fileprivate var previousOffsetY: CGFloat = 0.0
    fileprivate var scrollViewBounces: Bool  = true
    
    /// ContentInsetY that needs to be adjusted when the record is refreshed
    fileprivate var insetTDelta: CGFloat     = 0.0
    
    /// Record contentInsetY that needs to be adjusted when hovering
    fileprivate var holdInsetTDelta: CGFloat = 0.0
    
    /// Is it still over
    private var isEnding: Bool = false
    
    convenience init(animator: CRRefreshProtocol = NormalHeaderAnimator(), handler: @escaping CRRefreshHandler) {
        self.init(frame: .zero)
        self.handler  = handler
        self.animator = animator
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.scrollViewBounces = weakSelf.scrollView?.bounces ?? true
        }
    }
    
    override func start() {
        
        guard let scrollView = scrollView else { return }
        
        // Ignore listening when animating
        ignoreObserver(true)
        scrollView.bounces = false
        
        super.start()
        
        // Start animation
        animator.refreshBegin(view: self)
        
        // Adjust scrollView's contentInset
        var insets           = scrollView.contentInset
        scrollViewInsets.top = insets.top
        insets.top          += animator.execute
        insetTDelta          = -animator.execute
        holdInsetTDelta      = -(animator.execute - animator.hold)
        
        UIView.animate(withDuration: CRRefreshComponent.animationDuration, animations: { 
            scrollView.contentOffset.y = self.previousOffsetY
            scrollView.contentInset    = insets
            scrollView.contentOffset.y = -insets.top
        }) { (finished) in
            DispatchQueue.main.async {
                self.handler?()
                self.ignoreObserver(false)
                scrollView.bounces = self.scrollViewBounces
            }
        }
    }
    
    override func stop() {
        
        guard let scrollView = scrollView else { return }
        
        // Ignore listening when animating
        ignoreObserver(true)
        animator.refreshWillEnd(view: self)
        
        if self.animator.hold != 0 {
            UIView.animate(withDuration: CRRefreshComponent.animationDuration) {
                scrollView.contentInset.top += self.holdInsetTDelta
            }
        }
        func beginStop() {
            
            guard isEnding == false, isRefreshing else { return }
            
            isEnding = true
            
            // End animation
            animator.refreshEnd(view: self, finish: false)
            
            // Adjust scrollView's contentInset
            UIView.animate(withDuration: CRRefreshComponent.animationDuration, animations: {
                scrollView.contentInset.top += self.insetTDelta - self.holdInsetTDelta
            }) { (finished) in
                DispatchQueue.main.async {
                    self.state = .idle
                    super.stop()
                    self.animator.refreshEnd(view: self, finish: true)
                    self.ignoreObserver(false)
                    self.isEnding = false
                }
            }
        }
        
        if animator.endDelay > 0 {
            
            if self.isEnding == false {
                
                let delay =  DispatchTimeInterval.milliseconds(Int(animator.endDelay * 1000))
                
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    beginStop()
                })
            }
        } else {
            beginStop()
        }
    }
    
    override func offsetChange(change: [NSKeyValueChangeKey: Any]?) {
        
        guard let scrollView = scrollView else { return }
        
        super.offsetChange(change: change)
        
        // SectionHeader staying solution
        guard isRefreshing == false else {
            
            if self.window == nil { return }
            
            let top          = scrollViewInsets.top
            let offsetY      = scrollView.contentOffset.y
            let height       = frame.size.height
            
            var scrollingTop = (-offsetY > top) ? -offsetY : top
            scrollingTop     = (scrollingTop > height + top) ? (height + top) : scrollingTop
            scrollView.contentInset.top = scrollingTop
            insetTDelta      = scrollViewInsets.top - scrollingTop
            
            return
        }
        
        // Calculation Progress
        var isRecordingProgress = false
        
        defer {
            if isRecordingProgress == true {
                let percent = -(previousOffsetY + scrollViewInsets.top) / animator.trigger
                animator.refresh(view: self, progressDidChange: percent)
            }
        }
        
        let offsets = previousOffsetY + scrollViewInsets.top
        
        if offsets < -animator.trigger {
            
            if isRefreshing == false {
                if scrollView.isDragging == false, state == .pulling {
                    beginRefreshing()
                    state = .refreshing
                } else {
                    if scrollView.isDragging {
                        state = .pulling
                        isRecordingProgress = true
                    }
                }
            }
            
        } else if offsets < 0 {
            if isRefreshing == false {
                state = .idle
                isRecordingProgress = true
            }
        }
        
        previousOffsetY = scrollView.contentOffset.y
    }
}
