//
//  IndexViewController.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 12/05/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit
import Paybook


class IndexViewController: UIViewController {
    
    
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Paybook.api_key = api_key
        
        if NSUserDefaults.standardUserDefaults().objectForKey("token") != nil {
            let dashboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("tabDashboard") as! UITabBarController
            self.presentViewController(dashboard, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        logInButton.layer.borderColor = UIColor(colorLiteralRed: 19/250, green: 160/250, blue: 213/250, alpha: 1.0).CGColor
        logInButton.layer.borderWidth = 1.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
