//
//  GalleryImagesCollectionViewCell.swift
//  Roka
//
//  Created by Pankaj Rana on 01/11/22.
//

import UIKit

class GalleryImagesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewBottomConstant: NSLayoutConstraint!
    
    @IBOutlet weak var setDpView: UIView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var centerImage: UIImageView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var inappLabel: UILabel!
    @IBOutlet weak var dpView: UIView!
    @IBOutlet weak var setAsDPButton: UIButton!
    @IBOutlet weak var bottomDPView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
