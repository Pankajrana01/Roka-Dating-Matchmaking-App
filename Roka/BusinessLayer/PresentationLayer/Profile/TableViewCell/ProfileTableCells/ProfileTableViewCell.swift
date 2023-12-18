//
//  ProfileTableViewCell.swift
//  Roka
//
//  Created by  Developer on 19/10/22.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var labelCell: UILabel!
    @IBOutlet weak var buttonForward: UIButton!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var widthButtonForward: NSLayoutConstraint!
    
    static let identifier = "ProfileTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(model: SettingModel) {
        imageCell.image = UIImage(named: model.image)
        labelCell.text = model.label
        buttonForward.isHidden = !model.isForward
        widthButtonForward.constant = model.isForward ? 18 : 0
        viewLine.isHidden = !model.isLine
    }
    
}
