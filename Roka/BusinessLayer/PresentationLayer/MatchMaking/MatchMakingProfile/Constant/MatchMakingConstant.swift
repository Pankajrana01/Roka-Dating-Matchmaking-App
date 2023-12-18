//
//  MatchMakingConstant.swift
//  Roka
//
//  Created by  Developer on 21/11/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var matchMaking: UIStoryboard {
        return UIStoryboard(name: "MatchMakingProfile", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let matchMaking                     = "MatchMakingViewController"
    static let skipBrowse                      = "SkipBrowseViewController"
}

extension StringConstants {}
