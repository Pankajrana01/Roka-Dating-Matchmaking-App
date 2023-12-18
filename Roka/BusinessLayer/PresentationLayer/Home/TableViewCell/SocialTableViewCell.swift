//
//  SocialTableViewCell.swift
//  Roka
//
//  Created by Pankaj Rana on 18/10/22.
//

import UIKit

class SocialTableViewCell: UITableViewCell {

    @IBOutlet weak var socialLabelTitle: UILabel!
    @IBOutlet weak var linkedInImage: UIImageView!
    @IBOutlet weak var instagramImage: UIImageView!
    @IBOutlet weak var twitterImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
