//
//  AgeRangeViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 11/10/22.
//

import Foundation
import UIKit

class AgeRangeViewModel: BaseViewModel {
    var completionHandler: ((Int, Int, Int) -> Void)?
    var isCome = ""
    var isFriend = false
    var rangeSlider1: RangeSeekSlider!
    var rangeSlider2: RangeSeekSlider!
    weak var rangeSlider1Label: UILabel!
    var slider1Min = ""
    var slider1Max = ""
    var ageRangePriority = 100
    var selectedMinValue = 18
    var selectedMaxValue = 99
    var selectedAgeRangePriority = 100
    
    
    func rangeSlider1Initialize() {
        rangeSlider1.delegate = self
        rangeSlider1.minValue = 18
        rangeSlider1.maxValue = 99
        rangeSlider1.selectedMinValue = CGFloat(selectedMinValue)
        rangeSlider1.selectedMaxValue = CGFloat(selectedMaxValue)
        self.slider1Min = "\(selectedMinValue)"
        self.slider1Max = "\(selectedMaxValue)"
        self.updateSlider1LabelInputs()
    
    }
    
    func updateSlider1LabelInputs() {
        self.rangeSlider1Label.text = slider1Min + " - " + slider1Max
    }
    
    func rangeSlider2Initialize() {
        rangeSlider2.delegate = self
        rangeSlider2.minValue = 0
        rangeSlider2.maxValue = 100.0
        rangeSlider2.selectedMaxValue = CGFloat(selectedAgeRangePriority)
        self.ageRangePriority = selectedAgeRangePriority

    }
    
    // MARK: - API Call...
    func processForGetUserPreferenceProfileData() {
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
                        if let userPreferences = userResponseData["userPreferences"] as? [[String:Any]] {
                            DispatchQueue.main.async {

                            let userPreference = userPreferences[0]
                           
                            if let ageRangePriority = userPreference["ageRangePriority"] as? Int{
                                self.selectedAgeRangePriority = ageRangePriority
                            }
                            
                            if let maxAge = userPreference["maxAge"] as? Int{
                                self.selectedMaxValue = maxAge
                            }
                            
                            if let minAge = userPreference["minAge"] as? Int{
                                self.selectedMinValue = minAge
                            }
                            
//                            if GlobalVariables.shared.isAgeRangeApiCalled == false {
//                                self.selectedAgeRangePriority = 100
//                            }
                                self.rangeSlider1Initialize()
                                self.rangeSlider2Initialize()
                                self.rangeSlider1.layoutSubviews()
                                self.rangeSlider2.layoutSubviews()
                            }
                        }
                        
                        hideLoader()
                    }
            } else{
                hideLoader()
            }
        }
    }
  
    
    func saveButtonAction() {
        completionHandler?(Int(self.slider1Max) ?? 99, Int(self.slider1Min) ?? 18, ageRangePriority)
    }
}

// MARK: - RangeSeekSliderDelegate
extension AgeRangeViewModel: RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider === rangeSlider1 {
            print("Custom slider updated. Min Value: \(Int(minValue)) Max Value: \(Int(maxValue))")
            self.slider1Min = "\(Int(minValue))"
            self.slider1Max = "\(Int(maxValue))"
            self.updateSlider1LabelInputs()
        } else if slider === rangeSlider2 {
            print("Custom slider updated. Min Value: \(Int(minValue)) Max Value: \(Int(maxValue))")
            self.ageRangePriority = Int(maxValue)
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
