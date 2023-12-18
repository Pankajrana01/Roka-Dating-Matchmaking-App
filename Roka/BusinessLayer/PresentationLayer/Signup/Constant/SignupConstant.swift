//
//  SignupConstant.swift
//  Roka
//
//  Created by Pankaj Rana on 20/09/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var signup: UIStoryboard {
        return UIStoryboard(name: "Signup", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let signup                      = "SignupViewController"
}

extension ValidationError{
    
}
