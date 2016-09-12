//
//  TransactionMO.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 26/08/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import Foundation
import CoreData
import Paybook


@objc(TransactionMO)
class TransactionMO: NSManagedObject {

    convenience init(transaction : Transaction){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("Transaction", inManagedObjectContext: managedContext)!
    
        
        self.init(entity: entity, insertIntoManagedObjectContext: managedContext)
        self.amount = transaction.amount
        self.desc = transaction.description
        self.id_account = transaction.id_account
        self.id_account_type = transaction.id_account_type
        self.id_external = transaction.id_external
        self.id_site = transaction.id_site
        self.id_site_organization = transaction.id_site_organization
        self.id_site_organization_type = transaction.id_site_organization_type
        self.id_transaction = transaction.id_transaction
        self.id_user = transaction.id_user
        self.is_disable = transaction.is_disable
        
        if let dtrefresh = transaction.dt_refresh{
            self.dt_refresh = Int32(dtrefresh)
        }else{
            self.dt_refresh = 0
        }
        
        if let dttransaction = transaction.dt_transaction{
            self.dt_transaction = Int32(dttransaction)
        }else{
            self.dt_transaction = 0
        }
        
        do {
            try managedContext.save()
        }catch{
            print(error)
        }
    }
    
    /*
    func chargeTransactions (transactions: NSArray){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("Transaction", inManagedObjectContext: managedContext)!
        
        
        transactions.enumerateObjectsWithOptions(NSEnumerationOptions(), usingBlock: { (item, idx, stop) -> Void in
            TransactionMO(transaction: item as! Transaction)
            
        })
        
        
    }
    
    */
    
    

}
