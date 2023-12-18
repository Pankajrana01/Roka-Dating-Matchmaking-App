//
//  BasicInfoConstant.swift
//  Roka
//
//  Created by Pankaj Rana on 21/09/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var basicInfo: UIStoryboard {
        return UIStoryboard(name: "BasicInfo", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let basicInfo                      = "BasicInfoViewController"
    static let recoveryEmail                  = "RecoveryEmailViewController"
    static let locationSearch                  = "SearchLocationVC"
}

extension ValidationError{
    
}
