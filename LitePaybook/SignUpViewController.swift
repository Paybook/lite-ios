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

    
    @IBOutlet weak var scrollView: UIScrollView!
    
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
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if (textField != emailTextField && textField != passwordTextField){
            scrollView.setContentOffset(CGPointMake(0, 40), animated: true)
        }
        
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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    

}
