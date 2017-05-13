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
        self.title = "AnimationHeader"
        mainTableView = HeaderAnimationTableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: self.view.frame.height), style: .plain)
        mainTableView.reachbottomClosure = reachBottom
        mainTableView.settingInfo.followAnimationType = .HoldAndStretch;
        mainTableView.settingInfo.headerViewActualHeight = 230;
        mainTableView.settingInfo.headerViewHiddenHeight = 44;
        mainTableView.tableFooterView = UIView.init()
        mainTableView.estimatedRowHeight = 100
        mainTableView.rowHeight = UITableViewAutomaticDimension
        let imageView = UIImageView.init(image: UIImage.init(named: "b"))
        imageView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 0)
        mainTableView.topView = imageView
        mainTableView.delegate = self
        mainTableView.dataSource = self
//        mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentify)
        mainTableView.register(UINib.init(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentify)
        self.view.addSubview(mainTableView)
        
    }

    // MARK: -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  30;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
        
//        cell.contentView.backgroundColor = UIColor.init(red:CGFloat(arc4random_uniform(255))/CGFloat(255.0), green:CGFloat( arc4random_uniform(255))/CGFloat(255.0), blue:CGFloat(arc4random_uniform(255))/CGFloat(255.0) , alpha: 1)
        return  cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.setContentView();
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  44
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        mainTableView.scrollViewDidScroll(mainTableView)
    }
    
    func reachBottom(isTop:Bool) {
        if isTop {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        } else {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    func setContentView() -> (UIView){
        let height:CGFloat = 44
        let eachWidth:CGFloat = SCREEN_WIDTH / 5.0
        let bgView = UIView.init(frame: CGRect.init(x:0, y:0, width:SCREEN_WIDTH, height:height))
        bgView.backgroundColor = UIColor.darkGray
        bgView.alpha = 0.7
        
        mainTableView.addSubview(bgView)
        
        let follow = UIButton.init(frame: CGRect.init(x:0, y:0, width:eachWidth, height:height))
        follow.setTitle("Follow", for: .normal)
        follow.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        follow.setTitleColor(UIColor.white, for: .normal)
        follow.setTitleColor(UIColor.orange, for: .selected)
        follow.addTarget(self, action: #selector(followAction), for: .touchUpInside)
        bgView.addSubview(follow)
        
        let followAndStretch = UIButton.init(frame: CGRect.init(x:eachWidth, y:0, width:eachWidth, height:height))
        followAndStretch.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        followAndStretch.setTitle("Follow&Stretch", for: .normal)
        followAndStretch.setTitleColor(UIColor.white, for: .normal)
        followAndStretch.setTitleColor(UIColor.orange, for: .selected)
        followAndStretch.addTarget(self, action: #selector(followAndStretchAction), for: .touchUpInside)
        bgView.addSubview(followAndStretch)
        
        let hold = UIButton.init(frame: CGRect.init(x:eachWidth * 2, y:0, width:eachWidth, height:height))
        hold.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        hold.setTitle("Hold", for: .normal)
        hold.setTitleColor(UIColor.white, for: .normal)
        hold.setTitleColor(UIColor.orange, for: .selected)
        hold.addTarget(self, action: #selector(holdAction), for: .touchUpInside)
        bgView.addSubview(hold)
        
        let holdAndStretch = UIButton.init(frame: CGRect.init(x:eachWidth * 3, y:0, width:eachWidth, height:height))
        holdAndStretch.setTitle("Hold&Stretch", for: .normal)
        holdAndStretch.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        holdAndStretch.setTitleColor(UIColor.white, for: .normal)
        holdAndStretch.setTitleColor(UIColor.orange, for: .selected)
        holdAndStretch.addTarget(self, action: #selector(holdAndStretchAction), for: .touchUpInside)
        selectBtn = holdAndStretch
        selectBtn.isSelected = true
        bgView.addSubview(holdAndStretch)
        
        let holdAndFold = UIButton.init(frame: CGRect.init(x:eachWidth * 4, y:0, width:eachWidth, height:height))
        holdAndFold.setTitle("Hold&Fold", for: .normal)
        holdAndFold.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        holdAndFold.setTitleColor(UIColor.white, for: .normal)
        holdAndFold.setTitleColor(UIColor.orange, for: .selected)
        holdAndFold.addTarget(self, action: #selector(holdAndFoldAction), for: .touchUpInside)
        bgView.addSubview(holdAndFold)
        
        return bgView
    }
    func followAction(btn:UIButton) {
        selectBtn.isSelected = false
        btn.isSelected = !btn.isSelected
        selectBtn = btn
        mainTableView.settingInfo.followAnimationType = .Follow
    }
    
    func followAndStretchAction(btn:UIButton) {
        selectBtn.isSelected = false
        btn.isSelected = !btn.isSelected
        selectBtn = btn
        mainTableView.settingInfo.stretchType = .StretchEqual
        mainTableView.settingInfo.followAnimationType = .FollowAndStretch
    }
    
    func holdAction(btn:UIButton) {
        selectBtn.isSelected = false
        btn.isSelected = !btn.isSelected
        selectBtn = btn
        mainTableView.settingInfo.followAnimationType = .Hold
    }
    
    func holdAndStretchAction(btn:UIButton) {
        selectBtn.isSelected = false
        btn.isSelected = !btn.isSelected
        selectBtn = btn
        mainTableView.settingInfo.stretchType = .StretchSameRate
        mainTableView.settingInfo.followAnimationType = .HoldAndStretch
    }
    func holdAndFoldAction(btn:UIButton) {
        selectBtn.isSelected = false
        btn.isSelected = !btn.isSelected
        selectBtn = btn
        mainTableView.settingInfo.stretchType = .StretchSameRate
        mainTableView.settingInfo.followAnimationType = .FollowAndFold
    }
}
