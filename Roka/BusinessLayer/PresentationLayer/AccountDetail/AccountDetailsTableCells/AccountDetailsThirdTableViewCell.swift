//
//  AccountDetailsThirdTableViewCell.swift
//  Roka
//
//  Created by  Developer on 26/10/22.
//

import UIKit

class AccountDetailsThirdTableViewCell: UITableViewCell {

    // MARK: - IBOutlets..
    @IBOutlet weak var buttonTwitter: UIButton!
    @IBOutlet weak var buttonInstagram: UIButton!
    @IBOutlet weak var buttonLinkedIn: UIButton!
    
    @IBOutlet weak var buttonCrossTwitter: UIButton!
    @IBOutlet weak var buttonCrossInstagram: UIButton!
    @IBOutlet weak var buttonCrossLinkedIn: UIButton!
    
    // MARK: - Variables..
    static let identifier = "AccountDetailsThirdTableViewCell"
    var callBackForSocialMediaButtons: ((_ index: Int) -> ())?
    var callBackForRemoveSocialMediaButtons: ((_ index: Int) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    // MARK: - Action for social media buttons...
    @IBAction func socialMediaButtonsClicked(_ sender: UIButton) {
        callBackForSocialMediaButtons?(sender.tag)
    }
    
    // MARK: - Action for cross buttons...
    @IBAction func crossButtonsClicked(_ sender: UIButton) {
        callBackForRemoveSocialMediaButtons?(sender.tag)
    }
}
