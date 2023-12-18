//
//  WalkThroughConstat.swift
//  Roka
//
//  Created by Pankaj Rana on 19/09/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var walkthrough: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let walkthrough                      = "WalkThroughViewController"
}

