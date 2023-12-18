//
//  MatchMakingDetailSearchViewController.swift
//  Roka
//
//  Created by  Developer on 08/12/22.
//

import UIKit

class MatchMakingDetailSearchViewController: BaseViewController {
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.matchMakingDetailSearch
        
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.matchMakingDetailSearch
    }

    lazy var viewModel: MacthMakingDetailSearchViewModel = MacthMakingDetailSearchViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    profiles: [ProfilesModel],
                    profilesCellVMArray: [MatchMakingDetailsCollectionViewCellViewModel],
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! MatchMakingDetailSearchViewController
        controller.viewModel.isComeFor = isComeFor
        controller.viewModel.profileArray = profiles
        controller.viewModel.profileCellViewModels = profilesCellVMArray
        controller.viewModel.reservedProfileCellViewModels = profilesCellVMArray
        controller.hidesBottomBarWhenPushed = true
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var shareViewHeightConstant: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.showHideShareButton()
//        self.showHideNoDataCollection()
        showNavigationBackButton(title: StringConstants.matchMakingDetailSearch + "\(viewModel.isComeFor)")
        
    }
 
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: MatchMakingDetailsCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: MatchMakingDetailsCollectionViewCell.identifier)
        collectionView.reloadData()
        
    }
    
    private func showHideShareButton() {
        if self.viewModel.reservedProfileCellViewModels.filter({ $0.isSelected }).count > 0 {
            self.shareViewHeightConstant.constant = 60
            self.shareView.isHidden = false
        } else {
            self.shareView.isHidden = true
            self.shareViewHeightConstant.constant = 0
        }
    }
    
    //    private func showHideNoDataCollection() {
    //        if viewModel.profileArray.count != 0 {
    //            self.collectionView.isHidden = false
    //            self.noDataView.isHidden = true
    //        } else {
    //            if self.viewModel.isSuggested {
    //                // suggested
    //                self.collectionView.isHidden = true
    //                self.noDataView.isHidden = true
    //            } else {
    //                // choosen By me
    //                self.collectionView.isHidden = true
    //                self.noDataView.isHidden = false
    //            }
    //        }
    //    }
    
    @IBAction func shareButtonClicked(_ sender: UIButton) {
        // Action here
        // Go to share search screen
        let selectedProfile = self.viewModel.reservedProfileCellViewModels.filter({ $0.isSelected }).map({ $0.model })
        self.viewModel.proceedToShareSearchScreen(model: selectedProfile)
    }
    
    // MARK: - Search Handler..
    @IBAction func searchHandler(_ sender: UITextField) {
        /// We have used `reservedProfileCellViewModels` to reserve the original data while searching our result..
        if let searchText = sender.text {
            self.viewModel.profileCellViewModels = searchText.isEmpty ? self.viewModel.reservedProfileCellViewModels : self.viewModel.reservedProfileCellViewModels.filter { $0.model.firstName!.lowercased().contains(searchText.lowercased()) }
            self.collectionView.reloadData()
            
            if viewModel.profileCellViewModels.count == 0 {
                self.collectionView.isHidden = true
                self.noDataView.isHidden = false
            } else {
                self.collectionView.isHidden = false
                self.noDataView.isHidden = true
            }
        }
    }
}

extension MatchMakingDetailSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Collection Delegate & DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.profileCellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchMakingDetailsCollectionViewCell.identifier, for: indexPath) as! MatchMakingDetailsCollectionViewCell
        let cellVM = viewModel.profileCellViewModels[indexPath.row]
        cell.configure(viewModel: cellVM)
       
        cell.callBackShareButton = { [weak self] in
            guard let strongSelf = self else { return }
            cellVM.isSelected = !cellVM.isSelected
            strongSelf.showHideShareButton()
            strongSelf.collectionView.reloadData()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.viewModel.hostViewController.view.frame.size.width/2 - 30, height: 240)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.proceedToDetailScreen(profile: viewModel.profileCellViewModels[indexPath.row].model, index: indexPath.row)
    }
}
