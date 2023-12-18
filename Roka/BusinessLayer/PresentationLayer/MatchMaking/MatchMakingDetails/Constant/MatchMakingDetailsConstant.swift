//
//  MatchMakingDetailsConstant.swift
//  Roka
//
//  Created by  Developer on 05/12/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var matchMakingDetails: UIStoryboard {
        return UIStoryboard(name: "MatchMakingDetails", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let matchMakingDetails                     = "MatchMakingDetailsViewController"
    static let matchMakingDetailsPager                = "MatchMakingDetailsPagerController"

}

extension StringConstants {
    static let matchMakingDetails                  = "Profiles for "
    static let emptyChoosenByMe                    = "You haven’t chosen anyone yet!"
    static let emptySuggested                      = "You don't have any suggestions yet!"
}
