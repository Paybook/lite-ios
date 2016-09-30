//
//  FilterViewController.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 19/09/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit
import Paybook

protocol Filter : class {
    func filterBy(dict : [String:AnyObject]?)
}

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var accountsArray : [Account] = []
    let staticCells = [[
        "id_account":"all"
        ]]
    
    weak var mDelegate: Filter?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func cancel(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch (section) {
        case 0 :
            return 1
        case 1 :
            return accountsArray.count
        default :
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("AccountCell", forIndexPath: indexPath) as? AccountTableViewCell
        
        if cell == nil {
            cell = AccountTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "AccountCell")
        }
        
        if indexPath.section == 0{
            cell!.accounLabel.text = "Despliega todas las transacciones"
            cell!.siteLabel.text = "Remueve todos los filtros"
            cell!.avatarImageView.image = UIImage(named: "account-avatar")
        }else{
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
            cell!.siteLabel.text = account.site.valueForKey("name") as? String
            
            
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            mDelegate?.filterBy(nil)
            self.navigationController?.popViewControllerAnimated(true)
        }else{
            let account : Account = accountsArray[indexPath.row]
            mDelegate?.filterBy(["id_account": account.id_account])
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Account.get(currentSession, id_user: nil, completionHandler: {
            accounts, error in
            if accounts != nil {
                if accounts!.count > 0 {
                    self.accountsArray = accounts!
                    self.tableView.reloadData()
                }else{
                    self.tableView.hidden = true
                }
            }else{
                self.tableView.hidden = true
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
