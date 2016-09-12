//
//  StatusAlertViewController.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 26/05/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit

class StatusAlertViewController: UIViewController {
    
    var status = [String:AnyObject?]()
    
    
    @IBOutlet weak var statusColorTopView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UITextView!
    @IBOutlet weak var succesButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var iconLabel: UILabel!
    
    @IBAction func addOtherAccount(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    @IBAction func continueFunction(sender: AnyObject) {
        if status["success"] as! Bool {
            self.navigationController?.popToRootViewControllerAnimated(true)
        }else{
            self.navigationController?.popViewControllerAnimated(false)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if status["success"] as! Bool {
            statusColorTopView.backgroundColor = UIColor(colorLiteralRed: (22/255.0), green: (192/255.0), blue: (79/255.0), alpha: 1.0)
            succesButton.setTitle("TERMINAR", forState: .Normal)
            iconLabel.text = ""
            iconLabel.textColor =  UIColor(colorLiteralRed: (22/255.0), green: (192/255.0), blue: (79/255.0), alpha: 1.0)
        }else{
            statusColorTopView.backgroundColor = UIColor(colorLiteralRed: (216/255.0), green: (58/255.0), blue: (72/255.0), alpha: 1.0)
            iconLabel.text = ""
            iconLabel.textColor = UIColor(colorLiteralRed: (216/255.0), green: (58/255.0), blue: (72/255.0), alpha: 1.0)
        }
        titleLabel.text = status["title"] as? String
        descLabel.text = status["desc"] as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
