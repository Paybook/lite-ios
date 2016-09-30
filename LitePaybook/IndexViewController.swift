//
//  IndexViewController.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 12/05/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit
import Paybook


class IndexViewController: UIViewController {
    
    var expired : Bool = false
    var timer : NSTimer!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var alertView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Paybook.api_key = api_key
        let topColor  = UIColor(colorLiteralRed: (216/255.0), green: (57/255.0), blue: (72/255.0), alpha: 1.0)
        let bottomColor  = UIColor(colorLiteralRed: (78/255.0), green: (51/255.0), blue: (90/255.0), alpha: 1.0)
        
        
        let gradientColors : [CGColor] = [topColor.CGColor,bottomColor.CGColor]
        
        let gradientLocations = [0.0, 1.0]
        let gradientLayer : CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, atIndex: 0)
        
        logInButton.layer.borderColor = UIColor.whiteColor().CGColor
        logInButton.layer.borderWidth = 1.0
        
        // Do any additional setup after loading the view.
    }
    
    func closeAlert () {
        UIView.animateWithDuration(0.5, animations: {
            self.alertView.center.y = -30
        })
        self.timer.invalidate()
    }
    
    override func viewDidAppear(animated: Bool) {
        if expired {
            UIView.animateWithDuration(0.5, animations: {
                self.alertView.center.y = 30
            })
           
            timer = NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: #selector(self.closeAlert), userInfo: nil, repeats: false)
        }
            
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
