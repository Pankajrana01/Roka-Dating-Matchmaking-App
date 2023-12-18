//
//  HeightTableViewCell.swift
//  Roka
//
//  Created by Pankaj Rana on 18/10/22.
//

import UIKit

class HeightTableViewCell: UITableViewCell {
    @IBOutlet weak var titleOne: UILabel!
    @IBOutlet weak var titleOnedesc: UILabel!
    
    @IBOutlet weak var titleTwo: UILabel!
    @IBOutlet weak var titleTwodesc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
