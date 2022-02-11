//
//  OnborderCollectionViewCell.swift
//  Glaucoma detection
//
//  Created by Abdelnasser on 16/11/2021.
//

import UIKit

class OnborderCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: OnborderCollectionViewCell.self)
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titelLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func setup(_ slide:Onborder) {
        
        imageView.image = slide.image
        titelLabel.text = slide.titel
        descriptionLabel.text = slide.description
    }
    
}
