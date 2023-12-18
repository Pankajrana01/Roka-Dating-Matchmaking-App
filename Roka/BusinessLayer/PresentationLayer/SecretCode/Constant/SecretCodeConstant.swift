//
//  SecretCodeConstant.swift
//  Roka
//
//  Created by Pankaj Rana on 20/09/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var secret: UIStoryboard {
        return UIStoryboard(name: "Signup", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let secret                      = "SecretCodeViewController"
}

extension ValidationError{
    static let invalidOtp = "This OTP is invalid"
    static let emptyOtp = "OTP can not be empty."
    static let invalidCode = "This Code is invalid"
    static let emptyCode = "Code can not be empty."
}
