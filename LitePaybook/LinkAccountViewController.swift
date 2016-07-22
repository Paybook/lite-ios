//
//  LinkAccountViewController.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 13/05/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit
import Paybook


class LinkAccountViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    /*
    var banksData = [[String: AnyObject]]()
    var entitiesData = [[String: AnyObject]]()
    var sitesData = [[String: AnyObject]]()
    var bankSelected = [String: AnyObject]()*/
    
    
    var banksData = [Site_organization]()
    var entitiesData = [Site_organization]()
    var sitesData = [Site]()
    var bankSelected : Site_organization!
    
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
  
    /*
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
        
        collectionView.reloadData()
        
        
    }*/
    
    
    
    func sortOrganizations(organizations: [Site_organization])->Void{
        
        for item in organizations{
            
            switch item.id_site_organization_type{
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
        
        //getOrganizations(data, callback: sortOrganizations, callback_error: callback_error)
        Catalogues.get_site_organizations(currentSession, id_user: nil){
            response, error in
            if response != nil{
                
                
                
            }
        }
        
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
        
        
        var bank : Site_organization
        
        switch currentType {
            case "banks":  //[Site_organization] Bancos
                bank = banksData[indexPath.row]
                if let avatarImage =  bank.avatar{
                    let url = NSURL(string: url_images + avatarImage)
                    print(url_images + avatarImage)
                    // For recycled cells' late image loads.
                    if let image = url!.cachedImage {
                        // Cached: set immediately.
                        cell.bankImageView!.image = image
                        
                    } else {
                        // Not cached, so load then fade it in.
                        
                        url!.fetchImage { image in
                            // Check the cell hasn't recycled while loading.
                            /*if self.imageUrl == url {
                             cell.bankImageView!.image = image
                             }*/
                            cell.bankImageView!.image = image
                        }
                    }
                }
                cell.nameLabel.text = nil
                break
            case "entities": //[Site_organization] entidades SAT
                bank = entitiesData[indexPath.row]
                if let avatarImage =  bank.avatar{
                    let url = NSURL(string: url_images + avatarImage)
                    
                    // For recycled cells' late image loads.
                    if let image = url!.cachedImage {
                        // Cached: set immediately.
                        cell.bankImageView!.image = image
                        
                    } else {
                        // Not cached, so load then fade it in.
                        
                        url!.fetchImage { image in
                            // Check the cell hasn't recycled while loading.
                            /*if self.imageUrl == url {
                             cell.bankImageView!.image = image
                             }*/
                            cell.bankImageView!.image = image
                        }
                    }
                    
                }

                
                cell.nameLabel.text = nil
            break
            case "sites":   //[Site] tipos de cuentas bancarias
                let site = sitesData[indexPath.row]
                if let avatarImage =  bankSelected.avatar{
                    let url = NSURL(string: url_images + avatarImage)
                   
                    // For recycled cells' late image loads.
                    if let image = url!.cachedImage {
                        // Cached: set immediately.
                        cell.bankImageView!.image = image
                        
                    } else {
                        // Not cached, so load then fade it in.
                        
                        url!.fetchImage { image in
                            // Check the cell hasn't recycled while loading.
                            /*if self.imageUrl == url {
                             cell.bankImageView!.image = image
                             }*/
                            cell.bankImageView!.image = image
                        }
                    }
                    
                }
                cell.nameLabel.text = site.name
                break
            default:
                break
        }
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        /*
        switch currentType {
        case "banks":
            bankSelected = banksData[indexPath.row]
            if let sites = bankSelected as? NSArray {
                //check if have two o more diferent types account
                if sites.count > 1{
                    //Display types accounts
                    sitesData = sites as! [[String : AnyObject]]
                    currentType = "sites"
                    collectionView.reloadData()
                }else{
                    //open credentials view
                    print(bankSelected["name"]!)
                    let nextStep = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("credentialsViewController") as! CredentialsViewController
                    
                    nextStep.bank = bankSelected//["sites"] as? [String:AnyObject?]
                    
                    var site = bankSelected["sites"] as? NSArray
                    nextStep.siteId = site![0]["id_site"] as? String
                    self.navigationController?.pushViewController(nextStep, animated: true)
                    print("opened")
                }
                
            }

            break
        case "entities":
            var entitieSelected = entitiesData[indexPath.row]
            print("Selected: \(entitieSelected)")
            let nextStep = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("credentialsViewController") as! CredentialsViewController
            
            nextStep.bank = entitieSelected//["sites"] as? [String:AnyObject?]
            
            var site = entitieSelected["sites"] as? NSArray
            nextStep.siteId = site![0]["id_site"] as? String
            self.navigationController?.pushViewController(nextStep, animated: true)
            
            break
        case "sites":
            var siteSelected = sitesData[indexPath.row]
            let nextStep = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("credentialsViewController") as! CredentialsViewController
            
            nextStep.bank = bankSelected//["sites"] as? [String:AnyObject?]
            nextStep.siteId = siteSelected["id_site"] as? String
            self.navigationController?.pushViewController(nextStep, animated: true)
            print("opened")
            break
        default:
            break
        }
        */
        
        
    }
    
}
