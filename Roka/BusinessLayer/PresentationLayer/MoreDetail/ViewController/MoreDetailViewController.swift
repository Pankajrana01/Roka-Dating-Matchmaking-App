//
//  MoreDetailViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 06/10/22.
//

import UIKit

class MoreDetailViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.moreDetail
        
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.moreDetail
    }
    
    lazy var viewModel: MoreDetailViewModel = MoreDetailViewModel(hostViewController:self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor: String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! MoreDetailViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.hidesBottomBarWhenPushed = true
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startAligingButton: UIButton!
    @IBOutlet weak var topLable: UILabel!
    @IBOutlet weak var tableTopView: NSLayoutConstraint!
    @IBOutlet weak var startAligingBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        viewModel.tableView = tableView
        // Do any additional setup after loading the view.
        if viewModel.isComeFor == "AboutMeProfile" {
            viewModel.segment = "AboutMeProfile"
            // showNavigationBackButton(title: "My Profile")
            self.title = "My Profile"
            self.startAligingButton.isHidden = true
            self.tableViewBottom.constant = 0
            self.tableTopView.constant = 18
            self.startAligingBottom.constant = 30
            self.topLable.isHidden = false
            self.topLable.backgroundColor = UIColor.appTitleBlueColor
            viewModel.processForGetGenderData(type: "1")
        }
        else if viewModel.isComeFor == "PreferenceProfile" {
            viewModel.segment = "My preferences"
            //showNavigationBackButton(title: "  Profile Preferences")
            self.title = "Profile Preferences"
            self.startAligingButton.isHidden = true
            self.tableViewBottom.constant = 0
            viewModel.processForGetGenderData(type: "2")
            self.tableTopView.constant = 18
            self.startAligingBottom.constant = 30
            self.topLable.isHidden = false
            self.topLable.backgroundColor = UIColor.appTitleBlueColor
        }
        else if viewModel.isComeFor == "Friend Preferences" {
            viewModel.segment = "My preferences"
            self.title = "Friend's Preferences"
            viewModel.processForGetGenderData(type: "2")
            self.startAligingButton.isHidden = false
            self.tableViewBottom.constant = 90
            self.tableTopView.constant = 22
            self.startAligingBottom.constant = 20
            self.topLable.isHidden = false
            self.startAligingButton.setTitle("Start Matching", for: .normal)
        }
        else if viewModel.isComeFor == "Friend My Preferences" {
            viewModel.segment = "My preferences"
            self.title = "Friend's Preferences"
            viewModel.processForGetGenderData(type: "2")
            self.startAligingButton.isHidden = true
            self.tableViewBottom.constant = 0
            self.tableTopView.constant = 22
            self.startAligingBottom.constant = 0
            self.topLable.isHidden = false
        }
        else if title == "More about Friend" {
            viewModel.segment = "About me"
            viewModel.processForGetGenderData(type: "1")
            self.startAligingButton.isHidden = false
            self.tableViewBottom.constant = 90
            self.tableTopView.constant = 2
            self.startAligingBottom.constant = 30
            self.topLable.isHidden = true
        }
        else if title == "Friend Preferences" {
            viewModel.segment = "My preferences"
            viewModel.processForGetGenderData(type: "2")
            self.startAligingButton.isHidden = true
            self.tableViewBottom.constant = 0
            self.tableTopView.constant = 2
            self.startAligingBottom.constant = 30
            self.topLable.isHidden = true
        }
        else {
            viewModel.segment = title ?? "About me"
            viewModel.processForGetGenderData(type: "1")
            self.startAligingButton.isHidden = false
            self.tableViewBottom.constant = 90
            self.tableTopView.constant = 2
            self.topLable.isHidden = true
        }
    }
    
    func addNavigationBackButton() {
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 25, height: 30)
      
        if viewModel.isComeFor == "Friend Preferences" || viewModel.isComeFor == "Friend My Preferences" {
            btn2.setImage(UIImage(named: "Ic_back_1"), for: .normal)
        } else {
            btn2.setImage(UIImage(named: "ic_back_white"), for: .normal)
        }
        
        btn2.addTarget(self, action: #selector(backkButtonTapped(_:)), for:.touchUpInside)
        let barButton = UIBarButtonItem(customView: btn2)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func backkButtonTapped(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addNavigationBackButton()
        if title == "My preferences" || title == "Profile Preferences" || title == "Friend Preferences" {
            viewModel.processForGetUserPreferenceProfileData()
        } else if viewModel.isComeFor == "Friend Preferences" || viewModel.isComeFor == "Friend My Preferences" {
            viewModel.processForGetUserPreferenceProfileData()
        } else {
            viewModel.processForGetUserData()
        }
    }
    
    @IBAction func startAligningClicked(_ sender: Any) {
        if viewModel.isComeFor == "Friend Preferences" {
            GlobalVariables.shared.selectedImages.removeAll()
            GlobalVariables.shared.isComeFor = ""
            GlobalVariables.shared.cameraCancel = ""
            viewModel.popBackToController()
        } else {
            GlobalVariables.shared.selectedImages.removeAll()
            GlobalVariables.shared.isComeFor = ""
            GlobalVariables.shared.cameraCancel = ""
            viewModel.proceedForTabbar()
        }
    }
}
