//
//  SuggestionConstant.swift
//  Roka
//
//  Created by Pankaj Rana on 30/10/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var suggestion: UIStoryboard {
        return UIStoryboard(name: "Suggestion", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let suggestion                     = "SuggestionViewController"

}

extension StringConstants {
    static let suggestionSubmit              = "Suggestion submitted successfully"
}
