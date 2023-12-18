//
//  UpgradeSubcriptionViewController.swift
//  Roka
//
//  Created by ios on 29/09/23.
//

import UIKit

class UpgradeSubcriptionViewController: BaseAlertViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.popups
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.subcriptionUpgrade
    }
    
    lazy var viewModel: UpgradeSubcriptionViewModel = UpgradeSubcriptionViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    @IBOutlet weak var upgradeToPremiumButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    var name = ""
    var callBacktoMainScreen: (() ->())?
    var callBackforDismiss: (() ->())?
    
    class func show(over host: UIViewController,
                    completionHandler: @escaping ((String) -> Void)) {
        let controller = self.getController() as! UpgradeSubcriptionViewController
        controller.show(over: host, completionHandler: completionHandler)
    }
    
    func show(over host: UIViewController,
              completionHandler: @escaping ((String) -> Void)) {
        viewModel.completionHandler = completionHandler
        show(over: host, completionHandler: completionHandler)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameLabel.text = "Hi \(UserModel.shared.storedUser?.firstName ?? "")!"
    }
    
    
    func setFocusOnButton() {
        upgradeToPremiumButton.setNeedsFocusUpdate()
    }

    @IBAction func upgradePremiumButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.callBacktoMainScreen?()
        }
    }

    @IBAction func doLaterButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.callBackforDismiss?()
        }
    }
    
    @IBAction func dismissButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
//        self.dismiss(animated: true) {
//            self.callBackforDismiss?()
//        }
    }
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [upgradeToPremiumButton]
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        self.setFocusOnButton()
    }
    
    override func shouldUpdateFocus(in context: UIFocusUpdateContext) -> Bool {
        return true
    }
}

class UpgradeSubcriptionViewModel: BaseViewModel {
    var isComeFor = ""
    var completionHandler: ((String) -> Void)?
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
}
