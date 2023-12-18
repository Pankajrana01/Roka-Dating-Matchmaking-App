//
//  WelcomeViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 18/07/23.
//

import Foundation
import UIKit

class WelcomeViewModel: BaseViewModel {
    var user = UserModel.shared.user
    
    func proceedToLoginScreen() {
        let contorller = LoginViewController.getController()
        contorller.show(from: self.hostViewController)
    }
    
    func proceedToRegisterScreen() {
        let contorller = SignupViewController.getController()
        contorller.show(from: self.hostViewController)
    }
    
    func proceedToModeSelectionScreen() {
        let contorller = SelectionModeViewController.getController()
        contorller.show(from: self.hostViewController)
    }

    // MARK: - API Call...
    func processForGetVersionData() {
        ApiManager.makeApiCall(APIUrl.BasicApis.appVersion + "?platform=IOS",
                               headers: nil,
                               method: .get) { response, _ in
            if !self.hasErrorIn(response) {
                if let responseData = response![APIConstants.data] as? [String: Any] {
                    if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                        
                        if responseData["version"] as? String != appVersion {
                            if Double(responseData["minimumVersion"] as? String ?? "0") ?? 0.0 > Double(appVersion) ?? 0.0 {
                                self.showAlertForVersionUpgrade(forceUpdate: true)
                            } else {
                                self.showAlertForVersionUpgrade(forceUpdate: false)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func showAlertForVersionUpgrade(forceUpdate: Bool) {
        let alert = UIAlertController(title: "Update Roka", message: "Roka recommends that you update to the latest version for a seamless &  enhanced performance of the app.", preferredStyle: .alert)
//
//        let imgTitle = UIImage(named:"applifyLogo")
//        let imgViewTitle = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
//        imgViewTitle.image = imgTitle
//
//        alert.view.addSubview(imgViewTitle)
        
        if forceUpdate == false {
            alert.addAction(UIAlertAction(title: "NO THANKS", style: .default, handler: { _ in
                }))
        }
        
        alert.addAction(UIAlertAction(title: "UPDATE", style: .default, handler: { _ in
            self.proceedForOpenAppStore()
        }))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.hostViewController.view
            popoverController.sourceRect = CGRect(x: self.hostViewController.view.bounds.midX, y: self.hostViewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.hostViewController.present(alert, animated: true, completion: nil)
    }
    
    func proceedForOpenAppStore() {
        if let url = URL(string: "itms-apps://apple.com/app") {
            UIApplication.shared.open(url)
        }
    }
    
}
