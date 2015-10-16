//
//  ContactsTableViewCell.swift
//  Where'sBaby
//
//  Created by 刘向宏 on 15/10/16.
//  Copyright © 2015年 coolLH. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {

    @IBOutlet weak var headImageView : UIImageView!
    @IBOutlet weak var mobelLabel : UILabel!
    @IBOutlet weak var shortLabel : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
