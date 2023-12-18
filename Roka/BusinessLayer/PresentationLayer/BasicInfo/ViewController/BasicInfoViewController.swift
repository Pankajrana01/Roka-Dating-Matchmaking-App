//
//  BasicInfoViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 21/09/22.
//

import UIKit

class BasicInfoViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.basicInfo
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.basicInfo
    }

    lazy var viewModel: BasicInfoViewModel = BasicInfoViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor : String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! BasicInfoViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.hidesBottomBarWhenPushed = true
        controller.show(from: viewController, forcePresent: forcePresent)
    }

    @IBOutlet weak var navigationLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var appLogo: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lastNameTextField: UnderlinedTextField!
    @IBOutlet weak var firstNameTextField: UnderlinedTextField!
    @IBOutlet weak var emailNameTextField: UnderlinedTextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var topViewConstrains: NSLayoutConstraint!
    @IBOutlet weak var buttonVerify: UIButton!
    
    @IBOutlet weak var locationTextField: UnderlinedTextField!
    @IBOutlet weak var preferredLocationTextFiled: UnderlinedTextField!
    @IBOutlet weak var toggleButton: UIButton!

    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var preferedLocationView: UIView!
    @IBOutlet weak var toggleView: UIView!
    
    @IBOutlet weak var relationshipView: UIView!
    @IBOutlet weak var relationshipNameTxt: UILabel!
    
    
    @IBOutlet weak var preferedDistanceView: UIView!
    @IBOutlet weak var rangeSlider2: RangeSeekSlider!
    @IBOutlet weak var rangeSlider2Label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Customizing our navigation bar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        KAPPDELEGATE.initializeDatingNavigationBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.backButton.isHidden = true
        self.navigationLabel.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        self.relationshipNameTxt.textColor = UIColor.appPlaceholder
        setupUI()
        //viewModel.processForGetRelationshipsData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func setupUI() {
        viewModel.firstNameTextField = firstNameTextField
        viewModel.lastNameTextField = lastNameTextField
        viewModel.emailNameTextField = emailNameTextField
        viewModel.relationshipNameTxt = relationshipNameTxt
        viewModel.firstNameTextField.delegate = viewModel
        viewModel.lastNameTextField.delegate = viewModel
        viewModel.emailNameTextField.delegate = viewModel
        viewModel.nextButton = nextButton
        viewModel.buttonVerify = buttonVerify
        viewModel.locationTextField = locationTextField
        viewModel.preferredLocationTextFiled = preferredLocationTextFiled
        viewModel.toggleButton = toggleButton

        if viewModel.isComeFor == "Profile" {
            self.appLogo.isHidden = true
            self.backButton.isHidden = false
            self.navigationLabel.isHidden = false
            showNavigationBackButton(title: "  Edit Basic Info")
            self.titleLabel.isHidden = true
            self.topViewConstrains.constant = -30
            self.nextButton.setTitle("Done", for: .normal)
            self.firstNameTextField.text = viewModel.user.firstName
            self.lastNameTextField.text = viewModel.user.lastName
            
            if viewModel.user.email == nil || viewModel.user.email == "null" || viewModel.user.email == "<null>"{
                self.emailNameTextField.text = ""
            } else {
                self.emailNameTextField.text = viewModel.user.email
            }
            self.firstNameTextField.isUserInteractionEnabled = false
            self.lastNameTextField.isUserInteractionEnabled = false
            
            self.locationView.isHidden = false
            self.preferedLocationView.isHidden = false
            self.toggleView.isHidden = false
            self.relationshipView.isHidden = true
            self.preferedDistanceView.isHidden = false
            
            viewModel.rangeSlider2 = rangeSlider2
            viewModel.rangeSlider2Label = rangeSlider2Label
            
            viewModel.rangeSlider2Initialize()
            
            self.viewModel.processForGetUserData { result in
                if let userPreferences = result?["userPreferences"] as? [[String:Any]] {
                    
                    self.viewModel.preferedlat = userPreferences[0]["latitude"] as? String ?? "0"
                    self.viewModel.preferedlng = userPreferences[0]["longitude"] as? String ?? "0"
                    self.viewModel.preferedcity = userPreferences[0]["city"] as? String ?? ""
                    self.viewModel.preferedstate = userPreferences[0]["state"] as? String ?? ""
                    self.viewModel.preferedcountry = userPreferences[0]["country"] as? String ?? ""
                    
                    if self.viewModel.preferedcity != "" && self.viewModel.preferedcountry != "" {
                        self.preferredLocationTextFiled.text =  "\(userPreferences[0]["city"] as? String ?? ""), " + "\(userPreferences[0]["country"] as? String ?? "")"
                    }else {
                        self.preferredLocationTextFiled.text = ""
                    }
                }
                self.initLocation()
            }
            
            if self.viewModel.user.emailVerified == 1 {
                self.buttonVerify.isHidden = false
                self.buttonVerify.tintColor = UIColor.appPurpleColor
           //     self.buttonVerify.borderColor = UIColor.systemGreen
           //     self.buttonVerify.borderWidth = 1
            //    self.buttonVerify.clipsToBounds = true
                self.buttonVerify.setTitle("Verified", for: .normal)
            }else{
                self.buttonVerify.isHidden = false
                self.buttonVerify.tintColor = UIColor.appPurpleColor
           //     self.buttonVerify.borderColor = UIColor.appYellowColor
           //     self.buttonVerify.borderWidth = 1
           //     self.buttonVerify.clipsToBounds = true
                self.buttonVerify.setTitle("Verify", for: .normal)
            }
            
        } else {
            self.firstNameTextField.text = viewModel.storedUser?.firstName as? String ?? ""
            self.lastNameTextField.text = viewModel.storedUser?.lastName as? String ?? ""
            self.emailNameTextField.text = viewModel.storedUser?.email as? String ?? ""
            
            if viewModel.storedUser?.firstName as? String == "<null>" {
                self.firstNameTextField.text = ""
            }
            if viewModel.storedUser?.lastName as? String == "<null>" {
                self.lastNameTextField.text = ""
            }
            if viewModel.storedUser?.email as? String == "<null>" {
                self.emailNameTextField.text = ""
            } 
            
            showNavigationLogo()
            viewModel.enableDisableNextButton()
            self.firstNameTextField.isUserInteractionEnabled = true
            self.lastNameTextField.isUserInteractionEnabled = true
            self.buttonVerify.isHidden = true
            self.locationView.isHidden = true
            self.preferedLocationView.isHidden = true
            self.preferedDistanceView.isHidden = true
            self.toggleView.isHidden = true
            self.relationshipView.isHidden = true
        }
    }
    
    func initLocation() {
        viewModel.lat =  viewModel.storedUser?.latitude as? String ?? "0"
        viewModel.lng = viewModel.storedUser?.longitude as? String ?? "0"
        viewModel.city = viewModel.storedUser?.city as? String ?? ""
        viewModel.state = viewModel.storedUser?.state as? String ?? ""
        viewModel.country = viewModel.storedUser?.country as? String ?? ""
        
        
        if viewModel.storedUser?.city as? String != "" && viewModel.storedUser?.country as? String != "" {
            locationTextField.text = "\(viewModel.storedUser?.city as? String ?? ""), " + "\(viewModel.storedUser?.country as? String ?? "")"
        } else {
            locationTextField.text = ""
        }
    }
    
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func relationshipButtonAction(_ sender: UIButton) {
        viewModel.proceedForSelectRelationship()
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        viewModel.checkValidation(firstNameTextField: firstNameTextField, lastNameTextField: lastNameTextField, emailNameTextField: emailNameTextField)
    }
    
    @IBAction func recoveryEmailButtonAction(_ sender: UIButton) {
      //  viewModel.recoveryEmailInfoButton()
    }
    
    @IBAction func verifyButtonAction(_ sender: UIButton) {
        if self.buttonVerify.currentTitle == "Verify" {
            viewModel.processForVerifyEmail(email: self.emailNameTextField.text ?? "")
        }
    }
    
    
    @IBAction func toggleButton(_ sender: UIButton) {
        self.view.endEditing(true)
        if toggleButton.currentImage == UIImage(named: "Ic_toggle_on") {
            toggleButton.setImage(UIImage(named: "Ic_toggle_off"), for: .normal)
            viewModel.isLocationSetDefault = 0

        } else {
            toggleButton.setImage(UIImage(named: "Ic_toggle_on"), for: .normal)
            viewModel.isLocationSetDefault = 1
            self.preferredLocationTextFiled.text = self.locationTextField.text
            self.viewModel.preferedcity = self.viewModel.city
            self.viewModel.preferedstate = self.viewModel.state
            self.viewModel.preferedcountry = self.viewModel.country
            self.viewModel.preferedlat = self.viewModel.lat
            self.viewModel.preferedlng = self.viewModel.lng
        }
    }
    
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        viewModel.openGooglePlacesController(type: "location")
    }
    
    @IBAction func preferredLocationButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        viewModel.openGooglePlacesController(type: "preferedLocation")
    }
}
