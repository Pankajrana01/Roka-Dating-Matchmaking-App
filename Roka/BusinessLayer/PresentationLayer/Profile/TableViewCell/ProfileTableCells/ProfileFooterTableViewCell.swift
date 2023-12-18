//
//  ProfileFooterTableViewCell.swift
//  Roka
//
//  Created by  Developer on 20/10/22.
//

import UIKit

class ProfileFooterTableViewCell: UITableViewCell {
    @IBOutlet weak var deleteAccountButton: UIButton!
    @IBOutlet weak var versionButton: UIButton!
    @IBOutlet weak var buttonLogout: UIButton!
    @IBOutlet weak var deactivateButton: UIButton!
    
    // Callback for logout button click.
    var onLogoutClick: (() -> ())?
    var onDeleteAccountClick: (() -> ())?
    var onDeActivateAccountClick: (() -> ())?
    
    static let identifier = "ProfileFooterTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.versionButton.setTitle("Version: \(appVersion)", for: .normal)
        }
    }
    
    @IBAction func deactivateButtonAction(_ sender: UIButton) {
        onDeActivateAccountClick?()
    }
    
    @IBAction func deleteAccount(_ sender: UIButton) {
        onDeleteAccountClick?()
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        onLogoutClick?()
    }
}
