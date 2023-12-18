//
//  MatchedViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 06/12/22.
//

import Foundation
import UIKit

class MatchedViewModel: BaseViewModel {
    var completionHandler: ((String) -> Void)?
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    let otherUserProfile: ProfilesModel? = nil
    var userInfo = [AnyHashable: Any]()
    var notificationData : Notifications?
    var profileArr: [ProfilesModel] = []
    var isCome = ""
    var title = ""
    var desc = ""
    
    func proceedForHome() {
        KAPPDELEGATE.updateRootController(TabBarController.getController(),
                                          transitionDirection: .fade,
                                          embedInNavigationController: true)
    }
    
    func getProfile() {
        let id: String
        if self.isCome == "NotificationScreen" {
            id = self.notificationData?.senderID ?? ""

        } else {
            id = self.userInfo["senderId"] as? String ?? ""
        }
        
        let param = [ "id": id] as [String: Any]
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        showLoader()
        
        ApiManagerWithCodable<ProfilesResponseModel>.makeApiCall(APIUrl.UserMatchMaking.getUserMatchMakingProfileData,
                                                                 params: param,
                                                                 headers: headers,
                                                                 method: .get) { (response, resultModel) in
            hideLoader()
            if let result = resultModel, result.statusCode == 200, result.data.count == 0 {
               
            } else if resultModel?.statusCode == 200 {
                self.profileArr.removeAll()
                self.profileArr.append(contentsOf: resultModel?.data ?? [])
            }
            else {
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func moveToChatScreen(completion: @escaping (() -> Void)) {
        if self.profileArr.count != 0{
            showLoader()
            let profile = self.profileArr[0]
            var userImage = ""
            let images = profile.userImages?.filter({($0.file != "" && $0.file != "<null>" && $0.isDp == 1)})
            if let images = images, !images.isEmpty {
                let image = images[0]
                userImage = image.file == "" ? "dp" : image.file ?? "dp"
            }
            
            let sendDataModel = FirebaseSendDataModel(id: profile.id, dialogStatus: 2, userName: "\(profile.firstName ?? "") \(profile.lastName ?? "")", userPic: userImage, isSubscriptionPlanActive: profile.isSubscriptionPlanActive, isConnection: 0, countryCode: profile.countryCode, phoneNumber: profile.phoneNumber, isPhoneVerified: 1)
            
            FirestoreManager.checkForChatRoom(sendDataModel: sendDataModel) { status, existingProfile in
                hideLoader()
                if status {
                    KAPPDELEGATE.updateRootController(ChatViewController.getController(with: "PROFILE_MATCHED", chatRoom: existingProfile!),
                                                      transitionDirection: .fade,
                                                      embedInNavigationController: true)
                    completion()
                }
            }
        }
    }
}
