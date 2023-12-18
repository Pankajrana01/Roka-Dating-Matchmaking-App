//
//  ProfileConstant.swift
//  Roka
//
//  Created by Pankaj Rana on 10/10/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var profile: UIStoryboard {
        return UIStoryboard(name: "Profile", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let profile                     = "ProfileViewController"


}

extension StringConstants {
    static let sentforVerification         = "Sent for verification "
 //   static let KYCPending                  = "KYC pending "
    static let KYCPending                  = "Video verification "
    static let KYCVerified                 = "Video verified "
    static let KYCRejected                 = "KYC rejected "
}
