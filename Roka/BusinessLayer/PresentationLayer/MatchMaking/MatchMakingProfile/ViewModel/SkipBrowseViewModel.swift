//
//  SkipBrowseViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 12/10/23.
//

import Foundation
import UIKit
import GooglePlaces

class SkipBrowseViewModel: BaseViewModel {
    var isComeFor = ""
    var completionHandler: ((Bool) -> Void)?
    var profileArr: [ProfilesModel] = []
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    var nextButton: UIButton!
    var rangeSlider1: RangeSeekSlider!
    var rangeSlider1Label: UILabel!
    var genderArray = [GenderRow]()
    var genderArrayIndex = [String]()
    var slider1Min = ""
    var slider1Max = ""
    var broswSkipDetailsDictionary = [String:Any]()
    var preferredGenderIds = [String]()
    var preferredGendersNames = [String]()
    var selectedGenderId = ""
    var selectedMinValue = 18
    var selectedMaxValue = 99
    weak var genderTextField: UILabel!
    
    var preferedlat = ""
    var preferedlng = ""
    var preferedcity = ""
    var preferedcountry = ""
    var preferedstate = ""
    weak var toggleButton: UIButton!
    weak var preferredLocationTextFiled: UnderlinedTextField!
    var isLocationSetDefault = 1


    
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
    
    func proceedForSelectPreferredGender() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { value in }
       
        controller.show(over: self.hostViewController, isComeFor: "sexualPreference2", isFriend: false, genderArray: self.genderArray, selectedGenderId: self.preferredGenderIds.joined(separator: ",")) { id, value, value2 in
            
        } preferredCompletionHandler: { text, ids, priority  in
            self.genderTextField.text = text
            self.genderTextField.textColor = .appBorder
            self.preferredGenderIds.removeAll()
            self.preferredGenderIds = ids
    
        }

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
        broswSkipDetailsDictionary[WebConstants.preferredMinAge] = Int(slider1Min)
        broswSkipDetailsDictionary[WebConstants.preferredMaxAge] = Int(slider1Max)
        
    }
    
    func openGooglePlacesController(type: String){
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
       // self.isLocationSelectedFor = type
        // Display the autocomplete view controller.
        self.hostViewController.present(autocompleteController, animated: true, completion: {
            self.hostViewController.navigationController?.isNavigationBarHidden = false
        })
        
    }
    
    func checkValidation(genderTextField: UILabel,preferredLocationTextFiled:UITextField) {
        validateModelWithFriendsBasicInputs(genderTextField: genderTextField, preferredLocationTextFiled: preferredLocationTextFiled)
    }
    
    func validateModelWithFriendsBasicInputs(genderTextField: UILabel,preferredLocationTextFiled:UITextField) {
        
        if genderTextField.text == "" || genderTextField.text == "Enter" {
            showMessage(with: ValidationError.selectGender)
        }
        else if preferredLocationTextFiled.text == "" {
            showMessage(with: ValidationError.selectPreferedLocation)
        }else{
            var preferrGenderCommaSepartedIds = ""
            if self.preferredGenderIds.count > 1{
                preferrGenderCommaSepartedIds = self.preferredGenderIds.joined(separator: ",")
            }else{
                preferrGenderCommaSepartedIds = self.preferredGenderIds[0]
            }
            //  params[WebConstants.friendId] = self.receivedProfile?.id ?? ""
            //  broswSkipDetailsDictionary[WebConstants.gender] = self.genderTextField.text
              broswSkipDetailsDictionary[WebConstants.preferredGenders] = preferrGenderCommaSepartedIds
              broswSkipDetailsDictionary[WebConstants.preferredMaxAge] = self.selectedMaxValue
              broswSkipDetailsDictionary[WebConstants.preferredMinAge] = self.selectedMinValue
            //  broswSkipDetailsDictionary[WebConstants.preferredLatitude] = "\(self.preferedlat)"
            //  broswSkipDetailsDictionary[WebConstants.preferredLongitude] = "\(self.preferedlng)"
              broswSkipDetailsDictionary[WebConstants.preferredState] = "\(self.preferedstate)"
              broswSkipDetailsDictionary[WebConstants.preferredCity] = "\(self.preferedcity)"
              broswSkipDetailsDictionary[WebConstants.preferredCountry] = "\(self.preferedcountry)"
              broswSkipDetailsDictionary[WebConstants.limit] = 20
              broswSkipDetailsDictionary[WebConstants.skip] = 0
            //  params[WebConstants.isLocationSetDefault] = self.isLocationSetDefault
              
              MatchMakingDetailsViewController.show(from: hostViewController, isComeFor: "BrowseAndSkip",broswSkipDetailsDictionary: broswSkipDetailsDictionary) { succes in
              }
        }
    }
}
// MARK: - RangeSeekSliderDelegate

extension SkipBrowseViewModel: RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider === rangeSlider1 {
            print("Custom slider updated. Min Value: \(Int(minValue)) Max Value: \(Int(maxValue))")
            self.slider1Min = "\(Int(minValue))"
            self.slider1Max = "\(Int(maxValue))"
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
extension SkipBrowseViewModel: GMSAutocompleteViewControllerDelegate {
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
            preferedlat = "\(place.coordinate.latitude)"
        }
        // Show longitude
        if place.coordinate.longitude.description.count != 0 {
            print(place.coordinate.longitude)
            preferedlng = "\(place.coordinate.longitude)"
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
