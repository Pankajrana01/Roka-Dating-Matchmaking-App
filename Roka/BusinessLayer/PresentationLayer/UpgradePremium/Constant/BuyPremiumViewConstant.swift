//
//  BuyPremiumViewConstant.swift
//  Roka
//
//  Created by Pankaj Rana on 29/10/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var buyPremium: UIStoryboard {
        return UIStoryboard(name: "BuyPremiumViewController", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let BuyPremium                     = "BuyPremiumViewController"
    static let mySubscription                 = "SubscriptionViewController"

}
