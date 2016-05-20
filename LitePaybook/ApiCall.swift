//
//  ApiCall.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 16/05/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import Foundation
import Alamofire


public func login (data: [String:String], callback: ((token : String?)-> Void), callback_error: (()-> Void)?){
    
    let url = "\(api_url)login"
    
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
    
    let url = "\(api_url)signup"
    
    Alamofire.request(.POST,url , parameters: ["username":data["username"]!, "password" : data["password"]!], encoding: .JSON , headers: ["Content-Type": "application/json; charset=utf-8"]).validate()
        .responseJSON { (response) -> Void in
            guard response.result.isSuccess else {
                print(" RESPONSE ERROR: \(response.result.error?.code)")
                
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


public func getOrganizations (data: [String:AnyObject], callback: ((response : [String:AnyObject])-> Void), callback_error: ((code: Int)-> Void)?){
    
    let url = "https://sync.paybook.com/v1/catalogues/organizations/sites"
    print(data)
    Alamofire.request(.GET,url , parameters: data, encoding: .JSON , headers: ["Content-Type": "application/json; charset=utf-8"]).validate()
        .responseJSON { (response) -> Void in
            guard response.result.isSuccess else {
             
                print("Error \(response.response?.statusCode)")
                if callback_error != nil{
                    callback_error!(code: (response.response?.statusCode)!)
                }
                return
            }
            
            if let responseObj = response.result.value as? [String: AnyObject]{
                callback(response: responseObj)
            }

           // print(response.result.value)
            
    }
    
    
}

