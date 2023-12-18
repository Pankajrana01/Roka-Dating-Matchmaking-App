//
//  ChatPagerController.swift
//  Roka
//
//  Created by Applify  on 21/11/22.
//

import UIKit

class ChatPagerController: DTPagerController {

    class func storyboard() -> UIStoryboard {
        return UIStoryboard.chat
    }
    
    class func identifier() -> String {
        return ViewControllerIdentifier.chatPager
    }
    
    class func getController() -> ChatPagerController {
        return self.storyboard().instantiateViewController(withIdentifier:
            self.identifier()) as! ChatPagerController
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
    
    let viewController1 = InboxController.getController()
    let viewController2 = InviteController.getController()
    var searchBar: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirestoreManager.signInOnFirebase()

        perferredScrollIndicatorHeight = 3
        viewController1.title = "Inbox"
        
        viewController2.title = "Invitations"
        
        viewControllers = [viewController1, viewController2]
        
        scrollIndicator.backgroundColor = UIColor.loginBlueColor
        scrollIndicator.layer.cornerRadius = scrollIndicator.frame.height / 2

        setSelectedPageIndex(0, animated: true)

        pageSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.appBorder], for: .selected)
        pageSegmentedControl.backgroundColor = .white
        
        showLeftNavigationLogo()
        showRightNavigationLogo()
    }
        
    // MARK: - Navigation Bar
    func showLeftNavigationLogo() {
        let btn1 = UIButton.init(frame: CGRect(x: 15, y: 0, width: 30, height: 30))
        if GlobalVariables.shared.selectedProfileMode == "MatchMaking" {
            btn1.setImage(UIImage(named: "Ic_Logo_nav"), for: .normal)
        }else{
            btn1.setImage(UIImage(named: "IC_logo_purple"), for: .normal)
        }
        
        let leftItem = UIBarButtonItem(customView: btn1)
        
        let space = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItems = [leftItem]
    }
    
    func showRightNavigationLogo() {
        let btn1 = UIButton.init(frame: CGRect(x: 25, y: 0, width: 30, height: 30))
        btn1.addTarget(self, action: #selector(self.btnCreateGroupAct(_:)), for: .touchUpInside)
        let addGroupItem = UIBarButtonItem(customView: btn1)
        
        let btn2 = UIButton.init(frame: CGRect(x: 25, y: 0, width: 30, height: 30))
        btn2.addTarget(self, action: #selector(self.btnFilterAct(_:)), for: .touchUpInside)
        let filterItem = UIBarButtonItem(customView: btn2)
        
        let btn3 = UIButton.init(frame: CGRect(x: 25, y: 0, width: 30, height: 30))
        btn3.addTarget(self, action: #selector(self.btnSearchAct(_:)), for: .touchUpInside)
        let searchItem = UIBarButtonItem(customView: btn3)
        
        if GlobalVariables.shared.selectedProfileMode == "MatchMaking" {
            btn1.setImage(UIImage(named: "ic_add_group"), for: .normal)
            btn2.setImage(UIImage(named: "New_Filter_con_Black"), for: .normal)
            btn3.setImage(UIImage(named: "Ic_search_dark"), for: .normal)
        }else{
            btn1.setImage(UIImage(named: "new_Whitle_Group"), for: .normal)
            btn2.setImage(UIImage(named: "new_White_Filter"), for: .normal)
            btn3.setImage(UIImage(named: "new_Whitle_Search"), for: .normal)
        }
        
        self.navigationItem.rightBarButtonItems = [addGroupItem, filterItem, searchItem]
    }
    
    func showSearchBar() {
        searchBar = UITextField(frame: CGRectMake(0, 0, UIScreen.main.bounds.width - 95, 20))
        searchBar?.placeholder = "Search"
        searchBar?.font = UIFont(name: "SFProDisplay-Regular", size: 15.0)
        searchBar?.borderStyle = .roundedRect // border style
        searchBar?.delegate = self
        searchBar?.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
        let leftNavBarButton = UIBarButtonItem(customView:searchBar!)
        self.navigationItem.leftBarButtonItems = [leftNavBarButton]
        
        let cancelBtn = UIButton.init(frame: CGRect(x: 25, y: 0, width: 50, height: 30))
        cancelBtn.setTitle("Cancel", for: .normal)
        if GlobalVariables.shared.selectedProfileMode == "MatchMaking" {
            cancelBtn.setTitleColor(UIColor.black, for: .normal)
        }else{
            cancelBtn.setTitleColor(UIColor.white, for: .normal)
        }
        cancelBtn.titleLabel?.font = UIFont(name: "SFProDisplay-Regular", size: 15.0)

        cancelBtn.addTarget(self, action: #selector(self.searchCancelAct(_:)), for: .touchUpInside)
        let cancelBtnItem = UIBarButtonItem(customView: cancelBtn)

        self.navigationItem.rightBarButtonItems = [cancelBtnItem]
    }
    
    // MARK: - Button Actions
    @objc func btnSearchAct(_ button: UIButton) {
        showSearchBar()
    }
    
    @objc func btnFilterAct(_ button: UIButton) {
        (viewController1 as? InboxController)?.applyFiters()
    }
    
    @objc func btnCreateGroupAct(_ button: UIButton) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "One to One Chat", style: .default, handler: { action in
            CreateGroupViewController.show(from: self, forcePresent: false, isComeFor: "oneToOne", profiles: []) { success in
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Group Chat", style: .default, handler: { action in
            CreateGroupViewController.show(from: self, forcePresent: false, isComeFor: "group", profiles: []) { success in
            }
        }))
        
        
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func searchCancelAct(_ button: UIButton) {
        self.endEditing(true)
        searchAction(text: "")
        showLeftNavigationLogo()
        showRightNavigationLogo()
    }
}

// MARK: - UITextFieldDelegate
extension ChatPagerController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        if (textField == searchBar) {
            searchAction(text: newString)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchBar?.endEditing(true)
        searchAction(text: searchBar?.text ?? "")
        return true
    }
    
    @objc func doneButtonClicked(_ sender: Any) {
        self.searchBar?.endEditing(true)
        searchAction(text: searchBar?.text ?? "")
    }
    
    func searchAction(text:String) {
        self.selectedPageIndex == 0 ? (viewController1 as? InboxController)?.searchAction(text: text) : (viewController2 as? InviteController)?.searchAction(text: text)
    }
}
