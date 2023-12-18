//
//  BuyPremiumViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 29/10/22.
//

import Foundation
import UIKit
import StoreKit
import CountryPickerView


class BuyPremiumViewModel: BaseViewModel {
    var isComeFor = ""
    var completionHandler: ((Bool) -> Void)?
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    var selectedIndex = -1
    var products = [SKProduct]()
    weak var blackView: UIView!
    weak var congratulationView: UIView!
    var premiumModels = [PremiumModel]()
    var kycVideo = [[String:Any]]()
    var userData = [String: Any]()
    
    private lazy var cpv: CountryPickerView = {
        let countryPickerView = CountryPickerView()
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        return countryPickerView
    }()
    
    private func getCountryCode() -> String {
       if let code = cpv.getCountryByPhoneCode(DefaultSelectedCountryCode)?.phoneCode {
            return code
        } else if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String,
            let code = cpv.getCountryByCode(countryCode)?.phoneCode {
            return code
        }
        return "N.A."
    }
    
    func viewDidSetup() {
        IAPManager.shared.getProducts { (result) in
            DispatchQueue.main.async {
                switch result {
                    case .success(let products): self.products = products
                    case .failure(let error): self.showIAPRelatedError(error)
                }
            }
        }
    }
    func getProduct(containing keyword: String) -> SKProduct? {
        return products.filter { $0.productIdentifier.contains(keyword) }.first
    }
    
    func getProductForItem(at index: Int) -> SKProduct? {
        // Search for a specific keyword depending on the index value.
        let keyword: String
     //   self.selectedIndex = index
        switch index {
        case 0: keyword = ".OneWeekPlan"
        case 1: keyword = ".monthlyplan"
        case 2: keyword = ".ThreeMonthPlan"
        case 3: keyword = ".halfyearlyplan"
        case 4: keyword = ".yearlyplan"
        default: keyword = ""
        }
        
        // Check if there is a product fetched from App Store containing
        // the keyword matching to the selected item's index.
        guard let product = self.getProduct(containing: keyword) else { return nil }
        return product
    }
    
    func purchase(product: SKProduct) -> Bool {
        if !IAPManager.shared.canMakePayments() {
            return false
        } else {
            showLoader()
            IAPManager.shared.buy(product: product) { (result) in
                hideLoader()
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        print(result)
                        switch result {
                        case .success(let transId):
                            print("\(transId)")
                            if transId != ""{
                                self.proceedForPurchase(transactionIdentifier: transId)
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    case .failure(let error):
                        self.showIAPRelatedError(error)
                    }
                }
            }
        }
        
        return true
    }
    
    func proceedForPurchase(transactionIdentifier:String){
        var params = [String:Any]()
//        if self.premiumModels[selectedIndex].planType == "1" {
//            params[WebConstants.planType] = 1
//            params[WebConstants.planPrice] = self.premiumModels[selectedIndex].planPrice
//
//        } else if self.premiumModels[selectedIndex].planType == "6" {
//            params[WebConstants.planType] = 6
//            params[WebConstants.planPrice] = self.premiumModels[selectedIndex].planPrice
//
//        } else if self.premiumModels[selectedIndex].planType == "12" {
//            params[WebConstants.planType] = 12
//            params[WebConstants.planPrice] = self.premiumModels[selectedIndex].planPrice
//
//        }
        
//        if let country = self.cpv.getCountryByPhoneCode(user.countryCode) {
//            print(country as Any)
//            params[WebConstants.country] = country.code
//        }
        params[WebConstants.planType] = self.premiumModels[selectedIndex].planType
        params[WebConstants.planPrice] = self.premiumModels[selectedIndex].planPrice
        params[WebConstants.country] = self.premiumModels[selectedIndex].country
        params[WebConstants.transactionIdentifier] = transactionIdentifier
        
        self.subscriptionApiCall(prams: params) { response in
            UIView.animate(withDuration: 1) {
                self.blackView.isHidden = false
                self.congratulationView.isHidden = false
                self.congratulationView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.congratulationView.center = self.blackView.center
                
                self.blackView.transform = .identity
                self.congratulationView.transform = .identity
                self.blackView.alpha = 0.5
                self.congratulationView.alpha = 1
                self.hostViewController.navigationController?.navigationBar.isUserInteractionEnabled = false
                
            } completion: { _ in }
        }
    }
    
    func proceedForGotItAction() {
        self.completionHandler?(true)
        self.hostViewController.navigationController?.navigationBar.isUserInteractionEnabled = true
        self.hostViewController.navigationController?.popViewController(animated: true)
    }
    
 
    // MARK: - API Call...
    func getSubscriptionApiCall(_ result:@escaping([[String: Any]]?) -> Void) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.BasicApis.getSubscriptions,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .get) { response, _ in
                                if !self.hasErrorIn(response) {
                                    if let responseData = response![APIConstants.data] as? [String: Any] {
                                        if let rows = responseData["rows"] as? [[String: Any]] {
                                            result(rows)
                                        }
                                    }
                                }
            hideLoader()
        }
    }
    func subscriptionApiCall(prams:[String:Any] ,_ result:@escaping([String: Any]?) -> Void) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.InAppPurchase.inAppPurchase,
                               params: prams,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .post) { response, _ in
                                if !self.hasErrorIn(response) {
                                    if let responseData = response![APIConstants.data] as? [String: Any] {
                                        NotificationCenter.default.post(name: .premiumPlan, object: nil)
                                        result(responseData)
                                    }
                                }
            hideLoader()
        }
    }
    
    func showIAPRelatedError(_ error: Error) {
        let message = error.localizedDescription
        
        // In a real app you might want to check what exactly the
        // error is and display a more user-friendly message.
        // For example:
        /*
        switch error {
        case .noProductIDsFound: message = NSLocalizedString("Unable to initiate in-app purchases.", comment: "")
        case .noProductsFound: message = NSLocalizedString("Nothing was found to buy.", comment: "")
        // Add more cases...
        default: message = ""
        }
        */
        
        showSingleAlert(withMessage: message)
    }
    
    
    func showSingleAlert(withMessage message: String) {
        let alertController = UIAlertController(title: "Roka", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.hostViewController.view
            popoverController.sourceRect = CGRect(x: self.hostViewController.view.bounds.midX, y: self.hostViewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.hostViewController.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(for product: SKProduct) {
        guard let price = IAPManager.shared.getPriceFormatted(for: product) else { return }
        
        let alertController = UIAlertController(title: product.localizedTitle,
                                                message: product.localizedDescription,
                                                preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Buy now for \(price)", style: .default, handler: { (_) in
            
            if !self.purchase(product: product) {
                self.showSingleAlert(withMessage: "In-App Purchases are not allowed in this device.")
            }
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.hostViewController.view
            popoverController.sourceRect = CGRect(x: self.hostViewController.view.bounds.midX, y: self.hostViewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.hostViewController.present(alertController, animated: true, completion: nil)
    }
    
    func getUserProfileData() {
        self.processForGetUserProfileData { result in
            self.userData = result ?? [:]
        }
    }
    
    func updateKycStatusCall(_ result:@escaping(String?) -> Void) {
        if self.userData.count != 0 {
            if let userVideos = self.userData["userVideos"] as? [[String:Any]] {
                self.kycVideo = userVideos
            }
            if let isKycApproved = self.userData["isKycApproved"] as? Int {
                if self.kycVideo.count != 0 {
                    if isKycApproved == 0 {
                        self.proceedForKycVerificationPendingScreen()
                        result("Failed")
                    } else if isKycApproved == 1 {
                        result("Success")
                    } else if isKycApproved == 2 {
                        self.proceedForPendingKYCView()
                        result("Failed")
                    }
                } else {
                    self.proceedForPendingKYCView()
                    result("Failed")
                }
            }
        }
    }
    
    func proceedForPendingKYCView() {
        let controller = PendingKYCViewController.getController() as! PendingKYCViewController
        controller.dismissCompletion = { value  in }
        controller.show(over: self.hostViewController) { value  in }
    }
    
    func proceedForKycVerificationPendingScreen() {
        let controller = PendingVerificationViewController.getController() as! PendingVerificationViewController
        controller.dismissCompletion = { value  in }
        controller.show(over: self.hostViewController) { value  in }
    }
    // MARK: - API Call...
    func processForGetUserProfileData(_ result:@escaping([String: Any]?) -> Void) {
        ApiManager.makeApiCall(APIUrl.UserApis.getUserProfileDetail,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .get) { response, _ in
            DispatchQueue.main.async {
                if let userResponseData = response![APIConstants.data] as? [String: Any] {
                    result(userResponseData)
                }
            }
            hideLoader()
        }
    }
}



// MARK: - Country picker Delegate
extension BuyPremiumViewModel: CountryPickerViewDelegate, CountryPickerViewDataSource {
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return true
    }
    
    func countryPickerView(_ countryPickerView: CountryPickerView,
                           didSelectCountry country: Country) {
    }
}
