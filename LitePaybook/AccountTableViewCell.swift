//
//  AccountTableViewCell.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 31/08/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit

class AccountTableViewCell: UITableViewCell {

    @IBOutlet weak var accounLabel: UILabel!
    @IBOutlet weak var siteLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var balanceLabel: UILabel!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}