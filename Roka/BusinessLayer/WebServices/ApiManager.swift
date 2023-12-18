//
//  ApiManager.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import Alamofire
import UIKit

class ApiManager: BaseApiManager {
    class func makeApiCall(_ url: String,
                           params: [String: Any] = [:],
                           headers: [String: String]? = nil,
                           method: HTTPMethod = .post,
                           completion: @escaping ( _ result: [String: Any]?,  _ jsonResponse: Data?) -> Void) {
        if method == .get {
            let dataRequest = self.getDataRequest(url,
                                                  params: params,
                                                  method: .get,
                                                  encoding: URLEncoding.default,
                                                  headers: headers)
            self.executeDataRequest(dataRequest, with: completion)
        } else {
            let dataRequest = self.getDataRequest(url,
                                                  params: params,
                                                  method: method,
                                                  headers: headers)
            self.executeDataRequest(dataRequest, with: completion)
        }
    }
        
    private class func executeDataRequest(_ dataRequest: DataRequest,
                                          with completion: @escaping ( _ result: [String: Any]?,  _ jsonResponse: Data?) -> Void) {
        if NetworkReachabilityManager()?.isReachable == false {
            completion(getNoInternetError(), nil)
            return
        }
        dataRequest.responseJSON { response in
            DispatchQueue.main.async {
                switch response.result {
                case .success(let value):
                    guard let value = value as? [String: Any] else {
                       // completion(self.getNoInternetError(), response.data)
                        completion(self.getUnknownError(response.error?.localizedDescription), response.data)
                        return
                    }
                    print ("success")
                    print("\(value)")
                    completion(value, response.data)
                case .failure:
                    completion(self.getUnknownError(response.error?.localizedDescription), response.data)
                }
            }
        }
    }
}

class BaseApiManager: NSObject {
    
    class func getDataRequest(_ baseUrl: String,
                              _ url: String,
                              params: [String: Any]? = nil,
                              method: HTTPMethod = .post,
                              encoding: ParameterEncoding = URLEncoding.default,
                              headers: [String: String]? = nil) -> DataRequest {

        var httpHeaders: HTTPHeaders = []
        if let headers = headers {
            for (key, value) in headers {
                httpHeaders[key] = value
            }
        }
        let dataRequest = AF.request(baseUrl + url,
                                     method: method,
                                     parameters: params,
                                     encoding: encoding,
                                     headers: httpHeaders)
        
        return dataRequest
    }
    
    
    class func getDataRequest(_ url: String,
                              params: [String: Any] = [:],
                              method: HTTPMethod = .post,
                              encoding: ParameterEncoding = JSONEncoding.default,
                              headers: [String: String]? = nil) -> DataRequest {

        var httpHeaders: HTTPHeaders = []
        if let headers = headers {
            for (key, value) in headers {
                httpHeaders[key] = value
            }
        }
        let dataRequest = AF.request(url,
                                     method: method,
                                     parameters: params,
                                     encoding: encoding,
                                     headers: httpHeaders)
        print(url)
        print(headers as Any)
        print(params)
        return dataRequest
    }
}

extension BaseApiManager {
    
    static func getNoInternetError() -> [String: Any] {
        return [APIConstants.message: GenericErrorMessages.noInternet,
                APIConstants.code: 503]
    }
    
    static func getUnknownError(_ message: String? = nil) -> [String: Any] {
        return [APIConstants.message: message ?? GenericErrorMessages.internalServerError,
                APIConstants.code: 503]
    }
}

class ApiManagerWithCodable<T: Codable>: BaseApiManagerCodable {
    class func makeApiCall(_ url: String,
                           params: [String: Any] = [:],
                           headers: [String: String]? = nil,
                           method: HTTPMethod = .post,
                           requiresPinning: Bool = true,
                           completion: @escaping ([String: Any]?, T?) -> Void) {
        print("Params ----->", params)
        print("Full Url ----->", url)
        print("Header ----->", headers as Any)
        let dataRequest = self.getDataRequest(url,
                                              params: params,
                                              method: method,
                                              headers: headers,
                                              requiresPinning: requiresPinning)
        self.executeDataRequest(dataRequest, with: completion)
    }
    
    static func executeDataRequest(_ dataRequest: DataRequest,
                                   with completion: @escaping (_ result: [String: Any]?, _ model: T?) -> Void) {
        if ApiManagerWithCodable.isNetworkReachable == false {
            completion(getNoInternetError(),nil)
            return
        }
        dataRequest.responseJSON { response in
            DispatchQueue.main.async {
                switch response.result {
                case .success(let value):
                    guard let value = value as? [String: Any] else {
                        completion(self.getUnknownError(response.error?.localizedDescription), nil)
                        return
                    }
                    //https://1rva45bgif.execute-api.ap-south-1.amazonaws.com/dev/api/v1/user/browserUser?limit=2&skip=0&preferredCity=Sahibzada%20Ajit%20Singh%20Nagar&preferredState=Punjab&preferredCountry=India&preferredMinAge=20&preferredMaxAge=50&preferredGenders=b1cb6994-c70e-4bdd-8bba-178bdde109fe

//                    print ("success")
                    print("\(value)")
                    do{
                        guard let data = response.data else {completion(value,nil)
                            return
                        }
                        let user = try JSONDecoder().decode(T.self, from: data)
                        let statusCode = value["statusCode"] as? Int
                        if statusCode == 401{
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LogoutCall"), object: nil)
                            
                            completion(value,user)

                        } else {
                            completion(value,user)
                        }
                    } catch {
                        print(error)
                        let statusCode = value["statusCode"] as? Int
                        if statusCode == 401{
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LogoutCall"), object: nil)
                            
                            completion(value,nil)

                        } else {
                            completion(self.getUnknownError(error.localizedDescription), nil)
                        }
                    }
                case .failure:
                    print(self.getUnknownError(response.error?.localizedDescription))
                    completion(self.getUnknownError(response.error?.localizedDescription), nil)

                }
            }
        }
    }
    
    func gotoLoginScreen() {
        UserModel.shared.logoutUser()
        KAPPDELEGATE.updateRootController(LoginViewController.getController(),
                                          transitionDirection: .toRight,
                                          embedInNavigationController: true)
    }
}

class BaseApiManagerCodable: NSObject {
    class var isNetworkReachable: Bool {
        return NetworkReachabilityManager()?.isReachable == true
    }
    static  let sharedInstance = BaseApiManager()
    
    let sessionManager: Session = {
        let url = APIUrl.baseUrl
        let manager = ServerTrustManager(evaluators: [url: DisabledTrustEvaluator()])
        let configuration = URLSessionConfiguration.af.default
        
        return Session(configuration: configuration, serverTrustManager: manager)
    }()
    
    class func getDataRequest(_ url: String,
                              params: [String: Any] = [:],
                              method: HTTPMethod = .post,
                              headers: [String: String]? = nil,
                              requiresPinning: Bool) -> DataRequest {
        let encoding: ParameterEncoding = method == .get ? URLEncoding(destination: .queryString) : JSONEncoding.default

        var httpHeaders: HTTPHeaders?
        if let headers = headers {
            httpHeaders = HTTPHeaders(headers)
        }
        let dataRequest: DataRequest
            dataRequest = AF.request(url,
                                     method: method,
                                     parameters: params,
                                     encoding: encoding,
                                     headers: httpHeaders)
        debugPrint("URl:---", dataRequest.request?.url as Any)

        return dataRequest
    }
}

extension BaseApiManagerCodable {
    
    static func getNoInternetError() -> [String: Any] {
        return [APIConstants.message: GenericErrorMessages.noInternet,
                APIConstants.code: 503]
    }
    
    static func getUnknownError(_ message: String? = nil) -> [String: Any] {
        if !isNetworkReachable {
            return getNoInternetError()
        } else {
            return [APIConstants.message: GenericErrorMessages.internalServerError,
                    APIConstants.code: 503]
        }
    }
}
