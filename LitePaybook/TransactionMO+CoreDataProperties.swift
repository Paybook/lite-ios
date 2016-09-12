//
//  TransactionMO+CoreDataProperties.swift
//  LitePaybook
//
//  Created by Gabriel Villarreal on 26/08/16.
//  Copyright © 2016 Gabriel Villarreal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TransactionMO {

    @NSManaged var amount: NSNumber?
    @NSManaged var desc: String?
    @NSManaged var dt_refresh: Int32
    @NSManaged var dt_transaction: Int32
    @NSManaged var id_account: String?
    @NSManaged var id_account_type: String?
    @NSManaged var id_external: String?
    @NSManaged var id_site: String?
    @NSManaged var id_site_organization: String?
    @NSManaged var id_site_organization_type: String?
    @NSManaged var id_transaction: String?
    @NSManaged var id_user: String?
    @NSManaged var is_disable: Bool

}
