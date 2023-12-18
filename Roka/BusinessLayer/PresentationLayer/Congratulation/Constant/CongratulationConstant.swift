//
//  CongratulationConstant.swift
//  Roka
//
//  Created by Pankaj Rana on 31/10/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var congratulation: UIStoryboard {
        return UIStoryboard(name: "CongratsViewController", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let congratulation                     = "CongratsViewController"

}

