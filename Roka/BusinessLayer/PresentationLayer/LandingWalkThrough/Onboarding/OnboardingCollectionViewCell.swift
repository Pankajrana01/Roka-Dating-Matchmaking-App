//
//  OnboardingCollectionViewCell.swift
//  Yummie
//
//  Created by Emmanuel Okwara on 30/01/2021.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: OnboardingCollectionViewCell.self)
    
    @IBOutlet weak var slideImageView: UIImageView!
    
    func setup(_ slide: OnboardingSlide) {
        slideImageView.image = slide.image
    }
}
