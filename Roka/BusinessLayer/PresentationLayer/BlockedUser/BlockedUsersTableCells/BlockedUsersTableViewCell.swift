//
//  BlockedUsersTableViewCell.swift
//  Roka
//
//  Created by  Developer on 24/10/22.
//

import UIKit

class BlockedUsersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var labelProfileName: UILabel!
    @IBOutlet weak var buttonUnblock: UIButton!
    
    static let identifier = "BlockedUsersTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configure(model: BlockedUsersModel, isBlocked: Bool) {
        profileImage.image = UIImage(named: model.image)
        labelProfileName.text = model.name
        if isBlocked {
            buttonUnblock.setTitle("Unblock", for: .normal)
        } else {
            buttonUnblock.setTitle("Block", for: .normal)
        }
    }
    
}
