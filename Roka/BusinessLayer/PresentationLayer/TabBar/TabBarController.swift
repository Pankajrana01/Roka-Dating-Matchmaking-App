//
//  TabBarController.swift
//  Roka
//
//  Created by Pankaj Rana on 23/09/22.
//

import UIKit
import FirebaseDatabase
import CodableFirebase

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    class func storyboard() -> UIStoryboard {
        return UIStoryboard.tabBar
    }
    
    class func identifier() -> String {
        return ViewControllerIdentifier.tabBar
    }
    
    class func getController() -> TabBarController {
        return self.storyboard().instantiateViewController(withIdentifier:
            self.identifier()) as! TabBarController
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
    var isKycApproved = 0
    var kycVideo = [[String:Any]]()
    var chatRooms: [ChatRoomModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
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
       // updateProfileIcon()
        
        if GlobalVariables.shared.isKycPendingPopupShow == false {
            updateKycStatusCall()
        }else{
            GlobalVariables.shared.isKycPendingPopupShow = false
        }
    
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
    
    func proceedForPendingKYCView() {
        let controller = PendingKYCViewController.getController() as! PendingKYCViewController
        controller.dismissCompletion = { value  in }
        controller.show(over: self) { value  in
        }
    }
    
    func updateKycStatusCall() {
        if GlobalVariables.shared.selectedProfileMode != "MatchMaking" {
            self.processForGetUserProfileData { result in
                if let userVideos = result?["userVideos"] as? [[String:Any]] {
                    self.kycVideo = userVideos
                }
                if let isKycApproved = result?["isKycApproved"] as? Int {
                    if self.kycVideo.count != 0 {
                        if isKycApproved == 2 {
                            self.proceedForPendingKYCView()
                        }
                    } else {
                        self.proceedForPendingKYCView()
                    }
                }
            }
        }
    }
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // NotificationCenter.default.addObserver(self, selector: #selector(updateProfileIconImage),name: NSNotification.Name("updateProfileIcon"),                               object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateNotificationIconImage),name: .updateNotificationIcon,                               object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateChatIconImage),name: .updateChatIcon,                               object: nil)
    }

    // MARK: - Remove Notification
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func updateProfileIcon() {
        for i in 0..<self.user.userImages.count {
            if self.user.userImages[i].isDp == 1 {
                let userImage = self.user.userImages[i].file
                let imageUrl: String = KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + userImage
                
                if let url = URL(string: imageUrl) {
                    DispatchQueue.global().async { [weak self] in
                        if let data = try? Data(contentsOf: url) {
                            if let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    if let tabBarItem5 = self?.tabbar.items?[4] {
                                        
                                        let barImage: UIImage = image.squareMyImage().resizeMyImage(newWidth: 25).roundMyImage.withRenderingMode(.alwaysOriginal)

                                        tabBarItem5.image = barImage
                                        tabBarItem5.title = ""
                                        tabBarItem5.selectedImage = barImage
                                    }
                                }
                            }
                        }
                    }
                } else {
                    self.tabbar.items![4].image = UIImage(named: "img_profile_tab")?.withRenderingMode(.alwaysOriginal)
                    self.tabbar.items![4].selectedImage = UIImage(named: "img_profile_tab")?.withRenderingMode(.alwaysOriginal)
                }
                
            }
        }
    }
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    @objc func updateProfileIconImage(_ notification: Notification){
        updateProfileIcon()
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
                
                if self.user.unreadNotificationCount == 0 {
                    self.tabbar.items![1].image = UIImage(named: "ic_notifications_unselected")?.withRenderingMode(.alwaysOriginal)
                    self.tabbar.items![1].selectedImage = UIImage(named: "ic_notifications_selected")?.withRenderingMode(.alwaysOriginal)
                } else {
                    self.tabbar.items![1].image = UIImage(named: "ic_notifications_unselected_red")?.withRenderingMode(.alwaysOriginal)
                    self.tabbar.items![1].selectedImage = UIImage(named: "ic_notifications_selected_red")?.withRenderingMode(.alwaysOriginal)
                }
            }
        }
    }
    
    // MARK: - API Call...
    func processForGetUserProfileData(_ result:@escaping([String: Any]?) -> Void) {
        ApiManager.makeApiCall(APIUrl.UserApis.getUserProfileDetail,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .get) { response, _ in
            DispatchQueue.main.async {
                if let userResponseData = response![APIConstants.data] as? [String: Any] {
                    result(userResponseData)
                }
            }
            //hideLoader()
        }
    }
    
}

extension UIImage{
    var roundMyImage: UIImage {
        let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
        UIBezierPath(
            roundedRect: rect,
            cornerRadius: self.size.height
        ).addClip()
        self.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    func resizeMyImage(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    func squareMyImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: self.size.width, height: self.size.width))
        
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.width))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
extension TabBarController {
    func chatHistoryApi(_ result:@escaping([String: Any]?) -> Void) {
        ApiManager.makeApiCall(APIUrl.Chat.chatHistory,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .get) { response, _ in }
    }
}
