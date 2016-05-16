//
//  IndexViewController.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 12/05/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit

class IndexViewController: UIViewController {
    
    
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        logInButton.layer.borderColor = UIColor.blueColor().CGColor//UIColor(colorLiteralRed: 19, green: 160, blue: 213, alpha: 100.0).CGColor
        logInButton.layer.borderWidth = 1.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
