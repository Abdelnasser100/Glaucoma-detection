//
//  FUserListner.swift
//  Glaucoma detection
//
//  Created by Abdelnasser on 10/02/2022.
//

import Foundation
import  Firebase

class FUserListner {
    
    static let shared = FUserListner()
    private init(){}
    
    //MARK: - Login
    
    func loginUserWith(email:String,password:String,complation:@escaping(_ error:Error?,_ isEmailVerified:Bool)->Void){
    
        Auth.auth().signIn(withEmail: email, password: password){(authResult,error)in
            
            if error == nil && authResult!.user.isEmailVerified {
                complation(error,true)
                self.downloadUserFromFireStore(userId: authResult!.user.uid)
                
            }else{
                complation(error,false)
            }
        }
    
    }
    
    //MARK: - Regester
    
    func regesterUserwith(email:String,password:String,complation:@escaping(_ error:Error?)->Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            
            complation(error)
            
            if error == nil {
                authResult?.user.sendEmailVerification { (error) in
                    complation(error)
                }
            }
            
            if authResult?.user != nil {
                
                let user = User(id: authResult!.user.uid, username: email, email: email, pushid: "", avatarLink: "")
                
                self.saveUserToFireStore( user)
                saveUserLocally(user)
            }
        }
    }
    
    
    //MARK: - LogOut
    
    func logOutCurrentUser(complation:@escaping(_ error:Error?)->Void){
        do{
            try Auth.auth().signOut()
            userDefult.removeObject(forKey: kCURRENTUSER)
            userDefult.synchronize()
            complation(nil)
            
        }catch{
            complation(error)
        }
    }
    
    
    //MARK: - Resend link verficiation function
    
    func resendVerificationEmailWith(email:String,complation:@escaping(_ error:Error?)->Void){
        Auth.auth().currentUser?.reload(completion: {(error)in
        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
            complation(error)
        })
    })
    }
    
    //MARK: - Reset password
    
    func resetPasswordFor(email:String,complation:@escaping(_ error:Error?)->Void){
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            complation(error)
        }
    }
    
    
    func saveUserToFireStore(_ uesr:User){
        do{
            try firestoreRefrence(.User).document(uesr.id).setData(from: uesr)
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    
    
    //MARK: - Download User From FireStore
    
    private func downloadUserFromFireStore(userId:String){
        
        firestoreRefrence(.User).document(userId).getDocument{(docoment, error) in
            guard let userdocument = docoment else{
                print("no data found")
                return
            }
            
            let result = Result{
                try? userdocument.data (as:User.self)
            }
            
            switch result{
            case .success(let userObject):
                if let user = userObject{
                    saveUserLocally(user)
                }else{
                    print("Document Dos't exist")
                }
            case .failure(let error):
                print("error decoding user", error.localizedDescription)
            }
            
        }
    }
    
    
    
    //MARK: - Download users using IDs
    
    func downloadUsersFromFirestore(withIds:[String],complation:@escaping(_ allUsers:[User])->Void){
        
        var count = 0
        var userArray:[User] = []
        
        for userId in withIds{
            firestoreRefrence(.User).document(userId).getDocument { (quarySnapshot, error) in
                guard let document = quarySnapshot else{
                    return
                }
                let user = try? document.data(as: User.self)
                
                userArray.append(user!)
                count+=1
                
                if count == withIds.count{
                    complation(userArray)
                }
            }
        }
    }
    
    
    
    //MARK: - Download All User from FireStore
    
    
    func downloadAllUsersFromFireStore(complation:@escaping(_ allUsers:[User])->Void){
        
        var users:[User] = []
        
        
        firestoreRefrence(.User).getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else{
                print("No Document Found")
                return
            }
            
            let allUsers = documents.compactMap { (snapshot) -> User? in
                return try? snapshot.data(as: User.self)
            }
            
            for user in allUsers{
                if User.currentId != user.id{
                    users.append(user)
                }
            }
            
            complation(users)
        }
        
    }
    
    
}
