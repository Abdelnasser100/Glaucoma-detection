//
//  HomeViewController.swift
//  Glaucoma detection
//
//  Created by Abdelnasser on 24/11/2021.
//

import UIKit
import SideMenu

class HomeViewController: UIViewController {

    //MARK: - Vars
    var menu:SideMenuNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menu = SideMenuNavigationController(rootViewController: MenuTableViewController())
        menu?.leftSide = true
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        SideMenuManager.default.leftMenuNavigationController = menu
            
    }
    

    @IBAction func sideMenu(_ sender: UIBarButtonItem) {
        present(menu!, animated: true, completion: nil)
    }
    

}
