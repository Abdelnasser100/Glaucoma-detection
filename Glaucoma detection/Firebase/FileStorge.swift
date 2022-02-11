//
//  FileStorge.swift
//  Glaucoma detection
//
//  Created by Abdelnasser on 10/02/2022.
//

import Foundation
import UIKit
import ProgressHUD
import FirebaseStorage

let storage = Storage.storage()

class FileStorage {
    
    //MARK: - Image
    
    class func uploadImage(_ image:UIImage,directory:String,complation:@escaping(_ documentLink:String?)->Void){
        
        // 1-Create Folder in Firebase
        
        let storageRef = storage.reference(forURL: kFILEREFRENCE).child(directory)
        
        // 2-Convert Image to data
        
        let imageData = image.jpegData(compressionQuality: 0.5)
        
        // 3-Put the data into fireStore and retern the link
        
        var task:StorageUploadTask!
        
        task = storageRef.putData(imageData!,metadata:nil,completion:{(metaData,error)in
            task.removeAllObservers()
            ProgressHUD.dismiss()
            
            if error != nil{
                print("Error Uploading Image \(error!.localizedDescription)")
                return
            }
            storageRef.downloadURL { (url, error) in
                guard let download = url else{
                    complation(nil)
                    return
                }
                complation(download.absoluteString)
            }
            
        })
        
        // 4-Observe percentage upload
        
        task.observe(StorageTaskStatus.progress) { (snapshot) in
            let progress = snapshot.progress!.completedUnitCount/snapshot.progress!.totalUnitCount
            
            ProgressHUD.showProgress(CGFloat(progress))
        }
    }




class func downloadImage(imageUrl:String,complation:@escaping(_ image:UIImage?)->Void){
    let imageFileName = fileNameFrom(fileUrl: imageUrl)
    
    if fileExistsAtPath(path: imageFileName){
        if let contentsOfFile = UIImage(contentsOfFile: fileInDecomentDirectory(fileName: imageFileName)){
            complation(contentsOfFile)
        }else{
            print("Could not convert local image")
            complation(UIImage(named:"icon")!)
        }
    }
    else{
        if imageUrl != ""{
            let docomentUrl = URL(string: imageUrl)
            let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
            
            downloadQueue.async {
                let data = NSData(contentsOf: docomentUrl!)
                if data != nil{
                    FileStorage.saveFileLocally(fileData: data!, fileName: imageFileName)
                    DispatchQueue.main.async {
                        complation(UIImage(data: data! as Data))
                    }
                }else{
                    print("no document found in database")
                    complation(nil)
                }
            }
        }
    }
}
    
    
    
    //MARK: - save file Localy
    
    class func saveFileLocally(fileData:NSData,fileName:String){
        let docUrl = getDocumentUrl().appendingPathComponent(fileName,isDirectory: false)
        fileData.write(to: docUrl, atomically: true)
    }
}


// helper function

func getDocumentUrl()->URL{
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
}

func fileInDecomentDirectory(fileName:String)->String{
    return getDocumentUrl().appendingPathComponent(fileName).path
}


func fileExistsAtPath(path:String)->Bool{
    return FileManager.default.fileExists(atPath: fileInDecomentDirectory(fileName: path))
}
