//
//  EditeProfileTableViewController.swift
//  Glaucoma detection
//
//  Created by Abdelnasser on 12/02/2022.
//

import UIKit
import ProgressHUD
import Gallery

class EditeProfileTableViewController: UITableViewController, UITextFieldDelegate {
    
    

    var gallery:GalleryController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        showInfo()
        
        configerTextField()
    }
    
    
    //MARK: - OutLit
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userNameTextFiled: UITextField!
    
    
    //MARK: - OutLit Action
    
    @IBAction func chooseImageBtu(_ sender: UIButton) {
        showImageGallary()
        
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "Color TabelView")
        return headerView
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 || section == 1 ? 0.0 : 30.0
    }
    
    private func showInfo(){
        if let user = User.currentUser{
            userNameTextFiled.text = user.username
            
            if user.avatarLink != ""{
                FileStorage.downloadImage(imageUrl: user.avatarLink) { (avatarImage) in
                    self.avatarImage.image = avatarImage?.circleMasked
                }
            }
        }
        
    }
    
    
    //MARK: -  Gallary
    
    private func showImageGallary(){
        
        self.gallery = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow = [.cameraTab,.imageTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        
        self.present(gallery, animated: true, completion: nil)
        
    }
    
    
    //MARK: - Configer textFiled
    
    private func configerTextField(){
        userNameTextFiled.delegate = self
        userNameTextFiled.clearButtonMode = .whileEditing
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTextFiled{
            if textField.text != ""{
                if var user = User.currentUser{
                    user.username = textField.text!
                    saveUserLocally(user)
                    FUserListner.shared.saveUserToFireStore(user)
                }
            }
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    private func uploadAvatarImage(_ image:UIImage){
        let fileDirectory = "Avatars/" + "-\(User.currentId)" + ".jpg"
        
        FileStorage.uploadImage(image, directory: fileDirectory) { (avatarLink) in
            if var user = User.currentUser{
                user.avatarLink = avatarLink ?? ""
                saveUserLocally(user)
                FUserListner.shared.saveUserToFireStore(user)
            }
            
            FileStorage.saveFileLocally(fileData: image.jpegData(compressionQuality: 0.5)! as NSData, fileName: User.currentId)
        }
        
    }

}

extension EditeProfileTableViewController:GalleryControllerDelegate{
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        if images.count > 0{
            images.first?.resolve(completion: { (avatarImage) in
                if avatarImage != nil{
                    self.uploadAvatarImage(avatarImage!)
                    self.avatarImage.image = avatarImage
                }else{
                    ProgressHUD.showError("Could not select image")
                }
            })
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}

