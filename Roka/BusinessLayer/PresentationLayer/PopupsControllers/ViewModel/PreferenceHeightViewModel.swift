//
//  PreferenceHeightViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 11/10/22.
//

import Foundation
import UIKit

class PreferenceHeightViewModel: BaseViewModel {
    var completionHandler: ((String, String, String, Int) -> Void)?
    var isCome = ""
    var centimetreArr = [String]()
    var feetArr = [String]()
    var isSelected = "feet"
    var isFriend = false
    weak var rangeSlider1: RangeSeekSlider!
    weak var rangeSlider2: RangeSeekSlider!
    weak var rangeSlider1Label: UILabel!
    var slider1Min = ""
    var slider1Max = ""
    var slider1MinFeet = ""
    var slider1MaxFeet = ""
    var priority = 100
    var selectedheightPriority = 100
    
    var selectedMinValue = 122
    var selectedMaxValue = 183
    var isFeetSelected = true
    var tempHeightType = "Feet"
    var selectedMinFeet = ""
    var selectedMaxFeet = ""
    var selectedMinCm = ""
    var selectedMaxCm = ""
    var tempMinHeight: CGFloat = 4
    var tempMaxHeight: CGFloat = 6
    
    weak var feetLable: UILabel!
    weak var feetTickImage: UIImageView!
    weak var centimetreLable: UILabel!
    weak var centimetreTickImage: UIImageView!
    weak var centimetreView: UIView!
    weak var feetView: UIView!
    weak var feetViewWidth: NSLayoutConstraint!
    weak var centimetreViewWidth: NSLayoutConstraint!
    
    override func viewLoaded() {
        super.viewLoaded()
        
    }
    
    func configure(selectedMinValue: CGFloat = 122, selectedMaxValue: CGFloat = 183, heightType: String) {
        self.isFeetSelected = heightType == "Feet"
        
        if heightType == "Feet" {
            let minValue = convertFeetInchesToCM(value: selectedMinValue)
            let maxValue = convertFeetInchesToCM(value: selectedMaxValue)
            self.rangeSlider1.selectedMinValue = CGFloat(minValue)
            self.rangeSlider1.selectedMaxValue = CGFloat(maxValue)
            self.selectedMinValue = Int(minValue)
            self.selectedMaxValue = Int(maxValue)
        } else {
            self.rangeSlider1.selectedMinValue = CGFloat(selectedMinValue)
            self.rangeSlider1.selectedMaxValue = CGFloat(selectedMaxValue)
            self.selectedMinValue = Int(selectedMinValue)
            self.selectedMaxValue = Int(selectedMaxValue)
        }
        
        changeBtnLayoutOnSelection()
        self.updateSliderLabelInputs()
    }
    
    func changeBtnLayoutOnSelection() {
        if isFeetSelected {
            feetView.layer.borderColor = UIColor.appBrownColor.cgColor
            feetLable.textColor = UIColor.appBrownColor
            feetTickImage.isHidden = false
            feetViewWidth.constant = 85
            
            centimetreView.layer.borderColor = UIColor.appBrownColor.withAlphaComponent(0.5).cgColor
            centimetreLable.textColor = UIColor.appBrownColor.withAlphaComponent(0.5)
            centimetreTickImage.isHidden = true
            centimetreViewWidth.constant = 120
            rangeSlider1Initialize()
            
        } else {
            centimetreView.layer.borderColor = UIColor.appBrownColor.cgColor
            centimetreLable.textColor = UIColor.appBrownColor
            centimetreTickImage.isHidden = false
            centimetreViewWidth.constant = 130
            
            feetView.layer.borderColor = UIColor.appBrownColor.withAlphaComponent(0.5).cgColor
            feetLable.textColor = UIColor.appBrownColor.withAlphaComponent(0.5)
            feetTickImage.isHidden = true
            feetViewWidth.constant = 70
            rangeSlider1Initialize()
        }
    }
    
    func updateSliderLabelInputs() {
        if isFeetSelected {
            let minFeet = convertCmToFeet(value: selectedMinValue)
            let maxFeet = convertCmToFeet(value: selectedMaxValue)
            rangeSlider1Label.text = "\(minFeet)ft - \(maxFeet)ft"
            
            let val = minFeet.components(separatedBy: "′")
            let val1 = val[1].components(separatedBy: "“")
            let val2 = val1[0].components(separatedBy: " ")
            let finalMin = val[0] + "." + val2[1]
            
            let val4 = maxFeet.components(separatedBy: "′")
            let val5 = val4[1].components(separatedBy: "“")
            let val6 = val5[0].components(separatedBy: " ")
            let finalMax = val4[0] + "." + val6[1]
            
            print("\(finalMin)", "\(finalMax)", "Feet")
            selectedMinFeet = "\(finalMin)"
            selectedMaxFeet = "\(finalMax)"
        } else {
            rangeSlider1Label.text = "\(selectedMinValue)cm -\(selectedMaxValue)cm"
            print("\(selectedMinValue)", "\(selectedMaxValue)", "Centimetre")
            selectedMinCm = "\(selectedMinValue)"
            selectedMaxCm = "\(selectedMaxValue)"
        }
    }

    func convertCmToFeet(value: Int) -> String {
        let feet = Double(value) * 0.0328084
        let feetShow = Int(floor(feet))
        let feetRest: Double = ((feet * 100).truncatingRemainder(dividingBy: 100) / 100)
        let inches = Int(floor(feetRest * 12))
        return "\(Int(feetShow))′ \(Int(inches))“"
    }
    
    func convertFeetInchesToCM(value: CGFloat) -> CGFloat {
        let int_value = Int(value) // Feet
        let dec_value = (value - CGFloat(int_value)) * 10 // Inches
        let inches = (12 * CGFloat(int_value)) + dec_value
        return round(inches * 2.54)
    }

    func rangeSlider1Initialize() {
        rangeSlider1.delegate = self
        self.rangeSlider1.minValue = 31
        self.rangeSlider1.maxValue = 244
    }
    
    func rangeSlider2Initialize() {
        rangeSlider2.delegate = self
        rangeSlider2.minValue = 0
        rangeSlider2.maxValue = 100
        rangeSlider2.selectedMaxValue = CGFloat(selectedheightPriority)
        self.priority = selectedheightPriority

    }

    func saveButtonAction() {
        if isFeetSelected {
            completionHandler?("Feet", selectedMinFeet, selectedMaxFeet, self.priority)
        } else {
            completionHandler?("Centimetre", self.selectedMinCm, self.selectedMaxCm, self.priority)
        }
    }
    
    
    // MARK: - API Call...
    func processForGetUserPreferenceProfileData(_ result:@escaping([String: Any]?) -> Void) {
        DispatchQueue.main.async {
            showLoader()
        }
        var url = ""
        var params = [String:Any]()
        
        if isFriend {
            url = APIUrl.UserMatchMaking.getUserMatchMakingPreferenceDetail
            params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
            
        } else {
            url = APIUrl.UserApis.getUserPreferenceDetail
            params = [:]
        }
        
        ApiManager.makeApiCall(url, params: params,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .get) { response, _ in
            if !self.hasErrorIn(response) {
                
                if let userResponseData = response![APIConstants.data] as? [String: Any] {
                    
                    if let minimumHeight = userResponseData["userPreferences"] as? [Any],
                       let dict = minimumHeight[0] as? [String: Any],
                       let minHeight = dict["minHeight"] {
                        if minHeight is String {
                            if let numberMinHeight = NumberFormatter().number(from: minHeight as! String) {
                                let convertedMinHeight = CGFloat(truncating: numberMinHeight)
                                self.tempMinHeight = convertedMinHeight
                            }
                        } else {
                            self.tempMinHeight = dict["minHeight"] as? CGFloat ?? 0.0
                        }
                    }
                    if let maximumHeight = userResponseData["userPreferences"] as? [Any],
                       let dict = maximumHeight[0] as? [String: Any],
                       let maxHeight = dict["maxHeight"] {
                        if maxHeight is String {
                            if let numberMaxHeight = NumberFormatter().number(from: maxHeight as! String) {
                                let convertedMaxHeight = CGFloat(truncating: numberMaxHeight)
                                self.tempMaxHeight = convertedMaxHeight
                            }
                        } else {
                            self.tempMaxHeight = dict["maxHeight"] as? CGFloat ?? 0.0
                        }
                    }
                    if let heightType = userResponseData["userPreferences"] as? [Any],
                        let dict = heightType[0] as? [String: Any],
                        let hType = dict["heightType"] as? String,
                        let heightPriority = dict["heightPriority"] as? Int {
                        self.tempHeightType = hType
                        self.selectedheightPriority = heightPriority
                    }
                   
                    self.rangeSlider1Initialize()
                    self.rangeSlider2Initialize()
                    self.rangeSlider1.layoutSubviews()
                    self.rangeSlider2.layoutSubviews()
                    
                    if self.tempMinHeight != 0.0 && self.tempMaxHeight != 0.0 {
                        if self.tempMinHeight == 0.1 && self.tempMaxHeight == 0.1 {
                            self.tempMinHeight = 4.0
                            self.tempMaxHeight = 6.0
                            self.configure(selectedMinValue: self.tempMinHeight, selectedMaxValue: self.tempMaxHeight, heightType: self.tempHeightType)
                        } else {
                            self.configure(selectedMinValue: self.tempMinHeight, selectedMaxValue: self.tempMaxHeight, heightType: self.tempHeightType)
                        }
                        self.configure(selectedMinValue: self.tempMinHeight, selectedMaxValue: self.tempMaxHeight, heightType: self.tempHeightType)
                    }
                    hideLoader()
                }
            } else {
                hideLoader()
            }
        }
    }
  
}

// MARK: - RangeSeekSliderDelegate
extension PreferenceHeightViewModel: RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider === rangeSlider1 {
            print("Custom slider updated. Min Value: \(Int(minValue)) Max Value: \(Int(maxValue))")
            selectedMinValue = Int(slider.selectedMinValue)
            selectedMaxValue = Int(slider.selectedMaxValue)
            updateSliderLabelInputs()
            
        } else if slider === rangeSlider2 {
            print("Custom slider updated. Min Value: \(Int(minValue)) Max Value: \(Int(maxValue))")
            self.priority = Int(maxValue)
        } else {
            print("Custom slider updated. Min Value: \(Int(minValue)) Max Value: \(Int(maxValue))")
        }
    }

    func didStartTouches(in slider: RangeSeekSlider) {
        print("did start touches")
    }

    func didEndTouches(in slider: RangeSeekSlider) {
        print("did end touches")
    }
}
