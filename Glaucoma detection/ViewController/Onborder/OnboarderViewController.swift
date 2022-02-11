//
//  ViewController.swift
//  Glaucoma detection
//
//  Created by Abdelnasser on 16/11/2021.
//

import UIKit

class OnboarderViewController: UIViewController {
    
    //MARK: - Outlit
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var currentpageControl: UIPageControl!
    @IBOutlet weak var nextBtn: UIButton!
    
    //MARK: - Vars
    
    var slides:[Onborder] = []
    
    var currentPage = 0 {
        didSet {
            currentpageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                nextBtn.setTitle("Get Started", for: .normal)
            } else {
                nextBtn.setTitle("Next", for: .normal)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        slides = [
            Onborder(titel: "Vision Loss From Glaucoma Can be Slowed", description: "It's widely accepted that optic never damage caused by glaucoma is irrevsible.", image: #imageLiteral(resourceName: "images1")),
            Onborder(titel: "Performance Speed", description: "Speed and accuracy in the water to diagnose the disease in a short time.", image: #imageLiteral(resourceName: "image2")),
            Onborder(titel: "Glaucoma tests", description: "A group of tests that help diagnose glaucoma,aserious eye disease that can cause vision loss and blindness.", image: #imageLiteral(resourceName: "images3"))
            ]
            
        currentpageControl.numberOfPages = slides.count
   }

    
    //MARK: - Action
    
    @IBAction func nextBtn(_ sender: UIButton) {
        if currentPage == slides.count - 1 {
            let controller = storyboard?.instantiateViewController(identifier: "Home") as! UINavigationController
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .flipHorizontal
            UserDefaults.standard.hasOnboarded = true
            present(controller, animated: true, completion: nil)
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
}

extension OnboarderViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnborderCollectionViewCell.identifier, for: indexPath)as! OnborderCollectionViewCell
        
        cell.setup(slides[indexPath.row])
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
    
}

