//
//  StepOneViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 21/09/22.
//

import UIKit

class StepOneViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.lookingForLoveProfile
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.stepOne
    }

    lazy var viewModel: StepOneViewModel = StepOneViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    city:String,
                    country:String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! StepOneViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.city = city
        controller.viewModel.country = country
        controller.hidesBottomBarWhenPushed = true
        controller.show(from: viewController, forcePresent: forcePresent)
    }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var liveInTextField: UnderlinedTextField!
    @IBOutlet weak var iamTextField: UnderlinedTextField!
    @IBOutlet weak var bornTextField: UnderlinedTextField!
    @IBOutlet weak var relationshipTextField: UnderlinedTextField!
    @IBOutlet weak var wishingToHaveTextField: UnderlinedTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        KAPPDELEGATE.initializeDatingNavigationBar()
        
        addNavigationBackButton()
       
        showNavigationWhiteLogoinCenter()
        viewModel.nextButton = nextButton
        viewModel.liveInTextField = liveInTextField
        viewModel.iamTextField = iamTextField
        viewModel.bornTextField = bornTextField
        viewModel.relationshipTextField = relationshipTextField
        viewModel.wishingToHaveTextField = wishingToHaveTextField
        
    
//        liveInTextField.text = "\(viewModel.city), " + "\(viewModel.country)"
       
        liveInTextField.addTarget(self, action: #selector(liveInButtonTapped(_:)), for: .touchDown)
        iamTextField.addTarget(self, action: #selector(iamButtonTapped(_:)), for: .touchDown)
        bornTextField.addTarget(self, action: #selector(bornButtonTapped(_:)), for: .touchDown)
        liveInTextField.rightView?.tag = 100
        iamTextField.rightView?.tag = 101
        bornTextField.rightView?.tag = 102
    
        rightPaddingClick = { tag in
            if tag == 100 {
                self.viewModel.openGooglePlacesController()
            } else if tag == 101 {
                self.viewModel.proceedForSelectGender()
            } else if tag == 102 {
                self.viewModel.proceedForSelectDate()
            }
        }
        
        viewModel.enableDisableNextButton()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.processForGetGenderData()
        viewModel.checkLocationSettings { success in
            if success == true {
                self.initLocation()
            }
        }
        
        for family in UIFont.familyNames {
          let sName: String = family as String
          print("family: \(sName)")

            for name in UIFont.fontNames(forFamilyName: sName) {
            print("name: \(name as String)")
          }
        }
    }
    
    func addNavigationBackButton() {
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn2.setImage(UIImage(named: "ic_back_white"), for: .normal)
        btn2.addTarget(self, action: #selector(backkButtonTapped(_:)), for:.touchUpInside)
        let barButton = UIBarButtonItem(customView: btn2)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func backkButtonTapped(_ sender: UIButton) {
        if GlobalVariables.shared.isCreateForDatingProfile == "yes" {
            GlobalVariables.shared.isCreateForDatingProfile = ""
            GlobalVariables.shared.selectedProfileMode = "MatchMaking"
            KAPPDELEGATE.initializeMatchMakingNavigationBar()
            viewModel.proceedForCreateMatchMakingProfile()
        } else {
            if GlobalVariables.shared.isComesFromBasicInfo == true {
                self.viewModel.proceedToPreviousScreen()
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func initLocation() {
        self.nameLabel.text = "Welcome " + "\(viewModel.storedUser?.firstName ?? "") " + "\(viewModel.storedUser?.lastName ?? "")"
        
        viewModel.lat = GlobalVariables.shared.locationDetailsDictionary[WebConstants.latitude] as? String ?? "0"
        viewModel.lng = GlobalVariables.shared.locationDetailsDictionary[WebConstants.longitude] as? String ?? "0"
        viewModel.city = GlobalVariables.shared.locationDetailsDictionary[WebConstants.city] as? String ?? ""
        viewModel.state = GlobalVariables.shared.locationDetailsDictionary[WebConstants.state] as? String ?? ""
        viewModel.country = GlobalVariables.shared.locationDetailsDictionary[WebConstants.country] as? String ?? ""
        
        if GlobalVariables.shared.locationDetailsDictionary[WebConstants.city] as? String != "" && GlobalVariables.shared.locationDetailsDictionary[WebConstants.country] as? String != "" {
            liveInTextField.text =  "\(GlobalVariables.shared.locationDetailsDictionary[WebConstants.city] as? String ?? ""), " + "\(GlobalVariables.shared.locationDetailsDictionary[WebConstants.country] as? String ?? "")"
        } else {
            liveInTextField.text = ""
        }
        
        
        if liveInTextField.text == ", " {
            liveInTextField.text = ""
        }
        
        viewModel.enableDisableNextButton()
    }
    @IBAction func liveInButtonTapped(_ sender: UIButton){
        viewModel.openGooglePlacesController()
    }
    @IBAction func iamButtonTapped(_ sender: UIButton){
        viewModel.proceedForSelectGender()
    }
    @IBAction func bornButtonTapped(_ sender: UIButton){
        viewModel.proceedForSelectDate()
    }
    @IBAction func relationshipButtonTapped(_ sender: Any) {
        viewModel.proceedForSelectRelationship()
    }
    @IBAction func wishingToHaveButtonTapped(_ sender: Any) {
        viewModel.proceedForSelectWishing()
    }
    @IBAction func nextButtonAction(_ sender: UIButton) {
        viewModel.proceedForCreateProfileStepTwo()
    }
    

}
