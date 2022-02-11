//
//  Global Function.swift
//  Glaucoma detection
//
//  Created by Abdelnasser on 10/02/2022.
//

import Foundation
import  UIKit
import AVFoundation

func fileNameFrom(fileUrl:String)->String{
    let name = fileUrl.components(separatedBy: "-").last
    
    let name1 = name?.components(separatedBy: "?").first
    let name2 = name?.components(separatedBy: ".").first
    
    return name2!
}
