//
//  SavedProfilesViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 29/10/22.
//

import UIKit

class SavedProfilesViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.savedProfiles
        
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.savedProfiles
    }

    lazy var viewModel: SavedProfilesViewModel = SavedProfilesViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! SavedProfilesViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.hidesBottomBarWhenPushed = true
        controller.show(from: viewController, forcePresent: forcePresent)
    }

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nodataView: UIView!
    @IBOutlet weak var noDataSubTitleLbl: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.collectionView = collectionView
        viewModel.nodataView = nodataView
        viewModel.noDataSubTitleLbl  = noDataSubTitleLbl
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        showNavigationBackButton(title: "  Saved Profiles")
        viewModel.title = self.title ?? "For you"
        
        if self.title == "For you"{
            viewModel.current_page = 0
            viewModel.getSavedProfiles(page: "\(self.viewModel.current_page)")
        } else {
            viewModel.current_page = 0
            viewModel.getSavedProfiles(page: "\(self.viewModel.current_page)")
        }
        
        // This need to add to add someextra spcae to botton in table view
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0,bottom: CGFloat(20),right: 0)

    }
    
}
