//
//  TransactionsViewController.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 20/07/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit
import Paybook


class TransactionsViewController: UIViewController, UITableViewDataSource , UITableViewDelegate, UISearchBarDelegate, SWRevealViewControllerDelegate, Filter{

    var transactions = [Transaction]()
    var transactionsFiltered = [Transaction]()
    let searchController = UISearchController(searchResultsController: nil)
    
    var filtered : [String:AnyObject]!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var shadowMask: UIView!
    
    
    @IBAction func filterTransactions(sender: AnyObject) {
        let filterViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("filterViewController") as? FilterViewController
        filterViewController?.mDelegate = self
        
        self.navigationController?.pushViewController(filterViewController!, animated: true)
    }
    
    @IBAction func openMenu(sender: AnyObject) {
        revealViewController().rightRevealToggleAnimated(true)
    }
    
    
    
    // *** MARK TableView protocols
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return transactionsFiltered.count
        }
        return transactions.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CellTransaction", forIndexPath: indexPath) as? TransactionTableViewCell
        
        if cell == nil {
            cell = TransactionTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CellTransaction")
        }

        let transaction : Transaction!
        
        if searchController.active && searchController.searchBar.text != "" {
            transaction = transactionsFiltered[indexPath.row]
        } else {
            transaction = transactions[indexPath.row]
        }
        
        
        
        cell!.amountLabel.text = "$\(transaction.amount)"
        cell!.descriptionLabel.text = transaction.description
        
        
        let date = NSDate(timeIntervalSince1970: Double(transaction.dt_transaction!))
        let calendar = NSCalendar.currentCalendar()
        let dateFormatter = NSDateFormatter()
        let components = calendar.components([.Month, .Day], fromDate: date)
        
        let months = dateFormatter.shortMonthSymbols
        let monthSymbol = months[components.month-1]
        
        
        cell!.mounthLabel.text = monthSymbol
        cell!.dayLabel.text = "\(components.day)"
        
        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // MARK TableView protocols ***
    
    
    
    // *** MARK SWRevealViewController protocol
    
    func revealController(revealController: SWRevealViewController!, willMoveToPosition position: FrontViewPosition) {
        
        if(revealController.frontViewPosition == FrontViewPosition.Left) {
            self.shadowMask.hidden = false
        } else {
            self.shadowMask.hidden = true
            
        }
    }
    
    // MARK SWRevealViewController protocol ***
    
    
    
    // *** MARK Search bar
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        transactionsFiltered = transactions.filter { transaction in
            return ("\(transaction.description) \(transaction.amount)").lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    
    // MARK Search bar ***
    
    
    
    // *** MARK Filter protocol
    
    func filterBy(dict: [String : AnyObject]?) {
        
        if dict != nil {
            Transaction.get(currentSession, id_user: nil, options: dict!, completionHandler: {
                response , error in
                
                if response != nil {
                    self.transactions = response!
                    self.tableView.reloadData()
                }
            })
        }else{
            Transaction.get(currentSession, id_user: nil, options: ["order" : "dt_refresh"], completionHandler: {
                response , error in
                
                if response != nil {
                    self.transactions = response!
                    self.tableView.reloadData()
                }
            })
        }
        
        
        
    }
    
    // MARK Filter protocol ***
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil{
            self.revealViewController().delegate = self
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        if filtered != nil {
            Transaction.get(currentSession, id_user: nil, options: filtered, completionHandler: {
                response , error in
                
                if response != nil {
                    self.transactions = response!
                    self.tableView.reloadData()
                }
            })
        }else{
            Transaction.get(currentSession, id_user: nil){
                response , error in
                
                if response != nil {
                    self.transactions = response!
                    self.tableView.reloadData()
                }
                
            }
        }
        
        
        
        let topColor  = UIColor(colorLiteralRed: (216/255.0), green: (57/255.0), blue: (72/255.0), alpha: 1.0)
        let bottomColor  = UIColor(colorLiteralRed: (78/255.0), green: (51/255.0), blue: (90/255.0), alpha: 1.0)
        
        
        let gradientColors : [CGColor] = [topColor.CGColor,bottomColor.CGColor]
        
        let gradientLocations = [0.0, 1.0]
        let gradientLayer : CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        gradientLayer.frame = self.topBar.bounds
        
        self.topBar.layer.insertSublayer(gradientLayer, atIndex: 0)
        
        // Searchbar Settings
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        searchController.searchBar.searchBarStyle = .Minimal
        searchController.searchBar.tintColor = UIColor(colorLiteralRed: (78/255.0), green: (51/255.0), blue: (90/255.0), alpha: 1.0)
        tableView.tableHeaderView = searchController.searchBar
        tableView.tableHeaderView?.backgroundColor = UIColor(colorLiteralRed: (247/255.0), green: (247/255.0), blue: (247/255.0), alpha: 1.0)
        
        //tableView.tableHeaderView?.backgroundColor = paybookStyle.UIColorFromGallery("blackGray")
        //tableView.tableHeaderView?.tintColor = UIColor.whiteColor()
        //tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    

}


extension TransactionsViewController: UISearchResultsUpdating{
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
