//
//  TableViewCell.swift
//  TableViewHeaderAnimation
//
//  Created by xuelin on 2017/5/13.
//  Copyright © 2017年 as_one. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var ImgView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.ImgView.image = UIImage.init(named: "b");
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        self.ImgView.image = UIImage.init(named: "phil");
    }
    
}
