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
    
    /*
    - (void)webSocketDidOpen:(SRWebSocket *)newWebSocket {
    webSocket = newWebSocket;
    [webSocket send:[NSString stringWithFormat:@"Hello from %@", [UIDevice currentDevice].name]];
    }
    
    - (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    [self connectWebSocket];
    }
    
    - (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    [self connectWebSocket];
    }
*/
    
    func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject!) {
        
        print("MESSAGE: \(message)")
    }

    
    
    
    
    
    func connectWebSocket (urlSocket:String?){
        if urlSocket != nil {
            print("Init Socket: \(urlSocket)")
            //webSocket.delegate = nil;
            //webSocket = nil;
            
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
