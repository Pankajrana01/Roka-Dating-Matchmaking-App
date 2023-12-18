//
//  AccountDetailsSecondTableViewCell.swift
//  Roka
//
//  Created by  Developer on 26/10/22.
//

import UIKit

class AccountDetailsSecondTableViewCell: UITableViewCell {
    
    // MARK: - Variables..
    static let identifier = "AccountDetailsSecondTableViewCell"

    var callBackForPublicProfile: (() ->())?
    var callBackForEditBasicInfo: (() ->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    @IBAction func editBasicInfo(_ sender: UIButton) {
        callBackForEditBasicInfo?()
    }
    // MARK: - Action for view profile as public button...
    @IBAction func viewProfileAsPublicClicked(_ sender: UIButton) {
        callBackForPublicProfile?()
    }
}
