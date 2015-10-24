//
//  WatchSettingTableViewCell.swift
//  Where'sBaby
//
//  Created by shadowPriest on 15/10/24.
//  Copyright © 2015年 coolLH. All rights reserved.
//

import UIKit

class WatchSettingTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var selectedButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
