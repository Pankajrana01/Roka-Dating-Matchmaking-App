//
//  StepTwoViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 21/09/22.
//

import Foundation
import UIKit
import GooglePlaces

class StepTwoViewModel: BaseViewModel {
    var completionHandler: ((Bool) -> Void)?
    var nextButton: UIButton!
    var rangeSlider1: RangeSeekSlider!
    var rangeSlider1Label: UILabel!
    var rangeSlider2: RangeSeekSlider!
    var rangeSlider2Label: UILabel!
    var iamLookingTextField: UILabel!
    var preferredLocationTextFiled: UnderlinedTextField!
    var genderArray = [GenderRow]()
    var slider1Min = ""
    var slider1Max = ""
    var slider2Max = ""
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    var preferredDetailsDictionary = [String:Any]()
    var basicDetailsDictionary = [String:Any]()
    var preferredGenderIds = [String]()
    var isLocationSetDefault = 1
    var preferedlat = ""
    var preferedlng = ""
    var preferedcity = ""
    var preferedcountry = ""
    var preferedstate = ""
    weak var toggleButton: UIButton!
    
    func rangeSlider1Initialize() {
        rangeSlider1.delegate = self
        rangeSlider1.minValue = 18
        rangeSlider1.maxValue = 99
        rangeSlider1.selectedMinValue = 18
        rangeSlider1.selectedMaxValue = 99
        self.slider1Min = "18"
        self.slider1Max = "99"
        self.updateSlider1LabelInputs()
        
//        let rangeValues = Array(18...99)
//        rangeSlider1.setRangeValues(rangeValues)
//
//        preferredDetailsDictionary[WebConstants.preferredMinAge] = 18
//        preferredDetailsDictionary[WebConstants.preferredMaxAge] = 99
//
//        //rangeSlider1.setMinAndMaxRange(16, maxRange: 45)
//        rangeSlider1.setValueChangedCallback { (minValue, maxValue) in
//            print("rangeSlider1 min value:\(minValue)")
//            print("rangeSlider1 max value:\(maxValue)")
//        }
//        rangeSlider1.setMinValueDisplayTextGetter { (minValue) -> String? in
//            self.slider1Min = "\(minValue)"
//            self.updateSlider1LabelInputs()
//            return ""
//        }
//        rangeSlider1.setMaxValueDisplayTextGetter { (maxValue) -> String? in
//            self.slider1Max = "\(maxValue)"
//            self.updateSlider1LabelInputs()
//            return ""
//        }
    }
    
    func updateSlider1LabelInputs() {
        self.rangeSlider1Label.text = slider1Min + " - " + slider1Max
        preferredDetailsDictionary[WebConstants.preferredMinAge] = Int(slider1Min)
        preferredDetailsDictionary[WebConstants.preferredMaxAge] = Int(slider1Max)

    }
    
    func rangeSlider2Initialize() {
        rangeSlider2.delegate = self
        rangeSlider2.minValue = 0
        rangeSlider2.maxValue = 600
        
        rangeSlider2.selectedMaxValue = 300
        self.slider2Max = "300"
        self.updateSlider2LabelInputs()
        
        //rangeSlider2.setMinAndMaxValue(0, maxValue: 600)
//        let rangeValues = Array(0...600)
//        preferredDetailsDictionary[WebConstants.preferredDistance] = 100
//
//        rangeSlider2.setRangeValues(rangeValues)
//
//        rangeSlider2.setValueChangedCallback { (minValue, maxValue) in
//            print("rangeSlider2 min value:\(minValue)")
//            print("rangeSlider2 max value:\(maxValue)")
//        }
//        rangeSlider2.setMinValueDisplayTextGetter { (minValue) -> String? in
//            return ""
//        }
//        rangeSlider2.setMaxValueDisplayTextGetter { (maxValue) -> String? in
//            self.slider2Max = "\(maxValue)"
//            self.updateSlider2LabelInputs()
//            return ""
//        }
    }
    func updateSlider2LabelInputs() {
        if storedUser?.countryCode == "+91" {
            self.rangeSlider2Label.text = "with in " + slider2Max + " Km's"
        }else {
            self.rangeSlider2Label.text = "with in " + slider2Max + " miles"
        }
        preferredDetailsDictionary[WebConstants.preferredDistance] = Int(slider2Max)
    }
    
    func proceedForSelectPreferredGender() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { value in }
       
        controller.show(over: self.hostViewController, isComeFor: "PreferenceGender", isFriend: false, genderArray: self.genderArray, selectedGenderId: self.preferredGenderIds.joined(separator: ",")) { id, value, value2 in
            
        } preferredCompletionHandler: { text, ids, priority  in
            self.iamLookingTextField.text = text
            self.iamLookingTextField.textColor = .appBorder
            self.preferredGenderIds.removeAll()
            self.preferredGenderIds = ids
            var params = [String:Any]()
            params[WebConstants.id] = self.user.id
            params[WebConstants.gender] = ids
            params[WebConstants.genderPriority] = priority
            self.processForUpdateProfilePreferenceApiData(params: params)
        }

    }
    func processForUpdateProfilePreferenceApiData(params: [String: Any]) {
       // showLoader()
        ApiManager.makeApiCall(APIUrl.UserApis.updateProfilePrefrences,
                               params: params,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .put) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [String: Any]
                                    //showSuccessMessage(with: StringConstants.updatedPrefProfile)
                                    self.user.updateWith(responseData)
                                    KUSERMODEL.setUserLoggedIn(true)
                                }
            
                                hideLoader()
        }
    }
    func openGooglePlacesController() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
    
        // Display the autocomplete view controller.
        self.hostViewController.present(autocompleteController, animated: true, completion: nil)
        
    }
    
    func proceedForCreateProfileStepThree() {
        if self.preferredGenderIds.count == 0 {
            showMessage(with: ValidationError.selectPreferedGender)
        } else if self.preferredLocationTextFiled.text == "" {
            showMessage(with: ValidationError.selectPreferedLocation)
        } else {
            
            preferredDetailsDictionary[WebConstants.preferredGenders] = self.preferredGenderIds
            
            self.preferredDetailsDictionary[WebConstants.preferredState] = preferedstate
            self.preferredDetailsDictionary[WebConstants.preferredCity] = preferedcity
            self.preferredDetailsDictionary[WebConstants.preferredCountry] = preferedcountry
            self.preferredDetailsDictionary[WebConstants.preferredLatitude] = preferedlat
            self.preferredDetailsDictionary[WebConstants.preferredLongitude] = self.preferedlng
            self.preferredDetailsDictionary[WebConstants.isLocationSetDefault] = isLocationSetDefault
            user.updateWith(basicDetailsDictionary)
            user.updateWith(preferredDetailsDictionary)
            KUSERMODEL.setUserLoggedIn(true)
            KUSERMODEL.storedUser = user

            StepThreeViewController.show(from: self.hostViewController, forcePresent: false, selectedImages: [], isComeFor: "StepTwo", basicDetailsDictionary : basicDetailsDictionary, preferredDetailsDictionary:preferredDetailsDictionary) { success in
            }
        }
    }
}

// MARK: - RangeSeekSliderDelegate

extension StepTwoViewModel: RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider === rangeSlider1 {
            print("Custom slider updated. Min Value: \(Int(minValue)) Max Value: \(Int(maxValue))")
            self.slider1Min = "\(Int(minValue))"
            self.slider1Max = "\(Int(maxValue))"
            self.updateSlider1LabelInputs()
        } else if slider === rangeSlider2 {
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

extension StepTwoViewModel: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name ?? "")")
        print("Place ID: \(place.placeID ?? "")")
        // Show HouseAndFlat
        if place.name?.description != nil {
            print(place.name?.description ?? "")
        }
        
        // Show latitude
        if place.coordinate.latitude.description.count != 0 {
            print(place.coordinate.latitude)
            self.preferedlat = "\(place.coordinate.latitude)"
        }
        // Show longitude
        if place.coordinate.longitude.description.count != 0 {
            print(place.coordinate.longitude)
            self.preferedlng = "\(place.coordinate.longitude)"
        }
        var country = ""
        var state = ""
        // Show AddressComponents
        if place.addressComponents != nil {
            for addressComponent in (place.addressComponents)! {
                for type in (addressComponent.types){
                    switch(type){
                    case "sublocality_level_2":
                        print(addressComponent.name)
                    case "sublocality_level_1":
                        print(addressComponent.name)
                    case "administrative_area_level_2":
                        print(addressComponent.name)
                        
                    case "administrative_area_level_1":
                        print(addressComponent.name)
                        state = addressComponent.name
                    case "country":
                        print(addressComponent.name)
                        country = addressComponent.name
                    default:
                        break
                    }
                }
            }
        }
        
        self.preferredLocationTextFiled.text = "\(place.name?.description ?? ""), " + "\(country)"
    
        self.preferedcity = "\(place.name?.description ?? "")"
        self.preferedstate = "\(state)"
        self.preferedcountry = "\(country)"
      
        
        if self.preferredLocationTextFiled.text != "\(self.storedUser?.city ?? ""), " + "\(self.storedUser?.country ?? "")" {
            toggleButton.setImage(UIImage(named: "Ic_toggle_off"), for: .normal)
            self.isLocationSetDefault = 0

        } else {
            toggleButton.setImage(UIImage(named: "Ic_toggle_on"), for: .normal)
            self.isLocationSetDefault = 1
        }
        
        self.hostViewController.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.hostViewController.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    }
    
}
