//
//  AccountDetailsFirstTableViewCell.swift
//  Roka
//
//  Created by  Developer on 26/10/22.
//

import UIKit

class AccountDetailsFirstTableViewCell: UITableViewCell {

    // MARK: - IBOutlets..
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPhoneNumber: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var imageError: UIImageView!
    
    // MARK: - Variables..
    static let identifier = "AccountDetailsFirstTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
}
