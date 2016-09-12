//
//  AccounMO+CoreDataProperties.swift
//  
//
//  Created by Gabriel Villarreal on 29/08/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension AccounMO {

    @NSManaged var balance: Double
    @NSManaged var dt_refresh: Int32
    @NSManaged var id_account: String?
    @NSManaged var id_credential: String?
    @NSManaged var id_external: String?
    @NSManaged var id_site: String?
    @NSManaged var id_site_organization: String?
    @NSManaged var id_user: String?
    @NSManaged var name: String?
    @NSManaged var number: String?
    @NSManaged var site: String?

}
