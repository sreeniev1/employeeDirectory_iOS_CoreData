//
//  Company+CoreDataProperties.swift
//  employee_directory_coreData
//
//  Created by Sreeni E V on 16/09/22.
//
//

import Foundation
import CoreData


extension Company {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Company> {
        return NSFetchRequest<Company>(entityName: "Company")
    }

    @NSManaged public var bs: String?
    @NSManaged public var catchPhrase: String?
    @NSManaged public var name: String?
    @NSManaged public var id: Int16

}

extension Company : Identifiable {

}
