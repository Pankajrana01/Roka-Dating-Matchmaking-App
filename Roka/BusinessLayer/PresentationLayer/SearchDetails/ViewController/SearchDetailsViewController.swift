//
//  SearchDetailsViewController.swift
//  Roka
//
//  Created by  Developer on 10/11/22.
//

import UIKit

class SearchDetailsViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.searchDetails
        
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.searchDetails
    }

    lazy var viewModel: SearchDetailsViewModel = SearchDetailsViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! SearchDetailsViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.hidesBottomBarWhenPushed = true
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    
    @IBOutlet weak var noDataDesLabel: UILabel!
    @IBOutlet weak var nodataView: UIView!
    @IBOutlet weak var gridCollectionView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var fullCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.gridCollectionView = gridCollectionView
        viewModel.collectionView = collectionView
        viewModel.fullCollectionView = fullCollectionView
        viewModel.nodataView = nodataView
        viewModel.title = self.title ?? "Chosen by me"
        self.nodataView.isHidden = true
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appSavedPreferenceLayout), name: .appSavedPreferenceLayout, object: nil)
        
    }
    
    @objc func appSavedPreferenceLayout(notification: Notification) {
        if let userInfo = notification.userInfo as? [String: Any] {
            print(userInfo)
            if let layout = userInfo["layout"] as? LayoutType,
                let id = userInfo["searchPreferenceId"] as? String,
                let name = userInfo["searchPreferenceTitleName"] as? String,
                let isCome = userInfo["isCome"] as? String{
                print(name, isCome)
                viewModel.isCome = isCome
                viewModel.layout = layout
                viewModel.searchPreferenceId = id
                GlobalVariables.shared.searchPreferenceId = id
                GlobalVariables.shared.searchPreferenceCome = isCome
                viewModel.profileArr.removeAll()

                if viewModel.searchPreferenceId != ""{
                    callAPI(id: viewModel.searchPreferenceId)
                } else {
                    viewModel.searchPreferenceId = GlobalVariables.shared.searchPreferenceId
                    callAPI(id: viewModel.searchPreferenceId)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.current_page = 0
        viewModel.profileArr.removeAll()
        viewModel.isMoreRecordAvailable = false
        
        viewModel.gridCollectionView = gridCollectionView
        viewModel.collectionView = collectionView
        viewModel.fullCollectionView = fullCollectionView
        viewModel.nodataView = nodataView
        
        self.collectionView.reloadData()
        self.fullCollectionView.reloadData()
        self.gridCollectionView.reloadData()
        
        self.navigationController?.isNavigationBarHidden = false
        if viewModel.searchPreferenceId != ""{
            callAPI(id: viewModel.searchPreferenceId)
        } else {
            viewModel.searchPreferenceId = GlobalVariables.shared.searchPreferenceId
            viewModel.isCome = GlobalVariables.shared.searchPreferenceCome
            callAPI(id: viewModel.searchPreferenceId)
        }
        
        if viewModel.title == "Chosen by me" {
            self.noDataDesLabel.text = "See profiles saved by you here."
        } else {
            self.noDataDesLabel.text = "See profiles suggested by Roka \n here."
        }
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(refreshEditSavedPreferences), name: .refreshEditSavedPreferences, object: nil)
    }
    
    @objc func refreshEditSavedPreferences (){
        self.navigationController?.popViewController(animated: true)
    }
    func callAPI(id:String){
        if id != ""{
            viewModel.getRokaSuggestedProfiles { [weak self] url in
                guard let strongSelf = self else { return }
                strongSelf.viewModel.getProfiles(url: url ?? "", page: "\(strongSelf.viewModel.current_page)", id: id)
            }
        }
    }
}


