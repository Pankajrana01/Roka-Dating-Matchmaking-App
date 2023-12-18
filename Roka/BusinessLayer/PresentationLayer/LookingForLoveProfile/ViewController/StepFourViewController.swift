//
//  FouthStepViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 22/09/22.
//

import UIKit

class StepFourViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.lookingForLoveProfile
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.stepFour
    }

    lazy var viewModel: StepFourViewModel = StepFourViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func getController(with isCome: String) -> BaseViewController {
        let controller = self.getController() as! StepFourViewController
        controller.viewModel.isComeFor = isCome
        controller.hidesBottomBarWhenPushed = true
        return controller
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! StepFourViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.hidesBottomBarWhenPushed = true
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    @IBOutlet weak var topLabelConstraints: NSLayoutConstraint!
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var topView:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        showNavigationWhiteLogoinCenter()

        if GlobalVariables.shared.selectedProfileMode != "MatchMaking"{
            self.topView.backgroundColor = UIColor.appTitleBlueColor
        } else {
            self.topView.backgroundColor = UIColor(hex: "#AD9BFB")
        }
        
        if viewModel.isComeFor == "Profile" {
            topLabelConstraints.constant = 0
            topStackView.isHidden = true
            self.addNavigationBackButton()
            //showNavigationBackButton(title: "")
        } else if viewModel.isComeFor == "KYC_DECLINE_PUSH" {
            topLabelConstraints.constant = 0
            topStackView.isHidden = true
            self.addNavigationHomeBackButton()
        } else {
            addNavigationSkipButton()
           // self.addNavigationBackButton()
            self.navigationItem.setHidesBackButton(true, animated: true)

        }
        // Do any additional setup after loading the view.
        viewModel.nextButton = nextButton
    }
    
    func addNavigationHomeBackButton() {
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn2.setImage(UIImage(named: "ic_back_white"), for: .normal)
        btn2.addTarget(self, action: #selector(backkHomeButtonTapped(_:)), for:.touchUpInside)
        let barButton = UIBarButtonItem(customView: btn2)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func backkHomeButtonTapped(_ sender: UIButton){
        viewModel.proceedForHome()
    }
    
    func addNavigationBackButton() {
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn2.setImage(UIImage(named: "ic_back_white"), for: .normal)
        btn2.addTarget(self, action: #selector(backkButtonTapped(_:)), for:.touchUpInside)
        let barButton = UIBarButtonItem(customView: btn2)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func backkButtonTapped(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func addNavigationSkipButton() {
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30) //NSAttributedString.Key.underlineStyle: 1
        let attributes: [NSAttributedString.Key : Any] = [ NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "SharpSansTRIAL-Semibold", size: 18.0)! ]
        let attributedString = NSMutableAttributedString(string: "Skip", attributes: attributes)
        btn2.setAttributedTitle(NSAttributedString(attributedString: attributedString), for: .normal)
        btn2.addTarget(self, action: #selector(skipButtonTapped(_:)), for:.touchUpInside)
        let barButton = UIBarButtonItem(customView: btn2)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func skipButtonTapped(_ sender: UIButton){
        viewModel.proceedForCreateProfileStepFive()
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        //viewModel.proceedForCreateProfileStepFour()
        viewModel.allowCameraPermission()
        viewModel.allowMicrophonePermission()
    }
}
