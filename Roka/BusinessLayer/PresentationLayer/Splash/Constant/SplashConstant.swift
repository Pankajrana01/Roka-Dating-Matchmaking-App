//
//  SplashConstant.swift
//  Roka
//
//  Created by Pankaj Rana on 19/09/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var splash: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let splash                      = "SplashViewController"
    static let welcome                     = "WelcomeViewController"
}

extension StringConstants {
    static let termsOfServices             = "Terms of Services"
}
