//
//  TransactionsViewController.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 20/07/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit
import Paybook


class TransactionsViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    var transactions = [Transaction]()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellTransaction", forIndexPath: indexPath)
        
        let transaction = transactions[indexPath.row]
        cell.textLabel?.text = "$\(transaction.amount)   \(transaction.description)"
        
        return cell
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
