//
//  WatchCallOffSettingTableViewCell.swift
//  Where'sBaby
//
//  Created by shadowPriest on 15/10/25.
//  Copyright © 2015年 coolLH. All rights reserved.
//

import UIKit

class WatchCallOffSettingTableViewCell: UITableViewCell {

    @IBOutlet weak var stateButton: UIButton!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var stateClicked: ((Bool)->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func stateButtonClicked(sender: UIButton) {
        sender.selected = !sender.selected
        if let click = stateClicked{
            click(sender.selected)
        }
    }
}
