//
//  CongratulationViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 31/10/22.
//

import Foundation
import UIKit

class CongratulationViewModel: BaseViewModel {
    var isComeFor = ""
    var completionHandler: ((Bool) -> Void)?
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    
    
    func proceedForHome() {
        KAPPDELEGATE.updateRootController(TabBarController.getController(),
                                          transitionDirection: .fade,
                                          embedInNavigationController: true)
    }
    
}

