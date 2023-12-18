//
//  SkipBrowseViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 12/10/23.
//

import UIKit

class SkipBrowseViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.matchMaking
        
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.skipBrowse
    }

    lazy var viewModel: SkipBrowseViewModel = SkipBrowseViewModel(hostViewController: self)

    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! SkipBrowseViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.hidesBottomBarWhenPushed = true
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    @IBOutlet weak var genderTextField: UILabel!
    @IBOutlet weak var rangeSlider1: RangeSeekSlider!
    @IBOutlet weak var rangeSlider1Label: UILabel!
    
    @IBOutlet weak var preferredLocationTextFiled: UnderlinedTextField!
    @IBOutlet weak var toggleButton: UIButton!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Start browsing profile"
        
        viewModel.genderTextField = genderTextField
        viewModel.rangeSlider1 = rangeSlider1
        viewModel.rangeSlider1Label = rangeSlider1Label
        viewModel.preferredLocationTextFiled = preferredLocationTextFiled
        viewModel.toggleButton = toggleButton


        genderTextField.textColor = .appPlaceholder
        genderTextField.text = "Enter"
        
        
        if GlobalVariables.shared.locationDetailsDictionary[WebConstants.city] as? String != "" && GlobalVariables.shared.locationDetailsDictionary[WebConstants.country] as? String != "" {
            preferredLocationTextFiled.text =  "\(GlobalVariables.shared.locationDetailsDictionary[WebConstants.city] as? String ?? ""), " + "\(GlobalVariables.shared.locationDetailsDictionary[WebConstants.country] as? String ?? "")"
            
            viewModel.preferedlat = GlobalVariables.shared.locationDetailsDictionary[WebConstants.preferredLatitude] as? String ?? "0"
            viewModel.preferedlng = GlobalVariables.shared.locationDetailsDictionary[WebConstants.preferredLongitude] as? String ?? "0"
            viewModel.preferedcity = GlobalVariables.shared.locationDetailsDictionary[WebConstants.preferredCity] as? String ?? ""
            viewModel.preferedstate = GlobalVariables.shared.locationDetailsDictionary[WebConstants.preferredState] as? String ?? ""
            viewModel.preferedcountry = GlobalVariables.shared.locationDetailsDictionary[WebConstants.preferredCountry] as? String ?? ""            
            
            if preferredLocationTextFiled.text == ", " {
                preferredLocationTextFiled.text = ""
            }
        }else {
            preferredLocationTextFiled.text = ""
        }

        
        
        viewModel.rangeSlider1Initialize()
        viewModel.processForGetGenderData(type: "1") { model in
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func genderButtonTapped(_ sender: UIButton) {
        viewModel.proceedForSelectPreferredGender()
    }
    @IBAction func toggleButton(_ sender: UIButton) {
        if toggleButton.currentImage == UIImage(named: "Ic_toggle_on") {
            toggleButton.setImage(UIImage(named: "Ic_toggle_off"), for: .normal)
            viewModel.isLocationSetDefault = 0

        } else {
            toggleButton.setImage(UIImage(named: "Ic_toggle_on"), for: .normal)
            viewModel.isLocationSetDefault = 1
            self.preferredLocationTextFiled.text = "\(GlobalVariables.shared.locationDetailsDictionary[WebConstants.city] as? String ?? ""), " + "\(GlobalVariables.shared.locationDetailsDictionary[WebConstants.country] as? String ?? "")"
            self.viewModel.preferedcity = self.viewModel.preferedcity
            self.viewModel.preferedstate = self.viewModel.preferedstate
            self.viewModel.preferedcountry = self.viewModel.preferedcountry
            self.viewModel.preferedlat = self.viewModel.preferedlat
            self.viewModel.preferedlng = self.viewModel.preferedlng
        }
    }
    
    @IBAction func preferredLocationButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        viewModel.openGooglePlacesController(type: "preferedLocation")
    }
   
    @IBAction func nextButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        viewModel.checkValidation(genderTextField: genderTextField, preferredLocationTextFiled: preferredLocationTextFiled)
    }
}
