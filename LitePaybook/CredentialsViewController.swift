//
//  CredentialsViewController.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 20/05/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit
import Foundation
import Paybook


class CredentialsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
   
    var bank : Site_organization! = nil
    var site : Site! = nil
    var siteId : String!
    var credential : Credentials!
    var credentials = NSArray()
    var timer : NSTimer!
    var sending : Bool = false
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var credentialCollectionView: UICollectionView!
    
    @IBOutlet weak var processingView: UIView!
    @IBAction func cancelFunc(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func continueFunc(sender: AnyObject) {
        
        let arrayCredential = credentialCollectionView.visibleCells() as! [CredentialCell]
        var credentialsString = [String:String]()
        for i in arrayCredential{
            credentialsString[i.nameLabel.text!] = i.textField.text
        }
        
        
        print(credentialsString)
        sending = true
        setProcessing()
        _ = Credentials(session: currentSession, id_user: nil, id_site: site.id_site, credentials: credentialsString){
            response, error in
            self.sending = false
            if response != nil {
                
                
                
                self.credential = response
                print("\nCheck Status:")
                
                self.timer = NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: #selector(self.checkStatus), userInfo: nil, repeats: true)
                
                
                
            }
            
            
        }
        //createCredentials(data, callback: callback, callback_error: callback_error)*/
    }
   
    
    
    func checkStatus(){
        if sending == false {
            sending = true
            credential.get_status(currentSession, id_user: nil, completionHandler: {
                response, error in
                self.sending = false
                if response != nil{
                    
                    let status = response![response!.count-1]
                    
                    switch status["code"] as! Int{
                    case 100,101,102,103,104,105 :
                        print("Processing...\(status["code"])")
                        self.setProcessing();
                        break
                    case 200,201,202,203:
                        self.setFinished("La institución fue procesada correctamente. El sistema continúa trabajando en extraer la información necesaria.");
                        print("Success...\(status["code"])")
                        self.timer.invalidate()
                        break
                    case 301,401,402,403:
                        self.setError("Credenciales incorrectas. Por favor, vuelva a intentarlo.");
                        print("User Error \(status["code"])")
                        self.timer.invalidate()
                    case 405:
                        self.setError("Su cuenta está bloqueada. Por favor vaya a la página web de su banco.");
                        self.timer.invalidate()
                    case 406:
                        //user already logged in
                        self.setError("El usuario ya se encuentra conectado. Por favor, desconéctese de su banco si está conectado, vuelva a intentarlo pasados unos minutos.");
                        self.timer.invalidate()
                    case 410:
                        print("Waiting for two-fa \(status["code"])")
                        print(status)
                        let twofaViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("twofaViewController") as! TwofaViewController
                        
                        twofaViewController.credential = self.credential
                        twofaViewController.credentials = status["twofa"] as! NSArray
                        self.navigationController?.pushViewController(twofaViewController, animated: true)
                        
                        
                        
                        
                        self.timer.invalidate()
                        break
                    case 411:
                        //request timeout user info
                        self.setError("Pasó el tiempo máximo de espera para introducir esa información. Por favor, vuelva a intentarlo.");
                        self.timer.invalidate()
                    case 500,501,504,505:
                        print("System Error \(status["code"])")
                        self.setError("Error del sistema. Por favor, vuelva a intentarlo pasados unos minutos.");
                        self.timer.invalidate()
                        break
                    default :
                        self.setError("Error, por favor vuelva a intentarlo.");
                        self.timer.invalidate()
                        break
                    }
                }else{
                    print("Fail: \(error?.message)")
                    
                }
                
                
            })
            
        }
        
    }

    
    
    
    func callback_error(code: Int){
        switch code{
        case 401:
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "token")
            let indexViewController = self.storyboard!.instantiateViewControllerWithIdentifier("index")
            UIApplication.sharedApplication().keyWindow?.rootViewController = indexViewController
            break
        default :
            break
        }
        
    }
    
    func setProcessing(){
        print("Processing")
        UIView.animateWithDuration(0.5, animations: {
            self.processingView.alpha = 1.0
        })
        
        
        
        
    }
    
    func setError(desc: String?){
        
        let statusAlert = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("statusAlertViewController") as! StatusAlertViewController
        statusAlert.status = [
            "title":"Problema de conexión.",
            "success": false,
            "desc": desc
        ]
        self.navigationController?.pushViewController(statusAlert, animated: false)
    }
    
    func setFinished(desc:String){
        print("Success \(desc)")
        
        let statusAlert = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("statusAlertViewController") as! StatusAlertViewController
        statusAlert.status = [
            "title":"La institución fue procesada correctamente.",
            "success": true,
            "desc": "El sistema continúa trabajando en extraer la información necesaria."
        ]
        self.navigationController?.pushViewController(statusAlert, animated: false)
    }
    
    
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return credentials.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("credentialCell", forIndexPath: indexPath) as! CredentialCell
        let credential = credentials[indexPath.row]
        cell.nameLabel.text = credential["name"] as? String
        
        if credential["type"] as? String == "password"{
            cell.textField.secureTextEntry = true
        }
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:true);
        if bank != nil {
            nameLabel.text = bank.name
            if let coverImage = bank.cover{
                let url = NSURL(string: url_images+coverImage )
                url!.fetchImage { image in
                    self.coverImageView.image = image
                }
                
            }
            
        }
        
        credentials = self.site!.credentials!
        
        
        print(credentials)
        
        
        /*
        if bank != nil {
            nameLabel.text = bank["name"] as? String
            if let coverImage = bank["cover"] as? String{
                let url = NSURL(string: url_images+coverImage )
                url!.fetchImage { image in
                    self.coverImageView.image = image
                }

            }
            if let sites = bank["sites"] as? NSArray{
                for i in sites{
                    if i["id_site"] as? String == self.siteId{
                        credentials = (i["credentials"] as? NSArray)!
                    }
                }
            }
            
            
           
        }*/
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
