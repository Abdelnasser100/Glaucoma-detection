//
//  FCollectionRefrence.swift
//  Glaucoma detection
//
//  Created by Abdelnasser on 10/02/2022.
//

import Foundation
import Firebase

enum FCollectionRefrence:String {
    case User
    
}


func firestoreRefrence(_ collectionRefrence:FCollectionRefrence)->CollectionReference{
    
    return Firestore.firestore().collection(collectionRefrence.rawValue)
}
