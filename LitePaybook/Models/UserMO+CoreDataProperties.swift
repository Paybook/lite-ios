//
//  UserMO+CoreDataProperties.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 23/08/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension UserMO {

    @NSManaged var name: String?
    @NSManaged var id_user: String?
    @NSManaged var id_external: String?
    @NSManaged var dt_create: Int32
    @NSManaged var dt_modify: Int32
    @NSManaged var password: String?

}
