//
//  RightMenuTableViewController.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 05/09/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit

class RightMenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    @IBOutlet weak var accountTab: UIView!
    @IBOutlet weak var transactionsTab: UIView!
    @IBOutlet weak var settingTab: UIView!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var transactionLabel: UILabel!
    @IBOutlet weak var settingLabel: UILabel!
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 4 {
            print("Logout")/*
            let indexViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("index") as! IndexViewController
            
            self.presentViewController(indexViewController, animated: true, completion: nil)*/
            currentSession = nil
            isTest = false
            
            let nextWindow = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("indexView") as! IndexViewController
            let navigationController = UINavigationController(rootViewController: nextWindow)
            nextWindow.navigationController?.setNavigationBarHidden(true, animated: false)
            self.presentViewController(navigationController, animated: true, completion: nil)
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier != nil{
            print(segue.identifier)
            switch segue.identifier! {
            case "Accounts" :
                accountTab.hidden = false
                transactionsTab.hidden = true
                settingTab.hidden = true
                break
            case "Transactions" :
                accountTab.hidden = true
                transactionsTab.hidden = false
                settingTab.hidden = true
                break
            case "Settings" :
                accountTab.hidden = true
                transactionsTab.hidden = true
                settingTab.hidden = false
                break
            default :
                break
            }
        }
        
    }

}
