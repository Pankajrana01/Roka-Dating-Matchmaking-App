//
//  AddMoreDetailTableViewCell.swift
//  Roka
//
//  Created by Pankaj Rana on 06/10/22.
//

import UIKit

class AddMoreDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var subTitle: UILabel!
    
    var title: String! { didSet { titleDidSet() } }
    var subtitle: String! { didSet { subTitleDidSet() } }
    var image: UIImage! { didSet { imageDidSet() } }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func titleDidSet() {
        titleLabel.text = title
    }
    
    func subTitleDidSet() {
        subTitle.text = subtitle
    }
    
    func imageDidSet() {
        titleImage.image = image
    }
    
}
