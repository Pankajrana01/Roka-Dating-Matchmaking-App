//
//  SavedProfilesConstant.swift
//  Roka
//
//  Created by Pankaj Rana on 29/10/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var savedProfiles: UIStoryboard {
        return UIStoryboard(name: "SavedProfiles", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let savedProfiles                     = "SavedProfilesViewController"
    static let savedProfilesPager                = "SavedProfilePagerController"

}

extension TableViewCellIdentifier {

}
