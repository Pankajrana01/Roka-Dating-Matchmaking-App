//
//  PreferenceHeightViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 11/10/22.
//

import UIKit

class PreferenceHeightViewController: BaseAlertViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.popups
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.preferenceHeight
    }

    lazy var viewModel: PreferenceHeightViewModel = PreferenceHeightViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(over host: UIViewController,
                    isCome:String,
                    isFriend : Bool,
                    completionHandler: @escaping ((String, String, String, Int) -> Void)) {
        let controller = self.getController() as! PreferenceHeightViewController
        controller.viewModel.isCome = isCome
        controller.show(over: host, isCome: isCome, isFriend: isFriend, completionHandler: completionHandler)
    }
    
    func show(over host: UIViewController,
              isCome:String,
              isFriend : Bool,
              completionHandler: @escaping ((String, String, String, Int) -> Void)) {
        viewModel.completionHandler = completionHandler
        viewModel.isCome = isCome
        viewModel.isFriend = isFriend
        show(over: host)
    }
    @IBOutlet weak var feetLable: UILabel!
    @IBOutlet weak var feetTickImage: UIImageView!
    @IBOutlet weak var centimetreLable: UILabel!
    @IBOutlet weak var centimetreTickImage: UIImageView!
    @IBOutlet weak var centimetreView: UIView!
    @IBOutlet weak var feetView: UIView!
    @IBOutlet weak var rangeSlider1: RangeSeekSlider!
    @IBOutlet weak var rangeSlider1Label: UILabel!
    @IBOutlet weak var rangeSlider2: RangeSeekSlider!
    @IBOutlet weak var centimetreViewWidth: NSLayoutConstraint!
    @IBOutlet weak var feetViewWidth: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.isSelected = "feet"
        viewModel.feetLable = feetLable
        viewModel.feetTickImage = feetTickImage
        viewModel.centimetreLable = centimetreLable
        viewModel.centimetreTickImage = centimetreTickImage
        viewModel.centimetreView = centimetreView
        viewModel.feetViewWidth = feetViewWidth
        viewModel.centimetreViewWidth = centimetreViewWidth
        viewModel.feetView = feetView
        viewModel.rangeSlider1 = rangeSlider1
        viewModel.rangeSlider2 = rangeSlider2
        viewModel.rangeSlider1Label = rangeSlider1Label
        viewModel.rangeSlider1Initialize()
        viewModel.rangeSlider2Initialize()
        
        feetView.layer.borderColor = UIColor.appBrownColor.cgColor
        feetLable.textColor = UIColor.appBrownColor
        feetTickImage.isHidden = false
        
        centimetreView.layer.borderColor = UIColor.appBrownColor.withAlphaComponent(0.5).cgColor
        centimetreLable.textColor = UIColor.appBrownColor.withAlphaComponent(0.5)
        centimetreTickImage.isHidden = true
        
        viewModel.configure(selectedMinValue: viewModel.tempMinHeight, selectedMaxValue: viewModel.tempMaxHeight, heightType: viewModel.tempHeightType)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.processForGetUserPreferenceProfileData{ userResponseData in
            DispatchQueue.main.async {
                if let userPreferences = userResponseData?["userPreferences"] as? [[String:Any]] {
                    let userPreference = userPreferences[0]

                    if let heightType = userPreference["heightType"] as? String {

                        if heightType == "Centimetre" {
                            self.viewModel.isFeetSelected = false
                            self.viewModel.changeBtnLayoutOnSelection()
                            self.viewModel.updateSliderLabelInputs()
                        } else {
                            self.viewModel.isFeetSelected = true
                            self.viewModel.changeBtnLayoutOnSelection()
                            self.viewModel.updateSliderLabelInputs()
                        }

                    }
                }
            }
        }
    }
   
    @IBAction func saveButtonActiob(_ sender: UIButton) {
        viewModel.saveButtonAction()
        self.dismiss()
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss()
    }
    
    @IBAction func feetAction(_ sender: Any) {
        viewModel.isFeetSelected = true
        viewModel.changeBtnLayoutOnSelection()
        viewModel.updateSliderLabelInputs()
    }
    
    @IBAction func centimetreAction(_ sender: Any) {
        viewModel.isFeetSelected = false
        viewModel.changeBtnLayoutOnSelection()
        viewModel.updateSliderLabelInputs()

    }
    
}
