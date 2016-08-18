//
//  ProcessingViewController.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 27/05/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit

class ProcessingViewController: UIViewController {

    @IBOutlet weak var loaderImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //showAlert()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    func showAlert(){
        print("animate")
        UIView.animateWithDuration(1.5, animations: {
            self.view.alpha = 1.0
        })
        /*
        self.view.hidden = false
        let duration = 2.0
        let delay = 0.0
        let options = UIViewKeyframeAnimationOptions.CalculationModePaced
        let fullRotation = CGFloat(M_PI * 2)
        
        UIView.animateKeyframesWithDuration(duration, delay: delay, options: options, animations: {
            
            // note that we've set relativeStartTime and relativeDuration to zero.
            // Because we're using `CalculationModePaced` these values are ignored
            // and iOS figures out values that are needed to create a smooth constant transition
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
                self.loaderImage.transform = CGAffineTransformMakeRotation(1/3 * fullRotation)
            })
            
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
                self.loaderImage.transform = CGAffineTransformMakeRotation(2/3 * fullRotation)
            })
            
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
                self.loaderImage.transform = CGAffineTransformMakeRotation(3/3 * fullRotation)
            })
            
            }, completion: nil)
        print("Animateing")*/
    }
    
    func hideAlert(){
        
    }
   
    
}

extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2.0)
        rotateAnimation.duration = duration
        
        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate
        }
        self.layer.addAnimation(rotateAnimation, forKey: nil)
    }
}
