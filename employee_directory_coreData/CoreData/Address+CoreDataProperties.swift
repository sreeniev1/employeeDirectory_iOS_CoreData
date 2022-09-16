//
//  Address+CoreDataProperties.swift
//  employee_directory_coreData
//
//  Created by Sreeni E V on 16/09/22.
//
//

import Foundation
import CoreData


extension Address {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Address> {
        return NSFetchRequest<Address>(entityName: "Address")
    }

    @NSManaged public var city: String?
    @NSManaged public var street: String?
    @NSManaged public var suite: String?
    @NSManaged public var id: Int16
    @NSManaged public var zip: String?

}

extension Address : Identifiable {

}
