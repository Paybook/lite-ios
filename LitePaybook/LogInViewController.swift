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
        logIn()
    }
    @IBAction func close(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func logIn(){
        
        let addr = getIFAddresses()
            print(addr)
        //http://\(addr[0]):5000/login"
        let data = ["username":userTextField.text!, "password" : passwordTextField.text!]
        login(data, callback:{
                print("Success...")
            }, callback_error:{
                print("Error...")
            })
        
       
    }
    func textFieldDidEndEditing(textField: UITextField) {
        view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTag: NSInteger = textField.tag + 1;
        
        if textField.tag == 1{
            view.endEditing(true)
            // Send credentials
            
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

    func getIFAddresses() -> [String] {
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
        if getifaddrs(&ifaddr) == 0 {
            
            // For each interface ...
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr.memory.ifa_next }
                
                let flags = Int32(ptr.memory.ifa_flags)
                var addr = ptr.memory.ifa_addr.memory
                
                // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        
                        // Convert interface address to a human readable string:
                        var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String.fromCString(hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        
        return addresses
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
