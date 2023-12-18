//
//  Search.swift
//  Roka
//
//  Created by Pankaj Rana on 14/10/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var search: UIStoryboard {
        return UIStoryboard(name: "Search", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let search                     = "SearchViewController"

}

extension StringConstants {
    static let deletedSuccessfully         = "Deleted successfully"
}
