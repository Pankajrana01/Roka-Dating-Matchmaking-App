//
//  ShareConstant.swift
//  Roka
//
//  Created by Pankaj Rana on 14/10/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var share: UIStoryboard {
        return UIStoryboard(name: "Share", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let share                     = "ShareViewController"


}

extension TableViewCellIdentifier {
    static let shareCell                    = "shareTableViewCell"

}
