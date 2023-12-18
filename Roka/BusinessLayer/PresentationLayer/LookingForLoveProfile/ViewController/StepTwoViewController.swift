//
//  StepTwoViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 21/09/22.
//

import UIKit


class StepTwoViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.lookingForLoveProfile
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.stepTwo
    }

    lazy var viewModel: StepTwoViewModel = StepTwoViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    genderArray : [GenderRow],
                    basicDetailsDictionary : [String:Any],
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! StepTwoViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.basicDetailsDictionary = basicDetailsDictionary
        controller.viewModel.genderArray = genderArray
        controller.hidesBottomBarWhenPushed = true
        controller.show(from: viewController, forcePresent: forcePresent)
    }

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var rangeSlider1: RangeSeekSlider!
    @IBOutlet weak var rangeSlider1Label: UILabel!
    @IBOutlet weak var rangeSlider2: RangeSeekSlider!
    @IBOutlet weak var rangeSlider2Label: UILabel!
    @IBOutlet weak var iamLookingTextField: UILabel!
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var preferredLocationTextFiled: UnderlinedTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        viewModel.nextButton = nextButton
        viewModel.rangeSlider1 = rangeSlider1
        viewModel.rangeSlider1Label = rangeSlider1Label
        viewModel.rangeSlider2 = rangeSlider2
        viewModel.rangeSlider2Label = rangeSlider2Label
        viewModel.iamLookingTextField = iamLookingTextField
        viewModel.preferredLocationTextFiled = preferredLocationTextFiled
        viewModel.toggleButton = toggleButton
        
        iamLookingTextField.textColor = .appPlaceholder
        iamLookingTextField.text = "Enter"
        
        viewModel.preferedlat = viewModel.storedUser?.latitude ?? "0"
        viewModel.preferedlng = viewModel.storedUser?.longitude ?? "0"
        viewModel.preferedcountry = viewModel.storedUser?.country ?? ""
        viewModel.preferedstate = viewModel.storedUser?.state ?? ""
        viewModel.preferedcity = viewModel.storedUser?.city ?? ""
        
        self.preferredLocationTextFiled.text = "\(viewModel.storedUser?.city ?? ""), " + "\(viewModel.storedUser?.country ?? "")"
        
        viewModel.rangeSlider1Initialize()
        viewModel.rangeSlider2Initialize()
    }
    override func viewWillAppear(_ animated: Bool) {
        showNavigationWhiteLogoinCenter()
        addNavigationBackButton()
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
    
    @IBAction func toggleButton(_ sender: UIButton) {
        if toggleButton.currentImage == UIImage(named: "Ic_toggle_on") {
            toggleButton.setImage(UIImage(named: "Ic_toggle_off"), for: .normal)
            viewModel.isLocationSetDefault = 0

        } else {
            toggleButton.setImage(UIImage(named: "Ic_toggle_on"), for: .normal)
            viewModel.isLocationSetDefault = 1
            viewModel.preferedlat = viewModel.storedUser?.latitude ?? "0"
            viewModel.preferedlng = viewModel.storedUser?.longitude ?? "0"
            viewModel.preferedcountry = viewModel.storedUser?.country ?? ""
            viewModel.preferedstate = viewModel.storedUser?.state ?? ""
            viewModel.preferedcity = viewModel.storedUser?.city ?? ""
            self.preferredLocationTextFiled.text = "\(viewModel.storedUser?.city ?? ""), " + "\(viewModel.storedUser?.country ?? "")"
        }
    }
    @IBAction func iamLookingAction(_ sender: UIButton) {
        viewModel.proceedForSelectPreferredGender()
    }
    @IBAction func preferredLocationButtonTapped(_ sender: UIButton) {
        viewModel.openGooglePlacesController()
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        viewModel.proceedForCreateProfileStepThree()
    }

}
