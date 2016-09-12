//
//  SettingsViewController.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 18/05/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit
import Paybook

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var switchEnviroment: UISwitch!
    @IBOutlet weak var topBar: UIView!
    
   
    
    
    @IBAction func openMenu(sender: AnyObject) {
        revealViewController().rightRevealToggleAnimated(true)
    }
    
    func changeEnviroment(sender: UISwitch){
        
        if switchEnviroment.on {
            isTest = true
        } else {
            isTest = false
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if isTest{
            switchEnviroment.setOn(true, animated: false)
        }else{
            switchEnviroment.setOn(false, animated: false)
        }
        
        
        if self.revealViewController() != nil{
           
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        switchEnviroment.addTarget(self, action: #selector(changeEnviroment), forControlEvents: .ValueChanged)
        
        let topColor  = UIColor(colorLiteralRed: (216/255.0), green: (57/255.0), blue: (72/255.0), alpha: 1.0)
        let bottomColor  = UIColor(colorLiteralRed: (78/255.0), green: (51/255.0), blue: (90/255.0), alpha: 1.0)
        
        
        let gradientColors : [CGColor] = [topColor.CGColor,bottomColor.CGColor]
        
        let gradientLocations = [0.0, 1.0]
        let gradientLayer : CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        gradientLayer.frame = self.topBar.bounds
        
        self.topBar.layer.insertSublayer(gradientLayer, atIndex: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    


}
