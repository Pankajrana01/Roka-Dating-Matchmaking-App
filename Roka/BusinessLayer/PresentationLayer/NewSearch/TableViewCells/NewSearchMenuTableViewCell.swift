//
//  NewSearchMenuTableViewCell.swift
//  Roka
//
//  Created by  Developer on 16/11/22.
//

import UIKit

class NewSearchMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    static let identifier = "NewSearchMenuTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(model: SettingModel) {
        imageCell.image = UIImage(named: model.image)
        label.text = model.label
        // Name I am not change in because multiple check is handle on the basic of name So i do this.
        if model.label == "Age Range" {
            label.text = "Age"
        }
    }
}
