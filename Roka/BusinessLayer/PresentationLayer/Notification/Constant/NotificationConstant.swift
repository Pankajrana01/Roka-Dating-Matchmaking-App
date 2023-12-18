//
//  NotificationConstant.swift
//  Roka
//
//  Created by Pankaj Rana on 14/10/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var notification: UIStoryboard {
        return UIStoryboard(name: "Notification", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let notification                     = "NotificationViewController"


}
