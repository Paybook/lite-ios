//
//  UserMO.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 23/08/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//

import Foundation
import CoreData
import Paybook

@objc(UserMO)
class UserMO: NSManagedObject {

    convenience init(user : User, password: String){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: managedContext)!
        self.init(entity: entity, insertIntoManagedObjectContext: managedContext)
        self.id_user = user.id_user
        self.id_external = user.id_external
        self.name = user.name
        self.dt_create = nil
        self.dt_modify = nil
        self.password = password
        
        do {
            try managedContext.save()
        }catch{
            print(error)
        }
    }
    
    // Check if the credentials are correct
    static func checkPassword(username : String, password: String) -> UserMO?{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        
        let userFetch = NSFetchRequest(entityName: "User")
        userFetch.predicate = NSPredicate(format: "name == %@ && password == %@", username,password)
        
        do {
            let fetchResults = try managedContext.executeFetchRequest(userFetch) as? [UserMO]
            
            if fetchResults?.count > 0{
                return fetchResults![0]
            }else{
                return nil
            }
            
        } catch {
            fatalError("Failed check Password: \(error)")
        }
        
        
    }
    
    
    //Check if the user already exist
    static func checkUser(username : String) -> Bool{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        
        let userFetch = NSFetchRequest(entityName: "User")
        userFetch.predicate = NSPredicate(format: "name == %@", username)
        
        do {
            let fetchResults = try managedContext.executeFetchRequest(userFetch) as? [UserMO]
            
            if fetchResults?.count > 0{
                return true
            }else{
                return false
            }
            
        } catch {
            fatalError("Failed check User: \(error)")
        }
        
        
    }
    

}
