//
//  NewSearchConstant.swift
//  Roka
//
//  Created by  Developer on 02/11/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var newSearch: UIStoryboard {
        return UIStoryboard(name: "NewSearch", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let newSearch                     = "NewSearchViewController"

}

extension StringConstants {
    static let newSearch                     = "New filter"
    static let editPreferences               = "Edit filter"
}
