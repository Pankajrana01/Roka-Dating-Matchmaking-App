//
//  MatchMakingProfileTabConstant.swift
//  Roka
//
//  Created by Pankaj Rana on 25/11/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var matchMakingProfileTab: UIStoryboard {
        return UIStoryboard(name: "MatchMakingProfileTab", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let matchMakingProfileTab                     = "MatchMakingProfileTabViewController"
}
