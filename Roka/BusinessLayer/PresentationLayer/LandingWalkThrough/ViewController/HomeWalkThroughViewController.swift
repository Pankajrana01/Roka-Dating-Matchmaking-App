//
//  HomeWalkThroughViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 04/10/22.
//

import UIKit

class HomeWalkThroughViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.landingWalkThrough
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.homeWalkThrough
    }

    lazy var viewModel: HomeWalkThroughViewModel = HomeWalkThroughViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! HomeWalkThroughViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.show(from: viewController, forcePresent: forcePresent)
    }

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var toggleView: UIView!
    @IBOutlet weak var BottomView: UIView!
    @IBOutlet weak var HomeButtonView: UIView!
    @IBOutlet weak var NotificationButtonView: UIView!
    @IBOutlet weak var SearchButtonView: UIView!
    @IBOutlet weak var ChatButtonView: UIView!
    @IBOutlet weak var ProfileButtonView: UIView!
    
    @IBOutlet weak var tabbarStackView: UIStackView!
    @IBOutlet weak var BottomViewTitle: UILabel!
    @IBOutlet weak var BottomViewDesc: UILabel!
    
    @IBOutlet weak var bottomViewBgImage: UIImageView!
    @IBOutlet weak var notiCircle: UIImageView!
    @IBOutlet weak var notiImage: UIImageView!
    
    @IBOutlet weak var searchCircle: UIImageView!
    @IBOutlet weak var searchImage: UIImageView!
    
    @IBOutlet weak var chatCircle: UIImageView!
    @IBOutlet weak var chatImage: UIImageView!
    
    @IBOutlet weak var homeCircle: UIImageView!
    @IBOutlet weak var homeImage: UIImageView!
    
    @IBOutlet weak var profileCircle: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var bottomStackView: UIStackView!
    
    @IBOutlet weak var matchingImageView: UIImageView!
    
    var nextButtonActionIndex = 0
    var toggleButton = UIButton()
    var barItem = UIBarButtonItem()
    var leftItem = UIBarButtonItem()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        showLeftNavigationLogo()
        addNavigationLeftButton()
        self.leftItem.customView?.alpha = 0.2
        tabbarStackView.layer.masksToBounds = false
        tabbarStackView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        tabbarStackView.layer.shadowOffset = CGSize(width: -4, height: -6)
        tabbarStackView.layer.shadowOpacity = 0.5
        tabbarStackView.layer.shadowRadius = 10
        self.matchingImageView.isHidden = true
        
        viewModel.collectionView = collectionView
        viewModel.toggleView = toggleView
        viewModel.BottomView = BottomView
        viewModel.bottomViewBgImage = bottomViewBgImage
        viewModel.HomeButtonView = HomeButtonView
        viewModel.NotificationButtonView = NotificationButtonView
        viewModel.SearchButtonView = SearchButtonView
        viewModel.ChatButtonView = ChatButtonView
        viewModel.ProfileButtonView = ProfileButtonView
        viewModel.BottomViewTitle = BottomViewTitle
        viewModel.BottomViewDesc = BottomViewDesc
        
        viewModel.homeCircle = homeCircle
        viewModel.homeImage = homeImage
        viewModel.notiCircle = notiCircle
        viewModel.notiImage = notiImage
        viewModel.searchCircle = searchCircle
        viewModel.searchImage = searchImage
        viewModel.chatCircle = chatCircle
        viewModel.chatImage = chatImage
        viewModel.profileCircle = profileCircle
        viewModel.profileImage = profileImage
        
        viewModel.showToggleView()
        
        
        if viewModel.isComeFor == "MatchMaking"{
            self.matchingImageView.isHidden = false
        }else {
            self.matchingImageView.isHidden = true
        }
        
        if self.viewModel.isComeFor == "LandingDoneAction"{
            self.leftItem.customView?.alpha = 1.0
            tabbarStackView.isHidden = false
            blackView.isHidden = true
            toggleView.isHidden = true
            BottomView.isHidden = true
            bottomStackView.isHidden = true
        }
        
    // Do any additional setup after loading the view.
    }
    
    
    
    func showLeftNavigationLogo() {
        let btn1 = UIButton()
        btn1.setImage(UIImage(named: "Ic_Logo_nav"), for: .normal)
        btn1.frame = CGRect(x: 15, y: 0, width: 30, height: 30)
        leftItem.customView = btn1
        let space = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItems = [leftItem]
    }
    //Ic_toggle_matching
    func addNavigationLeftButton() {
        toggleButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        if viewModel.isComeFor == "MatchMaking"{
            toggleButton.setImage(UIImage(named: "Ic_toggle_matching"), for: .normal)
        } else {
            toggleButton.setImage(UIImage(named: "ic_toggle"), for: .normal)
        }
        barItem = UIBarButtonItem(customView: toggleButton)
        self.navigationItem.rightBarButtonItem = barItem
    }
    @IBAction func toggleNextButton(_ sender: UIButton) {
        nextButtonActionIndex += 1
        self.barItem.customView?.alpha = 0.2
        self.leftItem.customView?.alpha = 0.2
       
        viewModel.showHomeView()
    }
    
    @IBAction func toggleSkipAllButton(_ sender: UIButton) {
        if viewModel.isComeFor == "MatchMaking"{
            viewModel.proceedForCreateMatchMakingProfile()
        } else {
            viewModel.proceedForHome()
        }
    }
   
    @IBAction func bottomViewNextButton(_ sender: UIButton) {
        nextButtonActionIndex += 1
        self.barItem.customView?.alpha = 0.2
        self.leftItem.customView?.alpha = 0.2
        switch nextButtonActionIndex {
        case 1:
            viewModel.showHomeView()
        case 2:
            viewModel.showNotificationView()
        case 3:
            viewModel.showSearchView()
        case 4:
            viewModel.showChatView()
        case 5:
            viewModel.showProfileView()
        case 6:
            viewModel.proceedToLandingWalkthrough()
        default:
            break
        }
    }
    
    @IBAction func profileButtonAction(_ sender: UIButton) {
        viewModel.proceedForLogout()
    }
    @IBAction func bottomViewSkipAllButton(_ sender: UIButton) {
        viewModel.proceedToLandingWalkthrough()
    }
}
