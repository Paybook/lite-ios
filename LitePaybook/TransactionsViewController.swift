//
//  TransactionsViewController.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 20/07/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit
import Paybook


class TransactionsViewController: UIViewController, UITableViewDataSource , UITableViewDelegate {

    var transactions = [Transaction]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topBar: UIView!
    
    @IBAction func openMenu(sender: AnyObject) {
        revealViewController().rightRevealToggleAnimated(true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CellTransaction", forIndexPath: indexPath) as? TransactionTableViewCell
        
        if cell == nil {
            cell = TransactionTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CellTransaction")
        }

        
        let transaction = transactions[indexPath.row]
        
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil{
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        Transaction.get(currentSession, id_user: nil){
            response , error in
            
            if response != nil {
                self.transactions = response!
                self.tableView.reloadData()
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
