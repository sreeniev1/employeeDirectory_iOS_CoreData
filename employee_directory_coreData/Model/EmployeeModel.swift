//
//  EmployeeModel.swift
//
//  Created by Sreeni E V on 15/09/22.
//

import Foundation

struct EmployeeModel: Codable {
    let id : Int16?
    let name : String?
    let username : String?
    let email : String?
    let profile_image : String?
    let phone : String?
    let website : String?
    let address: EmployeeAddress?
    let company: EmployeeCompany?
    
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case username = "username"
        case email = "email"
        case profile_image = "profile_image"
        case address = "address"
        case phone = "phone"
        case website = "website"
        case company = "company"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int16.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        profile_image = try values.decodeIfPresent(String.self, forKey: .profile_image)
        address = try values.decodeIfPresent(EmployeeAddress.self, forKey: .address)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        website = try values.decodeIfPresent(String.self, forKey: .website)
        company = try values.decodeIfPresent(EmployeeCompany.self, forKey: .company)
    }
    
    static let database = DBManager.shared
    func storeUserData() {
        guard let users = EmployeeModel.database.add(Users.self) else { return }
        
        users.id = id ?? 0
        users.name = name
        users.userName = username
        users.email = email
        users.profileImage = profile_image
        users.website = website
        users.phone = phone
        
        EmployeeModel.database.save()
    }
    
    func getAddress() -> EmployeeAddress? {
        return self.address
    }
    
    func getCompany() -> EmployeeCompany? {
        return self.company
    }
}

struct EmployeeAddress: Codable {
    var id: Int16?
    let street: String?
    let suite: String?
    let city: String?
    let zipCode: String?
    
    init(id: Int, street: String? = nil, suite: String? = nil, city: String? = nil, zip: String? = nil) {
        self.id = Int16(id)
        self.street = street
        self.suite = suite
        self.city = city
        self.zipCode = zip
    }
    
    static let database = DBManager.shared
    
    func storeAddress() {
        guard let address = EmployeeModel.database.add(Address.self) else { return }
        
        address.id = id ?? 0
        address.zip = zipCode
        address.suite = suite
        address.street = street
        address.city = city
        
        EmployeeModel.database.save()
    }
}


struct EmployeeCompany: Codable {
    
    var id: Int16?
    let name: String?
    let catchPhrase: String?
    let bs: String?
    
    init(id: Int, name: String? = nil, catchphrase: String? = nil, bs: String? = nil) {
        self.id = Int16(id)
        self.name = name
        self.catchPhrase = catchphrase
        self.bs = bs
    }
    
    func storeCompanyData() {
        guard let company = EmployeeModel.database.add(Company.self) else { return }
        
        company.id = id ?? 0
        company.catchPhrase = catchPhrase
        company.bs = bs
        company.name = name
        
        EmployeeModel.database.save()
    }
    
}
