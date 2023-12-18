//
//  SavedProfilePagerController.swift
//  Roka
//
//  Created by Pankaj Rana on 29/10/22.
//

import Foundation
import UIKit

class SavedProfilePagerController: DTPagerController {
    class func storyboard() -> UIStoryboard {
        return UIStoryboard.savedProfiles
    }
    
    class func identifier() -> String {
        return ViewControllerIdentifier.savedProfilesPager
    }
    
    class func getController() -> SavedProfilePagerController {
        return self.storyboard().instantiateViewController(withIdentifier:
            self.identifier()) as! SavedProfilePagerController
    }
   
    class func show(from viewController: UIViewController, forcePresent: Bool = false) {
        let vc = self.getController()
        vc.hidesBottomBarWhenPushed = true

        vc.show(from: viewController, forcePresent: forcePresent)
    }

    func show(from viewController: UIViewController, forcePresent: Bool = false) {
        viewController.endEditing(true)
        DispatchQueue.main.async {
            if forcePresent {
                viewController.present(self, animated: true, completion: nil)
            } else {
                viewController.navigationController?.pushViewController(self, animated: true)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        perferredScrollIndicatorHeight = 2

        let viewController1 = SavedProfilesViewController.getController()
      //  viewController1.title = "Dating"
        viewController1.title = "For you"

        
        let viewController2 = SavedProfilesViewController.getController()
      //  viewController2.title = "Matchmaking"
        viewController2.title = "For others"

        viewControllers = [viewController1, viewController2]
        
       // scrollIndicator.backgroundColor = UIColor.appBorder
        scrollIndicator.backgroundColor  =  UIColor(hex: "#AD9BFB")
        scrollIndicator.layer.cornerRadius = scrollIndicator.frame.height / 2

        setSelectedPageIndex(0, animated: true)

        pageSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.appBorder], for: .selected)
        pageSegmentedControl.backgroundColor = .white
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
       // showNavigationBackButton(title: StringConstants.savedProfiles)
        addNavigationBackButton()
        self.title = StringConstants.savedProfiles
    }
    
    func addNavigationBackButton() {
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn2.setImage(UIImage(named: "ic_back_white"), for: .normal)
        btn2.addTarget(self, action: #selector(backkButtonTapped(_:)), for:.touchUpInside)
        let barButton = UIBarButtonItem(customView: btn2)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func backkButtonTapped(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func showNavigationBackButton(title:String){
        let customView = UIView(frame: CGRect(x: -15.0, y: 0.0, width: 300.0, height: 44.0))

        let label = UILabel(frame: customView.frame)
        label.text = title
        label.textColor = UIColor.appBorder
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont(name: "SharpGrotesk-SemiBold25", size: 16.0)
        customView.addSubview(label)
        self.navigationItem.titleView = customView
    }
    
}
