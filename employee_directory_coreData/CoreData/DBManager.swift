//
//  DatabaseController.swift
//  Employee Details
//
//  Created by Sreeni E V on 16/09/22.
//

import Foundation
import CoreData
import UIKit

class DBManager {
    
    private var viewContext: NSManagedObjectContext!
    
    static let shared = DBManager()
    
    init() {
        viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func add<T: NSManagedObject>(_ type: T.Type) -> T? {
        guard let entityName = T.entity().name else { return nil }
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: viewContext) else { return nil }
        let object = T(entity: entity, insertInto: viewContext)
        return object
    }
    
    func save() {
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetch<T: NSManagedObject>(_ type: T.Type) -> [T] {
        
        let request = T.fetchRequest()
        do {
            let result = try viewContext.fetch(request)
            return result as! [T]
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func checkDbHaveThisData(email: String, name: String) -> Bool {

        let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()

        let identifierPredicate = NSPredicate(format: "email == %@", email)
        let namePredicate = NSPredicate(format: "name == %@", name)
        let compundPredicate = NSCompoundPredicate(type: .and, subpredicates: [identifierPredicate, namePredicate])
        fetchRequest.predicate = compundPredicate
                
        do {
            let arrData = try viewContext.fetch(fetchRequest)
            
            return !arrData.isEmpty
            
        } catch {
            print(error.localizedDescription)
        }
        return false
    }
    
    
    func fetchPredicatedEntity<T:NSManagedObject>(entity: T.Type, for id: Int16) -> T? {

        let fetchRequest = NSFetchRequest<T>(entityName: NSStringFromClass(T.self))

        let identifierPredicate = NSPredicate(format: "id == %i", id)
        fetchRequest.predicate = identifierPredicate
                
        do {
            let arrData = try viewContext.fetch(fetchRequest)
            
            if arrData.count > 0 {
                return arrData.first
            } else {
                return nil
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }


}
