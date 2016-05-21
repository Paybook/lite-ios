//
//  LinkAccountViewController.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 13/05/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit

class LinkAccountViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var banksData = [[String: AnyObject]]()
    var entitiesData = [[String: AnyObject]]()
    var sitesData = [[String: AnyObject]]()
    var arrayb = NSArray()
    var currentType = "banks"    //("banks"/"entities"/"sites")
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func changeServices(sender: AnyObject) {
        currentType = "entities"
        collectionView.reloadData()
    }
    
    @IBAction func changeBanks(sender: AnyObject) {
        currentType = "banks"
        collectionView.reloadData()
    }
    
    func getBanks(response: [String:AnyObject])->Void{
        print("ARRAY\(response["response"])")
        let bankarray = response["response"] as! [[String: AnyObject]]
        
            arrayb = bankarray
            collectionView.reloadData()
        
        
    }
    
    func sortOrganizations(response: [String:AnyObject])->Void{
        // Cast response to Array
        let bankarray = response["response"] as! [[String: AnyObject]]
        
        for item in bankarray{
            
            switch item["id_site_organization_type"] as! String{
            case "56cf4f5b784806cf028b4568" :
                banksData.append(item)
                break
            case "56cf4f5b784806cf028b4569" :
                entitiesData.append(item)
                break
            default :
                break
                
            }
        }
        arrayb = bankarray
        collectionView.reloadData()
        
        
    }
    
    func callback_error(code: Int){
        switch code{
        case 401:
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "token")
            let indexViewController = self.storyboard!.instantiateViewControllerWithIdentifier("index")
            UIApplication.sharedApplication().keyWindow?.rootViewController = indexViewController
            break
        default :
            break
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("token:\(NSUserDefaults.standardUserDefaults().objectForKey("token")!)")
        
        let data = ["token": NSUserDefaults.standardUserDefaults().objectForKey("token")!]
        
        getOrganizations(data, callback: sortOrganizations, callback_error: callback_error)
        
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        var numberOfRows = 0
        
        switch currentType {
        case "banks":
            numberOfRows = banksData.count
            break
        case "entities":
            numberOfRows = entitiesData.count
            break
        case "sites":
            numberOfRows = sitesData.count
            break
        default:
            break
        }
        return numberOfRows
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("bankCell", forIndexPath: indexPath) as! BankCell
        
        
        var bank = [String:AnyObject]()
        
        switch currentType {
            case "banks":
                bank = banksData[indexPath.row]
                break
            case "entities":
                bank = entitiesData[indexPath.row]
                break
            case "sites":
                bank = sitesData[indexPath.row]
                cell.nameLabel.text = bank["name"] as? String
                break
            default:
                break
        }
        
        if let avatarImage =  bank["avatar"] as? String{
            let url = NSURL(string: url_images + avatarImage)
        
            url!.fetchImage { image in
                // Check the cell hasn't recycled while loading.
                cell.bankImageView!.image = image
               
            }
/*
            
            // Image loading.
            cell.imageUrl = url  // For recycled cells' late image loads.
            if let image = url!.cachedImage {
                // Cached: set immediately.
                cell.bankImageView!.image = image
                cell.bankImageView!.alpha = 1
            } else {
                // Not cached, so load then fade it in.
                cell.bankImageView!.alpha = 0
                url!.fetchImage { image in
                    // Check the cell hasn't recycled while loading.
                    if cell.imageUrl == url {
                        cell.bankImageView!.image = image
                        UIView.animateWithDuration(0.3) {
                            cell.bankImageView!.alpha = 1
                        }
                    }
                }
            }*/
            
        }else{
           
            
        }
        
        
        // Configure the cell
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if currentType == "banks"{
            let bank = banksData[indexPath.row]
            
            if let sites = bank["sites"] as? NSArray {
                //check if have two o more diferent types account
                if sites.count > 1{
                    //Display types accounts
                    sitesData = sites as! [[String : AnyObject]]
                    currentType = "sites"
                    collectionView.reloadData()
                }else{
                    //open credentials view
                    print(bank["name"]!)
                    let nextStep = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("credentialsViewController") as! CredentialsViewController
                    
                    nextStep.bank = bank//["sites"] as? [String:AnyObject?]
                    
                    self.navigationController?.pushViewController(nextStep, animated: true)
                    print("opened")
                }
                
            }
        }else{
            //bank = entitiesData[indexPath.row]
        }
    }
    
}
