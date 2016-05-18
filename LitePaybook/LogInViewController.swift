//
//  LogInViewController.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 11/05/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit
import Alamofire


class LogInViewController: UIViewController, UITextFieldDelegate, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func didPressEnter(sender: AnyObject) {
        checkFields()
    }
    @IBAction func close(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func checkFields(){
        if userTextField.text != "" && passwordTextField.text != "" {
            let data = ["username":userTextField.text!, "password" : passwordTextField.text!]
            login(data, callback:openDashboard, callback_error:{
                print("Error...")
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func openDashboard(token: String?)->Void{
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(token, forKey: "token")
     
        let dashboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("tabDashboard") as! UITabBarController
        self.presentViewController(dashboard, animated: true, completion: nil)
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTag: NSInteger = textField.tag + 1;
        
        if textField.tag == 1{
            view.endEditing(true)
            // Send credentials
            checkFields()
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

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
