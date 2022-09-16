//
//  EmployeeViewModel.swift
//
//  Created by Sreeni E V on 16/09/22.
//

import Foundation
import UIKit

class EmployeeViewModel {
    
    let webservice = WebService()
    
    func fetchUserDetails(urlString: String, completion: @escaping ((_ status: Bool) -> Void)) {
        
        guard let url = URL(string: urlString) else { return }
        
        webservice.makeRequest(url: url) { response, rawData, error in
            guard let _ = error else {
                
                if let data = rawData {
                    do {
                        let model = try JSONDecoder().decode([EmployeeModel].self, from: data)
                        
                        self.bindModel(model: model)
                        
                        completion(true)
                    } catch {
                        completion(false)
                    }
                    
                } else {
                    //No data received
                    completion(false)
                }
                return
            }
            //Error found
            completion(false)
        }
    }
}

extension EmployeeViewModel {
    
    func  bindModel(model: [EmployeeModel]) {
        for m in model {
            
            if !checkDbHaveThisData(model: m) {
                m.storeUserData()
                let id = m.id
                
                //Get each Address
                var address = m.getAddress()
                address?.id = id
                //Store Address data in CoreData
                address?.storeAddress()
                
                //Get each Company
                var company = m.getCompany()
                company?.id = id
                //Store Company data in CoreData
                company?.storeCompanyData()
            } else {
                continue
            }

        }
    }
}

extension EmployeeViewModel {
    func checkDbHaveThisData(model: EmployeeModel) -> Bool {
        let database = DBManager.shared
        
        guard let email = model.email, let name = model.name else { return false}
        
        return(database.checkDbHaveThisData(email: email, name: name))
    }
}

