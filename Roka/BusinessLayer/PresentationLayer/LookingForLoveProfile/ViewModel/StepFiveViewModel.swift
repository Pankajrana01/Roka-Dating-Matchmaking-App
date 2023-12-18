//
//  StepFiveViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 23/09/22.
//

import Foundation
import UIKit

class StepFiveViewModel : BaseViewModel {
    var completionHandler: ((Bool) -> Void)?
    var nextButton: UIButton!
    var iscomeFrom = ""
    var storedUser = KAPPSTORAGE.user
    var user = UserModel.shared.user
    var callBackforUpdateUserInfo: ((_ success: [String: Any]) -> Void)?
    
    
    
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
    
    
    func proceedForTabbar() {
        HomeWalkThroughViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "") { success in
        }
    }
    
    func proceedForAddMoreDetails() {
        DetailPagerController.show(from: self.hostViewController, forcePresent: false, isCome: "")
    }
    
    func proceedForSelectReligion(_ result:@escaping(Bool?) -> Void){
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { value  in}
        controller.show(over: self.hostViewController, isComeFor: "Religion", isFriend: false, genderArray: [], selectedGenderId: "") { id, value, value2 in
            var params = [String:Any]()
            params[WebConstants.id] = self.user.id
            params[WebConstants.religionId] = id
            params[WebConstants.isReligionPrivate] = value2
            self.processForUpdateProfileApiData(params: params, titleName: "Religion") { success in
                result(true)
            }
            
        } preferredCompletionHandler: { text, ids, priority  in
        }
    }
    
    func proceedForSelectEthencity(_ result:@escaping(Bool?) -> Void){
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { value  in }
        controller.show(over: self.hostViewController, isComeFor: "Ethencity", isFriend: false, genderArray: [], selectedGenderId: "") { id, value, value2 in
            
            var params = [String:Any]()
            params[WebConstants.id] = self.user.id
            params[WebConstants.ethnicityId] = id
            params[WebConstants.isEthnicityPrivate] = value2
            self.processForUpdateProfileApiData(params: params, titleName: "Ethnicity"){ success in
                result(true)
            }
            
        } preferredCompletionHandler: { text, ids, priority  in
        }
    }
    
    func proceedForSelectHeight(_ result:@escaping(Bool?) -> Void){
        let controller = HeightViewController.getController() as! HeightViewController
        controller.dismissCompletion = { value  in }
        controller.show(over: self.hostViewController, isCome: "Height", isFriend: false) { value1, value2, priority   in
            
            var params = [String:Any]()
            params[WebConstants.id] = self.user.id
            params[WebConstants.height] = value2
            params[WebConstants.heightType] = value1
            params[WebConstants.isHeightPrivate] = priority
            self.processForUpdateProfileApiData(params: params, titleName: "Height"){ success in
                result(true)
            }
        }
    }
    
    func proceedForSelectEducation(_ result:@escaping(Bool?) -> Void){
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { value  in }
        controller.show(over: self.hostViewController, isComeFor: "Education", isFriend: false, genderArray: [], selectedGenderId: "") { id, value, value2 in
            var params = [String:Any]()
            params[WebConstants.id] = self.user.id
            params[WebConstants.educationQualificationId] = id
            params[WebConstants.isEducationPrivate] = value2
            self.processForUpdateProfileApiData(params: params, titleName: "Education"){ success in
                result(true)
            }
        } preferredCompletionHandler: { text, ids, priority  in
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
                                    showSuccessMessage(with: "\(titleName) " + "updated successfully")
                                    result(true)
                                }
            
                                hideLoader()
        }
    }
}
