//
//  MatchMakingEditConstant.swift
//  Roka
//
//  Created by  Developer on 21/11/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var matchMakingEdit: UIStoryboard {
        return UIStoryboard(name: "MatchMakingEdit", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let matchMakingBasicInfoEdit                     = "MatchMakingEditBasicInfoViewController"
    static let matchMakingEdit                     = "MatchMakingEditViewController"
}
