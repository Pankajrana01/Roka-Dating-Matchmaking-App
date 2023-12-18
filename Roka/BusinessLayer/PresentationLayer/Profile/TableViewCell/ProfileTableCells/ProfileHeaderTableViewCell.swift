//
//  ProfileHeaderTableViewCell.swift
//  Roka
//
//  Created by  Developer on 20/10/22.
//

import UIKit

class ProfileHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var forwordButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPhoneNumber: UILabel!
    @IBOutlet weak var buttonKYCNotVerified: UIButton!
    @IBOutlet weak var buttonEditProfile: UIButton!
    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var myProfileButtonWidth: NSLayoutConstraint!
    
    var callBackForVerifyKyc: (() ->())?
    var callBackForEditProfile: (() ->())?
    
    static let identifier = "ProfileHeaderTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
    @IBAction func buttonKYCNotVerifiedPressed(_ sender: Any) {
        callBackForVerifyKyc?()
    }
    
    @IBAction func buttonEditProfilePressed(_ sender: Any) {
        callBackForEditProfile?()
    }
    

}
