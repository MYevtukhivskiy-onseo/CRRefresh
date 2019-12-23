//
//  CRRefreshComponent.swift
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

typealias CRRefreshHandler = (() -> ())

enum CRRefreshState {
    /// Normal idle state
    case idle
    /// Release to refresh
    case pulling
    /// Refreshing status
    case refreshing
    /// Upcoming status
    case willRefresh
}

class CRRefreshComponent: UIView {
    
    weak var scrollView: UIScrollView?
    
    var scrollViewInsets: UIEdgeInsets = .zero
    
    var handler: CRRefreshHandler?
    
    var animator: CRRefreshProtocol!
    
    var state: CRRefreshState = .idle {
        didSet {
            if state != oldValue {
                DispatchQueue.main.async {
                    self.animator.refresh(view: self, stateDidChange: self.state)
                }
            }
        }
    }
    
    fileprivate var isObservingScrollView: Bool = false
    fileprivate var isIgnoreObserving:     Bool = false
    fileprivate(set) var isRefreshing:     Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        autoresizingMask = [.flexibleLeftMargin, .flexibleWidth, .flexibleRightMargin]
    }
    
    convenience init(animator: CRRefreshProtocol = CRRefreshAnimator(), handler: @escaping CRRefreshHandler) {
        self.init(frame: .zero)
        
        self.handler  = handler
        self.animator = animator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        // Remove the old parent control
        removeObserver()
        
        if let newSuperview = newSuperview as? UIScrollView {
            
            // Save the initial contentInset of UIScrollView
            scrollViewInsets = newSuperview.contentInset
            
            DispatchQueue.main.async { [weak self, newSuperview] in
                
                guard let weakSelf = self else { return }
                
                weakSelf.addObserver(newSuperview)
            }
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        scrollView = superview as? UIScrollView
        
        let view = animator.view
        
        if view.superview == nil {
            let inset = animator.insets
            addSubview(view)
            
            view.frame = CGRect(x: inset.left,
                                y: inset.top,
                                width: bounds.size.width - inset.left - inset.right,
                                height: bounds.size.height - inset.top - inset.bottom)
            
            view.autoresizingMask = [
                .flexibleWidth,
                .flexibleTopMargin,
                .flexibleHeight,
                .flexibleBottomMargin
            ]
        }
    }
    
    //MARK:  Methods
    final func beginRefreshing() -> Void {
        
        guard isRefreshing == false else { return }
        
        if self.window != nil {
            state = .refreshing
            start()
        } else {
            if state != .refreshing {
                state = .willRefresh
                
                // Prevent the view from calling beginRefreshing before it is displayed
                DispatchQueue.main.async {
                    
                    self.scrollViewInsets = self.scrollView?.contentInset ?? .zero
                    
                    if self.state == .willRefresh {
                        self.state = .refreshing
                        self.start()
                    }
                }
                
            }
        }
        
    }
    
    final func endRefreshing() -> Void {
        guard isRefreshing else { return }
        self.stop()
    }
    
    func ignoreObserver(_ ignore: Bool = false) {
        isIgnoreObserving = ignore
    }
    
    func start() {
        isRefreshing = true
    }
    
    func stop() {
        isRefreshing = false
    }
    
    func sizeChange(change: [NSKeyValueChangeKey: Any]?) {}
    func offsetChange(change: [NSKeyValueChangeKey: Any]?) {}
}

//MARK: Observer Methods 
extension CRRefreshComponent {
    
    fileprivate static var context            = "CRRefreshContext"
    fileprivate static let offsetKeyPath      = "contentOffset"
    fileprivate static let contentSizeKeyPath = "contentSize"
    
    static let animationDuration = 0.25
    
    fileprivate func removeObserver() {
        
        if let scrollView = superview as? UIScrollView, isObservingScrollView {
            scrollView.removeObserver(self, forKeyPath: CRRefreshComponent.offsetKeyPath, context: &CRRefreshComponent.context)
            scrollView.removeObserver(self, forKeyPath: CRRefreshComponent.contentSizeKeyPath, context: &CRRefreshComponent.context)
            isObservingScrollView = false
        }
    }
    
    fileprivate func addObserver(_ view: UIView?) {
        
        if let scrollView = view as? UIScrollView, !isObservingScrollView {
            
            scrollView.addObserver(self, forKeyPath: CRRefreshComponent.offsetKeyPath, options: [.initial, .new], context: &CRRefreshComponent.context)
            scrollView.addObserver(self, forKeyPath: CRRefreshComponent.contentSizeKeyPath, options: [.initial, .new], context: &CRRefreshComponent.context)
            
            isObservingScrollView = true
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        
        if context == &CRRefreshComponent.context {
            
            guard isUserInteractionEnabled, !isHidden else { return }
            
            if keyPath == CRRefreshComponent.contentSizeKeyPath {
                
                if isIgnoreObserving == false {
                    sizeChange(change: change)
                }
                
            } else if keyPath == CRRefreshComponent.offsetKeyPath {
                
                if isIgnoreObserving == false {
                    offsetChange(change: change)
                }
            }
            
        }
    }
    
}
