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
