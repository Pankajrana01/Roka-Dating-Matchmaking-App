//
//  AppDelegate+NSNotification.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let networkStatusUpdated     = Notification.Name("networkStatusUpdated")
    static let appEnterForeground       = Notification.Name("appEnterForeground")
    static let appBecomeInactive        = Notification.Name("appBecomeInactive")
    static let appSavedPreferenceLayout = Notification.Name("appSavedPreferenceLayout")
    static let AuthorizationAccess      = Notification.Name("AuthorizationAccess")

    static let refreshSavedPreferences  = Notification.Name("refreshSavedPreferences")
    static let refreshEditSavedPreferences  = Notification.Name("refreshEditSavedPreferences")
    static let refreshProfileCount      = Notification.Name("refreshProfileCount")
    
    static let updateNotificationIcon   = Notification.Name("updateNotificationIcon")
    static let updateNotificationForAds = Notification.Name("updateNotificationForAds")
    static let updateChatIcon   = Notification.Name("updateChatIcon")
    static let premiumPlan   = Notification.Name("BoughtPremiumPlan")

}
