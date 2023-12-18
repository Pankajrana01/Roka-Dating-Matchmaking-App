//
//  SearchDetailsConstant.swift
//  Roka
//
//  Created by  Developer on 10/11/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var searchDetails: UIStoryboard {
        return UIStoryboard(name: "SearchDetails", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let searchDetails                     = "SearchDetailsViewController"
    static let searchDetailsPager                = "SearchDetailsPagerController"

}

extension CollectionViewNibIdentifier {
    static let gridNib                           = "GridCollectionViewCell"
    static let fullNib                           = "FullViewCollectionViewCell"
    static let listNib                           = "SearchCollectionViewCell"
    static let FilterGridNib                     = "FilterGridCollectionViewCell"

}


extension CollectionViewCellIdentifier {
    static let gridCell                          = "GridCollectionViewCell"
    static let fullCell                          = "FullViewCollectionViewCell"
    static let listCell                          = "SearchCollectionViewCell"
    static let FilterGridCell                    = "FilterGridCollectionViewCell"

}
