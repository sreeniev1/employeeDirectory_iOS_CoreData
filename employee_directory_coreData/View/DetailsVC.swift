//
//  DetailsVC.swift
//
//  Created by Sreeni E V on 16/09/22.
//

import UIKit
import SDWebImage

class DetailsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var userPhoto: UIImageView!
    var user: Users?
    var address: Address?
    var company: Company?
    
    var titleArray = ["Name","Username","Email","Address","Phone","Website","Company"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeUi()
        
    }
    
    func initializeUi() {
        navigationItem.title = user?.name
        userPhoto.layer.borderWidth = 2
        userPhoto.layer.borderColor = UIColor.lightGray.cgColor
        userPhoto.layer.cornerRadius = userPhoto.frame.height/2
        userPhoto.clipsToBounds = true
        if let img = user?.profileImage {
            userPhoto.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named: "user.jpeg"))
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            
            self.userPhoto.transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5)
            
        }) { (finished) in
            UIView.animate(withDuration: 0.5, animations: {
                
                self.userPhoto.transform = CGAffineTransform.identity
                
            })
        }
    }
}

extension DetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        cell.textLabel?.text = titleArray[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
        cell.detailTextLabel?.text = "-"
        
        switch indexPath.row {
            
        case 0:
            
            cell.detailTextLabel?.text = user?.name
            return cell
            
        case 1:
            cell.detailTextLabel?.text = user?.userName
            return cell
            
        case 2:
            
            cell.detailTextLabel?.text = user?.email
            return cell
            
        case 3:
            
            if let address = address {
                let city = address.city ?? ""
                let street = address.street ?? ""
                let zip = address.zip ?? ""
                
                let full = "\(city),\(street),\(zip)"
                
                cell.detailTextLabel?.text = full
            }
            return cell
        case 4:
            cell.detailTextLabel?.text = user?.phone
            return cell
        case 5:
            cell.detailTextLabel?.text = user?.website
            return cell
        case 6:
            
            
            if let company = company {
                let name = company.name ?? ""
                let catchPhrase = company.catchPhrase ?? ""
                let bs = company.bs ?? ""
                
                let full = "\(name),\(catchPhrase),\(bs)"
                
                cell.detailTextLabel?.text = full
            }
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}
