//
//  CredentialsViewController.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 20/05/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import UIKit
import Foundation
import SocketRocket

class CredentialsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,SRWebSocketDelegate {
   
    var bank : [String:AnyObject?]! = nil
    var siteId : String!
    
    var credentials = NSArray()
    
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
        var site = bank["sites"] as? NSArray
        
        var data : [String: AnyObject] = [
            "id_site": site![0]["id_site"]!!,
            "token": NSUserDefaults.standardUserDefaults().objectForKey("token")!,
            "credentials": credentialsString        ]
       
        
        createCredentials(data, callback: callback, callback_error: callback_error)
    }
   
    func callback(response: [String:AnyObject])->Void{
        print("Response callback\(response["response"])")
        connectWebSocket(response["response"]!["ws"] as! String)
        
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
        processingView.hidden = false
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
    
    func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject!) {
        let code = message as? String
        
        //print("MESSAGE: \(message)  code: \(code?.values)")
        if let data = code!.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                let status = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
                if let statusCode = status!["code"] as? Int{
                        print(statusCode)
                    switch (statusCode){
                    case 100,101,102,103,104,105 :
                        setProcessing();
                        break
                    case 200,201:
                        setFinished("La institución fue procesada correctamente. El sistema continúa trabajando en extraer la información necesaria.");
                        webSocket.close()
                        break
                    case 301,401,402,403:
                        setError("Credenciales incorrectas. Por favor, vuelva a intentarlo.");
                        //invalid credentials
                        webSocket.close()
                        break
                    case 405:
                        setError("Su cuenta está bloqueada. Por favor vaya a la página web de su banco.");
                        //account locked, show message
                        webSocket.close()
                        break
                    case 406:
                        //user already logged in
                        setError("El usuario ya se encuentra conectado. Por favor, desconéctese de su banco si está conectado, vuelva a intentarlo pasados unos minutos.");
                        webSocket.close()
                        break
                    case 410:
                        //setExtraCredentials(response.twofa);
                        webSocket.close()
                        break
                    case 411:
                        //request timeout user info
                        setError("Pasó el tiempo máximo de espera para introducir esa información. Por favor, vuelva a intentarlo.");
                        webSocket.close()
                        break
                    case 500,501,502,503,504,505:
                        //non user error, just notify to retry later
                        setError("Error del sistema. Por favor, vuelva a intentarlo pasados unos minutos.");
                        webSocket.close()
                        break;
                    default:
                        //console.log(code);
                        setError("Error desconocido, por favor vuelva a intentarlo.");
                        webSocket.close()
                        break
                    }
                    
                }
                
            } catch let error as NSError {
                print(error)
            }
        }
        
    }

    func webSocket(webSocket: SRWebSocket!, didFailWithError error: NSError!) {
        print("Error : \(error)")
    }
    
    func webSocket(webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        print("Close: \(code), reason: \(reason), was clean:\(wasClean)")
        processingView.hidden = true
    }
    
    
    
    
    func connectWebSocket (urlSocket:String?){
        if urlSocket != nil {
            print("Init Socket: \(urlSocket)")
            var newWebSocket = SRWebSocket(URL: NSURL(string: urlSocket!))
            
            newWebSocket.delegate = self;
            newWebSocket.open()
            
 
        }
        
        
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
            
            
           
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
