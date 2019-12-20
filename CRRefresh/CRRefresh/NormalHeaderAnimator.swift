//
//  NormalHeaderAnimator.swift
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

class NormalHeaderAnimator: UIView, CRRefreshProtocol {
    
    var pullToRefreshDescription = "Pull down to refresh" {
        didSet {
            if pullToRefreshDescription != oldValue {
                titleLabel.text = pullToRefreshDescription
            }
        }
    }
    
    var releaseToRefreshDescription = "Release to refresh"
    var loadingDescription = "Loading..."
    
    var view: UIView { return self }
    var insets: UIEdgeInsets = .zero
    var trigger: CGFloat  = 60.0
    var execute: CGFloat  = 60.0
    var endDelay: CGFloat = 0
     var hold: CGFloat   = 60
    
    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage(named: "refresh_arrow")
        return imageView
    }()
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor.init(white: 0.625, alpha: 1.0)
        label.textAlignment = .left
        return label
    }()
    
    fileprivate let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView.init(style: .gray)
        indicatorView.isHidden = true
        return indicatorView
    }()
    
     override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.text = pullToRefreshDescription
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        self.addSubview(indicatorView)
    }
    
     required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = bounds.size
        let width = size.width
        let height = size.height
        
        UIView.performWithoutAnimation {
            titleLabel.sizeToFit()
            titleLabel.center = .init(x: width / 2.0, y: height / 2.0)
            indicatorView.center = .init(x: titleLabel.frame.origin.x - 16.0, y: height / 2.0)
            imageView.frame = CGRect.init(x: titleLabel.frame.origin.x - 28.0, y: (height - 18.0) / 2.0, width: 18.0, height: 18.0)
        }
    }
    
    
    func refreshBegin(view: CRRefreshComponent) {
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        imageView.isHidden     = true
        titleLabel.text        = loadingDescription
        imageView.transform    = CGAffineTransform(rotationAngle: 0.000001 - CGFloat(Double.pi))
    }
    
    func refreshEnd(view: CRRefreshComponent, finish: Bool) {
        
        if finish {
            indicatorView.stopAnimating()
            indicatorView.isHidden = true
            imageView.isHidden = false
            imageView.transform = CGAffineTransform.identity
        } else {
            titleLabel.text = pullToRefreshDescription
            setNeedsLayout()
        }
    }
    
     func refreshWillEnd(view: CRRefreshComponent) {
        
    }
    
    func refresh(view: CRRefreshComponent, progressDidChange progress: CGFloat) {
        
    }
    
    func refresh(view: CRRefreshComponent, stateDidChange state: CRRefreshState) {
        
        switch state {
            
        case .refreshing:
            titleLabel.text = loadingDescription
            setNeedsLayout()
            break
            
        case .pulling:
            titleLabel.text = releaseToRefreshDescription
            self.setNeedsLayout()
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions(), animations: { [weak self] in
                self?.imageView.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat(Double.pi))
            }) { (animated) in }
            
            break
            
        case .idle:
            titleLabel.text = pullToRefreshDescription
            self.setNeedsLayout()
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions(), animations: {
                [weak self] in
                self?.imageView.transform = CGAffineTransform.identity
            }) { (animated) in }
            break
        default:
            break
        }
    }
    
}
