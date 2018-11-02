//
//  AnimationViewController.swift
//  TableViewHeaderAnimation
//
//  Created by xuelin on 2017/5/13.
//  Copyright © 2017年 as_one. All rights reserved.
//

import UIKit

let cellIdentify = "cellIdentify"
let SCREEN_WIDTH = UIScreen.main.bounds.width;
let SCREEN_HEIGHT = UIScreen.main.bounds.height;

class AnimationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    private var mainTableView:HeaderAnimationTableView!
    
    private var selectBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white;
        self.title = "FollowAndFold"
        let topHeight = (self.navigationController?.navigationBar.frame.size.height)! + UIApplication.shared.statusBarFrame.size.height
        mainTableView = HeaderAnimationTableView.init(frame: CGRect.init(x: 0, y: topHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - topHeight), style: .plain)
        self.view.addSubview(mainTableView)
        mainTableView.settingInfo.followAnimationType = .FollowAndFold;
        if #available(iOS 11.0, *) {
            mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false;
        }
        mainTableView.settingInfo.headerViewActualHeight = 200;
        mainTableView.tableFooterView = UIView.init()
        mainTableView.estimatedRowHeight = 100
        mainTableView.rowHeight = UITableViewAutomaticDimension
        let imageView = UIImageView.init(image: UIImage.init(named: "b"))
        imageView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 200)
        mainTableView.topView = imageView
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(UINib.init(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentify)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Action", style: UIBarButtonItemStyle.plain, target: self, action: #selector(action))
    }

    func action() {
         let alertVc = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        // 下拉跟随
        let followAction = UIAlertAction.init(title: "Follow", style: .default) { (UIAlertAction) in
            self.followAction();
        }
        alertVc.addAction(followAction)
        // 下拉跟随并缩放Header
        let followAndStretchAction = UIAlertAction.init(title: "FollowAndStretch", style: .default) { (UIAlertAction) in
            self.followAndStretchAction();
        }
        alertVc.addAction(followAndStretchAction)
        // Header固定
        let holdAction = UIAlertAction.init(title: "Hold", style: .default) { (UIAlertAction) in
            self.holdAction();
        }
        alertVc.addAction(holdAction)
        // 上拉固定下拉放大
        let holdAndStretchAction = UIAlertAction.init(title: "HoldAndStretchAction", style: .default) { (UIAlertAction) in
            self.holdAndStretchAction();
        }
        alertVc.addAction(holdAndStretchAction)
        
        // 同时滚动但有折叠效果
        let holdAndFoldAction = UIAlertAction.init(title: "HoldAndFold", style: .default) { (UIAlertAction) in
            self.followAndFoldAction();
        }
        alertVc.addAction(holdAndFoldAction)
        
        let cancelAction = UIAlertAction.init(title: "Celcel", style: .cancel) { (UIAlertAction) in
            NSLog("Cancel", "")
        }
        alertVc.addAction(cancelAction)
        self.present(alertVc, animated: true, completion: nil)
    }
    
    // MARK: -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  30;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
        return  cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        mainTableView.scrollViewDidScroll(mainTableView)
    }

    func followAction (){
        mainTableView.settingInfo.followAnimationType = .Follow
        self.title = "Follow"
    }
    
    func followAndStretchAction (){
        mainTableView.settingInfo.stretchType = .StretchEqual
        mainTableView.settingInfo.followAnimationType = .FollowAndStretch
        self.title = "FollowAndStretch"
    }
    
    func holdAction() {
        mainTableView.settingInfo.followAnimationType = .Hold
        self.title = "Hold"
    }
    
    func holdAndStretchAction() {
        mainTableView.settingInfo.stretchType = .StretchSameRate
        mainTableView.settingInfo.followAnimationType = .HoldAndStretch
        self.title = "HoldAndStretch"
    }
    func followAndFoldAction() {
        mainTableView.settingInfo.stretchType = .StretchSameRate
        mainTableView.settingInfo.followAnimationType = .FollowAndFold
        self.title = "FollowAndFold"
    }
}
