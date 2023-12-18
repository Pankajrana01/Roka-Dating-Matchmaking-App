//
//  ProfileViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 10/10/22.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    @IBOutlet weak var topLable: UILabel!
    @IBOutlet weak var tableView: UITableView!

    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.profile
        
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.profile
    }

    lazy var viewModel: ProfileViewModel = ProfileViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! ProfileViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.show(from: viewController, forcePresent: forcePresent)
    }

    var barItem = UIBarButtonItem()
    var leftItem = UIBarButtonItem()
    var kycVideo = [[String:Any]]()
    var isKycApproved = 0
    var isSubscriptionPlanActive = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        if GlobalVariables.shared.selectedProfileMode == "MatchMaking" {
            showLeftNavigationLogo()
        } else {
            showLeftNavigationDatingLogo()
        }
        
        NotificationCenter.default.post(name: .updateNotificationIcon, object: nil)
    }
    
    func showLeftNavigationDatingLogo() {
        let btn1 = UIButton()
        btn1.setImage(UIImage(named: "IC_logo_purple"), for: .normal)
        btn1.frame = CGRect(x: 15, y: 0, width: 30, height: 30)
        leftItem.customView = btn1
       // let space = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItems = [leftItem]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GlobalVariables.shared.isComeFormProfile = false
        if GlobalVariables.shared.selectedProfileMode != "MatchMaking" {
            self.topLable.backgroundColor = UIColor.appTitleBlueColor
            
            self.viewModel.processForGetUserProfileData { result in
                if let userVideos = result?["userVideos"] as? [[String:Any]] {
                    self.kycVideo = userVideos
                }
                
                if let isKycApproved = result?["isKycApproved"] as? Int {
                    self.isKycApproved = isKycApproved
                }
                
                if let isSubscriptionPlanActive = result?["isSubscriptionPlanActive"] as? Int {
                    self.isSubscriptionPlanActive = isSubscriptionPlanActive
                }
                
                self.tableView.reloadData()
                NotificationCenter.default.post(name: NSNotification.Name("updateProfileIcon"), object: nil)
            }
            DispatchQueue.global(qos: .background).async {
                self.viewModel.processForGetUserData { result in
                    if let isSubscriptionPlanActive = result?["isSubscriptionPlanActive"] as? Int {
                        self.isSubscriptionPlanActive = isSubscriptionPlanActive
                    }
                    
                    self.tableView.reloadData()
                }
            }
        } else {
            self.topLable.backgroundColor = UIColor.loginBlueColor
        }
        
    }
    
    func initializedData() {
        DispatchQueue.global(qos: .background).async {
            self.viewModel.processForGetUserData { result in
                self.tableView.reloadData()
            }
        }
    }
    
    func showLeftNavigationLogo() {
        let btn1 = UIButton()
        btn1.setImage(UIImage(named: "Ic_Logo_nav"), for: .normal)
        btn1.frame = CGRect(x: 15, y: 0, width: 30, height: 30)
        leftItem.customView = btn1
        let space = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItems = [leftItem]
    }
    
    private func setupUI() {
        self.navigationController?.isNavigationBarHidden = false
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: ProfileTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProfileTableViewCell.identifier)
        tableView.register(UINib(nibName: ProfileHeaderTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProfileHeaderTableViewCell.identifier)
        tableView.register(UINib(nibName: ProfileFooterTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProfileFooterTableViewCell.identifier)
        tableView.register(UINib(nibName: ProfilePremiumTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProfilePremiumTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
            case (0, 0): return 125
            case (0, 1): return 90
            case (1, _): return 54
            case (2, _): return 68
//            if GlobalVariables.shared.selectedProfileMode != "MatchMaking" {
//                return 240
//            } else {
//                if self.viewModel.user.isDeactivate == 0 {
//                    return 180
//                } else {
//                    return 240
//                }
//            }
            default: return 100
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if GlobalVariables.shared.selectedProfileMode != "MatchMaking" {
            switch section {
            case 0: return self.isSubscriptionPlanActive == 1 ? 1 : 2
            case 1: return viewModel.modelArray.count
            case 2: return 1
            default: return 0
            }
        } else {
            switch section {
            case 0: return 1
            case 1: return viewModel.matchModelArray.count
            case 2: return 1
            default: return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if GlobalVariables.shared.selectedProfileMode != "MatchMaking" {
            switch (indexPath.section, indexPath.row) {
            case (0, 0):
                let cellHaeder = tableView.dequeueReusableCell(withIdentifier: ProfileHeaderTableViewCell.identifier) as! ProfileHeaderTableViewCell
                cellHaeder.selectionStyle = .none
                cellHaeder.labelName.text = "\(viewModel.user.firstName) " + "\(viewModel.user.lastName)"
                
                cellHaeder.labelPhoneNumber.text = "\(viewModel.user.countryCode) " + "\(viewModel.user.phoneNumber)"
                cellHaeder.bottomLine.backgroundColor = .clear
                
                if self.viewModel.user.userImages.count != 0 {
                    for i in 0..<self.viewModel.user.userImages.count {
                        if self.viewModel.user.userImages[i].isDp == 1 {
                            let userImage = self.viewModel.user.userImages[i].file
                            if userImage != "" {
                                let imageUrl: String = KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + userImage
                                
                                cellHaeder.profileImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "Avatar"), options: .refreshCached)
                                
                            } else {
                                cellHaeder.profileImage.image = #imageLiteral(resourceName: "Avatar")
                            }
                        }
                    }
                }
                cellHaeder.profileImage.layer.cornerRadius = cellHaeder.profileImage.frame.size.height / 2
                cellHaeder.profileImage.clipsToBounds = true
                cellHaeder.profileImage.contentMode = .scaleAspectFill
                
                cellHaeder.callBackForVerifyKyc = {
                    if self.kycVideo.count != 0 {
                        if self.isKycApproved == 0 { }
                        else if self.isKycApproved == 1 { }
                        else if self.isKycApproved == 2 {
                            self.viewModel.proceedForVerifyKycScreen()
                        }
                    } else {
                        self.viewModel.proceedForVerifyKycScreen()
                    }
                }
                
                cellHaeder.buttonEditProfile.setImage(UIImage(named: "Vector_28"), for: .normal)
                cellHaeder.buttonEditProfile.semanticContentAttribute = .forceRightToLeft
                cellHaeder.callBackForEditProfile = {
                    self.viewModel.proceedForEditProfileScreen()
                }
                cellHaeder.forwordButton.tag = indexPath.row
                cellHaeder.forwordButton.addTarget(self, action: #selector(forwordButtonAction(_:)), for: .touchUpInside)
                
                if self.kycVideo.count != 0 {
                    if self.isKycApproved == 0 {
                        cellHaeder.buttonKYCNotVerified.setTitle(StringConstants.sentforVerification, for: .normal)
                        cellHaeder.myProfileButtonWidth.constant = 90
                        cellHaeder.buttonKYCNotVerified.setImage(UIImage(named: "Vector_28Red"), for: .normal)
                        cellHaeder.buttonKYCNotVerified.semanticContentAttribute = .forceRightToLeft
                    }
                    else if self.isKycApproved == 1 {
                        cellHaeder.buttonKYCNotVerified.setTitle(StringConstants.KYCVerified, for: .normal)
                        cellHaeder.buttonKYCNotVerified.borderColor = UIColor.systemGreen
                        cellHaeder.buttonKYCNotVerified.setTitleColor(.systemGreen, for: .normal)
                        cellHaeder.buttonKYCNotVerified.setImage(UIImage(named: "greenTick"), for: .normal)
                        cellHaeder.buttonKYCNotVerified.semanticContentAttribute = .forceRightToLeft
                        
                    }
                    else if self.isKycApproved == 2 {
                        cellHaeder.buttonKYCNotVerified.setTitle(StringConstants.KYCPending, for: .normal)
                        cellHaeder.buttonKYCNotVerified.setImage(UIImage(named: "Vector_28Red"), for: .normal)
                        cellHaeder.buttonKYCNotVerified.semanticContentAttribute = .forceRightToLeft
                    }
                    
                } else {
                    cellHaeder.buttonKYCNotVerified.setTitle(StringConstants.KYCPending, for: .normal)
                    cellHaeder.buttonKYCNotVerified.setImage(UIImage(named: "Vector_28Red"), for: .normal)
                    cellHaeder.buttonKYCNotVerified.semanticContentAttribute = .forceRightToLeft
                }
                return cellHaeder
            case (0, 1):
                let cellPremium = tableView.dequeueReusableCell(withIdentifier: ProfilePremiumTableViewCell.identifier) as! ProfilePremiumTableViewCell
                cellPremium.selectionStyle = .none
                return cellPremium
            case (1, _):
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier) as! ProfileTableViewCell
                cell.configure(model: viewModel.modelArray[indexPath.row])
                cell.selectionStyle = .none
                if indexPath.section == 1 {
                    if indexPath.row == 11 {
                        cell.viewLine.isHidden = true
                    } else {
                        cell.viewLine.isHidden = false
                    }
                }
                return cell
            case (2, _):
                let cellFooter = tableView.dequeueReusableCell(withIdentifier: ProfileFooterTableViewCell.identifier) as! ProfileFooterTableViewCell
                cellFooter.selectionStyle = .none
                
                cellFooter.onLogoutClick = {
                    self.viewModel.proceedForLogout()
                }
                
                cellFooter.onDeleteAccountClick = {
                    self.viewModel.proceedForDeleteAccount()
                }
                
                cellFooter.onDeActivateAccountClick = {
                    self.viewModel.proceedForDeActivateAccount { status in
                        if status == "ChangeToMatachIngProfile" {
                            self.viewModel.selectedIndex = 1
                            GlobalVariables.shared.selectedProfileMode = "MatchMaking"
                            GlobalVariables.shared.homeCollectionTopConstant = 15.0
                            self.viewModel.checkLocationSettings()
                        }
                    }
                }
                return cellFooter
            default:
                return UITableViewCell()
            }
        } else {
            switch (indexPath.section, indexPath.row) {
            case (0, 0):
                let cellHaeder = tableView.dequeueReusableCell(withIdentifier: ProfileHeaderTableViewCell.identifier) as! ProfileHeaderTableViewCell
                cellHaeder.selectionStyle = .none
                cellHaeder.labelName.text = "\(viewModel.user.firstName) " + "\(viewModel.user.lastName)"
                
                cellHaeder.labelPhoneNumber.text = "\(viewModel.user.countryCode) " + "\(viewModel.user.phoneNumber)"
                
                cellHaeder.profileImage.image = UIImage(named: "ic_icon_matchmaking")
                    
                cellHaeder.profileImage.layer.cornerRadius = cellHaeder.profileImage.frame.size.height / 2
                cellHaeder.profileImage.clipsToBounds = true
                cellHaeder.profileImage.contentMode = .scaleAspectFill
               
                cellHaeder.buttonKYCNotVerified.isHidden = true
                cellHaeder.buttonEditProfile.isHidden = true
                
                cellHaeder.forwordButton.isHidden = true
            
                return cellHaeder
          
            case (1, _):
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier) as! ProfileTableViewCell
                cell.configure(model: viewModel.matchModelArray[indexPath.row])
                cell.selectionStyle = .none
                return cell
            case (2, _):
                let cellFooter = tableView.dequeueReusableCell(withIdentifier: ProfileFooterTableViewCell.identifier) as! ProfileFooterTableViewCell
                cellFooter.selectionStyle = .none
               
//                if self.viewModel.user.isDeactivate == 0 {
//                    cellFooter.deactivateButton.isHidden = true
//                } else {
//                    cellFooter.deactivateButton.isHidden = false
//                    cellFooter.deactivateButton.setTitle("Activate Dating Profile", for: .normal)
//                }
                cellFooter.onLogoutClick = {
                    self.viewModel.proceedForLogout()
                }
                
                cellFooter.onDeleteAccountClick = {
                    self.viewModel.proceedForDeleteAccount()
                }
                
                cellFooter.onDeActivateAccountClick = {
                    self.viewModel.proceedForDeActivateAccount { status in
                        if status == "refreshMatchMaking" {
                            self.initializedData()
                        }
                    }
                }
                return cellFooter
            default:
                return UITableViewCell()
            }
        }
    }
    
    @objc func forwordButtonAction(_ sender: UIButton){
        viewModel.proceedForAccountDetailScreen()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if GlobalVariables.shared.selectedProfileMode != "MatchMaking"{
            switch (indexPath.section, indexPath.row) {
            case (0,0):
                viewModel.proceedForAccountDetailScreen()
            case (0, 1):
                if self.kycVideo.count != 0 {
                    if self.isKycApproved == 0 {
                        viewModel.proceedForKycVerificationPendingScreen()
                    }
                    else if self.isKycApproved == 1{
                        viewModel.proceedForBuyPremiumScreen()
                    }
                    else if self.isKycApproved == 2{
                        viewModel.proceedForKycPendingScreen()
                    }
                } else {
                    viewModel.proceedForKycPendingScreen()
                }
                
            case (1, 0):
                viewModel.proceedForEditProfilePreferenceScreen()
            case (1, 1):
                viewModel.proceedForGalleryScreen()
            case (1,2):
                viewModel.proceedForSavedProfilesScreen()
            case (1,3):
                viewModel.proceedForBlockedUsersScreen()
            case (1,4):
                viewModel.proceedForReferAndEarnScreen()
            case (1,5):
                viewModel.proceedForMySubscriptionScreen()
            case (1,6):
                viewModel.proceedForNotificationsScreen()
            case (1,7):
                viewModel.proceedForPrivacyScreen()
            case (1,8):
                viewModel.proceedForTermsConditionsScreen()
            case (1,9):
                viewModel.proceedForHelpScreen()
            case (1,10):
                viewModel.proceedForSuggestionScreen()
            case (1,11):
                viewModel.proceedForFAQScreen()
            case (2,0):
                print("logout.")
            default:
                break
            }
        } else  {
            switch (indexPath.section, indexPath.row) {
            case (0,0): break
                //viewModel.proceedForAccountDetailScreen()
            case (1,0):
                viewModel.proceedForNotificationsScreen()
            case (1,1):
                viewModel.proceedForPrivacyScreen()
            case (1,2):
                viewModel.proceedForTermsConditionsScreen()
            case (1,3):
                viewModel.proceedForHelpScreen()
            case (1,4):
                viewModel.proceedForBlockedUsersScreen()
            case (1,5):
                viewModel.proceedForSuggestionScreen()
            case (1,6):
                viewModel.proceedForFAQScreen()
            case (2,0):
                print("logout.")
            default:
                break
            }
        }
    }
}
