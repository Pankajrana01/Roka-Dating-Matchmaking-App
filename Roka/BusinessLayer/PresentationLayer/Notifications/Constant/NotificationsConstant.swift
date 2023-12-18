//
//  NotificationsConstant.swift
//  Roka
//
//  Created by Pankaj Rana on 30/10/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var notifications: UIStoryboard {
        return UIStoryboard(name: "NotificationsViewController", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let notifications                     = "NotificationsViewController"
}

