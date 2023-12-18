//
//  SocialTableCell.swift
//  Roka
//
//  Created by ios on 10/10/23.
//

import UIKit

class SocialTableCell: UITableViewCell {

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
