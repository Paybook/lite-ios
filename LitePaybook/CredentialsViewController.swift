//
//  CredentialsViewController.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 20/05/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit

class CredentialsViewController: UIViewController {
    
    let bank : [String:AnyObject?]! = nil
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func cancelFunc(sender: AnyObject) {
    }
    @IBAction func continueFunc(sender: AnyObject) {
    }
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if bank != nil {
            if let coverImage = bank["cover"] as? String{
                
                let url = NSURL(string: url_images+coverImage )
                url!.fetchImage { image in
                    self.coverImageView.image = image
                }

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
