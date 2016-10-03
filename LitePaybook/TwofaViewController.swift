//
//  TwofaViewController.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 28/07/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit
import Paybook

class TwofaViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {

    var bank : Site_organization! = nil
    var site : Site! = nil
    var credential : Credentials!
    var credentials = NSArray()
    var timer : NSTimer!
    var textActive : UITextField! = nil
    var processing = false
    weak var mDelegate: LinkAccounts?
    
    @IBOutlet weak var processingLabel: UILabel!
    @IBOutlet weak var processingIcon: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var credentialCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func cancel(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func close(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func continueFunc(sender: AnyObject) {
        
        let arrayCredential = credentialCollectionView.visibleCells() as! [CredentialCell]
        var credentialsString = [String:String]()
        for i in arrayCredential{
            credentialsString[i.nameField] = i.textField.text
        }
        
        
        print("SEnding",credentialsString)
        
        
        credential.set_twofa(currentSession, id_user: nil, params: credentialsString){
            response, error in
            
            if response != nil && response == true {
                
                print("\nCheck Status:")
                self.setProcessing()
                self.timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(self.checkStatus), userInfo: nil, repeats: true)
                
            }
            
        }
        
        
    }
    
    
    
    func checkStatus(){
        
        credential.get_status(currentSession, id_user: nil, completionHandler: {
            response, error in
            if response != nil{
                
                let status = response![response!.count-1]
                
                switch status["code"] as! Int{
                case 100,101,102,103,104,105 :
                    print("Processing...\(status["code"])")
                    break
                case 200,201,202,203:
                    self.setFinished("La institución fue procesada correctamente. El sistema continúa trabajando en extraer la información necesaria.");
                    print("Success...\(status["code"])")
                    self.timer.invalidate()
                    self.mDelegate?.updateAccounts()
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
    
    // Rotate <targetView> indefinitely
    private func rotateView(targetView: UIView, duration: Double = 1.0) {
        UIView.animateWithDuration(duration, delay: 0.0, options: .CurveLinear, animations: {
            targetView.transform = CGAffineTransformRotate(targetView.transform, CGFloat(M_PI))
        }) { finished in
            if (self.processing){
                self.rotateView(targetView, duration: duration)
            }
        }
    }
    
    func setProcessing(){
        print("Processing")
        processing = true
        UIView.animateWithDuration(0.5, animations: {
            self.processingLabel.alpha = 1.0
            self.processingIcon.alpha = 1.0
            },completion: {
                finished in
                self.rotateView(self.processingIcon)
        })
        
    }
    
    func setError(desc: String?){
        processing = false
        self.processingLabel.alpha = 0.0
        self.processingIcon.alpha = 0.0

        let statusAlert = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("statusAlertViewController") as! StatusAlertViewController
        statusAlert.status = [
            "title":"Problema de conexión.",
            "success": false,
            "desc": desc
        ]
        self.navigationController?.pushViewController(statusAlert, animated: false)
    }
    
    func setFinished(desc:String){
        processing = false
        self.processingLabel.alpha = 0.0
        self.processingIcon.alpha = 0.0

        let statusAlert = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("statusAlertViewController") as! StatusAlertViewController
        statusAlert.status = [
            "title":"La institución fue procesada correctamente.",
            "success": true,
            "desc": "El sistema continúa trabajando en extraer la información necesaria."
        ]
        self.navigationController?.pushViewController(statusAlert, animated: false)
    }
    
    
    
    
    // *** MARK : CollectionView protocols 
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return credentials.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("credentialCell", forIndexPath: indexPath) as! CredentialCell
        let credential = credentials[indexPath.row]
        cell.nameLabel.text = credential["label"] as? String
        cell.nameField = credential["name"] as? String
        if credential["type"] as? String == "password"{
            cell.textField.secureTextEntry = true
        }
        return cell
    }
    // MARK : CollectionView protocols ***
    
    
    // *** MARK : Text Fields protocols and Keyboard Notifications
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textActive = textField
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        view.endEditing(true)
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            
            let p = textActive.convertPoint(textActive.center, toView: self.view)
            
            if (p.y) > (self.view.frame.size.height - keyboardSize.height){
                scrollView.setContentOffset(CGPointMake(0,(p.y) - (self.view.frame.size.height - keyboardSize.height)), animated: true)
            }
            
        }
        
    }
    
    // MARK : Text Fields protocols and Keyboard Notifications ***
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:true);
        if bank != nil {
            
            if let coverImage = bank.cover{
                let url = NSURL(string: url_images+coverImage )
                url!.fetchImage { image in
                    self.coverImageView.image = image
                }
                
            }
            
        }else{
            if isTest {
                coverImageView.image = UIImage(named: "acme-cover")
            }
        }
        nameLabel.text = site?.name
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SelectSiteViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
