//
//  ReferConstant.swift
//  Roka
//
//  Created by Pankaj Rana on 31/10/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var referAndEarn: UIStoryboard {
        return UIStoryboard(name: "ReferAndEarnViewController", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let referAndEarn                     = "ReferAndEarnViewController"

}

