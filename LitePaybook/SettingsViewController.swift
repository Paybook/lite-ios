//
//  SettingsViewController.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 18/05/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBAction func logOutButton(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "token")
        
        
        let indexViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("index") as! IndexViewController
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var data = [
            "token" : NSUserDefaults.standardUserDefaults().objectForKey("token")!
        ]
        
        getAccount(data, callback: {(response) in
                print("Get Account: \(response)")
            }, callback_error: {(error_code) in
                print("Error: \(error_code)")
        })
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
