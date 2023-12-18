//
//  PendingKYCViewModel.swift
//  Roka
//
//  Created by  Developer on 03/01/23.
//

import Foundation
import UIKit

class PendingKYCViewModel: BaseViewModel {
    var isComeFor = ""
    var completionHandler: ((String) -> Void)?
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    
    func proceedForVerifyKycScreen() {
        KAPPDELEGATE.updateRootController(StepFourViewController.getController(with: "KYC_DECLINE_PUSH"), transitionDirection: .toRight, embedInNavigationController: true)
    }
}
