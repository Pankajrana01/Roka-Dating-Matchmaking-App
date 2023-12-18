//
//  NotificationsViewModel.swift
//  Roka
//
//  Created by  Developer on 27/10/22.
//

import Foundation
import UIKit

class NotificationsViewModel: BaseViewModel {
    var isComeFor = ""
    var completionHandler: ((Bool) -> Void)?
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    
    
    var modelArray: [NotificationsModel] = [NotificationsModel(status: "New aligned", description: "You just got a new aligned", isOn: 1), NotificationsModel(status: "Messages", description: "Someone sent you a new message", isOn: 1),NotificationsModel(status: "New Likes", description: "You have been liked", isOn: 1),NotificationsModel(status: "Subscription Reminder", description: "Your subscription will end on", isOn: 1)]
    
    // MARK: - API Call...
    func getNotificaitons(_ result: @escaping([String: Any]?) -> Void) {
        showLoader()
        
        ApiManager.makeApiCall(APIUrl.UserApis.notificationSettings,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .get) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [String: Any]
                                    result(responseData)
                                }
            hideLoader()
        }
    }
    
    // MARK: - API Call...
    func updateNotifications(params: [String: Int], completion: @escaping () -> ()) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.UserApis.notificationSettings,
                               params: params,
                               headers: headers,
                               method: .put) { response, _ in
            if !self.hasErrorIn(response) {
                let responseData = response![APIConstants.data] as! [String: Any]
                completion()
            }
            hideLoader()
        }
    }
}

