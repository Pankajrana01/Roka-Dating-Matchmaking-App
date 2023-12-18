//
//  PushNotificationHandler.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications
import FirebaseDatabase
import CodableFirebase

extension Notification.Name {
    static let notificationTapped = Notification.Name("notificationTapped")
}

extension UNNotification {
    var userInfo: [AnyHashable : Any] {
        return self.request.content.userInfo
    }
}

extension UNNotificationResponse {
    var userInfo: [AnyHashable : Any] {
        return self.notification.request.content.userInfo
    }
}

enum PushNotificationType: Int {
    case BROADCAST_PUSH = 0
    case PROFILE_LIKED = 1
    case PROFILE_MATCHED = 5
    case KYC_APPROVED = 7
    case KYC_DECLINE = 8
    case USER_BLOCKED = 9
    case USER_DELETED = 10
    case CHAT_NOTIFICATION = 51
    case SUBSCRIPTION_REMINDER = 11
    case REFER_N_EARN = 12
    case COMPLEMENTARY_SUBSCRIPTION_GIVING = 13
    case COMPLEMENTARY_SUBSCRIPTION_REVOKING = 14
}

extension String {
    var intValue: Int? {
        let intValue = Int(self)
        return intValue
    }
}

protocol RequestListner {
    
}

protocol RequestMyAccountUpdatedListner: RequestListner {
    func requestMyAccountUpdated(Update: Bool)
}

protocol PiPListner {
    
}

protocol UpdatePiPListner: PiPListner {
    func pipListnerCallBack()
}


class PushNotificationHandler: NSObject {
    var profileArr: [ProfilesModel] = []
    
    static let shared: PushNotificationHandler = PushNotificationHandler()
    
    var notificationUserInfo: [AnyHashable : Any]?

    private override init() {
    }
    
    func configure() {
        UNUserNotificationCenter.current().delegate = self
        handleBadgeCount()
        Messaging.messaging().delegate = self
    }
    
    func handleBadgeCount() {
        DispatchQueue.main.async {
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
    
    func askForPushNotifications(_ completionHandler: (() -> Void)?) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            completionHandler?()
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func handlePushNotification(_ response: UNNotificationResponse) {
        let userInfo = response.userInfo
        if let notificationType = (userInfo["notificationType"] as? String ?? "").intValue {
            switch notificationType {

            case PushNotificationType.BROADCAST_PUSH.rawValue:
                print("Broadcast push received")

            case PushNotificationType.PROFILE_LIKED.rawValue:
                self.getLikedProfileData(userInfo: userInfo)
                
            case PushNotificationType.PROFILE_MATCHED.rawValue:
                if !(UIApplication.topViewController() is MatchedViewController){
                    self.proceedForProfileMatchedView(userInfo: userInfo)
                }
            case PushNotificationType.KYC_DECLINE.rawValue:
                if !(UIApplication.topViewController() is StepFourViewController){
                    KAPPDELEGATE.updateRootController(StepFourViewController.getController(with: "KYC_DECLINE_PUSH"), transitionDirection: .toRight, embedInNavigationController: true)
                }
            case PushNotificationType.KYC_APPROVED.rawValue:
                break
                
            case PushNotificationType.USER_DELETED.rawValue:
                self.logoutSuccess()
                
            case PushNotificationType.USER_BLOCKED.rawValue:
                self.logoutSuccess()
                
            case PushNotificationType.CHAT_NOTIFICATION.rawValue:
                if !(UIApplication.topViewController() is ChatViewController){
                    self.proceedForFetchChatRoomDetails(chatRoomId: userInfo["chatDialogId"] as? String ?? "")
                } else {
                    if let chatController = UIApplication.topViewController() as? ChatViewController{
                        if let pushChatDialogId = userInfo["chatDialogId"] as? String {
                            if pushChatDialogId != chatController.viewModel?.chatRoom?.chat_dialog_id ?? "" {
                                self.proceedForFetchChatRoomDetails(chatRoomId: userInfo["chatDialogId"] as? String ?? "")
                            }
                        }
                    }
                }
                
            case PushNotificationType.REFER_N_EARN.rawValue:
                if !(UIApplication.topViewController() is CongratsViewController){
                    KAPPDELEGATE.updateRootController(CongratsViewController.getController(), transitionDirection: .fade, embedInNavigationController: true)
                }
                
            case PushNotificationType.COMPLEMENTARY_SUBSCRIPTION_GIVING.rawValue:
                if !(UIApplication.topViewController() is SubscriptionViewController){
                    KAPPDELEGATE.updateRootController(SubscriptionViewController.getController(with: "COMPLEMENTARY_SUBSCRIPTION_GIVING"), transitionDirection: .fade, embedInNavigationController: true)
                }
            case PushNotificationType.COMPLEMENTARY_SUBSCRIPTION_REVOKING.rawValue:
                if !(UIApplication.topViewController() is SubscriptionViewController){
                    KAPPDELEGATE.updateRootController(SubscriptionViewController.getController(with: "COMPLEMENTARY_SUBSCRIPTION_REVOKING"), transitionDirection: .fade, embedInNavigationController: true)
                }
            default:
                print("Notification type not configured")
            }
        }
    }
    
    func shouldPresentNotificationBanner(_ response: UNNotification) -> Bool {
        let userInfo = response.userInfo
        print("------>",userInfo)
        if let notificationType = (userInfo["notificationType"] as? String ?? "").intValue {
            switch notificationType {
                
            case PushNotificationType.BROADCAST_PUSH.rawValue:
               // self.proceedForBroadCastPopupView(userInfo: userInfo)
                print("Broadcast push received")
                
            case PushNotificationType.PROFILE_LIKED.rawValue:
                NotificationCenter.default.post(name: NSNotification.Name("updateNotificationIcon"), object: nil)
                
            case PushNotificationType.PROFILE_MATCHED.rawValue:
                NotificationCenter.default.post(name: NSNotification.Name("updateNotificationIcon"), object: nil)
                if !(UIApplication.topViewController() is MatchedViewController) || !(UIApplication.topViewController() is ChatPagerController) || !(UIApplication.topViewController() is InboxController) || !(UIApplication.topViewController() is InviteController) {
                    self.proceedForProfileMatchedView(userInfo: userInfo)
                }
                
            case PushNotificationType.CHAT_NOTIFICATION.rawValue:
                
                if (UIApplication.topViewController() is ChatViewController){
                    if let chatController = UIApplication.topViewController() as? ChatViewController{
                        if let pushChatDialogId = userInfo["chatDialogId"] as? String {
                            if pushChatDialogId == chatController.viewModel?.chatRoom?.chat_dialog_id ?? "" {
                                return false
                            }
                        }
                    }
                    return true
                }
                
            default:
                return false
            }
        }
        return true
    }
}

extension PushNotificationHandler: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void) {
        handleBadgeCount()
        if self.shouldPresentNotificationBanner(notification) {
            completionHandler([.list, .banner, .sound, .badge])
        } else {
            completionHandler([.list, .banner, .sound, .badge])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        handleBadgeCount()
        self.notificationUserInfo = response.userInfo
        NotificationCenter.default.post(name: .notificationTapped, object: nil)
        self.handlePushNotification(response)
        completionHandler()
    }
}

extension PushNotificationHandler: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("fcmToken: " + fcmToken!)
        KAPPSTORAGE.fcmToken = fcmToken ?? "1234567890"
    }
}
// MARK: - Handle redirection according to push type selection...
extension PushNotificationHandler {
    fileprivate func showBroadcastPushAlert(userInfo: [AnyHashable: Any]) {
        let title = userInfo["title"] as? String
        let message = userInfo["message"] as? String
        
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in //Just dismiss the action sheet
        }
        
        alertController.addAction(okAction)
        
        var parentController = UIApplication.shared.keyWindow?.rootViewController
        //UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        while (parentController?.presentedViewController != nil &&
                parentController != parentController!.presentedViewController) {
            parentController = parentController!.presentedViewController
        }

        parentController?.present(alertController, animated:true, completion:nil)
        
        
        //KAPPDELEGATE.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        
    }
    
    fileprivate func proceedForBroadCastPopupView(userInfo: [AnyHashable: Any]) {
        let controller = BroadCastPushViewController.getController() as! BroadCastPushViewController
        controller.dismissCompletion = { value  in }
        
        if var parentController = UIApplication.shared.keyWindow?.rootViewController {
            while (parentController.presentedViewController != nil &&
                   parentController != parentController.presentedViewController) {
                parentController = parentController.presentedViewController!
            }
            controller.show(over: parentController, userInfo: userInfo, isCome: "PushNotificationHandler", title: "", desc: "") { value  in }
        }
    }
    
    fileprivate func proceedForProfileMatchedView(userInfo: [AnyHashable: Any]) {
        let controller = MatchedViewController.getController() as! MatchedViewController
        controller.dismissCompletion = { value  in}
        
        if var parentController = UIApplication.shared.keyWindow?.rootViewController {
            while (parentController.presentedViewController != nil &&
                   parentController != parentController.presentedViewController) {
                parentController = parentController.presentedViewController!
            }
            controller.show(over: parentController, isCome: "PROFILE_MATCHED", userInfo: userInfo, notificationData: nil) { value  in }
        }
    }
    
    fileprivate func logoutSuccess() {
        KUSERMODEL.logoutUser()
        gotoLoginScreen()
    }
    
    fileprivate func gotoLoginScreen() {
        UserModel.shared.logoutUser()
        KAPPDELEGATE.updateRootController(LoginViewController.getController(),
                                          transitionDirection: .toRight,
                                          embedInNavigationController: true)
    }
    
    
    func getLikedProfileData(userInfo: [AnyHashable: Any]) {
        let param = [ "id": userInfo["senderId"] as? String ?? ""] as [String: Any]
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
               
                if self.profileArr.count != 0 {
                    self.proceedToDetailScreen(profile: self.profileArr[0])
                }
                
            }
            else {
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    
    func proceedToDetailScreen(profile: ProfilesModel) {
        KAPPDELEGATE.updateRootController(FullViewDetailViewController.getController(with: "home", forceBackToHome: true, selectedProfile: profile, allProfiles: profileArr, selectedIndex: 0), transitionDirection: .toRight, embedInNavigationController: true)
    }
    
    
    func proceedForFetchChatRoomDetails(chatRoomId:String) {
        let ref = Database.database().reference().child("Chats").child(chatRoomId)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let snapDict = snapshot.value as? [String:AnyObject] {
                do {
                    let model = try FirebaseDecoder().decode(ChatRoomModel.self, from: snapDict)
                    KAPPDELEGATE.updateRootController(ChatViewController.getController(with: "CHAT_NOTIFICATION", chatRoom: model), transitionDirection: .fade,
                                                      embedInNavigationController: true)
                } catch let error {
                    print(error)
                }

            }else{
                print("SnapDict is null")
            }
        })
    }
}

extension UIApplication {
    
    var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
    
    var keyWindowPresentedController: UIViewController? {
        var viewController = self.keyWindow?.rootViewController
        // If root `UIViewController` is a `UITabBarController`
        if let presentedController = viewController as? UITabBarController {
            viewController = presentedController.selectedViewController
        }
        // Go deeper to find the last presented `UIViewController`
        while let presentedController = viewController?.presentedViewController {
            if let presentedController = presentedController as? UITabBarController {
                viewController = presentedController.selectedViewController
            } else {
                viewController = presentedController
            }
        }
        return viewController
    }
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        // add this if tabbar exist... to get top controller in tabbar...
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
