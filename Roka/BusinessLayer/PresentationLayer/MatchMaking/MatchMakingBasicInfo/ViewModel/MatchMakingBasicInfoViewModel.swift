//
//  MatchMakingBasicInfoViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 21/11/22.
//

import Foundation
import UIKit
import GooglePlaces

class MatchMakingBasicInfoViewModel: BaseViewModel {
    var isComeFor = ""
    var completionHandler: ((Bool) -> Void)?
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    var nextButton: UIButton!
    var rangeSlider1: RangeSeekSlider!
    var rangeSlider1Label: UILabel!
    var isLocationSetDefault = 1
    var selectedGenderId = ""
    var isLocationSelectedFor = ""
    
    weak var toggleButton: UIButton!
    weak var genderTextField: UILabel!
    weak var friendNameTextField: UnderlinedTextField!
    weak var preferredLocationTextFiled: UnderlinedTextField!
    weak var locationTextField: UnderlinedTextField!
    weak var sexualPreferenceTextField: UILabel!
    weak var bornTextField: UnderlinedTextField!
    
    var receivedProfile : ProfilesModel?
    var selectedProfile : ProfilesModel?
    var genderArray = [GenderRow]()
    var genderArrayIndex = [String]()
    var slider1Min = ""
    var slider1Max = ""
    var basicDetailsDictionary = [String:Any]()
    var preferredGenderIds = [String]()
    var preferredGendersNames = [String]()
    
    var preferedlat = ""
    var preferedlng = ""
    var preferedcity = ""
    var preferedcountry = ""
    var preferedstate = ""
    var lat = ""
    var lng = ""
    var city = ""
    var country = ""
    var state = ""
    var dob = ""
    var selectedDate = ""
    
    var selectedMinValue = 18
    var selectedMaxValue = 99
    
    func proceedForPlaceholderImageScreen() {
        DispatchQueue.main.async {
            let firstName = self.friendNameTextField.text ?? ""
            if firstName.isEmpty {
                self.friendNameTextField.becomeFirstResponder()
                showMessage(with: ValidationError.emptyName)
            }
            else if firstName.count < 3 || firstName.count > 30 {
                self.friendNameTextField.becomeFirstResponder()
                showMessage(with: ValidationError.invalidFullNameCount)
            }
            else if self.genderTextField.text == "Enter" {
                showMessage(with: ValidationError.selectGender)
            }
            //        else if self.dob == "" {
            //            showMessage(with: ValidationError.selectDOB)
            //        }
            else if self.locationTextField.text == "" {
                showMessage(with: ValidationError.selectLocation)
            }
            else if self.preferredLocationTextFiled.text == "" {
                showMessage(with: ValidationError.selectPreferedLocation)
            }
            else if self.sexualPreferenceTextField.text == "Enter" {
                showMessage(with: ValidationError.selectSexual)
            }
            else {
                self.basicDetailsDictionary[WebConstants.firstName] = self.friendNameTextField.text ?? ""
                self.basicDetailsDictionary[WebConstants.gender] = self.genderTextField.text ?? ""
                self.basicDetailsDictionary[WebConstants.genderId] = self.selectedGenderId
                self.basicDetailsDictionary[WebConstants.preferredGenders] = self.preferredGenderIds
                //self.basicDetailsDictionary[WebConstants.dob] = self.dob
                self.basicDetailsDictionary[WebConstants.state] = "\(self.state)"
                self.basicDetailsDictionary[WebConstants.city] = "\(self.city)"
                self.basicDetailsDictionary[WebConstants.country] = "\(self.country)"
                self.basicDetailsDictionary[WebConstants.latitude] = "\(self.lat)"
                self.basicDetailsDictionary[WebConstants.longitude] = "\(self.lng)"
                
                self.basicDetailsDictionary[WebConstants.preferredMinAge] = Int(self.slider1Min)
                self.basicDetailsDictionary[WebConstants.preferredMaxAge] = Int(self.slider1Max)
                
                self.basicDetailsDictionary[WebConstants.preferredState] = self.preferedstate
                self.basicDetailsDictionary[WebConstants.preferredCity] = self.preferedcity
                self.basicDetailsDictionary[WebConstants.preferredCountry] = self.preferedcountry
                self.basicDetailsDictionary[WebConstants.preferredLatitude] = self.preferedlat
                self.basicDetailsDictionary[WebConstants.preferredLongitude] = self.preferedlng
                self.basicDetailsDictionary[WebConstants.isLocationSetDefault] = self.isLocationSetDefault
                print(self.basicDetailsDictionary)
                
                MatchMakingPlaceholderController.show(from: self.hostViewController, forcePresent: false, isComeFor: "MatchMakingProfile", selectedProfile: self.selectedProfile, profileResponseData: [:], basicDetailsDictionary: self.basicDetailsDictionary) { success in
                    
                }
            }
        }
    }
    
    func proceedForSelectDate() {
        let controller = CalendarViewController.getController() as! CalendarViewController
        controller.dismissCompletion = { value  in
        }
        controller.show(over: self.hostViewController, selectedDate:self.selectedDate, isCome: "step1", isFriend: true) { value, value2, value3  in
            self.bornTextField.text = value
            self.dob = value2
            self.selectedDate = value2
        }
    }
    
    func processForGetGenderData(type: String, _ result: @escaping(String?) -> Void) {
        var params = [String:Any]()
        params["type"] = type
        self.genderApiCall(params: params) { model in
            self.genderArray = model?.data ?? []
            result("yes")
        }
    }
    // MARK: - API Call...
    func genderApiCall(params: [String:Any], _ result: @escaping(ResponseModel?) -> Void) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        
        ApiManagerWithCodable<ResponseModel>.makeApiCall(APIUrl.BasicApis.genders,
                                                         params: params,
                                                         headers: headers,
                                                         method: .get) { (response, resultModel) in
            hideLoader()
            if resultModel?.statusCode == 200 {
                result(resultModel)
            } else {
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func proceedForSelectGender() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { value  in }
        if genderArray.count != 0 {
            controller.show(over: self.hostViewController, isComeFor: "Gender", isFriend: false, genderArray: self.genderArray, selectedGenderId: selectedGenderId) { id, value, value2 in
                self.genderTextField.text = value
                self.genderTextField.textColor = .appBorder
                self.selectedGenderId = id
            } preferredCompletionHandler: { text, ids, priority  in
            }
        }
    }
    
    func openGooglePlacesController(type: String){
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.isLocationSelectedFor = type
        // Display the autocomplete view controller.
        self.hostViewController.present(autocompleteController, animated: true, completion: {
            self.hostViewController.navigationController?.isNavigationBarHidden = false
        })
        
    }
    
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
        basicDetailsDictionary[WebConstants.preferredMinAge] = Int(slider1Min)
        basicDetailsDictionary[WebConstants.preferredMaxAge] = Int(slider1Max)
        
    }
    
    func proceedForSelectPreferredSexual() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { value  in }
        
        controller.show(over: self.hostViewController, isComeFor: "sexualPreference", isFriend: false, genderArray: self.genderArray, selectedGenderId: self.preferredGenderIds.joined(separator: ",")) { id, value, value2 in
            
        } preferredCompletionHandler: { text, ids, priority  in
            self.sexualPreferenceTextField.text = text
            self.sexualPreferenceTextField.textColor = .appBorder
            self.preferredGenderIds.removeAll()
            self.preferredGenderIds = ids
            var params = [String:Any]()
            params[WebConstants.id] = self.user.id
            params[WebConstants.gender] = ids
            params[WebConstants.genderPriority] = priority
            // self.processForUpdateProfilePreferenceApiData(params: params)
        }
        
    }
    
    func checkValidation(firstNameTextField: UITextField, genderTextField: UILabel, locationTextField:UITextField,  preferredLocationTextFiled:UITextField) {
        if let params = validateModelWithFriendsBasicInputs(firstNameTextField: firstNameTextField, genderTextField: genderTextField, locationTextField: locationTextField, preferredLocationTextFiled: preferredLocationTextFiled) {
            print(params)
            self.processForUpdateFriendProfileApiData(params: params)
        }
    }
    
    func validateModelWithFriendsBasicInputs(firstNameTextField: UITextField, genderTextField: UILabel, locationTextField:UITextField,  preferredLocationTextFiled:UITextField) -> [String: Any]? {
        let firstName = firstNameTextField.text?.trimmed ?? ""
        
        if firstName.isEmpty {
            firstNameTextField.becomeFirstResponder()
            showMessage(with: ValidationError.emptyFirstName)
            return nil
        }
        else if firstName.count < 3 || firstName.count > 30 {
            firstNameTextField.becomeFirstResponder()
            showMessage(with: ValidationError.invalidFirstName)
            return nil
        }
        else if genderTextField.text == "" || genderTextField.text == "Enter" {
            showMessage(with: ValidationError.selectGender)
            return nil
        }
//        else if self.dob == "" {
//            showMessage(with: ValidationError.selectDOB)
//            return nil
//        }
        else if locationTextField.text == "" {
            showMessage(with: ValidationError.selectLocation)
            return nil
        }
        else if sexualPreferenceTextField.text == "Enter" || self.preferredGenderIds.count == 0 {
            showMessage(with: ValidationError.selectPreferedGender)
            return nil
        }
        else if preferredLocationTextFiled.text == "" {
            showMessage(with: ValidationError.selectPreferedLocation)
            return nil
        }
        
        var params = [String:Any]()
        params[WebConstants.friendId] = self.receivedProfile?.id ?? ""
        params[WebConstants.firstName] = firstName
        params[WebConstants.gender] = self.genderTextField.text
        params[WebConstants.genderId] = self.selectedGenderId
        params[WebConstants.latitude] = "\(self.lat)"
        params[WebConstants.longitude] = "\(self.lng)"
        params[WebConstants.state] = "\(self.state)"
        params[WebConstants.city] = "\(self.city)"
        params[WebConstants.country] = "\(self.country)"
        params[WebConstants.preferredGenders] = self.preferredGenderIds
        params[WebConstants.preferredMaxAge] = self.selectedMaxValue
        params[WebConstants.preferredMinAge] = self.selectedMinValue
        params[WebConstants.preferredLatitude] = "\(self.preferedlat)"
        params[WebConstants.preferredLongitude] = "\(self.preferedlng)"
        params[WebConstants.preferredState] = "\(self.preferedstate)"
        params[WebConstants.preferredCity] = "\(self.preferedcity)"
        params[WebConstants.preferredCountry] = "\(self.preferedcountry)"
        params[WebConstants.isLocationSetDefault] = self.isLocationSetDefault
        return params
    }
    
    
    // MARK: - API Call...
    func processForUpdateFriendProfileApiData(params: [String: Any]) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.UserMatchMaking.updateFriendsProfileV1,
                               params: params,
                               headers: headers,
                               method: .put) { response, _ in
            if !self.hasErrorIn(response) {
                let responseData = response![APIConstants.data] as! [String: Any]
                showSuccessMessage(with: StringConstants.updatedFriendsProfile)
                self.popBackToController()
            }
            hideLoader()
        }
    }
    
    func popBackToController() {
        for controller in self.hostViewController.navigationController!.viewControllers as Array {
            if controller.isKind(of: MatchMakingViewController.self) {
                self.hostViewController.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
}

// MARK: - RangeSeekSliderDelegate

extension MatchMakingBasicInfoViewModel: RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider === rangeSlider1 {
            print("Custom slider updated. Min Value: \(Int(minValue)) Max Value: \(Int(maxValue))")
            self.slider1Min = "\(Int(minValue))"
            self.slider1Max = "\(Int(maxValue))"
            self.selectedMinValue = Int(minValue)
            self.selectedMaxValue = Int(maxValue)
            self.updateSlider1LabelInputs()
        }  else {
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

extension MatchMakingBasicInfoViewModel: GMSAutocompleteViewControllerDelegate {
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
            if self.isLocationSelectedFor == "location"{
                lat = "\(place.coordinate.latitude)"
            }else {
                preferedlat = "\(place.coordinate.latitude)"
            }
        }
        // Show longitude
        if place.coordinate.longitude.description.count != 0 {
            print(place.coordinate.longitude)
            if self.isLocationSelectedFor == "location"{
                lng = "\(place.coordinate.longitude)"
            }else {
                preferedlng = "\(place.coordinate.longitude)"
            }
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
        if self.isLocationSelectedFor == "location"{
            self.locationTextField.text = "\(place.name?.description ?? ""), " + "\(country)"
            self.city = "\(place.name?.description ?? "")"
            self.state = "\(state)"
            self.country = "\(country)"
            
//            self.preferredLocationTextFiled.text = "\(place.name?.description ?? ""), " + "\(country)"
//            self.preferedcity = "\(place.name?.description ?? "")"
//            self.preferedstate = "\(state)"
//            self.preferedcountry = "\(country)"
            
        } else {
            self.preferredLocationTextFiled.text = "\(place.name?.description ?? ""), " + "\(country)"
            self.preferedcity = "\(place.name?.description ?? "")"
            self.preferedstate = "\(state)"
            self.preferedcountry = "\(country)"
        }
        
        if self.preferredLocationTextFiled.text != "\(GlobalVariables.shared.locationDetailsDictionary[WebConstants.preferredCity] as? String ?? ""), " + "\(GlobalVariables.shared.locationDetailsDictionary[WebConstants.preferredCountry] as? String ?? "")" {
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

