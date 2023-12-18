//
//  MacthMakingEditTableViewCell.swift
//  Roka
//
//  Created by  Developer on 21/11/22.
//

import UIKit

class MacthMakingEditTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    static let identifier = "MacthMakingEditTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func configure(indexPath: Int) {
        switch indexPath {
        case 0:
            self.label.text = "Edit basic Info"
        case 1:
            self.label.text = "Edit profile Image"
        case 2:
            self.label.text = "Edit preferences"
        case 3:
            self.label.text = "Delete profile"
        default:
            break
        }
    }
}
