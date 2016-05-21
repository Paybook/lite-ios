//
//  CredentialsViewController.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 20/05/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit

class CredentialsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var bank : [String:AnyObject?]! = nil
    var credentials = NSArray()
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var credentialCollectionView: UICollectionView!
    
    @IBAction func cancelFunc(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func continueFunc(sender: AnyObject) {
    }
   
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return credentials.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("credentialCell", forIndexPath: indexPath) as! CredentialCell
        let credential = credentials[indexPath.row]
        cell.nameLabel.text = credential["name"] as? String

        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if bank != nil {
            nameLabel.text = bank["name"] as? String
            if let coverImage = bank["cover"] as? String{
                let url = NSURL(string: url_images+coverImage )
                url!.fetchImage { image in
                    self.coverImageView.image = image
                }

            }
            let sites = bank["sites"] as? NSArray
            print(sites![0]["credentials"])
            
            credentials = (sites![0]["credentials"] as? NSArray)!
           
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
