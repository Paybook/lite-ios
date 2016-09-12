//
//  SelectSiteViewController.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 02/09/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit
import Paybook


class SelectSiteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {

    var organization : Site_organization! = nil
    var sites : [Site] = []
    var site : Site! = nil
    var credential : Credentials! = nil
    var timer : NSTimer!
    var sending : Bool = false
    var textActive : UITextField! = nil
    
    
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var twofaView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var prcessingLabel: UILabel!
    
    @IBAction func cancel(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func close(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // *** MARK :
    
    
    @IBAction func continueFunc(sender: AnyObject) {
        
        let arrayCredential = collectionView.visibleCells() as! [CredentialCell]
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
                        twofaViewController.bank = self.organization
                        twofaViewController.site = self.site
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
            self.prcessingLabel.hidden = false
        })
        
        
        
        
    }
    
    func setError(desc: String?){
        self.prcessingLabel.hidden = true
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
        self.prcessingLabel.hidden = true
        let statusAlert = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("statusAlertViewController") as! StatusAlertViewController
        statusAlert.status = [
            "title":"La institución fue procesada correctamente.",
            "success": true,
            "desc": "El sistema continúa trabajando en extraer la información necesaria."
        ]
        self.navigationController?.pushViewController(statusAlert, animated: false)
    }
    


    
    
    
    
    //*** MARK : TableView protocols
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("SiteCell") as? SiteTableViewCell
        
        if cell == nil {
            cell = SiteTableViewCell(style: .Default, reuseIdentifier: "SiteCell")
        }
        
        if isTest {
            cell!.avatarImageView.image = UIImage(named: "acme-avatar-red")
        }else{
            if let avatarImage =  organization.avatar{
                let url = NSURL(string: url_images + avatarImage)
                
                if let image = url!.cachedImage {
                    // Cached: set immediately.
                    cell!.avatarImageView.image = image
                    
                } else {
                    // Not cached, so load then fade it in.
                    url!.fetchImage { image in
                        // Check the cell hasn't recycled while loading.
                        cell!.avatarImageView.image = image
                        
                    }
                }
            }
        }
        
        
        
        
        cell!.nameLabel.text = sites[indexPath.row].name
        
        return cell!
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sites.count
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.site = self.sites[indexPath.row]
        self.collectionView.reloadData()
        self.twofaView.hidden = false
    }
    
    
    
    // MARK : TableView protocols ***
    
    //*** MARK : CollectionView protocols
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if site != nil{
            return site.credentials.count
        }else{
            return 0
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("credentialCell", forIndexPath: indexPath) as! CredentialCell
        
        if site != nil{
            let credential = site.credentials[indexPath.row]
            cell.nameLabel.text = credential["name"] as? String
            
            if credential["type"] as? String == "password"{
                cell.textField.secureTextEntry = true
            }
        }else{
            
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
        if isTest{
            self.coverImageView.image = UIImage(named: "acme-cover")
            Catalogues.get_sites(currentSession, id_user: nil, is_test: isTest, completionHandler: {
                sites , error in
                if sites != nil {
                    self.sites = sites!
                    if self.sites.count == 1{
                        self.site = self.sites[0]
                        self.collectionView.reloadData()
                        self.twofaView.hidden = false
                    }else{
                        self.tableView.reloadData()
                    }
                    
                }
            })
        }else{
            if organization != nil {
                if let coverImage =  organization.small_cover{
                    let url = NSURL(string: url_images + coverImage)
                    
                    if let image = url!.cachedImage {
                        // Cached: set immediately.
                        self.coverImageView.image = image
                    } else {
                        // Not cached, so load then fade it in.
                        url!.fetchImage { image in
                            // Check the cell hasn't recycled while loading.
                            self.coverImageView.image = image
                        }
                    }
                }
                
                Catalogues.get_sites(currentSession, id_user: nil, is_test: isTest, options: ["id_site_organization":organization.id_site_organization], completionHandler: {
                    sites , error in
                    if sites != nil {
                        self.sites = sites!
                        if self.sites.count == 1{
                            self.site = self.sites[0]
                            self.collectionView.reloadData()
                            self.twofaView.hidden = false
                        }else{
                            self.tableView.reloadData()
                        }
                        
                    }
                })
            }
        }
        
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
