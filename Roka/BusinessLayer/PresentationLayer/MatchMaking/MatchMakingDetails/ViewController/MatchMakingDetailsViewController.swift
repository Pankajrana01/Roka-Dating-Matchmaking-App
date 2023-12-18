//
//  MatchMakingDetailsViewController.swift
//  Roka
//
//  Created by  Developer on 05/12/22.
//

import UIKit

class MatchMakingDetailsViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.matchMakingDetails
        
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.matchMakingDetails
    }

    lazy var viewModel: MatchMakingDetailsViewModel = MatchMakingDetailsViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    broswSkipDetailsDictionary : [String:Any],
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! MatchMakingDetailsViewController
        controller.viewModel.isComeFor = isComeFor
        controller.hidesBottomBarWhenPushed = true
        controller.viewModel.broswSkipDetailsDictionary = broswSkipDetailsDictionary
        controller.show(from: viewController, forcePresent: forcePresent)
    }

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var noDataImage: UIImageView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var shareViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var topStaticLbl: UILabel!

    var friendsId = ""
    var getArray: ( ([ProfilesModel]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.shareView.isHidden = true
        self.shareViewHeightConstant.constant = 0
        self.viewModel.id = friendsId
        setupCollectionView()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.shareView.isHidden = true
        self.shareViewHeightConstant.constant = 0
        if viewModel.isComeFor == "BrowseAndSkip"{
            self.navigationController?.isNavigationBarHidden = false
            self.title = "Browse profiles"
            self.addNavigationEditButton()
            self.addNavigationBackButton()
            self.topStaticLbl.backgroundColor = UIColor.loginBlueColor
            self.callBrowseSkipApi()
        }else{
            callAPI()
        }
    }
    
    func addNavigationEditButton() {
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        if GlobalVariables.shared.selectedProfileMode == "MatchMaking" {
            btn2.setImage(UIImage(named: "Edit_New"), for: .normal)
        }
        btn2.addTarget(self, action: #selector(editButtonTapped(_:)), for:.touchUpInside)
        let barButton = UIBarButtonItem(customView: btn2)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func addNavigationBackButton() {
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        if GlobalVariables.shared.selectedProfileMode == "MatchMaking" {
            btn2.setImage(UIImage(named: "Ic_back_1"), for: .normal)
        }
        btn2.addTarget(self, action: #selector(backkButtonTapped(_:)), for:.touchUpInside)
        let barButton = UIBarButtonItem(customView: btn2)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func backkButtonTapped(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }

    
    @objc func editButtonTapped(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }

    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: MatchMakingDetailsCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: MatchMakingDetailsCollectionViewCell.identifier)
    }
    
    private func showHideShareButton() {
        if self.viewModel.reservedProfileCellViewModels.filter({ $0.isSelected }).count > 0 {
            self.shareViewHeightConstant.constant = 60
            self.shareView.isHidden = false
            self.shareView.backgroundColor = .clear
        } else {
            self.shareView.isHidden = true
            self.shareViewHeightConstant.constant = 0
            self.shareView.backgroundColor = .clear
        }
    }
    
    private func callAPI() {
        DispatchQueue.main.async { showLoader() }
        self.viewModel.getFriendsMatchMakingData { [weak self] result in
            guard let strongSelf = self else { return }
            if let profileData = result?.data, let count = result?.data.count, count != 0 {
                strongSelf.viewModel.profileArray = profileData
                strongSelf.getArray?(profileData)
                strongSelf.collectionView.isHidden = false
                strongSelf.noDataView.isHidden = true
            } else {
                if strongSelf.viewModel.isSuggested {
                    // Roka Suggested
                    //strongSelf.noDataImage.image = UIImage(named: "Ic_no_dota_found 1")

                    strongSelf.noDataLabel.text = StringConstants.emptySuggested
                    strongSelf.collectionView.isHidden = true
                    strongSelf.noDataView.isHidden = false
                } else {
                    // choosen by me
                   // strongSelf.noDataImage.image = UIImage(named: "Ic_no_dota_found 1")
                    strongSelf.noDataLabel.text = StringConstants.emptyChoosenByMe
                    strongSelf.collectionView.isHidden = true
                    strongSelf.noDataView.isHidden = false
                }
                strongSelf.getArray?([])
            }
            DispatchQueue.main.async {
                hideLoader()
                strongSelf.collectionView.reloadData()
            }
        }
    }
    
    private func callBrowseSkipApi() {
        DispatchQueue.main.async { showLoader() }
        self.viewModel.browseSkipApiCall { [weak self] result in
            guard let strongSelf = self else { return }
            if let profileData = result?.data, let count = result?.data.count, count != 0 {
                strongSelf.viewModel.profileArray = profileData
                strongSelf.getArray?(profileData)
                strongSelf.collectionView.isHidden = false
                strongSelf.noDataView.isHidden = true
            } else {
                strongSelf.noDataLabel.text = StringConstants.emptyChoosenByMe
                strongSelf.collectionView.isHidden = true
                strongSelf.noDataView.isHidden = false
                strongSelf.getArray?([])
            }
            DispatchQueue.main.async {
                hideLoader()
                strongSelf.collectionView.reloadData()
            }
        }
    }

    @IBAction func shareButtonClicked(_ sender: UIButton) {
        // Action here
        // Go to share search screen
        let selectedProfile = self.viewModel.profileCellViewModels.filter({ $0.isSelected }).map({ $0.model })
        self.viewModel.proceedToShareSearchScreen(model: selectedProfile) { response in
            if response == "sucessforSharePopup"{
                self.callAPI()
                self.shareView.isHidden = true
                self.shareViewHeightConstant.constant = 0
            }
        }
    }
}

extension MatchMakingDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Collection Delegate & DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.profileCellViewModels.count
    }
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchMakingDetailsCollectionViewCell.identifier, for: indexPath) as! MatchMakingDetailsCollectionViewCell
        let cellVM = viewModel.profileCellViewModels[indexPath.row]
        cell.configure(viewModel: cellVM)
        
        if self.viewModel.isSuggested {
            cell.backView.backgroundColor = UIColor.white
        } else {
            cell.backView.backgroundColor = UIColor.appLightBlueColor
        }
        
        if viewModel.isComeFor == "BrowseAndSkip" {
            cell.colorView.backgroundColor = UIColor.white
        }
        cell.callBackShareButton = { [weak self] in
            guard let strongSelf = self else { return }
            cellVM.isSelected = !cellVM.isSelected
            strongSelf.showHideShareButton()
            strongSelf.collectionView.reloadData()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.viewModel.hostViewController.view.frame.size.width/2 - 20, height: 210)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if viewModel.isComeFor == "BrowseAndSkip" {
            viewModel.proceedToDetailScreen(profile: viewModel.profileCellViewModels[indexPath.row].model, index: indexPath.row, isCome: "BrowseAndSkip")
        } else {
            viewModel.proceedToDetailScreen(profile: viewModel.profileCellViewModels[indexPath.row].model, index: indexPath.row, isCome: "MatchMakingProfile")
        }
    }
    
    
}
