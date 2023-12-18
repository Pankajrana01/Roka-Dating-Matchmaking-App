//
//  MatchMakingProfileCreatedControllerViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 21/11/22.
//

import Foundation
import UIKit

class MatchMakingProfileCreatedViewModel: BaseViewModel {
    var completionHandler: ((Bool) -> Void)?
    var nextButton: UIButton!
    var iscomeFrom = ""
    var storedUser = KAPPSTORAGE.user
    var user = UserModel.shared.user
    var callBackforUpdateUserInfo: ((_ success: [String: Any]) -> Void)?
    var profileUser = UserModel.shared.user
    var selectedProfileData = [String: Any]()
    var selectedProfile : ProfilesModel?
   
    // MARK: - API Call...
    func processForGetUserData() {
        showLoader()
        var params = [String:Any]()
        params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.UserMatchMaking.getUserMatchMakingProfileDetail,
                               params: params,
                               headers: headers,
                               method: .get) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [String: Any]
                                    self.user.updateWith(responseData)
                                    self.selectedProfileData = responseData
                                    self.callBackforUpdateUserInfo?(responseData)
                                }
                                hideLoader()
        }
    }
    func popBackToController() {
        for controller in self.hostViewController.navigationController!.viewControllers as Array {
            if controller.isKind(of: MatchMakingViewController.self) {
                UserModel.shared.refreshUser()
                user.userImages.removeAll()
                self.hostViewController.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }

    func proceedForEditPlaceholderImageScreen() {
        MatchMakingPlaceholderController.show(from: self.hostViewController, forcePresent: false, isComeFor: "EditMatchingProfilePlaceHolder", selectedProfile: selectedProfile, profileResponseData: self.selectedProfileData, basicDetailsDictionary: [:]) { success in
        }
    }
    
    func proceedForTabbar() {
        HomeWalkThroughViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "") { success in
        }
    }
    
    func proceedForAddMoreDetails() {
        DetailPagerController.show(from: self.hostViewController, forcePresent: false, isCome: "MatchMakingProfile")
    }
    
    func proceedForEditProfilePreferenceScreen() {
        MoreDetailViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "Friend Preferences") { success in
        }
    }
    
    func proceedForSelectReligion(_ result:@escaping(Bool?) -> Void) {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { value  in }
        controller.show(over: self.hostViewController, isComeFor: "Religion", isFriend: true, genderArray: [], selectedGenderId: "") { id, value, value2 in
            var params = [String:Any]()
            params[WebConstants.id] = self.user.id
            params[WebConstants.religionId] = id
            params[WebConstants.isReligionPrivate] = value2
            self.processForUpdateFriendsProfileApiData(params: params, titleName: "Religion") { success in
                result(true)
            }
            
        } preferredCompletionHandler: { text, ids, priority  in
        }
    }
    
    func proceedForSelectEthencity(_ result:@escaping(Bool?) -> Void) {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { value  in }
        controller.show(over: self.hostViewController, isComeFor: "Ethencity", isFriend: true, genderArray: [], selectedGenderId: "") { id, value, value2 in
            
            var params = [String:Any]()
            params[WebConstants.id] = self.user.id
            params[WebConstants.ethnicityId] = id
            params[WebConstants.isEthnicityPrivate] = value2
            self.processForUpdateFriendsProfileApiData(params: params, titleName: "Ethnicity"){ success in
                result(true)
            }
            
        } preferredCompletionHandler: { text, ids, priority  in
        }
    }
    
    func proceedForSelectHeight(_ result:@escaping(Bool?) -> Void){
        let controller = HeightViewController.getController() as! HeightViewController
        controller.dismissCompletion = { value  in }
        controller.show(over: self.hostViewController, isCome: "Height", isFriend: true) { value1, value2, priority   in
            
            var params = [String:Any]()
            params[WebConstants.id] = self.user.id
            params[WebConstants.height] = value2
            params[WebConstants.heightType] = value1
            params[WebConstants.isHeightPrivate] = priority
            self.processForUpdateFriendsProfileApiData(params: params, titleName: "Height"){ success in
                result(true)
            }
        }
    }
    
    func proceedForSelectEducation(_ result:@escaping(Bool?) -> Void){
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { value  in }
        controller.show(over: self.hostViewController, isComeFor: "Education", isFriend: true, genderArray: [], selectedGenderId: "") { id, value, value2 in
            var params = [String:Any]()
            params[WebConstants.id] = self.user.id
            params[WebConstants.educationQualificationId] = id
            params[WebConstants.isEducationPrivate] = value2
            self.processForUpdateFriendsProfileApiData(params: params, titleName: "Education"){ success in
                result(true)
            }
        } preferredCompletionHandler: { text, ids, priority  in
        }
    }
    
    
    // MARK: - API Call...
    func processForUpdateFriendsProfileApiData(params: [String: Any], titleName:String, _ result:@escaping(Bool?) -> Void) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.UserMatchMaking.updateFriendsProfile,
                               params: params,
                               headers: headers,
                               method: .put) { response, _ in
                                if !self.hasErrorIn(response) {
                                    _ = response![APIConstants.data] as! [String: Any]
                                    showSuccessMessage(with: "\(titleName) " + "updated successfully")
                                    result(true)
                                }
            
                                hideLoader()
        }
    }
}
