//
//  MatchingTabBarConstant.swift
//  Roka
//
//  Created by Pankaj Rana on 21/11/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var matchingTabBar: UIStoryboard {
        return UIStoryboard(name: "MatchingTabBar", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let matchingTabBar              = "MatchingTabBar"
}
