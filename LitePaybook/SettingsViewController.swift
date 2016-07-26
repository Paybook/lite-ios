//
//  SettingsViewController.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 18/05/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit
import Paybook

class SettingsViewController: UIViewController {
    
    
    
    @IBOutlet weak var switchEnviroment: UISwitch!
    
    
    @IBAction func logOutButton(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "token")
        
        
        //let indexViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("index") as! IndexViewController
        
    }
    
    
    
    
    func changeEnviroment(sender: UISwitch){
        /*
        if switchEnviroment.on {
            isTest = true
        } else {
            isTest = false
        }*/
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        if isTest{
            switchEnviroment.setOn(true, animated: false)
        }else{
            switchEnviroment.setOn(false, animated: false)
        }*/
        
        switchEnviroment.addTarget(self, action: #selector(changeEnviroment), forControlEvents: .ValueChanged)
        
        Catalogues.get_sites(currentSession, id_user: nil, id_site_organization: "5731fb37784806a6118b4568", is_test: nil){
                response, error in
            if response != nil{
                for site in response! {
                    print(site.name, site.credentials)
                }
            }else{
                
                print("Error Sites", error?.message)
            }
        }
        
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
