//
//  ApiCall.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 16/05/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import Foundation
import Alamofire


let apiurl : String = "http://127.0.0.1:5000/"//"<your url server>"
let api_key : String = "f81113bcd5f1722a5a5050d378e50459"



public func login (data: [String:String], callback: ((token : String?)-> Void), callback_error: (()-> Void)?){
    
    let url = "\(apiurl)login"
    
    Alamofire.request(.POST,url , parameters: ["username":data["username"]!, "password" : data["password"]!], encoding: .JSON , headers: ["Content-Type": "application/json; charset=utf-8"]).validate()
        .responseJSON { (response) -> Void in
            guard response.result.isSuccess else {
                print(" RESPONSE: \(response.result)")
                print("Error while fetching remote room: \(response.result.error)")
                if callback_error != nil{
                    callback_error!()
                }
                return
            }
            
            if let responseObj = response.result.value as? [String: String]{
                callback(token: responseObj["token"])
            }
            
            print(response.result.value)
    }
    
    
}

public func signup (data: [String:String], callback: (()-> Void)?, callback_error: (()-> Void)?){
    
    let url = "\(apiurl)signup"
    
    Alamofire.request(.POST,url , parameters: ["username":data["username"]!, "password" : data["password"]!], encoding: .JSON , headers: ["Content-Type": "application/json; charset=utf-8"]).validate()
        .responseJSON { (response) -> Void in
            guard response.result.isSuccess else {
                print(" RESPONSE: \(response.result)")
                print("Error while fetching remote room: \(response.result.error)")
                if callback_error != nil{
                    callback_error!()
                }
                return
            }
            
            if callback != nil {
                callback!()
            }
            print(response.result.value)
    }
    
    
}


public func getOrganizations (data: [String:AnyObject], callback: ((response : [String:AnyObject])-> Void), callback_error: (()-> Void)?){
    
    let url = "https://sync.paybook.com/v1/catalogues/organizations/sites"
    print(data)
    Alamofire.request(.GET,url , parameters: data, encoding: .JSON , headers: ["Content-Type": "application/json; charset=utf-8"]).validate()
        .responseJSON { (response) -> Void in
            guard response.result.isSuccess else {
                print(" RESPONSE: \(response.result)")
                print("Error while fetching remote room: \(response.result.error)")
                if callback_error != nil{
                    callback_error!()
                }
                return
            }
            
            if let responseObj = response.result.value as? [String: AnyObject]{
                callback(response: responseObj)
            }

           // print(response.result.value)
            
    }
    
    
}




class MyImageCache {
    
    static let sharedCache: NSCache = {
        let cache = NSCache()
        cache.name = "MyImageCache"
        cache.countLimit = 20 // Max 20 images in memory.
        cache.totalCostLimit = 10*1024*1024 // Max 10MB used.
        return cache
    }()
    
}

extension NSURL {
    
    typealias ImageCacheCompletion = UIImage -> Void
    
    /// Retrieves a pre-cached image, or nil if it isn't cached.
    /// You should call this before calling fetchImage.
    var cachedImage: UIImage? {
        return MyImageCache.sharedCache.objectForKey(
            absoluteString) as? UIImage
    }
    
    /// Fetches the image from the network.
    /// Stores it in the cache if successful.
    /// Only calls completion on successful image download.
    /// Completion is called on the main thread.
    func fetchImage(completion: ImageCacheCompletion) {
        let task = NSURLSession.sharedSession().dataTaskWithURL(self) {
            data, response, error in
            if error == nil {
                if let  data = data,
                    image = UIImage(data: data) {
                    MyImageCache.sharedCache.setObject(
                        image,
                        forKey: self.absoluteString,
                        cost: data.length)
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(image)
                    }
                }
            }
        }
        task.resume()
    }
    
}


