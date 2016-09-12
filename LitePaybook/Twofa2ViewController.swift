//
//  Twofa2ViewController.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 02/09/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit
import Paybook


class Twofa2ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    var bank : Site_organization! = nil
    var site : Site! = nil
    var siteId : String!
    var credential : Credentials!
    var credentials = NSArray()
    var timer : NSTimer!
    
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return credentials.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("credentialCell", forIndexPath: indexPath) as! CredentialCell
        let credential = credentials[indexPath.row]
        cell.nameLabel.text = credential["name"] as? String
        
        if credential["type"] as? String == "password"{
            cell.textField.secureTextEntry = true
        }
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
