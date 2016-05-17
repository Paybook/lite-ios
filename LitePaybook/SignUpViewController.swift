//
//  SignUpViewController.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 13/05/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

    
    
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
        //
        
        if emailTextField.text != "" && passwordTextField.text != "" && confirmPasswordTextField.text != "" {
            
            if isValidEmail(emailTextField.text!){
                if passwordTextField.text == confirmPasswordTextField.text{
                    warningLabel.hidden = true
                    return true
                }else{
                    warningLabel.text = "confirm your password"
                    warningLabel.hidden = false
                }
            }else{
                warningLabel.text = "your email is not valid"
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
            let data = ["username": emailTextField.text!, "password": passwordTextField.text!]
            signup(data, callback: {self.openLogIn()}, callback_error: {print("Sign up Error")})
            
        }
    }
    
    @IBAction func backButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    

}
