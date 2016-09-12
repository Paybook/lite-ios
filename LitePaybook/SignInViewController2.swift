//
//  SignInViewController2.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 24/08/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit
import Paybook


class SignInViewController2: UIViewController, UITextFieldDelegate {
    var textActive : UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var textsView: UIView!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func signIn(sender: AnyObject) {
        //let user =
        warningLabel.hidden = true
        print("Check password")
        if let user = UserMO.checkPassword(emailTextField.text!, password: passwordTextField.text!){
            print("Get session")
            _ = Session(id_user: user.id_user!, completionHandler: {
                session, error in
                if session != nil{
                    currentSession = session
                    let dashboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DashboardViewController") as! SWRevealViewController
                    self.presentViewController(dashboard, animated: true, completion: nil)
                }else{
                    print(error?.message)
                }
                
            })
        }else{
            warningLabel.hidden = false
            warningLabel.text = "El usuario o password es incorrectas"
        }
    
    
    }
    
    @IBAction func Cancel(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textActive = textField
        /*
         if ((textsView.frame.size.height - (textField.center.y + 30)) < 216){
         scrollView.setContentOffset(CGPointMake(0, (216 - (textField.center.y + 30))), animated: true)
         }
         */
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        view.endEditing(true)
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTag: NSInteger = textField.tag + 1;
        
        if textField.tag == 2{
            view.endEditing(true)
            
        }else{
            // Try to find next responder
            if let nextResponder: UIResponder! = textField.superview!.viewWithTag(nextTag){
                nextResponder.becomeFirstResponder()
            }
            else {
                // Not found, so remove keyboard.
                textField.resignFirstResponder()
            }
            
        }
        return true // We do not want UITextField to insert line-breaks.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            print(textActive.center.y,keyboardSize.height,(textsView.frame.size.height),(textsView.frame.size.height) - (textActive.center.y + 15))
            
            if (textActive.center.y + 15) > (textsView.frame.size.height - keyboardSize.height){
                scrollView.setContentOffset(CGPointMake(0,(textActive.center.y + 15) - (textsView.frame.size.height - keyboardSize.height)), animated: true)
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let topColor  = UIColor(colorLiteralRed: (216/255.0), green: (57/255.0), blue: (72/255.0), alpha: 1.0)
        let bottomColor  = UIColor(colorLiteralRed: (78/255.0), green: (51/255.0), blue: (90/255.0), alpha: 1.0)
        
        
        let gradientColors : [CGColor] = [topColor.CGColor,bottomColor.CGColor]
        
        let gradientLocations = [0.0, 1.0]
        let gradientLayer : CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        gradientLayer.frame = self.topView.bounds
        
        self.topView.layer.insertSublayer(gradientLayer, atIndex: 0)
        
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignUpViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }
    


}
