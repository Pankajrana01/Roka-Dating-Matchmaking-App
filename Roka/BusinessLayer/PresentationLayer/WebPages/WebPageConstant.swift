//
//  WebPageConstant.swift
//  Roka
//
//  Created by Pankaj Rana on 30/10/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var webPages: UIStoryboard {
        return UIStoryboard(name: "WebPages", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let webPage                     = "WebPageViewController"


}
