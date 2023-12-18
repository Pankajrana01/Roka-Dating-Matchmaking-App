//
//  IAPManager.swift
//  Roka
//
//  Created by Pankaj Rana on 29/10/22.
//

import Foundation
import StoreKit

class IAPManager: NSObject {
    
    // MARK: - Custom Types
    
    enum IAPManagerError: Error {
        case noProductIDsFound
        case noProductsFound
        case paymentWasCancelled
        case productRequestFailed
    }

    
    // MARK: - Properties
    
    static let shared = IAPManager()
    
    var onReceiveProductsHandler: ((Result<[SKProduct], IAPManagerError>) -> Void)?
    
    var onBuyProductHandler: ((Result<String, Error>) -> Void)?
    
    var totalRestoredPurchases = 0
      
    typealias CompletionBlock = (_ success:Bool, _ error:Error?)->Void
    
    var completionBlock:CompletionBlock!
    
    // MARK: - Init
    
    private override init() {
        super.init()
    }
    
    
    // MARK: - General Methods
    
    fileprivate func getProductIDs() -> [String]? {
        guard let url = Bundle.main.url(forResource: "IAP_ProductIDs", withExtension: "plist") else { return nil }
        do {
            let data = try Data(contentsOf: url)
            let productIDs = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil) as? [String] ?? []
            return productIDs
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    
    func getPriceFormatted(for product: SKProduct) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price)
    }
    
    
    func startObserving() {
        SKPaymentQueue.default().add(self)
    }


    func stopObserving() {
        SKPaymentQueue.default().remove(self)
    }
    
    
    func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    
    // MARK: - Get IAP Products
    
    func getProducts(withHandler productsReceiveHandler: @escaping (_ result: Result<[SKProduct], IAPManagerError>) -> Void) {
        // Keep the handler (closure) that will be called when requesting for
        // products on the App Store is finished.
        onReceiveProductsHandler = productsReceiveHandler

        // Get the product identifiers.
        guard let productIDs = getProductIDs() else {
            productsReceiveHandler(.failure(.noProductIDsFound))
            return
        }

        // Initialize a product request.
        let request = SKProductsRequest(productIdentifiers: Set(productIDs))

        // Set self as the its delegate.
        request.delegate = self

        // Make the request.
        request.start()
    }
    
    
    
    // MARK: - Purchase Products
    
    func buy(product: SKProduct, withHandler handler: @escaping ((_ result: Result<String, Error>) -> Void)) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
        print("PRODUCT TO PURCHASE: \(product.productIdentifier)")

        // Keep the completion handler.
        onBuyProductHandler = handler
    }
    
    
    func restorePurchases(withHandler handler: @escaping ((_ result: Result<String, Error>) -> Void)) {
        onBuyProductHandler = handler
        totalRestoredPurchases = 0
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}


// MARK: - SKPaymentTransactionObserver
extension IAPManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { (transaction) in
            switch transaction.transactionState {
            case .purchased:
                //self.receiptValidation()
                onBuyProductHandler?(.success("\(transaction.transactionIdentifier ?? "")"))
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                totalRestoredPurchases += 1
                SKPaymentQueue.default().finishTransaction(transaction)
                
            case .failed:
                if let error = transaction.error as? SKError {
                    if error.code != .paymentCancelled {
                        onBuyProductHandler?(.failure(error))
                    } else {
                        onBuyProductHandler?(.failure(IAPManagerError.paymentWasCancelled))
                    }
                    print("IAP Error:", error.localizedDescription)
                }
                SKPaymentQueue.default().finishTransaction(transaction)
                
            case .deferred, .purchasing: break
            @unknown default: break
            }
        }
    }
    
    func receiptValidation() {
        let receiptPath = Bundle.main.appStoreReceiptURL?.path
        if FileManager.default.fileExists(atPath: receiptPath!){
            var receiptData:NSData?
            do{
                receiptData = try NSData(contentsOf: Bundle.main.appStoreReceiptURL!, options: .alwaysMapped)
            }
            catch{
                print("ERROR: " + error.localizedDescription)
            }
            
            guard let base64encodedReceipt = receiptData?.base64EncodedString(options: []) else { return  }
            
            self.checkReceiptStatus(base64encodedReceipt)
            
        }
    }

    
    func checkReceiptStatus(_ encodedString:String) {
        let SUBSCRIPTION_SECRET = "667ae62773dd41f4b592b20a731adf16"
        let requestDictionary = ["receipt-data":encodedString, "password":SUBSCRIPTION_SECRET]
        
        guard JSONSerialization.isValidJSONObject(requestDictionary) else {return }
        do {
            
            let requestData = try JSONSerialization.data(withJSONObject: requestDictionary)
            
            guard let validationURL = URL(string: APIUrl.InAppPurchase.sandBox) else {return }
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            var request = URLRequest(url: validationURL)
            request.httpMethod = "POST"
            request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
            
            let task = session.uploadTask(with: request, from: requestData) { (data, response, error) in
                if let data = data , error == nil {
                    do {
                        let parsedData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
                        
                        if parsedData["latest_receipt_info"] != nil && parsedData["latest_receipt_info"] is NSArray{
                            
                            let receipts:NSArray = parsedData["latest_receipt_info"] as! NSArray
                            
                            let receipt:NSDictionary = receipts.firstObject as! NSDictionary
                            
                            let dateString:String = String(format: "%@",receipt.object(forKey: "expires_date") as! CVarArg).replacingOccurrences(of: "Etc/GMT", with: "").trimmingCharacters(in: .whitespaces)
                            
                            let transactionID:String = String(format: "%@",receipt.object(forKey: "transaction_id") as! CVarArg).trimmingCharacters(in: .whitespaces)
                            
                            let purchasetimeMilliSec = String(format: "%@",receipt.object(forKey: "purchase_date_ms") as? String ?? "")
                            
                            
                        } else{
                            if self.completionBlock != nil {
                                self.completionBlock(false, nil)
                            }
                        }
                    } catch let error as NSError {
                        if self.completionBlock != nil {
                            self.completionBlock(false, error)
                        }
                    }
                }
            }
            task.resume()
        } catch let error as NSError {
            if self.completionBlock != nil {
                self.completionBlock(false, error)
            }
        }
    }
    func getExpirationDateFromResponse(_ jsonResponse: NSDictionary) -> Date? {
            
            if let receiptInfo: NSArray = jsonResponse["latest_receipt_info"] as? NSArray {
                
                let lastReceipt = receiptInfo.lastObject as! NSDictionary
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
                
                if let expiresDate = lastReceipt["expires_date"] as? String {
                    return formatter.date(from: expiresDate)
                }
                
                return nil
            }
            else {
                return nil
            }
        }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
//        if totalRestoredPurchases != 0 {
//            onBuyProductHandler?(.success(true))
//        } else {
//            print("IAP: No purchases to restore!")
//            onBuyProductHandler?(.success(false))
//        }
    }
    
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        if let error = error as? SKError {
            if error.code != .paymentCancelled {
                print("IAP Restore Error:", error.localizedDescription)
                onBuyProductHandler?(.failure(error))
            } else {
                onBuyProductHandler?(.failure(IAPManagerError.paymentWasCancelled))
            }
        }
    }
}




// MARK: - SKProductsRequestDelegate
extension IAPManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        // Get the available products contained in the response.
        let products = response.products

        // Check if there are any products available.
        if products.count > 0 {
            // Call the following handler passing the received products.
            onReceiveProductsHandler?(.success(products))
        } else {
            // No products were found.
            onReceiveProductsHandler?(.failure(.noProductsFound))
        }
    }
    
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        onReceiveProductsHandler?(.failure(.productRequestFailed))
    }
    
    
    func requestDidFinish(_ request: SKRequest) {
        // Implement this method OPTIONALLY and add any custom logic
        // you want to apply when a product request is finished.
    }
}




// MARK: - IAPManagerError Localized Error Descriptions
extension IAPManager.IAPManagerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noProductIDsFound: return "No In-App Purchase product identifiers were found."
        case .noProductsFound: return "No In-App Purchases were found."
        case .productRequestFailed: return "Unable to fetch available In-App Purchase products at the moment."
        case .paymentWasCancelled: return "In-App Purchase process was cancelled."
        }
    }
}
