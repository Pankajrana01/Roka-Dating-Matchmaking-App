//
//  LoginConstant.swift
//  Roka
//
//  Created by Pankaj Rana on 19/09/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var login: UIStoryboard {
        return UIStoryboard(name: "Login", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let login                      = "LoginViewController"
}

extension ValidationError{
    static let selectCountryCode          = "Please select country code."
    static let invalidPhoneNumber         = "Phone Number length should be 10 digits long."
    static let invalidPhoneNumberWithZero = "Phone Number length should be in between 7 to 16 digits long."
    static let invalidPhoneNumberWithZeroStart = "Phone Number cannot start with 0."
    static let groupName                   = "Please add group name."
    static let addMember                   = "Please select atleast one member."
    static let checkTermsAndPrivacy        = "Please accept the terms & conditions and privacy policy."
}
