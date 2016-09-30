//
//  AccountDetailViewController.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 27/09/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit
import Paybook

class AccountDetailViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    var accountsArray : [Account] = []
    var site : AnyObject!
    weak var mDelegate: LinkAccounts?
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func cancel(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func deleteSite(sender: AnyObject) {
        /*
        print("Delete credntial: \(accountsArray[0].id_credential)")
        
        Account.get(currentSession, id_user: nil, options: ["id_credential": "57ec4ac10c212a85048b487c"] ,completionHandler: {
            accounts, error in
            if accounts != nil{
                for acc in accounts!{
                    print(acc.name, acc.id_credential)
                }
            }
            
        })
        
        Credentials.get(currentSession, id_user: nil, completionHandler: {
            response , error in
            print(response)
            
            Credentials.delete(currentSession, id_user: nil, id_credential: self.accountsArray[0].id_credential, completionHandler: {
                response , error  in
                print("Response Delete", response)
                if (response != nil) {
                    
                    
                    Credentials.get(currentSession, id_user: nil, completionHandler: {
                        response , error in
                        for i in response!{
                            print(i.id_credential)
                            
                        }
                        
                    })
                   // self.mDelegate?.updateAccounts()
                    //self.navigationController?.popViewControllerAnimated(true)
                }else{
                    print(error)
                }
            })
        })
        */
        
        
    }
    // *** MARK TableVie Protocols
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0 :
            return accountsArray.count
        case 1 :
            return 1
        default :
            return 0
        }
       
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0{
            let account = accountsArray[indexPath.row]
            
            let nextWindow = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("transactionsViewController") as! TransactionsViewController
            let navigationController = UINavigationController(rootViewController: nextWindow)
            nextWindow.navigationController?.setNavigationBarHidden(true, animated: false)
            
            nextWindow.filtered = ["id_account":account.id_account]
            self.revealViewController().pushFrontViewController(navigationController, animated: true)
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            var cell = tableView.dequeueReusableCellWithIdentifier("AccountCell", forIndexPath: indexPath) as? AccountTableViewCell
            
            if cell == nil {
                cell = AccountTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "AccountCell")
            }
            
            
            let account = accountsArray[indexPath.row]
            
            
            if let avatarImage =  account.site.valueForKey("avatar") as? String{
                let url = NSURL(string: url_images + avatarImage)
                if let image = url!.cachedImage {
                    // Cached: set immediately.
                    cell!.avatarImageView.image = image
                } else {
                    // Not cached, so load then fade it in.
                    url!.fetchImage { image in
                        // Check the cell hasn't recycled while loading.
                        cell!.avatarImageView.image = image
                        
                    }
                }
            }
            
            cell!.accounLabel.text = account.name
            cell!.siteLabel.text = "Balance: $ \(account.balance)"
            
            return cell!
        
        
        }else{
             let cell = tableView.dequeueReusableCellWithIdentifier("DeleteCell", forIndexPath: indexPath)
            
            return cell
        }
        
        
    }
    
    func UITableView_Auto_Height()
    {
        if(self.tableView.contentSize.height < self.tableView.frame.height){
            var frame: CGRect = self.tableView.frame;
            frame.size.height = self.tableView.contentSize.height;
            self.tableView.frame = frame;
        }
    }
    // MARK TableVie Protocols ***
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if accountsArray.count > 0{
            site = accountsArray[0].site
            if let avatarImage =  accountsArray[0].site.valueForKey("small_cover") as? String{
                let url = NSURL(string: url_images + avatarImage)
                if let image = url!.cachedImage {
                    // Cached: set immediately.
                   self.avatarImageView.image = image
                } else {
                    // Not cached, so load then fade it in.
                    url!.fetchImage { image in
                        // Check the cell hasn't recycled while loading.
                        self.avatarImageView.image = image
                        
                    }
                }
            }
            
        }
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        UITableView_Auto_Height();
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
