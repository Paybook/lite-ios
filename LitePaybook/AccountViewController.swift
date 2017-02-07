//
//  AccountViewController.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 31/08/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit
import Paybook


class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SWRevealViewControllerDelegate, LinkAccounts {

    var sitesArray : [Site_organization] = []
    var accountsArray : [Account] = []
    var credentialsArray : NSArray = []
    var credentialsDict : [String : [Account]] = [:]
    var editingTable = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var shadowMask: UIView!
    @IBOutlet weak var editButton: UIButton!
    
    
    @IBAction func openMenu(sender: AnyObject) {
        revealViewController().rightRevealToggleAnimated(true)
    }
    
    @IBAction func editTableView(sender: AnyObject) {
        
        
        if(self.editing == true)
        {
            self.setEditing(false, animated: true)
            self.tableView.editing = false
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        else
        {
            self.setEditing(true, animated: true)
            //self.tableView.editing = true
            self.view.removeGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        
    }
    
    @IBAction func newAccount(sender: AnyObject) {
        if isTest {
            let nextWindow = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SelectSiteViewController2") as! SelectSiteViewController
            
            self.navigationController?.pushViewController(nextWindow, animated: true)
        }else{
            let nextWindow = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("accountStep1ViewController") as! AccountStep1ViewController
            
            self.navigationController?.pushViewController(nextWindow, animated: true)
        }
    }
    
    
    // *** MARK TableView
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        
        let credential = credentialsArray[indexPath.row]
        
        let nextWindow = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("accountDetailViewController") as! AccountDetailViewController
        nextWindow.credential = credential as! Credentials
        //nextWindow.site = credential as! Credentials
        nextWindow.mDelegate = self
        self.navigationController?.pushViewController(nextWindow, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return credentialsArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("AccountCell", forIndexPath: indexPath) as? AccountTableViewCell
        
        if cell == nil {
            cell = AccountTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "AccountCell")
        }
        /*
        let key = credentialsArray[indexPath.row] as! String
        let account = credentialsDict[key]![0]
       */
        
        let account = credentialsArray[indexPath.row] as? Credentials
        
        var found = false
        for site in sitesArray {
            if site.id_site_organization == account?.id_site_organization{
                cell!.accounLabel.text = site.name
                found = true
                if let avatarImage = site.avatar {
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
              
            }
        }
        
        
        if !found {
            cell!.accounLabel.text = "Acme Bank"
            cell!.avatarImageView.image = UIImage(named: "acme-avatar-red")
            
        }
        
        
        cell!.siteLabel.text = account?.username
 
        
        //cell!.balanceLabel.text = "$ \(account.balance)"
        
        return cell!
    }
    //  MARK TableView ***
  
    // *** MARK SWRevealViewController protocol
    
    func revealController(revealController: SWRevealViewController!, willMoveToPosition position: FrontViewPosition) {
        
        if(revealController.frontViewPosition == FrontViewPosition.Left) {
            self.shadowMask.hidden = false
        } else {
            self.shadowMask.hidden = true
            
        }
    }
    
    // MARK SWRevealViewController protocol ***
    
    // *** MARK LinkAccounts protocol
    
    func updateAccounts() {
        print("Update protocols")
        
        /*
        Account.get(currentSession, id_user: nil, completionHandler: {
            accounts, error in
            if accounts != nil {
                if accounts!.count > 0 {
                    
                    let result = accounts!.categorise({$0.id_credential})
                    
                    print(result)
                    self.credentialsDict = result
                    self.credentialsArray = Array(result.keys)
                    self.accountsArray = accounts!
                    self.tableView.reloadData()
                }else{
                    self.tableView.hidden = true
                }
            }else{
                self.tableView.hidden = true
            }
        })
        */
        Credentials.get(currentSession, id_user: nil, completionHandler: {
            credentials, error in
            if credentials != nil{
                self.credentialsArray = credentials!
                self.tableView.reloadData()
            }
            
        })

    }
    
    
    
    func showEditing(sender: UIBarButtonItem)
    {
        if(self.tableView.editing == true)
        {
            self.tableView.editing = false
            self.navigationItem.rightBarButtonItem?.title = "Done"
        }
        else
        {
            self.tableView.editing = true
            self.navigationItem.rightBarButtonItem?.title = "Edit"
        }
    }
    // MARK LinkAccounts protocol ***
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil{
            self.revealViewController().delegate = self
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        /*
        
        Account.get(currentSession, id_user: nil, completionHandler: {
            accounts, error in
            if accounts != nil {
                if accounts!.count > 0 {
                    
                    let result = accounts!.categorise({$0.id_credential})
                    for i in accounts!{
                        print("Cred:",i.id_credential)
                    }
                    
                    
                    self.credentialsDict = result
                    self.credentialsArray = Array(result.keys)
                    self.accountsArray = accounts!
                    self.tableView.reloadData()
                }else{
                    self.tableView.hidden = true
                }
            }else{
                self.tableView.hidden = true
            }
        })
        */
 
        Catalogues.get_site_organizations(currentSession, id_user: nil, completionHandler: {
            sites, error in
            if sites != nil{
                self.sitesArray = sites!
                Credentials.get(currentSession, id_user: nil, completionHandler: {
                    credentials, error in
                    if credentials != nil{
                        self.credentialsArray = credentials!
                        self.tableView.reloadData()
                    }
                    
                })
            }else{
                print(error?.message)
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

public extension SequenceType {
    
    /// Categorises elements of self into a dictionary, with the keys given by keyFunc
    
    func categorise<U : Hashable>(@noescape keyFunc: Generator.Element -> U) -> [U:[Generator.Element]] {
        var dict: [U:[Generator.Element]] = [:]
        for el in self {
            let key = keyFunc(el)
            if case nil = dict[key]?.append(el) { dict[key] = [el] }
        }
        return dict
    }
}
