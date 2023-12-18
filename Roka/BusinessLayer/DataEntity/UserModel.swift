//
//  UserModel.swift
//  KarGoCustomer
//
//  Created by Applify on 23/07/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

class UserModel: NSObject {
    static let shared = UserModel()
    var user: User = User()
    var storedUser = KAPPSTORAGE.user

    func refreshUser() {
        if let user = self.getLoggedInUserFromStorage() {
            self.user = user
        }
    }

    private override init() {
        super.init()
        if let user = self.getLoggedInUserFromStorage() {
            self.user = user
        }
    }

    private func getLoggedInUserFromStorage() -> User? {
        return KAPPSTORAGE.user
    }

    func setUserLoggedIn(_ isLoggedIn: Bool) {
        if isLoggedIn {
            KAPPSTORAGE.user = self.user
        } else {
            KAPPSTORAGE.user = nil
        }
    }
    
    func isLoggedIn() -> Bool {
        return KAPPSTORAGE.user != nil
    }

    var authorizationToken: String {
        return "Bearer " + KAPPSTORAGE.accessToken
    }
    
    func logoutUser() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        KAPPSTORAGE.user = nil
        FileManager.clearTmpDirectory()
        KAPPSTORAGE.registrationStep = "-1"
        KAPPSTORAGE.isWalkthroughShown = ""
        KAPPSTORAGE.isLightBoxOpenForChat = ""
        GlobalVariables.shared.selectedImages.removeAll()
        GlobalVariables.shared.isComeFor = ""
        GlobalVariables.shared.cameraCancel = ""
        GlobalVariables.shared.selectedProfileMode = "Dating"
        GlobalVariables.shared.homeCollectionTopConstant = 15.0
        self.user = User()
    }
}
