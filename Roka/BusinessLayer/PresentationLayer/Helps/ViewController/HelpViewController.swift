//
//  HelpViewController.swift
//  Roka
//
//  Created by  Developer on 01/11/22.
//

import UIKit

class HelpViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.help
        
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.help
    }

    lazy var viewModel: HelpViewModel = HelpViewModel(hostViewController: self)

    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! HelpViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    fileprivate func logoutSuccess() {
        KUSERMODEL.logoutUser()
        gotoLoginScreen()
    }
    
    @IBOutlet weak var deactiveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var topView: UILabel!
    @IBOutlet weak var labelEmailUs: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Help"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel.processForGetUserProfileData { result in
        }
        DispatchQueue.global(qos: .background).async {
            self.viewModel.processForGetUserData { result in
                if GlobalVariables.shared.selectedProfileMode != "MatchMaking"{
                    self.addNavigationBackButtonn()
                    self.topView.backgroundColor = UIColor.appTitleBlueColor
                    self.deleteButton.setTitleColor(UIColor(hex: "#9BA2AE"), for: .normal)
                    self.deleteButton.setTitle("Delete account", for: .normal)
                    self.deleteButton.layer.borderColor = UIColor(hex: "#CDD0D6").cgColor
                    self.deactiveButton.setTitle("Deactivate account", for: .normal)
                } else {
                    self.addNavigatioBlacknBackButton()
                    self.topView.backgroundColor = UIColor(hex: "#AD9BFB")
                    self.deleteButton.setTitleColor(UIColor(hex: "#031634"), for: .normal)
                    self.deleteButton.setTitle("Reactivate Roka- find for you", for: .normal)
                    self.deleteButton.layer.borderColor = UIColor.appTitleBlueColor.cgColor
                    self.deactiveButton.setTitle("Delete account", for: .normal)
                    
                    let isDeactivate = self.viewModel.user.isDeactivate

                    if isDeactivate == 0 {
                        self.deleteButton.isHidden = true
                    } else {
                        self.deleteButton.isHidden = false
                    }
                }
            }
        }
    }
    
    func addNavigationBackButtonn() {
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn2.setImage(UIImage(named: "ic_back_white"), for: .normal)
        btn2.addTarget(self, action: #selector(backkButtonTapped(_:)), for:.touchUpInside)
        let barButton = UIBarButtonItem(customView: btn2)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    func addNavigatioBlacknBackButton() {
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn2.setImage(UIImage(named: "Ic_back_1"), for: .normal)
        btn2.addTarget(self, action: #selector(backkButtonTapped(_:)), for:.touchUpInside)
        let barButton = UIBarButtonItem(customView: btn2)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func backkButtonTapped(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func deleteButtonAction(_ sender: UIButton) {
        if GlobalVariables.shared.selectedProfileMode != "MatchMaking"{
            let popup = UIStoryboard(name: "Popups", bundle: nil)
            if let popupvc = popup.instantiateViewController(withIdentifier: "DeletesViewController") as? DeletesViewController {
                popupvc.callbacktopreviousscreen = {
                    let popup = UIStoryboard(name: "SaveProfile", bundle: nil)
                    if let popupVC = popup.instantiateViewController(withIdentifier: "SuccessfulViewController") as? SuccessfulViewController {
                        popupVC.callbacktopreviousscreen = {
                            self.logoutSuccess()
                        }
                        popupVC.status = "Your Roka - find for you account has been successfully delete."
                        popupVC.modalPresentationStyle = .overCurrentContext
                        self.present(popupVC, animated: true)
                    }
                }
                popupvc.modalPresentationStyle = .overCurrentContext
                self.present(popupvc, animated: true)
            }
        } else {
            let popup = UIStoryboard(name: "SaveProfile", bundle: nil)
            if let popupVC = popup.instantiateViewController(withIdentifier: "SuccessfulViewController") as? SuccessfulViewController {
                popupVC.callbacktopreviousscreen = {
                    self.viewModel.processForDeActivateProfile(isDeactivate: 0) { result in
                        GlobalVariables.shared.selectedProfileMode = "Dating"
                        KAPPDELEGATE.initializeDatingNavigationBar()
                        self.proceedForDatingProfile()
                    }
                }
                popupVC.status = "Your Roka - find for you account has been successfully Reactivated."
                popupVC.modalPresentationStyle = .overCurrentContext
                self.present(popupVC, animated: true)
            }
        }
    }

    @IBAction func deactivateButtonAction(_ sender: UIButton) {
        if GlobalVariables.shared.selectedProfileMode != "MatchMaking" {
            let popup = UIStoryboard(name: "Popups", bundle: nil)
            if let popupvc = popup.instantiateViewController(withIdentifier: "DeactivateViewController") as? DeactivateViewController {
                popupvc.callbacktopreviousscreen = {
                    let popup = UIStoryboard(name: "SaveProfile", bundle: nil)
                    if let popupVC = popup.instantiateViewController(withIdentifier: "SuccessfulViewController") as? SuccessfulViewController {
                        popupVC.callbacktopreviousscreen = {
                            GlobalVariables.shared.selectedProfileMode = "MatchMaking"
                            GlobalVariables.shared.homeCollectionTopConstant = 15.0
                            KAPPDELEGATE.initializeMatchMakingNavigationBar()
                            self.proceedForCreateMatchMakingProfile()
                        }
                        popupVC.status = "Your Roka - find for you account has been successfully deactivated."
                        popupVC.modalPresentationStyle = .overCurrentContext
                        self.present(popupVC, animated: true)
                    }
                }
                popupvc.modalPresentationStyle = .overCurrentContext
                self.present(popupvc, animated: true)
            }
        } else {
            let popup = UIStoryboard(name: "Popups", bundle: nil)
            if let popupvc = popup.instantiateViewController(withIdentifier: "DeletesViewController") as? DeletesViewController {
                popupvc.callbacktopreviousscreen = {
                    let popup = UIStoryboard(name: "SaveProfile", bundle: nil)
                    if let popupVC = popup.instantiateViewController(withIdentifier: "SuccessfulViewController") as? SuccessfulViewController {
                        popupVC.callbacktopreviousscreen = {
                            GlobalVariables.shared.selectedProfileMode = "Dating"
                            KAPPDELEGATE.initializeDatingNavigationBar()
                            self.proceedForDatingProfile()
                        }
                        popupVC.status = "Your Roka - find for you account has been successfully delete."
                        popupVC.modalPresentationStyle = .overCurrentContext
                        self.present(popupVC, animated: true)
                    }
                }
                popupvc.modalPresentationStyle = .overCurrentContext
                self.present(popupvc, animated: true)
            }
        }
    }
    
    
    func proceedForCreateMatchMakingProfile() {
        KAPPDELEGATE.updateRootController(MatchingTabBar.getController(),
                                          transitionDirection: .fade,
                                          embedInNavigationController: true)
    }
   
    func proceedForDatingProfile() {
        KAPPDELEGATE.updateRootController(TabBarController.getController(),
                                          transitionDirection: .fade,
                                          embedInNavigationController: true)
    }
}
