//
//  User.swift
//  Glaucoma detection
//
//  Created by Abdelnasser on 09/02/2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct User:Codable,Equatable {
    var id = ""
    var username:String
    var email:String
    var pushid = ""
    var avatarLink = ""
    
    static var currentId:String{
        Auth.auth().currentUser!.uid
    }
    
    static var currentUser:User?{
        if Auth.auth().currentUser != nil{
            if let data = userDefult.data(forKey: kCURRENTUSER){
                
            let decoder = JSONDecoder()
            do{
                let userObject = try decoder.decode(User.self, from: data)
                return userObject
            }catch{
                print(error.localizedDescription)
            }
            }
        }
        return nil
    }
    
    
    static func == (lhs:User,rhs:User)->Bool{
        lhs.id == rhs.id
    }
    
}


func saveUserLocally(_ user:User){
    let encoder = JSONEncoder()
    do{
    let data = try encoder.encode(user)
    userDefult.setValue(data, forKey: kCURRENTUSER)
        
}catch{
    print(error.localizedDescription)
}

}



func createDummyUser(){
    
    let name = ["Ali","Ahmed"]

    var imageIndex = 1
    var userIndex = 1
    
    for i in 1..<2{
        let id = UUID().uuidString
        
        let fileDirectory = "Avatars/" + "_\(id)" + ".jpg"
        
        FileStorage.uploadImage(UIImage(named: "user\(imageIndex)")!, directory: fileDirectory) { (avaterLink) in
            
            let user = User(id: id, username: name[i], email: "user\(userIndex)@mail.com", pushid: "", avatarLink: avaterLink ?? "")
            
            userIndex += 1
            FUserListner.shared.saveUserToFireStore(user)
        }
        imageIndex += 1
        if imageIndex == 2{
            imageIndex = 1
        }
    }
    
}



