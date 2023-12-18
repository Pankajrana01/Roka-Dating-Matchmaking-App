//
//  GalleryCollectionViewCell.swift
//  iOS-Testing
//
//  Created by Pankaj Rana on 18/10/22.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var imageCaption: UILabel!
    var userImage: ProfilesImages! { didSet { userImageDidSet() } }
    
    func userImageDidSet() {
        let urlstring = userImage.file ?? ""
        let trimmedString = urlstring.replacingOccurrences(of: " ", with: "%20")
        
        backImageView.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + trimmedString)), placeholderImage: #imageLiteral(resourceName: "Avatar"), completed: nil)
        
        imageCaption.text = userImage.title
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
