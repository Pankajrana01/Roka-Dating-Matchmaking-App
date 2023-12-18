//
//  SaveProfileConstant.swift
//  Roka
//
//  Created by  Developer on 11/11/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var saveProfile: UIStoryboard {
        return UIStoryboard(name: "SaveProfile", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let saveProfile                     = "SaveProfileViewController"
    static let Successful                     = "SuccessfulViewController"

}

extension StringConstants {
    static let savedProfileSuccess              = "User Profile saved successfully"
    static let unsavedProfileSuccess            = "User Profile unsaved successfully"
}
