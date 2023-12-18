//
//  MatchMakingBasicInfoConstant.swift
//  Roka
//
//  Created by Pankaj Rana on 21/11/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var matchMakingBasicInfo: UIStoryboard {
        return UIStoryboard(name: "MatchMakingBasicInfo", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let matchMakingBasicInfoController      = "MatchMakingBasicInfoController"
    static let matchMakingPlaceholderController    = "MatchMakingPlaceholderController"
}

extension CollectionViewNibIdentifier {
    static let placeholderNib              = "PlaceholderCollectionViewCell"
}
extension CollectionViewCellIdentifier {
    static let placeholderCell             = "PlaceholderCollectionViewCell"

}
