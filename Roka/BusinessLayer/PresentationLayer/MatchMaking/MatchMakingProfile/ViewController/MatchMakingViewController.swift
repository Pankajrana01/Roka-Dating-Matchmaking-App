//
//  MatchMakingViewController.swift
//  Roka
//
//  Created by  Developer on 21/11/22.
//

import UIKit
import ObjectiveC.runtime

class MatchMakingViewController: BaseViewController {

    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.matchMaking
        
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.matchMaking
    }

    lazy var viewModel: MatchMakingViewModel = MatchMakingViewModel(hostViewController: self)

    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! MatchMakingViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    // MARK: - IBOutlets.
    @IBOutlet weak var collectionViewTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var backgroundViewTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var inappropriateLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var centerImage: UIImageView!
    
    @IBOutlet weak var collectionViewContainer: UIView!
    @IBOutlet weak var labelFriend: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var barItem = UIBarButtonItem()
    var leftItem = UIBarButtonItem()
    var toggleButton = UIButton()
    var isMoreRecordAvailable = false
    var current_page = 0
    var bannerView = ISBannerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
       // KAPPDELEGATE.initializeMatchMakingNavigationBar()
        self.backgroundView.isHidden = true
        self.collectionViewContainer.isHidden = true
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        // Hiding the tabBar as we are moving to other screen
        super.viewWillAppear(animated)
        fetchProfiles()
        NotificationCenter.default.post(name: .updateNotificationIcon, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        distroyBanner()
    }
    
    func fetchProfiles() {
        showLoader()
        self.viewModel.getFriendsProfile { [weak self] data in
            guard let strongSelf = self else { return }
            // if data present then show the collectionview
            // otherwise show other screen
            
            guard let data = data, data.data.count != 0 else {
                strongSelf.backgroundView.isHidden = false
                strongSelf.collectionViewContainer.isHidden = true
                if strongSelf.current_page == 0 {
                    strongSelf.isMoreRecordAvailable = false
                    strongSelf.viewModel.profileArr.removeAll()
                    GlobalVariables.shared.matchedProfileArr.removeAll()
                }
                return
            }
            strongSelf.backgroundView.isHidden = true
            strongSelf.collectionViewContainer.isHidden = false
            
            if strongSelf.current_page == 0 {
                strongSelf.isMoreRecordAvailable = false
                strongSelf.viewModel.profileArr.removeAll()
                GlobalVariables.shared.matchedProfileArr.removeAll()
            }
            
//            if data.data.count == 10 {
//                strongSelf.isMoreRecordAvailable = true
//            } else {
//                strongSelf.isMoreRecordAvailable = false
//            }
            strongSelf.viewModel.profileArr.append(contentsOf: data.data)
            GlobalVariables.shared.matchedProfileArr.append(contentsOf: data.data)
            
            
//            data.data.forEach { model in
//                strongSelf.viewModel.profileArr = data.data
//            }
            // reload collectionView
            DispatchQueue.main.async {
                strongSelf.setupIronSourceSdk()
                strongSelf.initBannerAdsView()
                strongSelf.collectionView.reloadData()
            }
            
            hideLoader()
        }
    }
    private func setupUI() {
        viewModel.checkLocationSettings()
        showLeftNavigationLogo()
        addNavigationLeftButton()
        setupCollectionView()
    }
    
    func showLeftNavigationLogo() {
        let btn1 = UIButton()
        btn1.setImage(UIImage(named: "Ic_Logo_nav"), for: .normal)
        btn1.frame = CGRect(x: 15, y: 0, width: 30, height: 25)
        leftItem.customView = btn1
        let space = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItems = [leftItem]
    }
    
    func addNavigationLeftButton() {
        toggleButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        toggleButton.setImage(UIImage(named: "Ic_toggle_matching"), for: .normal)
        toggleButton.addTarget(self, action: #selector(toggleButtonAction(_:)), for: .touchUpInside)
        barItem = UIBarButtonItem(customView: toggleButton)
        self.navigationItem.rightBarButtonItem = barItem
    }
    
    func setupCollectionView() {
        collectionView.register(UINib(nibName: MatchMakingCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: MatchMakingCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
  
    }
    
    @objc func toggleButtonAction(_ sender: UIButton) {
        proceedForSwitchModeScreen()
    }
    
    func proceedForSwitchModeScreen() {
        let controller = SwitchModeViewController.getController() as! SwitchModeViewController
        controller.dismissCompletion = { value  in
            self.distroyBanner()
        }
        controller.show(over: self, isComeFor: "MatchMaking") { value in }
    }
    
    @IBAction func skipBrowserButtonClicked(_ sender: Any) {
        viewModel.proceedToMatchMakingSkipBrowse()
    }
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        // Action here...
    }
    
    @IBAction func addFullButtonAction(_ sender: UIButton) {
        // Redirect to same screen as edit button action..
        self.viewModel.proceedToMatchMakingBasicInfo()
    }
}

extension MatchMakingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.profileArr.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchMakingCollectionViewCell.identifier, for: indexPath) as! MatchMakingCollectionViewCell
       
        if indexPath.row == 0 {
            cell.configure(index: indexPath.row, model: nil)
        } else {
            let model = viewModel.profileArr[indexPath.row - 1]
            cell.configure(index: indexPath.row, model: model)
        }
        
        cell.callBackForAdd_edit = { [weak self] tag in
            guard let strongSelf = self else { return }
            if tag == 0 {
                strongSelf.viewModel.proceedToMatchMakingBasicInfo()
            } else {
                strongSelf.viewModel.selectedProfile = strongSelf.viewModel.profileArr[indexPath.row - 1]
                strongSelf.viewModel.proceedToMatchMakingEdit(selectedProfile: strongSelf.viewModel.profileArr[indexPath.row - 1])
            }
        }
        
        cell.callBackForFull_Button = { [weak self] tag in
            guard let strongSelf = self else { return }
            strongSelf.viewModel.isComeFor = "fullButton"
            if tag == 0 {
                strongSelf.viewModel.proceedToMatchMakingBasicInfo()
            } else {
                strongSelf.viewModel.proceedToMatchMakingDetailsPagerController(selectedProfile: strongSelf.viewModel.profileArr[indexPath.row - 1], isComeFor: strongSelf.viewModel.isComeFor)
            }
        }
        
        cell.callBackForStackViewButton = { [weak self] tag in
            guard let strongSelf = self else { return }
            strongSelf.viewModel.isComeFor = "stackViewButton"
            if tag == 0 {
                print("Don't do anything")
            } else {
                strongSelf.viewModel.proceedToMatchMakingDetailsPagerController(selectedProfile: strongSelf.viewModel.profileArr[indexPath.row - 1], isComeFor: strongSelf.viewModel.isComeFor)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.view.frame.size.width/2 - 20, height: 210)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        /// vertical spacing
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if indexPath.row == self.viewModel.profileArr.count - 1 &&                     self.isMoreRecordAvailable {
//            DispatchQueue.main.asyncAfter(deadline: .now()) {                   self.current_page += 1
//                self.fetchProfiles()
//            }
//        }
    }
}
// MARK: - ISBannerDelegate Functions

extension MatchMakingViewController : ISBannerDelegate, ISInitializationDelegate, ISImpressionDataDelegate {
    
    func distroyBanner() {
        DispatchQueue.main.async {
           // if self.bannerView != nil {
                IronSource.destroyBanner(self.bannerView)
           // }
        }
    }
    
    func initializationDidComplete() {
        logFunctionName()
    }
    
    func setupIronSourceSdk() {
        ISIntegrationHelper.validateIntegration()
        IronSource.setBannerDelegate(self)
        IronSource.add(self)
        
       // IronSource.initWithAppKey(kAPPKEY, delegate: self)
        // To initialize specific ad units:
        IronSource.initWithAppKey(kAPPKEY, adUnits: [IS_BANNER])
    }
    func initBannerAdsView() {
        collectionViewTopConstraints.constant = 20
        let BNSize: ISBannerSize = ISBannerSize(description: "BANNER", width:320 ,height:50)
        IronSource.loadBanner(with: self, size: BNSize)
    }
    func logFunctionName(string: String = #function) {
        print("IronSource Swift Demo App: "+string)
    }
    
    func bannerDidLoad(_ bannerView: ISBannerView!) {
        self.bannerView = bannerView
        collectionViewTopConstraints.constant = 70
        backgroundViewTopConstraints.constant = 0
        let screenRect = UIScreen.main.bounds
        let screenHeight = screenRect.size.height
        if screenHeight >= 812 {
            if #available(iOS 11.0, *) {
                bannerView.frame = CGRect(x: self.view.frame.size.width/2 - bannerView.frame.size.width/2, y:160, width: bannerView.frame.size.width, height: bannerView.frame.size.height - self.view.safeAreaInsets.bottom * 2.5)
            } else {
                bannerView.frame = CGRect(x: self.view.frame.size.width/2 - bannerView.frame.size.width/2, y: 160, width: bannerView.frame.size.width, height: bannerView.frame.size.height  * 2.5)
            }
        } else {
            if #available(iOS 11.0, *) {
                bannerView.frame = CGRect(x: self.view.frame.size.width/2 - bannerView.frame.size.width/2, y:130, width: bannerView.frame.size.width, height: bannerView.frame.size.height - self.view.safeAreaInsets.bottom * 2.5)
            } else {
                bannerView.frame = CGRect(x: self.view.frame.size.width/2 - bannerView.frame.size.width/2, y: 130, width: bannerView.frame.size.width, height: bannerView.frame.size.height  * 2.5)
            }
        }
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
