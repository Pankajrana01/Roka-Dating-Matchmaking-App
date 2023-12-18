//
//  MatchMakingBasicInfoController.swift
//  Roka
//
//  Created by Pankaj Rana on 21/11/22.
//

import UIKit

class MatchMakingBasicInfoController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.matchMakingBasicInfo
        
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.matchMakingBasicInfoController
    }

    lazy var viewModel: MatchMakingBasicInfoViewModel = MatchMakingBasicInfoViewModel(hostViewController: self)

    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    receivedProfile : ProfilesModel?,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! MatchMakingBasicInfoController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.viewModel.receivedProfile = receivedProfile
        controller.hidesBottomBarWhenPushed = true
        controller.show(from: viewController, forcePresent: forcePresent)
    }

    @IBOutlet weak var scrollViewTop: NSLayoutConstraint!
    @IBOutlet weak var heartStackViewTop: NSLayoutConstraint!
    @IBOutlet weak var firendsNameTop: NSLayoutConstraint!
    @IBOutlet weak var labelTitleTop: NSLayoutConstraint!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var heartStackView: UIStackView!
    @IBOutlet weak var bornTextField: UnderlinedTextField!
    @IBOutlet weak var friendNameTextField: UnderlinedTextField!
    @IBOutlet weak var genderTextField: UILabel!
    @IBOutlet weak var locationTextField: UnderlinedTextField!
    @IBOutlet weak var sexualPreferenceTextField: UILabel!
    @IBOutlet weak var preferredLocationTextFiled: UnderlinedTextField!

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var rangeSlider1: RangeSeekSlider!
    @IBOutlet weak var rangeSlider1Label: UILabel!
    @IBOutlet weak var toggleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.friendNameTextField = friendNameTextField
        viewModel.genderTextField = genderTextField
        viewModel.locationTextField = locationTextField
        viewModel.bornTextField = bornTextField
        viewModel.sexualPreferenceTextField = sexualPreferenceTextField
        viewModel.preferredLocationTextFiled = preferredLocationTextFiled
        viewModel.nextButton = nextButton
        viewModel.rangeSlider1 = rangeSlider1
        viewModel.rangeSlider1Label = rangeSlider1Label
        viewModel.toggleButton = toggleButton

        genderTextField.textColor = .appPlaceholder
        genderTextField.text = "Enter"
        sexualPreferenceTextField.textColor = .appPlaceholder
        sexualPreferenceTextField.text = "Enter"
        // Do any additional setup after loading the view.
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.beginFromCurrentState, .curveEaseIn], animations: {
            self.heartStackView.isHidden = true
            self.labelTitle.isHidden = true
            self.heartStackViewTop.constant = 0
            self.firendsNameTop.constant = 0
            self.labelTitleTop.constant = 0
            self.scrollViewTop.constant = 0
        })
        
        viewModel.rangeSlider1Initialize()
        viewModel.processForGetGenderData(type: "1") { model in
            self.initLocation()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false

    }
    func initLocation() {
        if viewModel.isComeFor == "EditBasicInfoMatchMaking" {
            self.title = "Edit basic info"
            heartStackView.isHidden = true
            labelTitle.isHidden = true
            heartStackViewTop.constant = 0
            firendsNameTop.constant = 0
            labelTitleTop.constant = 0
            scrollViewTop.constant = 0
            nextButton.setTitle("Save changes", for: .normal)
            friendNameTextField.text = viewModel.receivedProfile?.firstName ?? ""
           // bornTextField.text = viewModel.receivedProfile?.dob ?? ""
            
            locationTextField.text =  "\(viewModel.receivedProfile?.city ?? ""), " + "\(viewModel.receivedProfile?.country ?? "")"
            preferredLocationTextFiled.text =  "\(viewModel.receivedProfile?.userPreferences?[0].city ?? ""), " + "\(viewModel.receivedProfile?.userPreferences?[0].country ?? "")"
            
            viewModel.lat = viewModel.receivedProfile?.latitude as? String ?? "0"
            viewModel.lng = viewModel.receivedProfile?.longitude as? String ?? "0"
            viewModel.city = viewModel.receivedProfile?.city as? String ?? ""
            viewModel.state = viewModel.receivedProfile?.state as? String ?? ""
            viewModel.country = viewModel.receivedProfile?.country as? String ?? ""
           
            viewModel.preferedlat = viewModel.receivedProfile?.userPreferences?[0].latitude as? String ?? "0"
            viewModel.preferedlng = viewModel.receivedProfile?.userPreferences?[0].longitude as? String ?? "0"
            viewModel.preferedcity = viewModel.receivedProfile?.userPreferences?[0].city as? String ?? ""
            viewModel.preferedstate = viewModel.receivedProfile?.userPreferences?[0].state as? String ?? ""
            viewModel.preferedcountry = viewModel.receivedProfile?.userPreferences?[0].country as? String ?? ""

            if viewModel.receivedProfile?.userPreferences?[0].isLocationSetDefault as? Int == 0 {
                toggleButton.setImage(UIImage(named: "Ic_toggle_off"), for: .normal)
                viewModel.isLocationSetDefault = 0
            } else {
                toggleButton.setImage(UIImage(named: "Ic_toggle_on"), for: .normal)
                viewModel.isLocationSetDefault = 1
            }
            
            genderTextField.text = viewModel.receivedProfile?.gender ?? ""
            viewModel.selectedGenderId = viewModel.receivedProfile?.genderId ?? ""
            self.genderTextField.textColor = .appTitleBlueColor
            
            if let genders = viewModel.receivedProfile?.userGenderPreferences as? [UserGenderPreference] {
                self.viewModel.preferredGendersNames.removeAll()
                self.viewModel.preferredGenderIds.removeAll()
                for gender in genders {
                    let gen = gender.gender
                    for i in 0..<self.viewModel.genderArray.count {
                        if gen?.id == self.viewModel.genderArray[i].id {
                            self.viewModel.preferredGenderIds.append(gen?.id ?? "")
                            self.viewModel.preferredGendersNames.append(gen?.name ?? "")
                        }
                    }
                }
                self.sexualPreferenceTextField.text = self.viewModel.preferredGendersNames.joined(separator: ", ")
                self.sexualPreferenceTextField.textColor = .appTitleBlueColor
                
                if let maxAge = viewModel.receivedProfile?.userPreferences?[0].maxAge as? Int {
                    self.viewModel.selectedMaxValue = maxAge
                }
                
                if let minAge = viewModel.receivedProfile?.userPreferences?[0].minAge as? Int{
                    self.viewModel.selectedMinValue = minAge
                }
                self.viewModel.rangeSlider1Initialize()
                self.viewModel.rangeSlider1.layoutSubviews()
            }
        } else {
            showNavigationLogoinCenter()
            heartStackView.isHidden = false
            labelTitle.isHidden = false
            heartStackViewTop.constant = 20
            firendsNameTop.constant = 30
            labelTitleTop.constant = 20
            scrollViewTop.constant = 20
            nextButton.setTitle("Next", for: .normal)
            
            viewModel.lat = GlobalVariables.shared.locationDetailsDictionary[WebConstants.latitude] as? String ?? "0"
            viewModel.lng = GlobalVariables.shared.locationDetailsDictionary[WebConstants.longitude] as? String ?? "0"
            viewModel.city = GlobalVariables.shared.locationDetailsDictionary[WebConstants.city] as? String ?? ""
            viewModel.state = GlobalVariables.shared.locationDetailsDictionary[WebConstants.state] as? String ?? ""
            viewModel.country = GlobalVariables.shared.locationDetailsDictionary[WebConstants.country] as? String ?? ""
            viewModel.preferedlat = GlobalVariables.shared.locationDetailsDictionary[WebConstants.preferredLatitude] as? String ?? "0"
            viewModel.preferedlng = GlobalVariables.shared.locationDetailsDictionary[WebConstants.preferredLongitude] as? String ?? "0"
            viewModel.preferedcity = GlobalVariables.shared.locationDetailsDictionary[WebConstants.preferredCity] as? String ?? ""
            viewModel.preferedstate = GlobalVariables.shared.locationDetailsDictionary[WebConstants.preferredState] as? String ?? ""
            viewModel.preferedcountry = GlobalVariables.shared.locationDetailsDictionary[WebConstants.preferredCountry] as? String ?? ""
            
            if GlobalVariables.shared.locationDetailsDictionary[WebConstants.city] as? String != "" && GlobalVariables.shared.locationDetailsDictionary[WebConstants.country] as? String != "" {
                locationTextField.text =  "\(GlobalVariables.shared.locationDetailsDictionary[WebConstants.city] as? String ?? ""), " + "\(GlobalVariables.shared.locationDetailsDictionary[WebConstants.country] as? String ?? "")"
                
                preferredLocationTextFiled.text =  "\(GlobalVariables.shared.locationDetailsDictionary[WebConstants.city] as? String ?? ""), " + "\(GlobalVariables.shared.locationDetailsDictionary[WebConstants.country] as? String ?? "")"
                
                if locationTextField.text == ", " {
                    locationTextField.text = ""
                }
                if preferredLocationTextFiled.text == ", " {
                    preferredLocationTextFiled.text = ""
                }
                
            } else {
                locationTextField.text = ""
                preferredLocationTextFiled.text = ""
            }
        }
    }
    @IBAction func bornButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        viewModel.proceedForSelectDate()
    }
    @IBAction func toggleButton(_ sender: UIButton) {
        self.view.endEditing(true)
        if toggleButton.currentImage == UIImage(named: "Ic_toggle_on") {
            toggleButton.setImage(UIImage(named: "Ic_toggle_off"), for: .normal)
            viewModel.isLocationSetDefault = 0

        } else {
            toggleButton.setImage(UIImage(named: "Ic_toggle_on"), for: .normal)
            viewModel.isLocationSetDefault = 1
            /*
            self.preferredLocationTextFiled.text = self.locationTextField.text
            self.viewModel.preferedcity = self.viewModel.city
            self.viewModel.preferedstate = self.viewModel.state
            self.viewModel.preferedcountry = self.viewModel.country
            self.viewModel.preferedlat = self.viewModel.lat
            self.viewModel.preferedlng = self.viewModel.lng
            */
            
             self.preferredLocationTextFiled.text = "\(GlobalVariables.shared.locationDetailsDictionary[WebConstants.city] as? String ?? ""), " + "\(GlobalVariables.shared.locationDetailsDictionary[WebConstants.country] as? String ?? "")"
            self.viewModel.preferedlat = GlobalVariables.shared.locationDetailsDictionary[WebConstants.preferredLatitude] as? String ?? "0"
            self.viewModel.preferedlng = GlobalVariables.shared.locationDetailsDictionary[WebConstants.preferredLongitude] as? String ?? "0"
            self.viewModel.preferedcity = GlobalVariables.shared.locationDetailsDictionary[WebConstants.preferredCity] as? String ?? ""
            self.viewModel.preferedstate = GlobalVariables.shared.locationDetailsDictionary[WebConstants.preferredState] as? String ?? ""
            self.viewModel.preferedcountry = GlobalVariables.shared.locationDetailsDictionary[WebConstants.preferredCountry] as? String ?? ""
//             self.viewModel.preferedcity = self.viewModel.preferedcity
//             self.viewModel.preferedstate = self.viewModel.preferedstate
//             self.viewModel.preferedcountry = self.viewModel.preferedcountry
//             self.viewModel.preferedlat = self.viewModel.preferedlat
//             self.viewModel.preferedlng = self.viewModel.preferedlng

             
        }
    }
    
    @IBAction func genderButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        viewModel.proceedForSelectGender()
    }
    
    @IBAction func sexualPreferenceAction(_ sender: UIButton) {
        self.view.endEditing(true)
        viewModel.proceedForSelectPreferredSexual()
    }
    
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        viewModel.openGooglePlacesController(type: "location")
    }
    
    @IBAction func preferredLocationButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        viewModel.openGooglePlacesController(type: "preferedLocation")
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if viewModel.isComeFor == "EditBasicInfoMatchMaking" {
            viewModel.checkValidation(firstNameTextField: friendNameTextField, genderTextField: genderTextField, locationTextField: locationTextField, preferredLocationTextFiled: preferredLocationTextFiled)
        } else {
            viewModel.proceedForPlaceholderImageScreen()
        }
    }
    
}
