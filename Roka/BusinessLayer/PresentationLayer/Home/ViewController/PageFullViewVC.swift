//
//  PageFullViewVC.swift
//  Roka
//
//  Created by ios on 25/09/23.
//

import UIKit

class PageFullViewVC: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.home
        
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.pageFullView
    }

    lazy var viewModel: PageFullViewModel = PageFullViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func getController(with isCome: String,
                             forceBackToHome:Bool,
                             selectedProfile: ProfilesModel,
                             allProfiles: [ProfilesModel],
                             selectedIndex : Int) -> BaseViewController {
        let controller = self.getController() as! FullViewDetailViewController
        controller.viewModel.isComeFor = isCome
        controller.viewModel.forceBackToHome = forceBackToHome
        controller.viewModel.allProfiles = allProfiles
        controller.viewModel.selectedIndex = selectedIndex
        controller.viewModel.previousSelectedIndex = selectedIndex
        controller.viewModel.selectedProfile = selectedProfile
        controller.hidesBottomBarWhenPushed = true
        return controller
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    forceBackToHome:Bool,
                    isFrom: String,
                    isComeFor:String,
                    selectedProfile: ProfilesModel,
                    allProfiles: [ProfilesModel],
                    selectedIndex : Int,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! PageFullViewVC
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.forceBackToHome = forceBackToHome
        controller.viewModel.isFrom = isFrom
        controller.viewModel.isComeFor = isComeFor
        controller.viewModel.allProfiles = allProfiles
        controller.viewModel.selectedIndex = selectedIndex
        controller.viewModel.previousSelectedIndex = selectedIndex
        controller.viewModel.selectedProfile = selectedProfile
        controller.hidesBottomBarWhenPushed = true
        controller.show(from: viewController, forcePresent: forcePresent)
    }
 
    @IBOutlet weak var cardButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var moreBtnLeadingConst: NSLayoutConstraint!
    @IBOutlet weak var moreBtnWidthConst: NSLayoutConstraint!
    var pageviewcontroller: UIPageViewController!
    var viewControllers = [FullViewDetailViewController]() //[BaseVC] = [BaseVC]()
    var viewControllersIdentifier = [String]() //[BaseVC] = [BaseVC]()
    var array = ["a", "s", "r", "e"]
    var undoIndex = 0
    var isFrom = ""
    var isSwipeFinished = true

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if GlobalVariables.shared.selectedProfileMode != "MatchMaking"{
            self.navigationView.backgroundColor = UIColor(hex: "#031634")
            self.nameLabel.textColor = .white
            self.backButton.setImage(UIImage(named: "ic_back_white"), for: .normal)
            self.moreButton.setImage(UIImage(named: "ic_dots"), for: .normal)
            self.cardButton.setImage(UIImage(named: "ic_card_white"), for: .normal)
            if UserModel.shared.user.id == viewModel.selectedProfile.id{
                self.moreButton.isHidden = true
                self.moreBtnWidthConst.constant = 0
            }else{
                self.moreButton.isHidden = false
            }
        } else {
            self.navigationView.backgroundColor = UIColor(hex: "#AD9BFB")
            self.nameLabel.textColor = UIColor(hex: "#031634")
            self.backButton.setImage(UIImage(named: "Ic_back_1"), for: .normal)
            self.moreButton.setImage(UIImage(named: "im_more_match"), for: .normal)
            self.cardButton.setImage(UIImage(named: "ic_card_black"), for: .normal)
        }
        updateAllProfilesArray()
        
    }
    
    func updateAllProfilesArray() {
        viewModel.allProfilesCopy = viewModel.allProfiles
        let count = viewModel.allProfiles.count - viewModel.selectedIndex
        
        viewModel.allProfiles.removeAll()
        for i in 0...count - 1 {
            viewModel.allProfiles.append(viewModel.allProfilesCopy[viewModel.selectedIndex + i])
        }
        viewModel.selectedIndex = 0
        print(viewModel.allProfiles.count)
        
        initPageViewController()
    }
    
    func initPageViewController() {
        viewModel.pageviewcontroller = self.pageviewcontroller
        self.pageviewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "PageViewControllerLeaderss") as? UIPageViewController
        self.fetchListCategoryData()
        self.pageviewcontroller.dataSource = self
        self.pageviewcontroller.delegate = self

        self.viewContainer.addSubview(pageviewcontroller.view)
        self.pageviewcontroller.view.frame = CGRect(x: 0, y: 0, width: self.viewContainer.frame.width, height: self.viewContainer.frame.height)
        self.addChild(pageviewcontroller)
        self.pageviewcontroller.didMove(toParent: self)
        self.pageviewcontroller.view.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.pageviewcontroller.view.isUserInteractionEnabled = true
    }
   
    func fetchListCategoryData() {
        self.nameSet()
        
        for i in 0...viewModel.allProfiles.count - 1 {
            
            let home = UIStoryboard(name: "Home", bundle: nil)
           
            if let allListTemplateVC = home.instantiateViewController(withIdentifier: "FullViewDetailViewController") as? FullViewDetailViewController {
                self.viewControllersIdentifier.append(allListTemplateVC.restorationIdentifier ?? "")
                allListTemplateVC.controllerIndex = i
                allListTemplateVC.viewModel.isComeFor = viewModel.isComeFor
                allListTemplateVC.viewModel.selectedProfile = viewModel.selectedProfile
                allListTemplateVC.viewModel.allProfiles = viewModel.allProfiles
                allListTemplateVC.viewModel.selectedIndex = viewModel.selectedIndex
                allListTemplateVC.viewModel.previousSelectedIndex = viewModel.selectedIndex

                allListTemplateVC.viewModel.isFrom = viewModel.isFrom
                
                allListTemplateVC.viewModel.callBacktoMainScreen = { index in
                    print(index)
                    self.viewModel.selectedIndex = index + 1
                    self.viewModel.previousSelectedIndex = index + 1
                   
                    print("Next Index ---->", self.viewModel.selectedIndex)
                    
                    self.viewModel.allProfiles[self.viewModel.selectedIndex - 1].isLiked = 1
                    
                    if self.viewControllers.indices.contains(allListTemplateVC.controllerIndex + 1) {
                        let firstVC = self.viewControllers[allListTemplateVC.controllerIndex + 1]
                        firstVC.viewModel.selectedIndex = self.viewModel.selectedIndex
                        firstVC.viewModel.allProfiles = self.viewModel.allProfiles
                        
                        self.pageviewcontroller.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
                        self.nameSet()
                    }
                }
                
                allListTemplateVC.viewModel.callBackForReject = { index in
                    print(index)
                    // self.viewModel.allProfiles[self.viewModel.selectedIndex].isLiked = 0
                    self.viewModel.selectedIndex = index + 1
                    self.viewModel.previousSelectedIndex = index + 1
                    
                    if self.viewControllers.indices.contains(allListTemplateVC.controllerIndex + 1) {
                        let firstVC = self.viewControllers[allListTemplateVC.controllerIndex + 1]
                        firstVC.viewModel.selectedIndex = self.viewModel.selectedIndex
                        firstVC.viewModel.allProfiles = self.viewModel.allProfiles
                        
                        self.pageviewcontroller.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
                        self.nameSet()
                    }
                }
                
                allListTemplateVC.viewModel.callBacktoPreviosScreen = { index in
                    print(index)
                    
                    self.viewModel.selectedIndex = index - 1
                    self.viewModel.previousSelectedIndex = index - 1
                    
                    print("previous Index ---->", self.viewModel.selectedIndex)
                    if self.viewControllers.indices.contains(allListTemplateVC.controllerIndex - 1) {
                        let firstVC = self.viewControllers[allListTemplateVC.controllerIndex - 1]
                        allListTemplateVC.viewModel.selectedIndex = self.viewModel.selectedIndex
                        firstVC.viewModel.selectedIndex = self.viewModel.selectedIndex
                        
                        self.pageviewcontroller.setViewControllers([firstVC], direction: .reverse, animated: true, completion: nil)
                        self.nameSet()
                    }
                }
                
                allListTemplateVC.viewModel.callBacktoSaveAction = { index, isSaved in
                    print(index, isSaved)
                    self.viewModel.selectedIndex = index + 1
                    self.viewModel.previousSelectedIndex = index + 1
                   
                    print("Next Index ---->", self.viewModel.selectedIndex)
                    
                    self.viewModel.allProfiles[self.viewModel.selectedIndex - 1].isSaved = isSaved
                    
                    if self.viewControllers.indices.contains(allListTemplateVC.controllerIndex + 1) {
                        let firstVC = self.viewControllers[allListTemplateVC.controllerIndex + 1]
                        firstVC.viewModel.selectedIndex = self.viewModel.selectedIndex
                        firstVC.viewModel.allProfiles = self.viewModel.allProfiles
                        
                        self.pageviewcontroller.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
                        self.nameSet()
                    }
                }
                
                allListTemplateVC.viewModel.callBacktoUndoAction = { index in
                    if UserModel.shared.storedUser?.isSubscriptionPlanActive == 1 {
                    } else {
                        self.viewModel.upgradePlan { callBack in }
                    }
                }
                self.viewControllers.append(allListTemplateVC)
                self.viewModel.viewControllers = self.viewControllers
            }
        }
        DispatchQueue.main.async {
           
            let vc = self.viewControllers[self.viewModel.selectedIndex]
            self.pageviewcontroller.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
            vc.viewModel.selectedIndex = self.viewModel.selectedIndex
            
        }
        
    }

    @IBAction func backButtonAction(_ sender: Any) {
        if viewModel.forceBackToHome{
            viewModel.proceedForHome()
        } else {
            self.backButtonTapped(self)
        }
    }
    
    @IBAction func moreButtonAction(_ sender: UIButton) {
        viewModel.showAlertForReportBlockUser()
    }
    
    @IBAction func switchCardViewButtonAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.viewModel.proceedForCardViewScreen()
        }
    }
    
    
    func likeUnlikeAction(index:Int, _ result:@escaping(String?) -> Void) {
        if self.viewModel.allProfiles.indices.contains(self.viewModel.selectedIndex) {
            self.viewModel.proceesForLike(index: index) { message in
                result("success")
            }
        } else {
            self.viewModel.popBackToController()
        }
    }
}

extension PageFullViewVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        guard let controller = viewController as? FullViewDetailViewController, let viewControllerIndex = viewControllers.firstIndex(where: {$0.controllerIndex == controller.controllerIndex}) else {
//            return nil
//        }
//        let previousIndex = viewControllerIndex - 1
//        guard previousIndex >= 0 else {
//            return nil
//        }
//        guard viewControllers.count > previousIndex else {
//            return nil
//        }
//        return viewControllers[previousIndex]
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        guard let controller = viewController as? FullViewDetailViewController, let viewControllerIndex = viewControllers.firstIndex(where: {$0.controllerIndex == controller.controllerIndex}) else {
//            return nil
//        }
//        let nextIndex = viewControllerIndex + 1
//        let viewControllersCount = viewControllers.count
//
//        guard viewControllersCount != nextIndex else {
//            return nil
//        }
//        guard viewControllersCount > nextIndex else {
//            return nil
//        }
//        return viewControllers[nextIndex]
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    
//        if !completed { return }
//
//        if let currentViewController = pageViewController.viewControllers?.first,
//           let destinationViewController = previousViewControllers.first {
//
//            if let currentIndex = viewControllers.firstIndex(of: currentViewController as! FullViewDetailViewController),
//               let destinationIndex = viewControllers.firstIndex(of: destinationViewController as! FullViewDetailViewController) {
//
//                print(currentIndex, destinationIndex)
//
//                guard let controller = pageViewController.viewControllers?.last as? FullViewDetailViewController else {
//                    return
//                }
//
//                if currentIndex >= destinationIndex {
//                    self.isSwipeFinished = true
//                    self.initRightSwipePageViewControllerUpdateNameDataAfterFinished(index: currentIndex, controller: controller, finished: true)
//                }
//
//                if currentIndex < destinationIndex {
//                    self.initLeftSwipePageViewControllerData(index: currentIndex, controller: controller)
//                }
//
//            }
//        }
        
    }
    
    func nameSet() {
        if viewModel.selectedIndex >= 0 {
            self.nameLabel.text = "\(viewModel.allProfiles[viewModel.selectedIndex].firstName ?? "")"
        }
    }
    
    func initRightSwipePageViewControllerData(index: Int, controller: FullViewDetailViewController, finished: Bool) {
        if viewControllers.count == index {
            viewControllers[index].viewModel.selectedIndex = index - 1
            viewModel.selectedIndex = index - 1
            self.nameSet()
        } else {
            viewControllers[index].viewModel.selectedIndex = index
            viewModel.selectedIndex = index
            self.nameSet()
        }
    }
    
    func initRightSwipePageViewControllerUpdateNameDataAfterFinished(index: Int, controller: FullViewDetailViewController, finished: Bool) {
        viewControllers[index].viewModel.selectedIndex = index
        viewModel.selectedIndex = index
        
        self.nameSet()
        print( "index---->", index, viewModel.selectedIndex)
        
        if viewModel.isFrom == "Likes" || viewModel.isFrom == "Aligned" {
            print("No Action")
        } else {
            if viewModel.isComeFor == "SavedPreferences" || viewModel.isComeFor == "MatchMakingProfile" {
                print("No Action")
            } else {
                if finished {
                    if index == 0 {
                        self.likeUnlikeAction(index: index) { result in
                            self.viewModel.allProfiles[index].isLiked = 1
                            controller.viewModel.allProfiles = self.viewModel.allProfiles
                            controller.viewModel.selectedIndex = index
                        }
                    } else {
                        self.likeUnlikeAction(index: index - 1) { result in
                            self.viewModel.allProfiles[index - 1].isLiked = 1
                            controller.viewModel.allProfiles = self.viewModel.allProfiles
                            controller.viewModel.selectedIndex = index
                        }
                    }
                }
            }
        }
    }
    
    func initLeftSwipePageViewControllerData(index: Int, controller: FullViewDetailViewController) {
        viewControllers[index].viewModel.selectedIndex = index
        viewModel.selectedIndex = index
        self.nameSet()
        
        if viewModel.isFrom == "Likes" || viewModel.isFrom == "Aligned" {
            print("No Action")
        } else {
            if viewModel.isComeFor == "SavedPreferences" || viewModel.isComeFor == "MatchMakingProfile" {
                print("No Action")
            } else {
                if UserModel.shared.storedUser?.isSubscriptionPlanActive == 1 {
                    viewModel.undoProfile(selectedIndex: index, previousIndex: index) { response in
                        self.viewModel.allProfiles[index].isLiked = 0
                        controller.viewModel.allProfiles = self.viewModel.allProfiles
                        controller.viewModel.selectedIndex = index
                    }
                }
            }
        }
    }
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return viewModel.allProfiles.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
//        if let currentViewController = pageViewController.viewControllers?.first,
//           let destinationViewController = pendingViewControllers.first {
//
//            if let currentIndex = viewControllers.firstIndex(of: currentViewController as! FullViewDetailViewController),
//               let destinationIndex = viewControllers.firstIndex(of: destinationViewController as! FullViewDetailViewController) {
//
//                print(currentIndex, destinationIndex)
//
//                guard let controller = pageViewController.viewControllers?.last as? FullViewDetailViewController else {
//                    return
//                }
//
//                if currentIndex < destinationIndex {
//                    print("Transition is moving to the right")
//                    self.pageviewcontroller.dataSource = self
//                    if self.isSwipeFinished {
//                        self.isSwipeFinished = false
//                        self.initRightSwipePageViewControllerData(index: destinationIndex, controller: controller, finished: false)
//                    }
//                }
//                else if currentIndex >= destinationIndex {
//                    print("Transition is moving to the left")
//                    if destinationIndex != -1 {
//                        if UserModel.shared.storedUser?.isSubscriptionPlanActive != 1 {
//                            DispatchQueue.main.async {
//                                self.pageviewcontroller.dataSource = nil
//                                self.viewModel.upgradePlan { callBack in
//                                    self.pageviewcontroller.dataSource = self
//                                    let vc = self.viewControllers[currentIndex]
//                                    self.pageviewcontroller.setViewControllers([vc], direction: .reverse, animated: true, completion: { done in
//                                    })
//
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
    }
}

class PageFullViewModel: BaseViewModel {
    var completionHandler: ((Bool) -> Void)?
    var isFrom = ""
    var isComeFor = ""
    var allProfiles: [ProfilesModel] = []
    var allProfilesCopy: [ProfilesModel] = []
    var selectedIndex = 0
    var copySelectedIndex = 0
    var previousSelectedIndex = 0
    var index = 0
    var displayIndex = 0
    var previousIndex = 0
    var selectedProfile: ProfilesModel!
    var forceBackToHome = false
    var notifications = [Notifications]()
    var pageviewcontroller: UIPageViewController!
    var viewControllers = [FullViewDetailViewController]()

    func proceedForHome() {
        KAPPDELEGATE.updateRootController(TabBarController.getController(),
                                          transitionDirection: .toLeft,
                                          embedInNavigationController: true)
    }
    
    func showAlertForReportBlockUser() {
        let alert = UIAlertController(title: "", message: "Do you want to report or block the user?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Report", style: .default, handler: { action in
            self.proceedToReportScreen()
        }))
        
        alert.addAction(UIAlertAction(title: "Block", style: .destructive, handler: { action in
            self.blockButtonTapped()
        }))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.hostViewController.view
            popoverController.sourceRect = CGRect(x: self.hostViewController.view.bounds.midX, y: self.hostViewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.hostViewController.present(alert, animated: true, completion: nil)
    }
    
    func blockButtonTapped() {
        let alert = UIAlertController(title: "Are you sure you want to block this user?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
            self.blockUser()
        }))
        
        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { action in        }))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.hostViewController.view
            popoverController.sourceRect = CGRect(x: self.hostViewController.view.bounds.midX, y: self.hostViewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.hostViewController.present(alert, animated: true, completion: nil)
    }
    
    func proceedToReportScreen() {
        ReportViewController.show(from: self.hostViewController, isComeFor: "Detail", id: selectedProfile.id ?? "") { success in }
    }
    
    func blockUser() {
        var params = [String:Any]()
        params[WebConstants.profileId] = selectedProfile.id
        processForBlockProfileData(params: params)
    }
    
    func processForBlockProfileData(params: [String: Any]) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.LandingApis.blockUser,
                               params: params,
                               headers: headers,
                               method: .put) { response, _ in
            if !self.hasErrorIn(response) {
                _ = response![APIConstants.data] as! [String: Any]
                
                showSuccessMessage(with: StringConstants.BlockSuccess)
                delay(0.5) {
                    self.popBackToController()
                }
              //  self.hostViewController.backButtonTapped(self)
                
            }
            hideLoader()
        }
    }
    
    func popBackToController() {
        for controller in self.hostViewController.navigationController!.viewControllers as Array {
            if controller.isKind(of: PagerController.self) {
                self.hostViewController.navigationController!.popToViewController(controller, animated: true)
                break
            }
            if controller.isKind(of: SearchDetailsPagerController.self) {
                self.hostViewController.navigationController!.popToViewController(controller, animated: true)
                break
            }
            
            if controller.isKind(of: SavedProfilePagerController.self) {
                self.hostViewController.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    func proceesForLike(index:Int, _ result:@escaping(String?) -> Void) {
        var params = [String:Any]()
        let profile = allProfiles[index]
        params[WebConstants.profileId] = profile.id
        params[WebConstants.isLiked] = profile.isLiked == 1 ? 0 : 1
        self.selectedIndex = index
        let userIdsArray = [UserModel.shared.user.id, profile.id ?? ""].sorted{ $0 < $1 }
        let chatDialogId = userIdsArray.joined(separator: ",")
        
        FirestoreManager.justCheckIfChatRoomExist(chatDialogId: chatDialogId) { exist, model in
            if (exist && profile.isYourProfileLiked == 1) {
                FirestoreManager.updateDialogStatus(chatRoom: model)
            }
        }
        if profile.isLiked == 0 {
            processForLikeProfileData(params: params) { message in
                result("success")
            }
        }
    }
    
    func processForLikeProfileData(params: [String: Any],  _ result:@escaping(String?) -> Void) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.LandingApis.likeProfile,
                               params: params,
                               headers: headers,
                               method: .put) { response, _ in
            if !self.hasErrorIn(response) {
                if let responseData = response![APIConstants.data] as? [String: Any] {
                    if responseData.count != 0 {
                        if responseData["id"] as? String != "" {
                            self.notifications.removeAll()
                            let userName = "\(self.selectedProfile.firstName ?? "") " + "\(self.selectedProfile.lastName ?? "")"
                            
                            var userImage = ""
                            for i in 0..<(self.selectedProfile.userImages?.count ?? 0){
                                if self.selectedProfile.userImages?[i].isDp as? Int == 1{
                                    userImage = self.selectedProfile.userImages?[i].file as? String ?? ""
                                }
                            }
                            
                            self.notifications.append(Notifications(id: "",
                                                                    senderID: self.selectedProfile.id,
                                                                    receiverID: "",
                                                                    platformType: 0,
                                                                    notificationType: 0,
                                                                    title: "",
                                                                    createdAt: "",
                                                                    userImage: userImage,
                                                                    userName: userName,
                                                                    message: ""))
                            
                            self.proceedForMatchedProfileScreen(notification: self.notifications[0])
                        }
                        result("success")
                        hideLoader()
                    } else {
                        hideLoader()
                        showSuccessMessage(with: "User Profile like successfully")
                        if self.allProfiles.indices.contains(self.selectedIndex) {
                            self.updateProfileData(index: self.selectedIndex)
                            result("success")
                        } else {
                            self.popBackToController()
                        }
                    }
                }
            }
            
        }
    }
    
    func updateProfileData(index:Int) {
        if self.allProfiles.indices.contains(index) {
            self.selectedProfile = self.allProfiles[index]
        } else {
            self.popBackToController()
        }
    }
    
    func proceedForMatchedProfileScreen(notification:Notifications) {
        MatchedViewController.show(over: self.hostViewController, isCome: "NotificationScreen", userInfo: [:], notificationData: notification) { success in
        }
    }
    
    func proceedForCardViewScreen() {
        CardViewViewController.show(from: self.hostViewController, forcePresent: false, isFrom: self.isFrom, isComeFor: self.isComeFor, selectedProfile: selectedProfile, allProfiles: allProfiles, selectedIndex: index) { success in

        }
    }
    
    func undoProfile(selectedIndex: Int, previousIndex:Int, _ result:@escaping(String?) -> Void) {
        self.selectedIndex = selectedIndex
        if allProfiles[selectedIndex].isLiked == 1 {
            var params = [String:Any]()
            params[WebConstants.profileId] = allProfiles[selectedIndex].id
            params[WebConstants.isLiked] = allProfiles[selectedIndex].isLiked == 1 ? 0 : 1
            
            processForUnLikeProfileData(params: params) { status in
                if status == "success" {
                    if self.allProfiles[selectedIndex].isSaved == 1 {
                        var params = [String:Any]()
                        params[WebConstants.profileId] = self.allProfiles[selectedIndex].id
                        params[WebConstants.status] = self.allProfiles[selectedIndex].isSaved == 1 ? 0 : 1
                        params[WebConstants.searchPreferenceId] = GlobalVariables.shared.searchPreferenceId
                        
                        self.processForUnSavedProfileData2(params: params) { status in
                            if status == "success" {
                                if self.allProfiles.indices.contains(self.selectedIndex) {
                                    result("success")
                                } else {
                                    self.popBackToController()
                                }
                            }
                        }
                    } else {
                        if self.allProfiles.indices.contains(self.selectedIndex) {
//                            self.tableView.reloadData()
                            result("success")
                            showMessage(with: "You have unliked the previous profile", theme: .success)
                        } else {
                            self.popBackToController()
                        }
                    }
                }
            }
        } else {
            var params = [String:Any]()
            params[WebConstants.profileId] = allProfiles[selectedIndex].id
            params[WebConstants.isRejected] =  "0"
            
            processForUnRejectProfileData(params: params) { status in
                if status == "success" {
                    if self.allProfiles[selectedIndex].isSaved == 1 {
                        var params = [String:Any]()
                        params[WebConstants.profileId] = self.allProfiles[selectedIndex].id
                        params[WebConstants.status] = self.allProfiles[selectedIndex].isSaved == 1 ? 0 : 1
                        params[WebConstants.searchPreferenceId] = GlobalVariables.shared.searchPreferenceId
                       
                        self.processForUnSavedProfileData2(params: params) { status in
                            if status == "success" {
                                if self.allProfiles.indices.contains(self.selectedIndex) {
                                    result("success")
                                } else {
                                    self.popBackToController()
                                }
                            }
                        }
                    } else {
                        if self.allProfiles.indices.contains(self.selectedIndex) {
                            result("success")
                            showMessage(with: "Profile unliked successfully", theme: .success)
                        } else {
                            self.popBackToController()
                        }
                    }
                }
            }
        }
    }
    
    func processForUnLikeProfileData(params: [String: Any], _ result:@escaping(String?) -> Void) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.LandingApis.likeProfile,
                               params: params,
                               headers: headers,
                               method: .put) { response, _ in
            if !self.hasErrorIn(response) {
                _ = response![APIConstants.data] as! [String: Any]
                self.allProfiles[self.selectedIndex].isLiked = 0
                result("success")
            }
            hideLoader()
        }
    }
    
    func processForUnSavedProfileData2(params: [String: Any], _ result:@escaping(String?) -> Void) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.UserApis.saveProfile,
                               params: params,
                               headers: headers,
                               method: .post) { response, _ in
            if !self.hasErrorIn(response) {
                _ = response![APIConstants.data] as! [String: Any]
                showSuccessMessage(with: StringConstants.unsavedProfileSuccess)

                self.allProfiles[self.selectedIndex].isSaved = 0
                result("success")
            }
            hideLoader()
        }
    }
    
    func processForUnRejectProfileData(params: [String: Any], _ result:@escaping(String?) -> Void) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.LandingApis.rejectProfile,
                               params: params,
                               headers: headers,
                               method: .put) { response, _ in
            if !self.hasErrorIn(response) {
                _ = response![APIConstants.data] as! [String: Any]
                result("success")
            }
            hideLoader()
        }
    }
    
    func upgradePlan( _ callBack:@escaping(String?) -> Void) {
        let popup = UIStoryboard(name: "Popups", bundle: nil)
        if let popupvc = popup.instantiateViewController(withIdentifier: "UpgradeSubcriptionViewController") as? UpgradeSubcriptionViewController {
            popupvc.callBacktoMainScreen = {
                BuyPremiumViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "Profile") { success in
                    callBack("Dismiss")
                }
            }
            popupvc.callBackforDismiss = {
                callBack("Dismiss")
            }
            popupvc.name = self.allProfiles[self.selectedIndex].firstName ?? ""
            popupvc.modalPresentationStyle = .overCurrentContext
//            popupvc.upgradeToPremiumButton.setNeedsFocusUpdate()
            self.hostViewController.present(popupvc, animated: true, completion: nil)
        }
    }
}
