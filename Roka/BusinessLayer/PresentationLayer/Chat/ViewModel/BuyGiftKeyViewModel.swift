//
//  BuyGiftKeyViewModel.swift
//  Roka
//
//  Created by Applify  on 06/01/23.
//

import Foundation
import StoreKit

class BuyGiftKeyViewModel: BaseViewModel {
    var isCome = ""
    var completionHandler: ((Bool) -> Void)?
    var chatRoom: ChatRoomModel?
    var products = [SKProduct]()

    func fetchAllProducts() {
        showLoader()
        IAPManager.shared.getProducts { (result) in
            DispatchQueue.main.async {
                hideLoader()
                switch result {
                    case .success(let products): self.products = products
                    case .failure(let error): self.showIAPRelatedError(error)
                }
            }
        }
    }
    
    func getProductForItem() -> SKProduct? {
        // Check if there is a product fetched from App Store containing
        // the keyword matching to the selected item's index.
        guard let product = self.getProduct(containing: ".giftkey") else { return nil }
        return product
    }
    
    func getProduct(containing keyword: String) -> SKProduct? {
        return products.filter { $0.productIdentifier.contains(keyword) }.first
    }
    
    func canPurchase() -> Bool {
        if !IAPManager.shared.canMakePayments() {
            self.showSingleAlert(withMessage: "In-App Purchases are not allowed in this device.")
            return false
        } else {
            return true
        }
    }
    
    func purchase(handler: @escaping (() -> Void)) {
        if let product = getProductForItem() {
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
                            if transId != "" {
                                self.proceedForPurchase(transactionIdentifier: transId, handler: {
                                    handler()
                                })
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    case .failure(let error):
                        self.showIAPRelatedError(error)
                    }
                }
            }
        } else {
            self.showSingleAlert(withMessage: "In-App Purchases are not allowed in this device.")
        }
    }
    
    func showIAPRelatedError(_ error: Error) {
        let message = error.localizedDescription
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
    
    func proceedForPurchase(transactionIdentifier: String, handler: @escaping (() -> Void)) {
        var params = [String:Any]()
        params[WebConstants.userId] = UserModel.shared.user.id
        params[WebConstants.transactionIdentifier] = transactionIdentifier
        params[WebConstants.country] = UserModel.shared.user.country
        params[WebConstants.planPrice] = 9

        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.InAppPurchase.sendGiftCard,
                               params: params,
                               headers: headers,
                               method: .post) { response, _ in
            if !self.hasErrorIn(response) {
               handler()
            }
        }
    }
}
