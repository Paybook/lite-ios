//
//  AccountStep1ViewController.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 01/09/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit
import Paybook


class AccountStep1ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate {

    
    
    @IBOutlet weak var tableView: UITableView!
    var site_organizations : [Site_organization] = []
    var searchActive : Bool = false
    var filtered:[Site_organization] = []
    
    @IBAction func cancel(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func close(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Catalogues.get_site_organizations(currentSession, id_user: nil, completionHandler: {
            catalogue, error in
            if catalogue != nil{
 
                self.site_organizations = catalogue!
                self.tableView.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = site_organizations.filter { organization in
            return organization.name.lowercaseString.containsString(searchText.lowercaseString)
            //return currency.name!.lowercaseString.containsString(searchText.lowercaseString)
        }

        
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    

    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return site_organizations.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let nextWindow = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SelectSiteViewController2") as! SelectSiteViewController
        
        nextWindow.organization = site_organizations[indexPath.row]
        self.navigationController?.pushViewController(nextWindow, animated: true)
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OrganizationCell", forIndexPath: indexPath) as? SiteOrganizationTableViewCell
        
        let organization = site_organizations[indexPath.row]
        
        if let coverImage =  organization.small_cover{
            let url = NSURL(string: url_images + coverImage)
            // For recycled cells' late image loads.
            if let image = url!.cachedImage {
                // Cached: set immediately.
                cell?.coverImageView!.image = image
                
            } else {
                // Not cached, so load then fade it in.
                url!.fetchImage { image in
                    // Check the cell hasn't recycled while loading.
                    cell!.coverImageView!.image = image
                }
            }
        }


        // Configure the cell...

        return cell!
    }
    
}
