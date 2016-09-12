//
//  TransactionTableViewCell.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 26/08/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var mounthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
