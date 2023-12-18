//
//  MoreDetailConstant.swift
//  Roka
//
//  Created by Pankaj Rana on 06/10/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var moreDetail: UIStoryboard {
        return UIStoryboard(name: "MoreDetail", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let moreDetail                     = "MoreDetailViewController"
    static let detailPageController           = "DetailPagerController"


}

extension StringConstants {
    static let moreProfileDetails             = "  More profile details"
    static let editAboutPreferences           = "  Edit about & preferences"
    static let savedProfiles                  = "Saved Profiles"
}


extension TableViewNibIdentifier {
    static let addMoreDetailCell              = "AddMoreDetailTableViewCell"
}

extension TableViewCellIdentifier {
    static let addMoreDetailCell              = "AddMoreDetailTableViewCell"
}
