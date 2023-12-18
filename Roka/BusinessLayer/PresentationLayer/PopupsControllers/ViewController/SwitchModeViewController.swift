//
//  SwitchModeViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 06/10/22.
//

import UIKit

class SwitchModeViewController: BaseAlertViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.popups
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.switchMode
    }

    lazy var viewModel: SwitchModeViewModel = SwitchModeViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(over host: UIViewController, isComeFor: String,
                    completionHandler: @escaping ((String) -> Void)) {
        let controller = self.getController() as! SwitchModeViewController
        controller.show(over: host, isComeFor: isComeFor, completionHandler: completionHandler)
    }
    
    func show(over host: UIViewController, isComeFor: String,
              completionHandler: @escaping ((String) -> Void)) {
        viewModel.completionHandler = completionHandler
        viewModel.isComeFor = isComeFor
        show(over: host)
    }


    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var LabelFirst: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       
    }
    
    func animateFirstLabel() {
        UIView.animate(withDuration: 1.2, delay: 0, options: ([.curveLinear]), animations: {() -> Void in
            self.LabelFirst.center = CGPointMake(0 - self.LabelFirst.bounds.size.width * 2, self.LabelFirst.center.y)
        }, completion:  { _ in
            delay(1.0) {
                if self.viewModel.isComeFor == "Dating" {
                    self.switchToMatchMaking()
                } else {
                    self.switchToDating()
                }
            }
        })
    }
    
    func animateSecondLabel() {
        UIView.animate(withDuration: 1.2, delay: 0, options: ([.curveLinear]), animations: {() -> Void in
            self.secondLabel.center = CGPointMake(self.secondLabel.bounds.size.width * 2, self.secondLabel.center.y)
        }, completion:  { _ in
            
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if viewModel.isComeFor == "Dating" {
            secondLabel.text = "Roka For Others"
        } else {
            secondLabel.text = "Roka For You"
        }
        
        animateFirstLabel()
        animateSecondLabel()
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss()
    }
    
    @IBAction func rokaDatingButton(_ sender: UIButton) {
        self.dismiss()
        if self.viewModel.user.isDeactivate == 1 {
            showMessage(with: "Your dating profile is deactivated. Please activate your profile")
        } else {
            viewModel.selectedIndex = 0
            GlobalVariables.shared.selectedProfileMode = "Dating"
            viewModel.checkLocationSettings()
            KAPPDELEGATE.initializeDatingNavigationBar()
            // viewModel.proceedForDatingProfile()
        }
    }
    
    func switchToDating() {
        self.dismiss()
        if self.viewModel.user.isDeactivate == 1 {
            showMessage(with: "Your dating profile is deactivated. Please activate your profile")
        } else {
            viewModel.selectedIndex = 0
            GlobalVariables.shared.selectedProfileMode = "Dating"
            viewModel.checkLocationSettings()
            KAPPDELEGATE.initializeDatingNavigationBar()
            // viewModel.proceedForDatingProfile()
        }
    }
    
    @IBAction func matchingButton(_ sender: UIButton) {
        self.dismiss()
        viewModel.selectedIndex = 1
        GlobalVariables.shared.selectedProfileMode = "MatchMaking"
        GlobalVariables.shared.homeCollectionTopConstant = 15.0
        viewModel.checkLocationSettings()
        KAPPDELEGATE.initializeMatchMakingNavigationBar()
        //viewModel.proceedForCreateMatchMakingProfile()
    }
    
    func switchToMatchMaking() {
        self.dismiss()
        viewModel.selectedIndex = 1
        GlobalVariables.shared.selectedProfileMode = "MatchMaking"
        GlobalVariables.shared.homeCollectionTopConstant = 15.0
        viewModel.checkLocationSettings()
        KAPPDELEGATE.initializeMatchMakingNavigationBar()
    }
}
