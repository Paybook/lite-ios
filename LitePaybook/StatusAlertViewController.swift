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
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UITextView!
    @IBOutlet weak var succesButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    
    
    
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
            statusColorTopView.backgroundColor = UIColor.greenColor()
            succesButton.setTitle("TERMINAR", forState: .Normal)
            iconImage.image = UIImage(named: "ok-icon")
        }else{
            statusColorTopView.backgroundColor = UIColor.redColor()
            iconImage.image = UIImage(named: "error-icon")
        }
        titleLabel.text = status["title"] as? String
        descLabel.text = status["desc"] as? String
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
