//
//  PagerController.swift
//  DTPagerController
//
//  Created by tungvoduc on 22/09/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import ObjectiveC.runtime

class PagerController: DTPagerController {
    func storyboard() -> UIStoryboard {
        return UIStoryboard.home
    }
    
    func identifier() -> String {
        return ViewControllerIdentifier.pageController
    }
    
    func getController() -> PagerController {
        return self.storyboard().instantiateViewController(withIdentifier:
            self.identifier()) as! PagerController
    }
   
    func show(from viewController: UIPageViewController, forcePresent: Bool = false) {
        let vc = self.getController()
        vc.show(from: viewController, forcePresent: forcePresent)
    }
    
    var barItem = UIBarButtonItem()
    var leftItem = UIBarButtonItem()
    var toggleButton = UIButton()
    var bannerView = ISBannerView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        perferredScrollIndicatorHeight = 2

        let viewController1 = HomeViewController.getController()
        viewController1.title = "For you"

        let viewController2 = HomeViewController.getController()
        viewController2.title = "Likes"

        let viewController3 = HomeViewController.getController()
        viewController3.title = "Aligned"

        let viewController4 = HomeViewController.getController()
        viewController4.title = "Nearby"
        
        viewControllers = [viewController1, viewController2, viewController3, viewController4]
        
        scrollIndicator.backgroundColor = UIColor.appPurpleColor.withAlphaComponent(0.5)
        scrollIndicator.layer.cornerRadius = scrollIndicator.frame.height / 2

        if KAPPSTORAGE.islikeSeleted == "0" {
            KAPPSTORAGE.islikeSeleted = "0"
            setSelectedPageIndex(0, animated: true)
        } else if KAPPSTORAGE.islikeSeleted == "1" {
            KAPPSTORAGE.islikeSeleted = "0"
            setSelectedPageIndex(1, animated: true)
        } else if KAPPSTORAGE.islikeSeleted == "3" {
            KAPPSTORAGE.islikeSeleted = "0"
            setSelectedPageIndex(3, animated: true)
        } else {
            setSelectedPageIndex(0, animated: true)
        }
        

        pageSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.appTitleBlueColor], for: .selected)
        pageSegmentedControl.backgroundColor = .white
        
//        pageSegmentedControl.layer.masksToBounds = true
//        pageSegmentedControl.layer.shadowColor = UIColor.lightGray.cgColor
//        pageSegmentedControl.layer.shadowOffset = CGSize(width: 0, height: 1)
//        pageSegmentedControl.layer.shadowRadius = 1
//        pageSegmentedControl.layer.shadowOpacity = 0.5
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        showLeftNavigationLogo()
        addNavigationRightButton()
      
        DispatchQueue.main.async {
            self.setupIronSourceSdk()
            self.initBannerAdsView()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        distroyBanner()
    }
    func showLeftNavigationLogo() {
        let btn1 = UIButton()
        btn1.setImage(UIImage(named: "IC_logo_purple"), for: .normal)
        btn1.frame = CGRect(x: 15, y: 0, width: 30, height: 30)
        leftItem.customView = btn1
        let space = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItems = [leftItem]
    }
    
    func addNavigationRightButton() {
        toggleButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        toggleButton.setImage(UIImage(named: "ic_toggle"), for: .normal)
        toggleButton.addTarget(self, action: #selector(toggleButtonAction(_:)), for: .touchUpInside)
        barItem = UIBarButtonItem(customView: toggleButton)
        self.navigationItem.rightBarButtonItem = barItem
    }

    @objc func toggleButtonAction(_ sender: UIButton){
        proceedForSwitchModeScreen()
    }
    
    func proceedForSwitchModeScreen() {
        let controller = SwitchModeViewController.getController() as! SwitchModeViewController
        controller.dismissCompletion = { _  in
            //self.distroyBanner()
        }
        controller.show(over: self, isComeFor: "Dating") { _ in }
    }
}

// MARK: - ISBannerDelegate Functions

extension PagerController: ISBannerDelegate, ISInitializationDelegate, ISImpressionDataDelegate {
    
    func distroyBanner() {
        DispatchQueue.main.async {
           // if self.bannerView != nil {
                IronSource.destroyBanner(self.bannerView)
            //}
        }
    }
    
    func initializationDidComplete() {
        logFunctionName()
    }

    func setupIronSourceSdk() {
        ISIntegrationHelper.validateIntegration()
        IronSource.setBannerDelegate(self)
        IronSource.add(self)
        
         //IronSource.initWithAppKey(kAPPKEY, delegate: self)
        // To initialize specific ad units:
        IronSource.initWithAppKey(kAPPKEY, adUnits: [IS_BANNER])
    }
    
    func initBannerAdsView() {
        let BNSize: ISBannerSize = ISBannerSize(description: "BANNER", width:320 ,height:50)
        IronSource.loadBanner(with: self, size: BNSize)
    }
    
    func logFunctionName(string: String = #function) {
        print("IronSource Swift Demo App: "+string)
    }
    
    func bannerDidLoad(_ bannerView: ISBannerView!) {
        self.bannerView = bannerView
        
        if #available(iOS 11.0, *) {
            bannerView.frame = CGRect(x: self.view.frame.size.width/2 - bannerView.frame.size.width/2, y:55, width: bannerView.frame.size.width, height: bannerView.frame.size.height - self.view.safeAreaInsets.bottom * 2.5)
        } else {
            bannerView.frame = CGRect(x: self.view.frame.size.width/2 - bannerView.frame.size.width/2, y: 55, width: bannerView.frame.size.width, height: bannerView.frame.size.height  * 2.5)
        }
        
        NotificationCenter.default.post(name: .updateNotificationForAds, object: nil)
        
        self.view.addSubview(bannerView)
        
        logFunctionName()
    }
    
    func bannerDidFailToLoadWithError(_ error: Error!) {
        logFunctionName(string: #function+String(describing: Error.self))
        
    }
    
    func didClickBanner() {
        logFunctionName()
    }
    
    func bannerWillPresentScreen() {
        logFunctionName()
    }
    
    func bannerDidDismissScreen() {
        logFunctionName()
    }
    
    func bannerWillLeaveApplication() {
        logFunctionName()
    }
    
    // MARK: - ISImpressionData Functions
    func impressionDataDidSucceed(_ impressionData: ISImpressionData!) {
        logFunctionName(string: #function+String(describing: impressionData))

    }
}
