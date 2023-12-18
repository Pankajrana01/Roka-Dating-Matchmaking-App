//
//  TabBarConstant.swift
//  Roka
//
//  Created by Pankaj Rana on 23/09/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var tabBar: UIStoryboard {
        return UIStoryboard(name: "TabBar", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let tabBar              = "TabBarController"
}
