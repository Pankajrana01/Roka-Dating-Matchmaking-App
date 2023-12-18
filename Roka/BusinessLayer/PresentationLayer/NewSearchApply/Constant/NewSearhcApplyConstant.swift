//
//  NewSearhcApplyConstant.swift
//  Roka
//
//  Created by  Developer on 04/11/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var newSearchApply: UIStoryboard {
        return UIStoryboard(name: "NewSearchApply", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let newSearchApply                     = "NewSearchApplyViewController"
}

extension StringConstants {
    static let savetitleCantEmpty                 = "Please enter preference title first"
    static let savedSuccessfully                  = "Preferences saved successfully"
    static let editSuccessfully                   = "Preferences edit successfully"
}
