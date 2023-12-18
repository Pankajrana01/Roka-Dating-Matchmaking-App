//
//  MatchingTabBar.swift
//  Roka
//
//  Created by Pankaj Rana on 21/11/22.
//

import UIKit
import FirebaseDatabase
import CodableFirebase

class MatchingTabBar: UITabBarController, UITabBarControllerDelegate {
    
    class func storyboard() -> UIStoryboard {
        return UIStoryboard.matchingTabBar
    }
    
    class func identifier() -> String {
        return ViewControllerIdentifier.matchingTabBar
    }
    
    class func getController() -> MatchingTabBar {
        return self.storyboard().instantiateViewController(withIdentifier:
            self.identifier()) as! MatchingTabBar
    }
   
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isCome:String) {
        let vc = self.getController()
        vc.isCome = isCome
        self.show(from: viewController, forcePresent: forcePresent, isCome: isCome)
    }

    func show(from viewController: UIViewController,
              forcePresent: Bool = false,
              isCome:String) {
        viewController.endEditing(true)
        DispatchQueue.main.async {
            if forcePresent {
                viewController.present(self, animated: true, completion: nil)
            } else {
                viewController.show(self, sender: nil)
            }
        }
    }
    
    @IBOutlet weak var tabbar: UITabBar!
    var isCome = ""
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    var chatRooms: [ChatRoomModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Customize the navigation bar color for the second tab
        self.navigationController?.isNavigationBarHidden = true
        setNeedsStatusBarAppearanceUpdate()
        customizeTabBar()

        tabBar.layer.masksToBounds = false
        tabBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        tabBar.layer.shadowOffset = CGSize(width: -2, height: -2)
        tabBar.layer.shadowOpacity = 0.2
        tabBar.layer.shadowRadius = 1
        //showNavigationLogo()
        // Do any additional setup after loading the view.
        self.delegate = self
        
        self.tabbar.items?[4].image = UIImage(named: "img_profile_tab_unselected")?.withRenderingMode(.alwaysOriginal)
        
        self.tabbar.items?[4].selectedImage = UIImage(named: "img_profile_tab_selected")?.withRenderingMode(.alwaysOriginal)
        self.tabbar.items?[4].title = "Profile"
       
        chatHistoryApi({ res in })
        
        viewControllers?.forEach {
            if let navController = $0 as? UINavigationController {
                let _ = navController.topViewController?.view
            } else {
                let _ = $0.view.description
            }
        }
    }
    
    func changeHeightOfTabbar() {
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        var tabFrame = tabBar.frame
        if UIDevice().userInterfaceIdiom == .phone {
            if height >= 812.0 {
                tabFrame.size.height    = 110
                tabFrame.origin.y       = view.frame.size.height - 110
                tabBar.frame            = tabFrame
            } else {
                tabFrame.size.height    = 68
                tabFrame.origin.y       = view.frame.size.height - 68
                tabBar.frame            = tabFrame
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        changeHeightOfTabbar()
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(updateNotificationIconImage),name: .updateNotificationIcon,                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateChatIconImage),name: .updateChatIcon,                               object: nil)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        // Set the default open tab bar items
        let defaultTabIndex = 2
        self.selectedIndex = defaultTabIndex
        
        if KAPPSTORAGE.searchBackCheck == true {
            KAPPSTORAGE.searchBackCheck = false
            let defaultTabIndex = 0
            self.selectedIndex = defaultTabIndex
        } else {
            let defaultTabIndex = 2
            self.selectedIndex = defaultTabIndex
        }
    }
    
    @objc func updateNotificationIconImage(_ notification: Notification){
        processForGetUserData()
    }
    
    @objc func updateChatIconImage(_ notification: Notification){
        if let unreadCount = notification.userInfo?["unreadCount"] as? Int {
            print(unreadCount)
            if unreadCount == 0{
                self.tabbar.items![3].image = UIImage(named: "ic_chat_unselected")?.withRenderingMode(.alwaysOriginal)
                self.tabbar.items![3].selectedImage = UIImage(named: "ic_chat_selected")?.withRenderingMode(.alwaysOriginal)
            } else {
                self.tabbar.items![3].image = UIImage(named: "ic_chat_unselected_red")?.withRenderingMode(.alwaysOriginal)
                self.tabbar.items![3].selectedImage = UIImage(named: "ic_chat_selected_red")?.withRenderingMode(.alwaysOriginal)
            }
        }
    }
    
    // MARK: - API Call...
    func processForGetUserData() {
        ApiManager.makeApiCall(APIUrl.User.basePreFix,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .get) { response, _ in
            if let responseData = response?[APIConstants.data] as? [String: Any] {
                self.user.updateWith(responseData)
                
                if self.user.unreadNotificationCount == 0{
                    self.tabbar.items![1].image = UIImage(named: "ic_notifications_unselected")?.withRenderingMode(.alwaysOriginal)
                    self.tabbar.items![1].selectedImage = UIImage(named: "ic_notifications_selected")?.withRenderingMode(.alwaysOriginal)
                } else {
                    self.tabbar.items![1].image = UIImage(named: "ic_notifications_unselected_red")?.withRenderingMode(.alwaysOriginal)
                    self.tabbar.items![1].selectedImage = UIImage(named: "ic_notifications_selected_red")?.withRenderingMode(.alwaysOriginal)
                }
            }
        }
    }
}
extension MatchingTabBar {
    func chatHistoryApi(_ result:@escaping([String: Any]?) -> Void) {
        ApiManager.makeApiCall(APIUrl.Chat.chatHistory,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .get) { response, _ in }
    }
}

extension UITabBarController {
    func customizeTabBar() {
        // Create a UITabBarAppearance instance
        let tabBarAppearance = UITabBarAppearance()

        // Set the default color for the tab bar item names (unselected state)
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.appTitleBlueColor, NSAttributedString.Key.font: UIFont(name: "SharpSansTRIAL-Semibold", size: 11.0)!
        ]
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes

        // Set the color for the selected tab bar item name
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.appTitleBlueColor, NSAttributedString.Key.font: UIFont(name: "SharpSansTRIAL-Semibold", size: 11.0)!
        ]
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes
        
        // Apply the customized appearance to the tab bar
        tabBar.standardAppearance = tabBarAppearance
    }
}
