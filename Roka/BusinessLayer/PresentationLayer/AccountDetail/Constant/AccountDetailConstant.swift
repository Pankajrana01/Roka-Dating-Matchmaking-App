//
//  AccountDetailConstant.swift
//  Roka
//
//  Created by Pankaj Rana on 29/10/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var accountDetails: UIStoryboard {
        return UIStoryboard(name: "AccountDetailsViewController", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let accountDetails                     = "AccountDetailsViewController"


}
