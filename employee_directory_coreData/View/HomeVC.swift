//
//  HomeViewController.swift
//
//  Created by Sreeni E V on 16/09/22.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    
    let urlString = "http://www.mocky.io/v2/5d565297300000680030a986"
    var activityView: UIActivityIndicatorView?
    
    var employeeVM = EmployeeViewModel()
    let dbManager = DBManager.shared
    
    var searchText: String? {
        didSet {
            if let text = searchText {
                self.getFilteredData(item: text)
            }
        }
    }
    
    var fetchedUsers: [Users]? {
        didSet {
            if let _ = fetchedUsers {
                self.reloadTable()
            }
        }
    }
    
    lazy var companiesFetched: [Company]? = {
        let companies = dbManager.fetch(Company.self)
        return companies
    }()
    
    var companyNamesArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkDbForUSers()
        navigationItem.title = "Home"
    }
  
    
    func checkDbForUSers() {
        let users = dbManager.fetch(Users.self)
        if !users.isEmpty  {
            self.fetchedUsers = users
            self.loadcompanyNamesArray(users: users)
        } else {
            self.getDataFromTheServer()
        }
    }


     func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    @IBAction func clearSearchTapped(_ sender: UIButton) {
        searchField.text = ""
        searchField.resignFirstResponder()
        
        let users = dbManager.fetch(Users.self)
        self.loadcompanyNamesArray(users: users)
        self.fetchedUsers = users
    }
    
    func getFilteredData(item: String) {
        
        var filteredUsers: [Users] = []
        var filteredUserIds: [Int16] = []
        
        guard let fetchedUsers = fetchedUsers else { return }
            
            if fetchedUsers.isEmpty { return }
            
            let filteredArray = fetchedUsers.compactMap({ $0.name!.lowercased().contains(item) || $0.email!.lowercased().contains(item)})
            var indexArray: [Int] = []
            for each in filteredArray {
                if each {
                    if let index = filteredArray.firstIndex(of: each) {
                        indexArray.append(index)
                    }
                }
            }
            if indexArray.count > 0 {
                for eachIndex in indexArray {
                    let user = fetchedUsers[eachIndex]
                    filteredUsers.append(user)
                    filteredUserIds.append(user.id)
                }
            }
            self.fetchedUsers = filteredUsers
            self.loadcompanyNamesArray(users: filteredUsers)
        
    }
}

extension HomeViewController {

    func getDataFromTheServer() {
        showActivityIndicator()
        
        employeeVM.fetchUserDetails(urlString: urlString, completion: { status in
            
            DispatchQueue.main.async {
                self.hideActivityIndicator()
            }
            
            if status {
                let users = self.dbManager.fetch(Users.self)
                self.loadcompanyNamesArray(users: users)
                self.fetchedUsers = users
            }
        })
    }
    
    func showActivityIndicator() {
        activityView = UIActivityIndicatorView(style: .large)
        activityView?.center = self.view.center
        self.view.addSubview(activityView!)
        activityView?.startAnimating()
    }

    func hideActivityIndicator(){
        if (activityView != nil){
            activityView?.stopAnimating()
        }
    }
    
    func loadcompanyNamesArray(users: [Users]) {
        for eachUser in users {
            let companyName = self.getCompany(for: eachUser.id)?.name ?? "Nothing"
            self.companyNamesArray.append(companyName)
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchedUsers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
        guard let users = fetchedUsers else { return UITableViewCell() }
        
        if !users.isEmpty {
            
        cell.nameLabel.text = users[indexPath.row].name
            
            if let img = users[indexPath.row].profileImage {
                cell.userImage.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named: "user.jpeg"))
            } else {
                cell.userImage.image = UIImage(named: "user.jpeg")
            }
            
            cell.companyLabel.text = companyNamesArray[indexPath.row]
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let users = fetchedUsers,!users.isEmpty else { return }

            let selectedId = users[indexPath.row].id

            let userModel = self.getUserModel(for: selectedId)
            let addressModel = self.getAddress(for: selectedId)
            let company = self.getCompany(for: selectedId)

        let userDetailsVC = self.storyboard!.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsVC

            userDetailsVC.user = userModel
            userDetailsVC.address = addressModel
            userDetailsVC.company = company

            self.navigationController?.pushViewController(userDetailsVC, animated: true)

    }
}


extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text
        if text != "" {
            self.searchText = text
        }
        textField.resignFirstResponder()
        return true
    }
}

extension HomeViewController {
    
    func fetchUsers() -> [Users] {
        let allUsers = dbManager.fetch(Users.self)
        return allUsers
    }
    
    func fetchCompanies() -> [Company] {
        let allCompanies = dbManager.fetch(Company.self)
        return allCompanies
    }
    
     func getUserModel(for id: Int16) -> Users? {
        let users = dbManager.fetchPredicatedEntity(entity: Users.self, for: id)
        return users
    }
    
     func getAddress(for id: Int16) -> Address? {
        let address = dbManager.fetchPredicatedEntity(entity: Address.self, for: id)
        return address
    }
    
     func getCompany(for id: Int16) -> Company? {
        let company = dbManager.fetchPredicatedEntity(entity: Company.self, for: id)
        return company
    }

}
