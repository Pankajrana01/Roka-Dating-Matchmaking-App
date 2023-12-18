//
//  SelectUserProfileConstant.swift
//  Roka
//
//  Created by Pankaj Rana on 21/09/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var selectUserProfile: UIStoryboard {
        return UIStoryboard(name: "SelectUserProfile", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let selectUserProfile            = "SelectUserProfileViewController"
    static let selctionMode                 = "SelectionModeViewController"
}

extension TableViewCellIdentifier{
    static let userProfileCell              = "UserProfileTableViewCell"
}

extension TableViewNibIdentifier {
    static let userProfileNib               = "UserProfileTableViewCell"
}

extension CollectionViewCellIdentifier{
    static let userProfileCell              = "UserProfileCollectionViewCell"
}

extension CollectionViewNibIdentifier {
    static let userProfileNib               = "UserProfileCollectionViewCell"
}


