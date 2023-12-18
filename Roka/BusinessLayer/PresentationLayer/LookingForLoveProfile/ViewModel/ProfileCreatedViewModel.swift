//
//  ProfileCreatedViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 07/08/23.
//

import Foundation
import UIKit

class ProfileCreatedViewModel : BaseViewModel {
    var completionHandler: ((Bool) -> Void)?
    var nextButton: UIButton!
    var iscomeFrom = ""
    var storedUser = KAPPSTORAGE.user
    var user = UserModel.shared.user
    var callBackforUpdateUserInfo: ((_ success: [String: Any]) -> Void)?
    var questionsData = [QuestionsData]()
    var profileArr: [ProfilesModel] = []
    var userResponse = [String:Any]()
    
    // MARK: - API Call...
    func processForGetUserData() {
        showLoader()
        ApiManager.makeApiCall(APIUrl.User.basePreFix,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .get) { response, _ in
            if !self.hasErrorIn(response) {
                let responseData = response![APIConstants.data] as! [String: Any]
                self.user.updateWith(responseData)
                UserModel.shared.setUserLoggedIn(true)
                UserModel.shared.storedUser = self.user
                self.callBackforUpdateUserInfo?(responseData)
            }
            hideLoader()
        }
    }
    
    func processForGetQuestionData(type: String) {
        var params = [String:Any]()
        params["type"] = type
        
        self.getApiCall(params: params, url: APIUrl.BasicApis.questionAboutUser) { model in
            self.questionsData = model?.data ?? []
            
//            self.tableView.reloadData()
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
    
    func proceedForTabbar() {
        KAPPSTORAGE.isWalkthroughShown = "Yes"
        KAPPDELEGATE.updateRootController(TabBarController.getController(),
                                          transitionDirection: .fade,
                                          embedInNavigationController: true)
    }
    
    func proceedForAddMoreDetails() {
        DetailPagerController.show(from: self.hostViewController, forcePresent: false, isCome: "")
    }
    
    // MARK: - API Call...
    func processForGetUserData(_ result:@escaping(String) -> Void) {
       // showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManagerWithCodable<SingleProfilesResponseModel>.makeApiCall(APIUrl.UserApis.getUserProfileDetail,
                                                                       params: [:],
                                                                       headers: headers,
                                                                       method: .get) { (response, resultModel) in
            if resultModel?.statusCode == 200 {
                self.profileArr.removeAll()
                self.profileArr.append(resultModel!.data)
                result("success")
            } else {
                showMessage(with: response?["message"] as? String ?? "")
            }
           // DispatchQueue.main.async { hideLoader() }
        }
    }
    
    // MARK: - API Call...
    func processForGetUserProfileData(_ result:@escaping([String: Any]?) -> Void) {
        //DispatchQueue.main.async { showLoader() }
        ApiManager.makeApiCall(APIUrl.UserApis.getUserProfileDetail,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .get) { response, _ in
            if !self.hasErrorIn(response) {
                let userResponseData = response![APIConstants.data] as! [String: Any]
                result(userResponseData)
                self.userResponse = userResponseData
            }
        }
    }
    
    func proceedToDetailScreen(profile: ProfilesModel, index:Int){
        PageFullViewVC.show(from: self.hostViewController, forcePresent: false, forceBackToHome: false, isFrom: "", isComeFor: "Profile", selectedProfile: profile, allProfiles: profileArr, selectedIndex: index) { success in
            
        }
    }
    
    // MARK: - API Call...
    func processForUpdateProfileApiData(params: [String: Any], titleName:String, _ result:@escaping(Bool?) -> Void) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.UserApis.updateProfile,
                               params: params,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .put) { response, _ in
                                if !self.hasErrorIn(response) {
                                    _ = response![APIConstants.data] as! [String: Any]
                                   // showSuccessMessage(with: "\(titleName) " + "updated successfully")
                                    result(true)
                                }
            
                                hideLoader()
        }
    }
}
