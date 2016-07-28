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

    
    var banksData = [Site_organization]()
    var entitiesData = [Site_organization]()
    var sitesData = [Site]()
    var bankSelected : Site_organization!
    
    var currentType = "banks"    //("banks"/"entities"/"sites")
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var servicesButton: UIButton!
    @IBAction func changeServices(sender: AnyObject) {
        currentType = "entities"
        collectionView.reloadData()
    }
    
    @IBOutlet weak var banksButton: UIButton!
    @IBAction func changeBanks(sender: AnyObject) {
        currentType = "banks"
        collectionView.reloadData()
    }
  

    
    
    func sortOrganizations(organizations: [Site_organization])->Void{
        print("sort Organization \(organizations)")
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
        
        
        collectionView.reloadData()
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
                
                if isTest {
                    let site = sitesData[indexPath.row]
                    // Not cached, so load then fade it in.
                    
                    cell.nameLabel.text = site.name
                    cell.nameLabel.hidden = false
                }else{
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
                    
                }
                break
            default:
                break
        }
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        switch currentType {
        case "banks":
            bankSelected = banksData[indexPath.row]
            print("selected \(bankSelected.name)")
            Catalogues.get_sites(currentSession, id_user: nil, id_site_organization: bankSelected.id_site_organization, is_test: nil){
                response, error in
                if response != nil {
                    
                    if response!.count > 1{
                        //Cargar opciones de cuenta
                        self.sitesData = response!
                        self.currentType = "sites"
                        collectionView.reloadData()
                    }else{
                        //Pasar a enviar credenciales
                        let nextStep = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("credentialsViewController") as! CredentialsViewController
                        
                        nextStep.bank = self.bankSelected//["sites"] as? [String:AnyObject?]
                        
                        let site = response![0]
                        nextStep.siteId = site.id_site
                        nextStep.site = site
                        self.navigationController?.pushViewController(nextStep, animated: true)
                    }
                    
                }else{
                    //Fail
                    
                }
            }
            break
        case "entities":
            
            
            
            let entitieSelected = entitiesData[indexPath.row]
            
            print("selected \(entitieSelected.name)")
            
            Catalogues.get_sites(currentSession, id_user: nil, id_site_organization: entitieSelected.id_site_organization, is_test: nil){
                response, error in
                if response != nil {
                    //Pasar a enviar credenciales
                    let nextStep = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("credentialsViewController") as! CredentialsViewController
                    
                    nextStep.bank = entitieSelected//["sites"] as? [String:AnyObject?]
                    
                    let site = response![0]
                    nextStep.siteId = site.id_site
                    nextStep.site = site
                    self.navigationController?.pushViewController(nextStep, animated: true)
                    
                }else{
                    //Fail
                    
                    
                }
            }

            
            
            break
        case "sites":
            //Pasar a enviar credenciales
            let nextStep = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("credentialsViewController") as! CredentialsViewController
            
            nextStep.bank = self.bankSelected//["sites"] as? [String:AnyObject?]
            
            let site = sitesData[indexPath.row]
            nextStep.siteId = site.id_site
            nextStep.site = site
            print("selected \(site.name)",site.credentials, site.id_site)
            self.navigationController?.pushViewController(nextStep, animated: true)
            break
        default:
            break
        }

        
        
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil{
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        if isTest {
            servicesButton.enabled = false
            banksButton.enabled = false
            Catalogues.get_sites(currentSession, id_user: nil, is_test: true){
                response, error in
                if response != nil {
                    //Cargar sites de prueba
                    self.sitesData = response!
                    self.currentType = "sites"
                    self.collectionView.reloadData()
                }else{
                    //Fail
                    print("Error get_sites: ", error?.message)
                }
            }

        }else{
            Catalogues.get_site_organizations(currentSession, id_user: nil){
                response, error in
                if response != nil{
                    self.sortOrganizations(response!)
                    
                }
            }
        }
        
        
    }
    
}
