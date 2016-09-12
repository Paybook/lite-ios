//
//  SignInViewController.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 19/07/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit
import Paybook


class SignInViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var userSelected : User!
    var users = [User]()
    
    
    @IBAction func LogIn(sender: AnyObject) {
        
        if userSelected != nil{
            print("Success")
            //Get a Paybook session
            _ = Session(id_user: userSelected.id_user){
                response, error in
                if response != nil{
                    self.openDashboard(response!)
                }else{
                    print(error?.message)
                }
            }
        
            /*
            if (UserMO.checkPassword(userSelected!.name, password: "gabriel") != nil){
                print("Success")
                //Get a Paybook session
                _ = Session(id_user: userSelected.id_user){
                    response, error in
                    if response != nil{
                        self.openDashboard(response!)
                    }else{
                        print(error?.message)
                    }
                }

            }else{
                print("Fail")
            }*/
        }
        
      
    }
    
    @IBAction func DeleteUser(sender: AnyObject) {
        if userSelected != nil{
            User.delete(userSelected.id_user){
                response, error in
                if response != nil && response == true{
                    print("User deleted")
                    User.get(){
                        response, error in
                        if response != nil {
                            self.users = response!
                            print(self.users)
                            self.tableView.reloadData()
                        }
                    }

                }
            }
        }

    }
    
    @IBAction func Cancel(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBOutlet weak var tableView: UITableView!

    
    
    func openDashboard(session: Session)->Void{
        // Save the current session
        currentSession = session
        //Open Dashboard
        let dashboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DashboardViewController") as! SWRevealViewController
        self.presentViewController(dashboard, animated: true, completion: nil)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            userSelected = users[indexPath.row]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        User.get(){
            response, error in
            if response != nil {
                self.users = response!
                print(self.users)
                self.tableView.reloadData()
            }
        }
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
