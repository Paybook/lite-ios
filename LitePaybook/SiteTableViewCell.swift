//
//  SiteTableViewCell.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 02/09/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit

class SiteTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
