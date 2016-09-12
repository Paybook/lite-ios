//
//  AccountViewController.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 31/08/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit
import Paybook


class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var accountsArray : [Account] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topBar: UIView!
    
    @IBAction func openMenu(sender: AnyObject) {
        revealViewController().rightRevealToggleAnimated(true)
    }
    
    
    @IBAction func newAccount(sender: AnyObject) {
        if isTest {
            let nextWindow = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("selectSiteViewController") as! SelectSiteViewController
            
            self.navigationController?.pushViewController(nextWindow, animated: true)
        }else{
            let nextWindow = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("accountStep1ViewController") as! AccountStep1ViewController
            
            self.navigationController?.pushViewController(nextWindow, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return accountsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
        cell!.siteLabel.text = account.site.valueForKey("name") as? String
        
        cell!.balanceLabel.text = "$ \(account.balance)"
        
        return cell!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil{
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
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
        
        let topColor  = UIColor(colorLiteralRed: (216/255.0), green: (57/255.0), blue: (72/255.0), alpha: 1.0)
        let bottomColor  = UIColor(colorLiteralRed: (78/255.0), green: (51/255.0), blue: (90/255.0), alpha: 1.0)
        
        
        let gradientColors : [CGColor] = [topColor.CGColor,bottomColor.CGColor]
        
        let gradientLocations = [0.0, 1.0]
        let gradientLayer : CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        gradientLayer.frame = self.topBar.bounds
        
        self.topBar.layer.insertSublayer(gradientLayer, atIndex: 0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
