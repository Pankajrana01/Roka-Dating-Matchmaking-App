//
//  NotificationViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 14/10/22.
//

import Foundation
import UIKit

class NotificationViewModel: BaseViewModel {
    var isComeFor = ""
    var completionHandler: ((Bool) -> Void)?
    var notifications = [Notifications]()
    var profileArr: [ProfilesModel] = []
    
    func processForGetNotifications(parmas: [String:Any], _ result: @escaping(NotificationResponseModel?) -> Void) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        
        ApiManagerWithCodable<NotificationResponseModel>.makeApiCall(APIUrl.UserApis.notifications,
                                                                     params: parmas,
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
    
    // MARK: - API Call...
    func processForReadNotificationData(parms:[String:Any], _ result: @escaping(String?) -> Void) {
       // showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.UserApis.notifications,
                               params: parms,
                               headers: headers,
                               method: .put) { response, _ in
                                if !self.hasErrorIn(response) {
                                    if let _ = response![APIConstants.data] as? [String: Any]{
                                        result("success")
                                    }
                                }
                hideLoader()
        }
    }
    
    func proceedForNotificationPopupView(title: String, description: String) {
        let controller = BroadCastPushViewController.getController() as! BroadCastPushViewController
        controller.dismissCompletion = { value  in }
        controller.show(over: self.hostViewController, userInfo: [:], isCome: "NotificationViewController", title: title, desc: description) { status in
        }

    }
    
    func proceedForVerifyKycScreen() {
        StepFourViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "Profile") { success in
        }
    }
    
    func proceedForReferAndEarnScreen() {
        ReferAndEarnViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "Profile") { success in
        }
    }
    
    func proceedForMatchedProfileScreen(notification:Notifications){
        MatchedViewController.show(over: self.hostViewController, isCome: "NotificationScreen", userInfo: [:], notificationData: notification) { success in
        }
    }
    
    func proceedForMySubscriptionScreen() {
        SubscriptionViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "Profile") { success in
        }
    }
    
    func getLikedProfileData(notification:Notifications) {
        let param = [ "id": notification.senderID ?? ""] as [String: Any]
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        showLoader()
        
        ApiManagerWithCodable<ProfilesResponseModel>.makeApiCall(APIUrl.UserMatchMaking.getUserMatchMakingProfileData,
                                                                 params: param,
                                                                 headers: headers,
                                                                 method: .get) { (response, resultModel) in
            hideLoader()
            if let result = resultModel, result.statusCode == 200, result.data.count == 0 {
                self.profileArr.removeAll()
            } else if resultModel?.statusCode == 200 {
                self.profileArr.removeAll()
                self.profileArr.append(contentsOf: resultModel?.data ?? [])
               
                if self.profileArr.count != 0{
                    self.proceedToDetailScreen(profile: self.profileArr[0])
                }
                
            }
            else {
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    
    func proceedToDetailScreen(profile: ProfilesModel) {
        PageFullViewVC.show(from: self.hostViewController, forcePresent: false, forceBackToHome: false, isFrom: "", isComeFor: "home", selectedProfile: profile, allProfiles: profileArr, selectedIndex: 0) { success in

        }
    }
}

