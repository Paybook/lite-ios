//
//  SignUpViewController.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 13/05/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit
import Paybook
import Alamofire

class SignUpViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {

    var textActive : UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textsView: UIView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var warningLabel: UILabel!
    
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    func checkCredentials() -> Bool {
        if emailTextField.text != "" && passwordTextField.text != "" && confirmPasswordTextField.text != "" {
            if passwordTextField.text == confirmPasswordTextField.text{
                warningLabel.hidden = true
                return true
            }else{
                warningLabel.text = "confirm your password"
                warningLabel.hidden = false
            }
            
        }else{
            warningLabel.text = "complete all fields"
            warningLabel.hidden = false
        }
        return false
    }
    
    func openLogIn() {
    
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    @IBAction func signUp(sender: AnyObject) {
        
        if checkCredentials(){
            if UserMO.checkUser(emailTextField.text!){
                self.warningLabel.text = "User already exist"
                self.warningLabel.hidden = false
            }else{
                _ = User(username: emailTextField.text!, id_user: nil, completionHandler: {
                    user, error in
                    if user != nil{
                        let newUser = UserMO(user: user!, password: self.passwordTextField.text!)
                        print("User created", newUser)
                        self.openLogIn()
                    }else{
                        print("Sign up Error: \(error?.message)")
                        self.warningLabel.text = "Sign up Error"
                        self.warningLabel.hidden = false
                    }
                })
            }
            
        }
    }
    
    
    
    
    @IBAction func backButton(sender: AnyObject) {
        print("back")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // *** MARK TextField protocols
    
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
            self.signUp(self)
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
    
    // MARK TextField protocols ***
    
    
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
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        
    }
    

}
