//
//  WalkThroughViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 19/09/22.
//

import Foundation
import UIKit

class WalkThroughViewModel: BaseViewModel {
    var logoImageView: UIImageView!
    var topImageView: UIImageView!
    var logoView: UIImageView!
    var logoStackView: UIStackView!
    var descLabel: UILabel!
    var bottomStackView: UIStackView!
    var loginButton: UIButton!
    var registerButton: UIButton!
    var animationDuration: Double = 1

    func performAnimtaion() {
        UIView.animate(withDuration: animationDuration) {
            self.logoStackView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.logoStackView.center = self.logoView.center
            self.logoStackView.transform = .identity
            self.logoStackView.alpha = 1
            
            self.descLabel.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.descLabel.alpha = 1
            self.descLabel.transform = .identity
            
            self.bottomStackView.frame = CGRect(x: self.bottomStackView.frame.origin.x, y: self.bottomStackView.frame.origin.y - 110.0, width: self.bottomStackView.frame.size.width, height: self.bottomStackView.frame.size.height)
            self.bottomStackView.alpha = 1
            self.bottomStackView.transform = .identity
            
            let screenRect = UIScreen.main.bounds
            let screenHeight = screenRect.size.height
            if screenHeight >= 812 {
                self.topImageView.frame = CGRect(x: self.topImageView.frame.origin.x, y: self.topImageView.frame.origin.y + 80.0, width: self.topImageView.frame.size.width, height: self.topImageView.frame.size.height)
            }else{
                self.topImageView.frame = CGRect(x: self.topImageView.frame.origin.x, y: self.topImageView.frame.origin.y + 100.0, width: self.topImageView.frame.size.width, height: self.topImageView.frame.size.height - 30)
            }
            self.topImageView.alpha = 1
            self.topImageView.transform = .identity

        } completion: { _ in
            self.animateBackground()
        }
    }
    
    //Add cover image animation ....
    func animateBackground() {
        UIView.animate(withDuration: 30.0, delay: 0.0, options: [.curveLinear, .repeat], animations: {
            self.topImageView.frame = self.topImageView.frame.offsetBy(dx: 1 * self.topImageView.frame.origin.x, dy: 0.0)
        }, completion: { _ in
            self.topImageView.transform = .identity
        })
        
    }
    
    func proceedToLoginScreen() {
        let contorller = LoginViewController.getController()
        contorller.show(from: self.hostViewController)
    }
    
    func proceedToRegisterScreen() {
        let contorller = SignupViewController.getController()
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


