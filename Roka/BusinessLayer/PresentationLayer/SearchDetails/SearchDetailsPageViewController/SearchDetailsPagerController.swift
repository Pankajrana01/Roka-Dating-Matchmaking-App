//
//  SearchDetailsPagerController.swift
//  Roka
//
//  Created by  Developer on 10/11/22.
//

import UIKit

class SearchDetailsPagerController: DTPagerController {
    class func storyboard() -> UIStoryboard {
        return UIStoryboard.searchDetails
    }
    
    class func identifier() -> String {
        return ViewControllerIdentifier.searchDetailsPager
    }
    
    class func getController() -> SearchDetailsPagerController {
        return self.storyboard().instantiateViewController(withIdentifier:
            self.identifier()) as! SearchDetailsPagerController
    }
   
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isCome:String,
                    id:String,
                    profileCount:String,
                    titleName:String) {
        let vc = self.getController()
        vc.hidesBottomBarWhenPushed = false
        vc.searchPreferenceId = id
        let nsString = titleName as NSString
        let screenRect = UIScreen.main.bounds
                let screenHeight = screenRect.size.height
                if screenHeight >= 812 {
                    vc.searchPreferenceTitleName = nsString.substring(with: NSRange(location: 0, length: nsString.length > 17 ? 17 : nsString.length))
                    if vc.searchPreferenceTitleName.count >= 17 {
                        vc.searchPreferenceTitleName += "..."
                    }
                } else {
                    vc.searchPreferenceTitleName = nsString.substring(with: NSRange(location: 0, length: nsString.length > 14 ? 14 : nsString.length))
                    if vc.searchPreferenceTitleName.count >= 14 {
                        vc.searchPreferenceTitleName += "..."
                    }
                }
      
        vc.profileCount = profileCount
        vc.isCome = isCome
        vc.show(from: viewController, forcePresent: forcePresent, id: id, isCome: isCome, profileCount: profileCount, titleName: titleName)
    }

    func show(from viewController: UIViewController,
              forcePresent: Bool = false,
              id:String,
              isCome:String,
              profileCount:String,
              titleName:String) {
        viewController.endEditing(true)
        DispatchQueue.main.async {
            if forcePresent {
                viewController.present(self, animated: true, completion: nil)
            } else {
                viewController.navigationController?.pushViewController(self, animated: true)
            }
        }
    }
    
    var isSelectedLayout = LayoutType.list
    var searchPreferenceId = ""
    var searchPreferenceTitleName = ""
    var profileCount = ""
    var isCome = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        initPager()
    }
    
    func initPager() {
//        var isMatchMaking = false
//        if GlobalVariables.shared.selectedProfileMode == "MatchMaking" {
//            isMatchMaking = true
//        }
        perferredScrollIndicatorHeight = 2
//        scrollIndicatorHeight.
        
        
        let viewController1 = SearchDetailsViewController.getController()
        viewController1.title = "Chosen by me"
        
        let viewController2 = SearchDetailsViewController.getController()
        viewController2.title = "Roka Suggested"

        let arrayControllers = [viewController1, viewController2]
        viewControllers = arrayControllers
        
        scrollIndicator.backgroundColor = UIColor.loginBlueColor
        scrollIndicator.layer.cornerRadius = scrollIndicator.frame.height / 2
        
        let index = 1
        setSelectedPageIndex(index, animated: true)
 
        pageSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.appBorder], for: .selected)
        pageSegmentedControl.backgroundColor = .white
        
        NotificationCenter.default.post(name: .appSavedPreferenceLayout, object: nil, userInfo: ["layout":self.isSelectedLayout,
                       "searchPreferenceId":self.searchPreferenceId,
                       "searchPreferenceTitleName":self.searchPreferenceTitleName,
                       "isCome": self.isCome])
        
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(refreshProfileCount), name: .refreshProfileCount, object: nil)
    }
    
    @objc func refreshProfileCount(_ notification: Notification) {
        if let count = notification.userInfo?["profileCount"] as? Int, count > 0 {
            updateNaviagtionItems(profileCount: "\(count) Profiles")
        } else {
            updateNaviagtionItems(profileCount: "")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        updateNaviagtionItems(profileCount: self.profileCount)
    }
    
    func updateNaviagtionItems(profileCount:String){
        let title2 = "  " + self.searchPreferenceTitleName + " "
        let desc2 = profileCount
        
        let longString2 = title2 //+ desc2
        let longestWordRange2 = (longString2 as NSString).range(of: desc2)
            
        let attributedString2 = NSMutableAttributedString(string: longString2, attributes: [NSAttributedString.Key.font : UIFont(name: "SharpGrotesk-SemiBold25", size: 16.0)!, NSAttributedString.Key.foregroundColor : UIColor.white.cgColor]) // UIColor.appBorder])
            
        attributedString2.setAttributes([NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Regular", size: 14.0)!, NSAttributedString.Key.foregroundColor : UIColor.appBorder], range: longestWordRange2)
            
//        showNavigationBackButton(title: attributedString2)
        addNavigationBackButton()
        self.title = title2
        
        
        let editButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(self.editNavButtonClicked))
        editButton.imageInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        
        editButton.image = UIImage(named: "ic_edit_2")
        editButton.title = ""
    
        let gridButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(self.gridNavButtonClicked))
        gridButton.image = UIImage(named: "Ic_Grid")
        gridButton.title = ""
        if GlobalVariables.shared.selectedProfileMode != "MatchMaking" {
        } else {
            editButton.tintColor = UIColor.appTitleBlueColor
            gridButton.tintColor = UIColor.appTitleBlueColor
        }
        
        // Here creating emptyButton just to give some space from the left side to rightButton.
        //let emptyRightButton = UIBarButtonItem()
        
        self.navigationItem.rightBarButtonItems = [gridButton, editButton]
    }
    
    @objc func editNavButtonClicked() {
        NewSearchViewController.show(from: self, isComeFor: "Search", preferenceId: searchPreferenceId) { success in
        }
    }
    
    @objc func gridNavButtonClicked() {
        proceedForLayoutView()
    }
    
    func addNavigationBackButton() {
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        if GlobalVariables.shared.selectedProfileMode == "MatchMaking" {
            btn2.setImage(UIImage(named: "Ic_back_1"), for: .normal)
        } else {
            btn2.setImage(UIImage(named: "ic_back_white"), for: .normal)
        }
        
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
    
    
    func proceedForLayoutView() {
        let controller = LayoutViewController.getController() as! LayoutViewController
        controller.dismissCompletion = { value  in }
        controller.show(over: self, isCome: "SavedPreferences", isSelected: isSelectedLayout) { value  in
            print(value)
            self.isSelectedLayout = value
            NotificationCenter.default.post(name: .appSavedPreferenceLayout, object: nil, userInfo: ["layout":self.isSelectedLayout,
                                "searchPreferenceId":self.searchPreferenceId,
                                "searchPreferenceTitleName":self.searchPreferenceTitleName,
                                "isCome": self.isCome])
        }
    }
    
    
    func showNavigationBackButton(title: NSAttributedString){
        let customView = UIView(frame: CGRect(x: -15.0, y: 0.0, width: 200.0, height: 44.0))

        let label = UILabel(frame: customView.frame)
        label.attributedText = title
        label.textColor = .white//UIColor.appBorder
        label.textAlignment = NSTextAlignment.center //NSTextAlignment.left
//        label.font = UIFont(name: "SFProDisplay-Medium", size: 20.0)
        customView.addSubview(label)
        self.navigationItem.titleView = customView
    }

}
