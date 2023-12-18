//
//  BlockedUsersConstant.swift
//  Roka
//
//  Created by Pankaj Rana on 30/10/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var blockedUsers: UIStoryboard {
        return UIStoryboard(name: "BlockedUsersViewController", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let blockedUsers                     = "BlockedUsersViewController"
    static let contactUsers                     = "ContactsViewController"
}

extension StringConstants {
    static let blockUsersSuccess                       = "User blocked successfully"
    static let unblockUsersSuccess                     = "User unblocked successfully"
    
}
