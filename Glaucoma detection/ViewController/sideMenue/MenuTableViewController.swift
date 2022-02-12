//
//  MenuTableViewController.swift
//  Glaucoma detection
//
//  Created by Abdelnasser on 12/02/2022.
//

import UIKit

class MenuTableViewController: UITableViewController {

    var data = ["Contact","Profile","about"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .systemYellow
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = data[indexPath.row]
        
        switch indexPath.row {
        case 0:
            cell.imageView?.image = UIImage(systemName: "person")
        case 1:
            cell.imageView?.image = UIImage(systemName: "pencil")
        case 2:
            cell.imageView?.image = UIImage(systemName: "exclamationmark.circle.fill")
        default:
            break
        }
        
        cell.backgroundColor = .systemYellow
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
          goToSetting()
        }
    }

    //MARK: - Do to setting
    
    private func goToSetting(){
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Setting")as! UINavigationController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
}
