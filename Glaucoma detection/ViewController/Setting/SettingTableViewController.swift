//
//  SettingTableViewController.swift
//  Glaucoma detection
//
//  Created by Abdelnasser on 12/02/2022.
//

import UIKit

class SettingTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        showInfo()
    }
    
    //MARK: -  OutLit
    
    @IBOutlet weak var userNameLable: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var appVersion: UILabel!
    
    //MARK: - OutLit Action
    
    @IBAction func editProfileBtn(_ sender: UIButton) {
    }
    
    
    @IBAction func logOutBtu(_ sender: UIButton) {
        FUserListner.shared.logOutCurrentUser { (error) in
            if error == nil{
                let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Login")
                DispatchQueue.main.async {
                    login.modalPresentationStyle = .fullScreen
                    self.present(login, animated: true, completion: nil)
                }
                
            }
        }
    }
    
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "Color TabelView")
        return headerView
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 10.0
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
          performSegue(withIdentifier: "edit", sender: self)
        }
    }

    
    //MARK: - Updata UI
   
   private func showInfo(){
    if let user = User.currentUser{
        userNameLable.text = user.username
         
        appVersion.text = "App Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
        if user.avatarLink != ""{
            FileStorage.downloadImage(imageUrl: user.avatarLink) { (avatarImage) in
                self.avatarImageView.image = avatarImage
                self.avatarImageView.cornerRadius = 40
            }
        }
    }
        
    }
    
    
    
}
