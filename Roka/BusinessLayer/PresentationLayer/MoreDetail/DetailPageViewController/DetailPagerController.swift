//
//  DetailPagerController.swift
//  Roka
//
//  Created by Pankaj Rana on 06/10/22.
//

import Foundation
import UIKit

class DetailPagerController: DTPagerController {
    class func storyboard() -> UIStoryboard {
        return UIStoryboard.moreDetail
    }
    
    class func identifier() -> String {
        return ViewControllerIdentifier.detailPageController
    }
    
    class func getController() -> DetailPagerController {
        return self.storyboard().instantiateViewController(withIdentifier:
            self.identifier()) as! DetailPagerController
    }
   
    class func show(from viewController: UIViewController, forcePresent: Bool = false, isCome:String) {
        let vc = self.getController()
        vc.isComeFor = isCome
        vc.show(from: viewController, forcePresent: forcePresent, isCome:isCome)
    }

    func show(from viewController: UIViewController, forcePresent: Bool = false, isCome:String) {
        viewController.endEditing(true)
        DispatchQueue.main.async {
            if forcePresent {
                viewController.present(self, animated: true, completion: nil)
            } else {
                viewController.navigationController?.pushViewController(self, animated: true)
            }
        }
    }
    
    var isComeFor = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        perferredScrollIndicatorHeight = 2

        if self.isComeFor == "MatchMakingProfile" || self.isComeFor == "EditMatchingProfile" {
            let viewController1 = MoreDetailViewController.getController()
            viewController1.title = "More about Friend"
            
            
            let viewController2 = MoreDetailViewController.getController()
            viewController2.title = "Friend Preferences"
            
            viewControllers = [viewController1, viewController2]
        } else {
            let viewController1 = MoreDetailViewController.getController()
            viewController1.title = "About me"
            
            
            let viewController2 = MoreDetailViewController.getController()
            viewController2.title = "My preferences"
            
            viewControllers = [viewController1, viewController2]
        }
        scrollIndicator.backgroundColor = UIColor.appPurpleColor.withAlphaComponent(0.5)
        scrollIndicator.layer.cornerRadius = scrollIndicator.frame.height / 2

        setSelectedPageIndex(0, animated: true)

        pageSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.appTitleBlueColor], for: .selected)
        pageSegmentedControl.backgroundColor = .white
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false

        if self.isComeFor == "EditMatchingProfile" {
            addNavigationBackButton()
            self.title = StringConstants.editAboutPreferences
            //showNavigationBackButton(title: StringConstants.editAboutPreferences)
        } else {
            addNavigationBackButton()
            self.title = StringConstants.moreProfileDetails
            //showNavigationBackButton(title: StringConstants.moreProfileDetails)
        }
    }

    func showNavigationBackButton(title:String) {
        let customView = UIView(frame: CGRect(x: -15.0, y: 0.0, width: 300.0, height: 44.0))

        let label = UILabel(frame: customView.frame)
        label.text = title
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "SharpGrotesk-SemiBold25", size: 16.0)
        customView.addSubview(label)
        self.navigationItem.titleView = customView
    }
    
    func addNavigationBackButton() {
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn2.setImage(UIImage(named: "ic_back_white"), for: .normal)
        btn2.addTarget(self, action: #selector(backkButtonTapped(_: )), for: .touchUpInside)
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        view.bounds = view.bounds.offsetBy(dx: 10, dy: 0)
        view.addSubview(btn2)
        
        let barButton = UIBarButtonItem(customView: view)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func backkButtonTapped(_ sender: UIButton) {
       self.navigationController?.popViewController(animated: true)
    }
    
}
