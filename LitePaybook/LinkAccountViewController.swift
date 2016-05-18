//
//  LinkAccountViewController.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 13/05/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit

class LinkAccountViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var banksData : [String] = ["Banorte", "Santander", "Banamex", "HSBC", "Banorte", "Santander", "Banamex", "HSBC"]
    var entitiesData : [String] = ["SAT"]
    var arrayb = NSArray()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func getBanks(response: [String:AnyObject])->Void{
        print("ARRAY\(response["response"])")
        let bankarray = response["response"] as! [[String: AnyObject]]
        
            arrayb = bankarray
            collectionView.reloadData()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("token:\(NSUserDefaults.standardUserDefaults().objectForKey("token")!)")
        
        let data = ["token": NSUserDefaults.standardUserDefaults().objectForKey("token")!]
        
        getOrganizations(data, callback: getBanks, callback_error: nil)
        
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayb.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("bankCell", forIndexPath: indexPath) as! BankCell
        //let bank = arrayb[indexPath.row]
        //print("avatar: \(bank.objectForKey("avatar"))")
        //cell.name.text = bank.objectForKey("name") as? String
        
        // Configure the cell
        return cell
    }
    
}
