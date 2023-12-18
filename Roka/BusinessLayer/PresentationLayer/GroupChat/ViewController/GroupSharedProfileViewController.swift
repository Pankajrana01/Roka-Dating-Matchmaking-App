//
//  GroupSharedProfileViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 28/12/22.
//

import UIKit

class GroupSharedProfileViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.groupChat
        
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.groupSharedProfile
    }

    lazy var viewModel: GroupSharedProfileViewModel = GroupSharedProfileViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    profilesIds: String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! GroupSharedProfileViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.viewModel.profilesIds = profilesIds
        controller.show(from: viewController, forcePresent: forcePresent)
    }

    @IBOutlet weak var gridCollectionView: UICollectionView!
    
    @IBOutlet weak var topStaticLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
      //  showNavigationBackButton(title: "  Shared Profiles")
        viewModel.gridCollectionView = gridCollectionView
        viewModel.getAllSharedProfiles { success in
            
        }
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addNavigationBackButton()
        self.title = "Sent Profiles"
        self.navigationController?.isNavigationBarHidden = false


    }
    
    func addNavigationBackButton() {
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        if GlobalVariables.shared.selectedProfileMode == "MatchMaking" {
            btn2.setImage(UIImage(named: "Ic_back_1"), for: .normal)
        }else{
            btn2.setImage(UIImage(named: "ic_back_white"), for: .normal)
        }
        btn2.addTarget(self, action: #selector(backkButtonTapped(_:)), for:.touchUpInside)
        let barButton = UIBarButtonItem(customView: btn2)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func backkButtonTapped(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}
