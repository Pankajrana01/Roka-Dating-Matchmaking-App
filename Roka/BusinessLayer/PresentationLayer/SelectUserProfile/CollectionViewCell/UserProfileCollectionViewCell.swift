//
//  UserProfileCollectionViewCell.swift
//  Roka
//
//  Created by Pankaj Rana on 21/09/22.
//

import UIKit

class UserProfileCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var pageView: UIPageControl!

    var title: String! { didSet { titleDidSet() } }
    var desc: String! { didSet { descDidSet() } }
    var image: String! { didSet { imageDidSet() } }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        pageView.numberOfPages = 3
        pageView.currentPage = 0
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
    }
    
    func titleDidSet() {
        titleLabel.text = title
    }
    func descDidSet() {
        descLabel.text = desc
    }
    func imageDidSet() {
        profileImage.image = UIImage(named: image)
    }

}
