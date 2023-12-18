//
//  QuestionsViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 18/08/23.
//

import Foundation
import UIKit

class QuestionsViewModel: BaseViewModel {
    var completionHandler: (([NSDictionary]) -> Void)?
    var isComeFor = ""
    var isFriend = false
    var questionsData = [QuestionsData]()
    var questionsIds = [String]()
    var userResponseData = [String: Any]()
    
    // MARK: - API Call...
    func processForGetUserProfileData(_ result: @escaping(String?) -> Void) {
        var url = ""
        var params = [String:Any]()
        
        if isFriend {
            url = APIUrl.UserMatchMaking.getUserMatchMakingProfileDetail
            params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
        } else {
            url = APIUrl.UserApis.getUserProfileDetail
            params = [:]
        }
        ApiManager.makeApiCall(url,
                               params: params,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .get) { response, _ in
            if !self.hasErrorIn(response) {
                let responseData = response![APIConstants.data] as! [String: Any]
                DispatchQueue.main.async {
                    self.userResponseData = response![APIConstants.data] as! [String: Any]
                    if let genders = self.userResponseData["userQuestionAnswer"] as? [[String:Any]] {
                        for gender in genders {
                            if let id = gender["questionId"] as? String {
                                if let index =  self.questionsData.firstIndex(where: {$0.id == id}) {
                                    self.questionsData[index].answer = gender["answer"] as? String ?? ""
                                }
                            }
                        }
                        
                        result("success")
                    }
                }
            }
            hideLoader()
        }
    }
    func processForGetQuestionData(type: String, _ result: @escaping(String?) -> Void) {
        var params = [String:Any]()
        params["type"] = type
        self.getApiCall(params: params, url: APIUrl.BasicApis.questionAboutUser) { model in
            self.questionsData = model?.data ?? []
            self.questionsIds.removeAll()
            
            for question in self.questionsData {
                self.questionsIds.append(question.id)
            }
            
            self.processForGetUserProfileData { status in
                result("success")
            }
        }
    }
    
    func getApiCall(params: [String:Any], url: String, _ result: @escaping(ResponseQuestionData?) -> Void) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        
        ApiManagerWithCodable<ResponseQuestionData>.makeApiCall(url, params: params,
                                                         headers: headers,
                                                         method: .get) { (response, resultModel) in
            hideLoader()
            if resultModel?.statusCode == 200 {
                result(resultModel)
            } else {
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
}
