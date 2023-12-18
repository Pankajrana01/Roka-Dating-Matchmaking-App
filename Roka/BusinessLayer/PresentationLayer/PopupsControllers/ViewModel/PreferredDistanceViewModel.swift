//
//  PreferredDistanceViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 07/12/23.
//

import Foundation

class PreferredDistanceViewModel: BaseViewModel {
    var completionHandler: ((String) -> Void)?
    var isComeFor = ""
    var rangeSlider2: RangeSeekSlider!
    var rangeSlider2Label: UILabel!
    var slider2Max = "300"
    var preferredDetailsDictionary = [String:Any]()
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    var userResponseData = [String: Any]()

    func rangeSlider2Initialize() {
        rangeSlider2.delegate = self
        rangeSlider2.minValue = 0
        rangeSlider2.maxValue = 600
        
        rangeSlider2.selectedMaxValue = 300
        self.updateSlider2LabelInputs()
        
    }
    func updateSlider2LabelInputs() {
        if storedUser?.countryCode == "+91" {
            self.rangeSlider2Label.text = "with in " + slider2Max + " Km's"
        }else {
            self.rangeSlider2Label.text = "with in " + slider2Max + " miles"
        }
        preferredDetailsDictionary[WebConstants.preferredDistance] = Int(slider2Max)
    }
    
    
    // MARK: - API Call...
    func processForGetUserProfileData(_ result: @escaping(String?) -> Void) {
        var url = ""
        var params = [String:Any]()
       
        url = APIUrl.UserApis.getUserProfileDetail
        params = [:]
        
        ApiManager.makeApiCall(url,
                               params: params,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .get) { response, _ in
            if !self.hasErrorIn(response) {
                let responseData = response![APIConstants.data] as! [String: Any]
                DispatchQueue.main.async {
                    self.userResponseData = response![APIConstants.data] as! [String: Any]
                    
                    if let userPreferences = self.userResponseData["userPreferences"] as? [[String:Any]] {
                        let userPreference = userPreferences[0]
                        if let distance = userPreference["distance"] as? Int {
                            self.rangeSlider2.selectedMaxValue = CGFloat(distance)
                            self.slider2Max = "\(distance)"
                            self.rangeSlider2Initialize()
                        }
                    }
                    result("success")
                }
                hideLoader()
            }
            
        }
    }
}
// MARK: - RangeSeekSliderDelegate

extension PreferredDistanceViewModel: RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider === rangeSlider2 {
            print("Custom slider updated. Min Value: \(Int(minValue)) Max Value: \(Int(maxValue))")
            self.slider2Max = "\(Int(maxValue))"
            self.updateSlider2LabelInputs()
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
