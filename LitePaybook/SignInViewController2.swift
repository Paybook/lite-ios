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

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var warningLabel: UILabel!
    
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
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTag: NSInteger = textField.tag + 1;
        
        if textField.tag == 1{
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
        return false // We do not want UITextField to insert line-breaks.
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
