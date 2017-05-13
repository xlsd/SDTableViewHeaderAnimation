//
//  HeaderAnimationTableView.swift
//  TableViewHeaderAnimation
//
//  Created by xuelin on 2017/5/13.
//  Copyright © 2017年 as_one. All rights reserved.
//

import UIKit
//  到达顶部和底部的闭包
typealias TableViewReachTopViewBottomClosure = (_ isTopDirection: Bool) -> Void;

class HeaderAnimationTableView: UITableView,UITableViewDelegate {
    
    /// 保存上次的contentOffSetY值 , 用于判断滚动方向
    private var previousContentOffSetY:CGFloat!
    private var topViewHeight:CGFloat!
    private var originWidth:CGFloat! = 0
    private var originHeight:CGFloat! = 0
    
    /// 滚动到topView的最下部分时调用
    var reachbottomClosure:TableViewReachTopViewBottomClosure!
    
    /// 先设置settingInfo后再设置topView
    var settingInfo:SwipAnimationViewInfo = SwipAnimationViewInfo()
    
    var topView:UIView? {
        didSet {
            
            let view = UIView.init(frame: CGRect.init(x:0, y:0, width:self.frame.width, height:settingInfo.headerViewActualHeight))
            view.alpha = 0
            self.tableHeaderView = view
            
            originWidth = topView?.frame.width
            topView?.frame = CGRect.init(x:0, y:-settingInfo.headerViewHiddenHeight, width:originWidth, height:settingInfo.headerViewHiddenHeight * 2 + settingInfo.headerViewActualHeight)
            originHeight = topView?.frame.height
            
            self.insertSubview(topView!, at: 0)
            settingInfo.headerViewActualHeight = originHeight - settingInfo.headerViewHiddenHeight*2.0
        }
    }
    
    /**
     *  页面设置信息
     */
    struct SwipAnimationViewInfo {
        /// 上方headerView上下隐藏部分高度
        var headerViewHiddenHeight:CGFloat = 40
        
        /// 上方headerView的露出的实际显示高度
        var headerViewActualHeight:CGFloat = 60
        
        /// 上方headerView随滚动旋转的最大角度 (0 ~ 90度)(对应值为0 ~ 1)
        var headerViewRotateMaxRadious:Double = M_PI_2
        
        
        /// 上部页面跟随下部页面的动画方式
        var followAnimationType:TopViewAnimationType = .HoldAndStretch
        
        var stretchType:StretchType = .StretchSameRate
    }
    
    /**
     *  页面滑动时 , 上部画面的动画
     */
    enum TopViewAnimationType {
        /**
         *  页面滑动时 , 上部画面保持原位
         */
        case Hold
        /**
         *  页面滑动时 , 上部画面保持原位 , 并且到最顶部时有拉伸动画
         */
        case HoldAndStretch
        /**
         *  页面滑动时 , 上部画面的位移与下部页面一致 , 即页面同步
         */
        case Follow
        /**
         页面滑动时 , 上部画面的位移与下部页面一致 , 即页面同步 , 并到底后有拉伸
         */
        case FollowAndStretch
        /**
         页面滑动时，上部位移是底部的一半，呈现的折叠效果
         */
        case FollowAndFold
    }
    
    enum StretchType {
        /// 同比例缩放
        case StretchSameRate
        /// 方形缩放
        case StretchEqual
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError()
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: .plain)
        self.delegate = self
        self.clipsToBounds = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch settingInfo.followAnimationType {
        case .Follow : self.headerAnimationFollow(contentOffSetY: scrollView.contentOffset.y)
        case .Hold : self.headerAnimationHold(contentOffSetY: scrollView.contentOffset.y)
        case .HoldAndStretch : self.headerAnimationHoldAndStretch(contentOffSetY: scrollView.contentOffset.y)
        case .FollowAndStretch : self.headerAnimationFollowAndStretch(contentOffSetY: scrollView.contentOffset.y)
        case .FollowAndFold : self.headerAnimationFold(contentOffSetY: scrollView.contentOffset.y)
        }
        // 判断是否滚动到上方view的最下部
        if abs(scrollView.contentOffset.y - settingInfo.headerViewActualHeight) < 20 {
            if reachbottomClosure != nil {
                reachbottomClosure!(scrollView.contentOffset.y > previousContentOffSetY)
            }
        }
        previousContentOffSetY = scrollView.contentOffset.y
    }
    
    // 不同的animationType作不同的动画处理
    func headerAnimationFollow(contentOffSetY:CGFloat) {
        if contentOffSetY <= 0 && contentOffSetY >= -settingInfo.headerViewHiddenHeight * 2.0 {
            topView?.frame = CGRect.init(x:0, y:-settingInfo.headerViewHiddenHeight + contentOffSetY / 2.0, width:self.originWidth, height:self.originHeight)
            
        }
    }
    
    func headerAnimationFollowAndStretch(contentOffSetY:CGFloat) {
        self.headerAnimationFollow(contentOffSetY: contentOffSetY)
        if contentOffSetY <= -settingInfo.headerViewHiddenHeight * 2.0  {
            let actualOffSetY = -contentOffSetY - settingInfo.headerViewHiddenHeight * 2
            var actualOffSetX:CGFloat = 0
            if settingInfo.stretchType == .StretchEqual {
                actualOffSetX = 0
            } else {
                actualOffSetX = actualOffSetY * originWidth / originHeight
            }
            self.topView?.frame = CGRect.init(x:-actualOffSetX / 2.0, y:contentOffSetY, width:self.originWidth + actualOffSetX, height:self.originHeight + actualOffSetY)
        }
    }
    
    func headerAnimationHold(contentOffSetY:CGFloat) {
        if contentOffSetY < settingInfo.headerViewActualHeight && contentOffSetY > 0 {
            topView?.frame = CGRect.init(x:0, y:-settingInfo.headerViewHiddenHeight + contentOffSetY, width:topView!.frame.width, height:(topView?.frame.height)!)
        } else if contentOffSetY <= 0 && contentOffSetY >= -settingInfo.headerViewHiddenHeight * 2.0 {
            topView?.frame = CGRect.init(x:0, y:-settingInfo.headerViewHiddenHeight + contentOffSetY / 2.0, width:self.originWidth, height:self.originHeight)
        }
    }
    
    func headerAnimationFold(contentOffSetY:CGFloat) {
        if contentOffSetY < settingInfo.headerViewActualHeight && contentOffSetY > 0 {
            topView?.frame = CGRect.init(x:0, y:-settingInfo.headerViewHiddenHeight + contentOffSetY * 0.5, width:topView!.frame.width, height:(topView?.frame.height)!)
        } else if contentOffSetY <= 0 && contentOffSetY >= -settingInfo.headerViewHiddenHeight * 2.0 {
            topView?.frame = CGRect.init(x:0, y:-settingInfo.headerViewHiddenHeight + contentOffSetY / 2.0, width:self.originWidth, height:self.originHeight)
        }
    }
    
    func headerAnimationHoldAndStretch(contentOffSetY:CGFloat) {
        self.headerAnimationHold(contentOffSetY: contentOffSetY)
        if contentOffSetY <= -settingInfo.headerViewHiddenHeight * 2.0 {
            let actualOffSetY = -contentOffSetY - settingInfo.headerViewHiddenHeight * 2
            var actualOffSetX:CGFloat = 0
            if settingInfo.stretchType == .StretchEqual {
                actualOffSetX = 0
            } else {
                actualOffSetX = actualOffSetY * originWidth / originHeight
            }
            self.topView?.frame = CGRect.init(x:-actualOffSetX / 2.0, y:contentOffSetY, width:self.originWidth + actualOffSetX, height:self.originHeight + actualOffSetY)
        }
        
    }
}
