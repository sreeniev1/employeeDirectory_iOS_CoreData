//
//  Users+CoreDataProperties.swift
//  employee_directory_coreData
//
//  Created by Sreeni E V on 16/09/22.
//
//

import Foundation
import CoreData


extension Users {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
        return NSFetchRequest<Users>(entityName: "Users")
    }

    @NSManaged public var email: String?
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var profileImage: String?
    @NSManaged public var userName: String?
    @NSManaged public var website: String?

}

extension Users : Identifiable {

}
