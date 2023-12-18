//
//  AppDelegate.swift
//  Roka
//
//  Created by Applify  on 19/09/22.
//

import UIKit
import SVProgressHUD
import SwiftMessages
import IQKeyboardManagerSwift
import GooglePlaces
import Firebase
import FirebaseCore
import FirebaseCrashlytics
import Swifter
@main

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    weak var screen : UIView? = nil
    var secureView: SecureView!

    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    var isCachingData: Bool = false
    var searchBackCheck: Bool = false
    var SeachFilter: Bool = false
    var isSubscriptionPlanActivess = 0

    // MARK: - for twitter login
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
            let callbackUrl = URL(string: TwitterConstants.CALLBACK_URL)!
            Swifter.handleOpenURL(url, callbackURL: callbackUrl)
            return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }

        if let placesAPIKey = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_PLACES_API_KEY") as? String {
            //AIzaSyDOgUN19bulgobjY5uhzzzedxyEJx9PIgg
            GMSPlacesClient.provideAPIKey(placesAPIKey)
        }
       // preventAppToTakeScreenshot()
        initializeDatingNavigationBar()
        initializeSVProgressHud()
        initializeSwiftMessages()
        initializeKeyboardManager()
        initializeFirebase()
        initializePushNotifications()
        startListeningNetworkReachability()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate{
    func initializeNavigationBar() {
//        UINavigationBar.appearance().tintColor = .appBorder
//        UINavigationBar.appearance().barTintColor = UIColor.white
//
        // Customizing our navigation bar
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.white
        appearance.shadowColor = UIColor.white
        let navigationFont = UIFont(name: "SharpGrotesk-SemiBold25", size: 18.0)
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.appTitleBlueColor, NSAttributedString.Key.font: navigationFont!]
        appearance.setBackIndicatorImage(UIImage(named: "Ic_back_1"), transitionMaskImage: UIImage(named: "Ic_back_1"))
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance

    }
    
    func initializeDatingNavigationBar() {
        UINavigationBar.appearance().tintColor = .white
//        UINavigationBar.appearance().barTintColor = UIColor.appTitleBlueColor
        
        // Customizing our navigation bar
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.appTitleBlueColor
        appearance.shadowColor = UIColor.appTitleBlueColor
        
        let navigationFont = UIFont(name: "SharpGrotesk-SemiBold25", size: 18.0)
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: navigationFont!]

        appearance.setBackIndicatorImage(UIImage(named: "Ic_back_1"), transitionMaskImage: UIImage(named: "Ic_back_1"))
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        
        
        // Color and font of typed text in the search bar.
        let searchBarTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 16)]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = searchBarTextAttributes as [NSAttributedString.Key : Any]
        // Color of the placeholder text in the search bar prior to text entry
          let placeholderAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 15)]
        // Color of the default search text.
          let attributedPlaceholder = NSAttributedString(string: "Search", attributes: placeholderAttributes as [NSAttributedString.Key : Any])
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = attributedPlaceholder

    }
    
    func initializeMatchMakingNavigationBar() {
//        UINavigationBar.appearance().tintColor = .appBorder
//        UINavigationBar.appearance().barTintColor = UIColor.loginBlueColor
        
        // Customizing our navigation bar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.loginBlueColor
        appearance.shadowColor = UIColor.loginBlueColor
        let navigationFont = UIFont(name: "SharpGrotesk-SemiBold25", size: 18.0)
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.appTitleBlueColor, NSAttributedString.Key.font: navigationFont!]
        appearance.setBackIndicatorImage(UIImage(named: "Ic_back_1"), transitionMaskImage: UIImage(named: "Ic_back_1"))
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance

    }
    
    private func initializeSVProgressHud() {
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setForegroundColor(UIColor.black)           //Ring Color
       // SVProgressHUD.setBackgroundColor(UIColor.appTheme)
    }
    
    private func initializeSwiftMessages() {
        SwiftMessages.defaultConfig.presentationStyle = .top
        SwiftMessages.defaultConfig.presentationContext = .window(windowLevel: .normal)
        SwiftMessages.defaultConfig.duration = SwiftMessages.Duration.seconds(seconds: 2.0)
        SwiftMessages.defaultConfig.preferredStatusBarStyle = .darkContent
    }
    
    private func initializeKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 10
        IQKeyboardManager.shared.toolbarTintColor = UIColor.black
    
    }

    private func initializeFirebase() {
//      FirebaseOptions.defaultOptions()?.deepLinkURLScheme = "DynamicLink"
        FirebaseApp.configure()
        if KUSERMODEL.isLoggedIn() {
            FirestoreManager.signInOnFirebase()
        }
    }
    
    private func initializePushNotifications() {
        PushNotificationHandler.shared.configure()
        PushNotificationHandler.shared.askForPushNotifications { }

    }
    
    private func preventAppToTakeScreenshot() {
        // Override point for customization after application launch.
        NotificationCenter.default.addObserver(self, selector: #selector(preventScreenshot), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
    }
    
    @objc func preventScreenshot() {
        self.blurScreen()
    }

    func blurScreen(style: UIBlurEffect.Style = UIBlurEffect.Style.regular) {
        screen = UIScreen.main.snapshotView(afterScreenUpdates: true)
        let blurEffect = UIBlurEffect(style: style)
        let blurBackground = UIVisualEffectView(effect: blurEffect)
        blurBackground.frame = (screen?.frame)!
        screen?.addSubview(blurBackground)
        window?.addSubview(screen!)
        
//        secureView = SecureView()
//        secureView.translatesAutoresizingMaskIntoConstraints = false
//
//        let placeholderText = UILabel()
//        placeholderText.translatesAutoresizingMaskIntoConstraints = false
//        placeholderText.numberOfLines = 0
//        placeholderText.textAlignment = .center
//        placeholderText.backgroundColor = .black
//        placeholderText.text = "Screenshot Blocked \nIt looks like you tried to take a screenshot. This screenshot was blocked for added privacy."
//
//        secureView.placeholderView.addSubview(placeholderText)
//        screen?.addSubview(secureView)
//        self.window?.addSubview(screen!)
        
//        NSLayoutConstraint.activate([
//            secureView.leadingAnchor.constraint(equalTo: self.screen!.leadingAnchor),
//            secureView.trailingAnchor.constraint(equalTo: self.screen!.trailingAnchor),
//            secureView.topAnchor.constraint(equalTo: self.screen!.topAnchor),
//            secureView.bottomAnchor.constraint(equalTo: self.screen!.bottomAnchor),
//            placeholderText.centerXAnchor.constraint(equalTo: secureView.centerXAnchor),
//            placeholderText.centerYAnchor.constraint(equalTo: secureView.centerYAnchor),
//        ])
        
    }

    func removeBlurScreen() {
        screen?.removeFromSuperview()
    }
}

extension AppDelegate {
    func silentPreloadS3UrlIfRequired() {
        if KAPPSTORAGE.s3Url.isEmpty && !isCachingData {
            isCachingData = true
            ApiManager.makeApiCall(APIUrl.BasicApis.getS3Floders, method: .get) { response, arg  in
                if !BaseViewModel.hasErrorIn(response),
                    let data = response![APIConstants.data] as? [String: Any] {
                    let s3Url = data[WebConstants.s3Url] as! String
                    let userPicDirectoryName = (data[WebConstants.directories] as! [String: Any])[WebConstants.users] as! String
                    KAPPSTORAGE.s3Url = s3Url
                    KAPPSTORAGE.userPicDirectoryName = userPicDirectoryName
                }
                self.isCachingData = false
            }
        }
    }
}
