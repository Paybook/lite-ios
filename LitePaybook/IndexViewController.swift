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
        
        
        if currentSession != nil{
            
            let dashboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("tabDashboard") as! UITabBarController
            self.presentViewController(dashboard, animated: true, completion: nil)
            
            currentSession.validate(){
                response, error in
                if response != nil && response == true {
                    print("Session validated")
                }else{
                    print("Session expired")
                    NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "token")
                    currentSession = nil
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let vc = storyboard.instantiateViewControllerWithIdentifier("indexViewController") as! IndexViewController
                    self.presentViewController(vc, animated: true, completion: nil)
                }
            }
        }
        

        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        logInButton.layer.borderColor = UIColor.whiteColor().CGColor
        logInButton.layer.borderWidth = 1.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
