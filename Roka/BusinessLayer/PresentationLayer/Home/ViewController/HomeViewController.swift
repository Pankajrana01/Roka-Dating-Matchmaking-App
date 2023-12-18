//
//  HomeViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 23/09/22.
//

import UIKit

struct HomeNotDataModel {
    let image: UIImage
    let labelFirst: String
    let labelSecond: String
    
    init(image: UIImage = UIImage(), labelFirst: String, labelSecond: String) {
        self.image = image
        self.labelFirst = labelFirst
        self.labelSecond = labelSecond
    }
}

class HomeViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.home
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.home
    }

    lazy var viewModel: HomeViewModel = HomeViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! HomeViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    @IBOutlet weak var collectionViewTopContraints: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imageStatus: UIImageView!
    @IBOutlet weak var stackViewLabels: UIStackView!
    @IBOutlet weak var labelFirst: UILabel!
    @IBOutlet weak var labelSecond: UILabel!
    @IBOutlet weak var likeStackView: UIStackView!
    @IBOutlet weak var sentButton: UIButton!
    @IBOutlet weak var receivedButton: UIButton!
    
    @IBOutlet weak var UpgradeVIew: UIView!
    @IBOutlet weak var userNameLable: UILabel!
    @IBOutlet weak var shadowView: UIView!
    
    
    var nextButtonActionIndex = 0
    var toggleButton = UIButton()
    var barItem = UIBarButtonItem()
    var leftItem = UIBarButtonItem()
    var isLikes = "sent"
    var type = "1"
    
    var kycVideo = [[String:Any]]()
    var isKycApproved = 0
    var isSubscriptionPlanActive = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.collectionView = collectionView
        self.collectionView.isHidden = false
        self.UpgradeVIew.isHidden = true
        
    }
   
    override func viewWillAppear(_ animated: Bool) {
        if KAPPSTORAGE.islikeSeleted == "1" {
            KAPPSTORAGE.islikeSeleted = "0"
            isLikes = "received"
            type = "2"
        } else {
            isLikes = "sent"
            type = "1"
        }
        self.navigationController?.isNavigationBarHidden = false
        NotificationCenter.default.post(name: .updateNotificationIcon, object: nil)
        print(CGFloat(GlobalVariables.shared.homeCollectionTopConstant))
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateNotificationForAds),name: .updateNotificationForAds,                               object: nil)
        
        showLeftNavigationLogo()
        addNavigationRightButton()
        viewModel.title = self.title ?? "Nearby"
        fetchProfileData()
    }
    
    func addBlurEffectForCollectionView() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView()

        blurEffectView.frame = collectionView.bounds
        self.collectionView.addSubview(blurEffectView)
        blurEffectView.effect = blurEffect
    }
    
    func removeBlurEffectForCollectionView() {
        for subview in collectionView.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
    }
    
    func initUpgradeView() {
        self.userNameLable.text = "Hi " + "\(viewModel.storedUser?.firstName ?? "")!"
//        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
//        shadowView.layer.shadowOpacity = 10
//        shadowView.layer.shadowOffset = CGSize(width: -1, height: 1)
//        shadowView.layer.shadowRadius = 10
//        shadowView.layer.shadowPath = UIBezierPath(rect: shadowView.bounds).cgPath
//        shadowView.layer.shouldRasterize = true
        
        shadowView.dropShadow(color: UIColor.lightGray, opacity: 10, offSet: .zero, radius: 5, scale: true)

        
        fetchUpgradePremiumStatus { success in
            if self.kycVideo.count != 0 {
                if self.isKycApproved == 0 {
                    self.UpgradeVIew.isHidden = false
                }
                else if self.isKycApproved == 1 {
                    self.UpgradeVIew.isHidden = true
                }
                else if self.isKycApproved == 2 {
                    self.UpgradeVIew.isHidden = false
                }
            } else {
                self.UpgradeVIew.isHidden = false
            }
        }
    }
    func fetchUpgradePremiumStatus(_ success:@escaping(Bool?) -> Void) {
        self.viewModel.processForGetUserProfileData { result in
            if let userVideos = result?["userVideos"] as? [[String:Any]] {
                self.kycVideo = userVideos
            }
            
            if let isKycApproved = result?["isKycApproved"] as? Int {
                self.isKycApproved = isKycApproved
            }
            
            if let isSubscriptionPlanActive = result?["isSubscriptionPlanActive"] as? Int {
                self.isSubscriptionPlanActive = isSubscriptionPlanActive
                KAPPSTORAGE.isSubcription = "\(isSubscriptionPlanActive)"
            }
            success(true)
        }
        
        DispatchQueue.global(qos: .background).async {
            self.viewModel.processForGetUserData { result in
                if let isSubscriptionPlanActive = result?["isSubscriptionPlanActive"] as? Int {
                    self.isSubscriptionPlanActive = isSubscriptionPlanActive
                    
                }
                success(true)
            }
        }
    }
    
    func fetchProfileData() {
        viewModel.getProfileUrl { [weak self] url in
            guard let strongSelf = self else { return }
            strongSelf.viewModel.profileArr.removeAll()
            strongSelf.viewModel.current_page = 0
            
            switch strongSelf.viewModel.title {
            case "Nearby":
               // strongSelf.imageStatus.image = strongSelf.viewModel.array[0].image
                strongSelf.labelFirst.text = strongSelf.viewModel.array[0].labelFirst
                strongSelf.labelSecond.text = strongSelf.viewModel.array[0].labelSecond
                strongSelf.collectionViewTopContraints.constant = CGFloat(GlobalVariables.shared.homeCollectionTopConstant)
                strongSelf.likeStackView.isHidden = true
                strongSelf.viewModel.getProfiles(url: url ?? "", page: "\(strongSelf.viewModel.current_page)", type: "")
                strongSelf.removeBlurEffectForCollectionView()
            case "For you":
               // strongSelf.imageStatus.image = strongSelf.viewModel.array[1].image
                strongSelf.labelFirst.text = strongSelf.viewModel.array[1].labelFirst
                strongSelf.labelSecond.text = strongSelf.viewModel.array[1].labelSecond
                strongSelf.collectionViewTopContraints.constant = CGFloat(GlobalVariables.shared.homeCollectionTopConstant)
                strongSelf.likeStackView.isHidden = true
                strongSelf.viewModel.getProfiles(url: url ?? "", page: "\(strongSelf.viewModel.current_page)", type: "")
                strongSelf.removeBlurEffectForCollectionView()
            case "Likes":
                //strongSelf.imageStatus.image = strongSelf.viewModel.array[2].image
                if strongSelf.isLikes == "sent" {
                    strongSelf.labelFirst.text = strongSelf.viewModel.array[2].labelFirst
                    strongSelf.labelSecond.text = strongSelf.viewModel.array[2].labelSecond
                    strongSelf.UpgradeVIew.isHidden = true
                } else {
                    strongSelf.labelFirst.text = strongSelf.viewModel.array[3].labelFirst
                    strongSelf.labelSecond.text = strongSelf.viewModel.array[3].labelSecond
                    strongSelf.initUpgradeView()

                }
                strongSelf.collectionViewTopContraints.constant = CGFloat(GlobalVariables.shared.homeCollectionTopConstant) + 35 + 15
                strongSelf.likeStackView.isHidden = false
                strongSelf.updateLikesStackView()
                
                strongSelf.viewModel.getProfiles(url: url ?? "", page: "\(strongSelf.viewModel.current_page)", type: strongSelf.type)
                
            case "Aligned":
               // strongSelf.imageStatus.image = strongSelf.viewModel.array[3].image
                strongSelf.labelFirst.text = strongSelf.viewModel.array[4].labelFirst
                strongSelf.labelSecond.text = strongSelf.viewModel.array[4].labelSecond
                strongSelf.collectionViewTopContraints.constant = CGFloat(GlobalVariables.shared.homeCollectionTopConstant)
                strongSelf.likeStackView.isHidden = true
                strongSelf.viewModel.getProfiles(url: url ?? "", page: "\(strongSelf.viewModel.current_page)", type: "")
                strongSelf.removeBlurEffectForCollectionView()
            default: break
            }
        }
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
        barItem = UIBarButtonItem(customView: toggleButton)
        self.navigationItem.rightBarButtonItem = barItem
    }
    
    @objc func updateNotificationForAds(_ notification: Notification) {
        switch self.viewModel.title {
        case "Nearby":
            GlobalVariables.shared.homeCollectionTopConstant = 55.0
            self.collectionViewTopContraints.constant = CGFloat(GlobalVariables.shared.homeCollectionTopConstant)
            self.likeStackView.isHidden = true
        case "For you":
            GlobalVariables.shared.homeCollectionTopConstant = 55.0
            self.collectionViewTopContraints.constant = CGFloat(GlobalVariables.shared.homeCollectionTopConstant)
            self.likeStackView.isHidden = true
        case "Likes":
            GlobalVariables.shared.homeCollectionTopConstant = 55.0
            self.collectionViewTopContraints.constant = CGFloat(GlobalVariables.shared.homeCollectionTopConstant) + 35 + 15
            self.likeStackView.isHidden = false
        case "Aligned":
            GlobalVariables.shared.homeCollectionTopConstant = 55.0
            self.collectionViewTopContraints.constant = CGFloat(GlobalVariables.shared.homeCollectionTopConstant)
            self.likeStackView.isHidden = true
        default: break
        }
        
        //GlobalVariables.shared.homeCollectionTopConstant = 55.0
        //collectionViewTopContraints.constant = CGFloat(GlobalVariables.shared.homeCollectionTopConstant)
    }
    
    func updateLikesStackView() {
        self.viewModel.profileArr.removeAll()
        if self.isLikes == "sent" {
            self.removeBlurEffectForCollectionView()
            self.sentButton.backgroundColor = UIColor.loginBlueColor
            self.sentButton.setTitleColor(UIColor.white, for: .normal)
            self.receivedButton.backgroundColor = UIColor.appSeparator
            self.receivedButton.setTitleColor(UIColor.appTitleBlueColor, for: .normal)
            
        } else {
           // self.addBlurEffectForCollectionView()
            self.receivedButton.backgroundColor = UIColor.loginBlueColor
            self.receivedButton.setTitleColor(UIColor.white, for: .normal)
            self.sentButton.backgroundColor = UIColor.appSeparator
            self.sentButton.setTitleColor(UIColor.appTitleBlueColor, for: .normal)
        }
    }
    
    @IBAction func sentButtonClicked(_ sender: Any) {
        self.viewModel.title = "Likes"
        self.isLikes = "sent"
        self.type = "1"
        updateLikesStackView()
        fetchProfileData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.UpgradeVIew.isHidden = true
        }
    }
    
    @IBAction func receivedButtonClicked(_ sender: Any) {
        self.isLikes = "received"
        self.type = "2"
        updateLikesStackView()
        fetchProfileData()
    }
    
    @IBAction func upgradePremiumButton(_ sender: Any) {
        if self.kycVideo.count != 0 {
            if self.isKycApproved == 0 {
                viewModel.proceedForKycVerificationPendingScreen()
            }
            else if self.isKycApproved == 1 {
                viewModel.proceedForBuyPremiumScreen()
            }
            else if self.isKycApproved == 2 {
                viewModel.proceedForKycPendingScreen()
            }
        } else {
            viewModel.proceedForKycPendingScreen()
        }
    }
}

