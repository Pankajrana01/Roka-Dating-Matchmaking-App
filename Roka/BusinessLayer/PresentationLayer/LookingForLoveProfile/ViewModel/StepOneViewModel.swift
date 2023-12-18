//
//  StepOneViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 21/09/22.
//

import Foundation
import UIKit
import GooglePlaces
import UIKit
import CoreLocation


class StepOneViewModel: BaseViewModel {
    var completionHandler: ((Bool) -> Void)?
    var genderArray = [GenderRow]()
    var createProfileModel: CreateProfileModel = CreateProfileModel()
    var city = ""
    var country = ""
    var nextButton: UIButton!
    var liveInTextField: UnderlinedTextField!
    var iamTextField: UnderlinedTextField!
    var bornTextField: UnderlinedTextField!
    var relationshipTextField: UnderlinedTextField!
    var wishingToHaveTextField: UnderlinedTextField!
    var locationnDetailsDictionary = [String:Any]()
    let user = UserModel.shared.user
    var storedUser = KAPPSTORAGE.user
    var basicDetailsDictionary = [String:Any]()
    var state = ""
    var dob = ""
    var selectedDate = ""
    var selectedGenderId = ""
    var lat = ""
    var lng = ""
    var relationshipId = ""
    var relationshipsArray = [GenderRow]()
    var wishingArray = [GenderRow]()
    var wishingIds = [String]()
    var isRelationshipPrivate = 0
    var isWishingPrivate = 0
    func openGooglePlacesController() {
//        let autocompleteController = GMSAutocompleteViewController()
//        autocompleteController.delegate = self
//        
//        // Display the autocomplete view controller.
//        self.hostViewController.present(autocompleteController, animated: true, completion: nil)
        
        let popup = UIStoryboard(name: "BasicInfo", bundle: nil)
        if let popupvc = popup.instantiateViewController(withIdentifier: "SearchLocationVC") as? SearchLocationVC {
            popupvc.modalPresentationStyle = .overCurrentContext
            popupvc.callBacktoMainScreen = {
                self.liveInTextField.text = popupvc.locationAddress
                self.lat = popupvc.lat
                self.lng = popupvc.long
                self.city = popupvc.city
                self.state = popupvc.state
                self.country = popupvc.country
            }
            self.hostViewController.present(popupvc, animated: false)
        }
        
    }
    
    func enableDisableNextButton() {
        if self.iamTextField.text == "" {
            self.nextButton.alpha = 0.5
            self.nextButton.isUserInteractionEnabled = false
        } else if self.dob == "" {
            self.nextButton.alpha = 0.5
            self.nextButton.isUserInteractionEnabled = false
        } else if self.liveInTextField.text == "" {
            self.nextButton.alpha = 0.5
            self.nextButton.isUserInteractionEnabled = false
        } else if self.relationshipId == "" {
            self.nextButton.alpha = 0.5
            self.nextButton.isUserInteractionEnabled = false
        } else if self.wishingIds.count == 0 {
            self.nextButton.alpha = 0.5
            self.nextButton.isUserInteractionEnabled = false
        } else {
            self.nextButton.alpha = 1.0
            self.nextButton.isUserInteractionEnabled = true
        }
    }
    
    func proceedForCreateProfileStepTwo() {
        if self.iamTextField.text == "" {
            showMessage(with: ValidationError.selectGender)
        } else if self.dob == ""  {
            showMessage(with: ValidationError.selectDOB)
        } else if self.liveInTextField.text == "" {
            showMessage(with: ValidationError.selectLocation)
        } else if self.relationshipId == "" {
            showMessage(with: ValidationError.emptyRelationshipStatus)
        } else if self.wishingIds.count == 0 {
            showMessage(with: ValidationError.emptyWishingStatus)
        } else {
            basicDetailsDictionary[WebConstants.gender] = self.iamTextField.text ?? ""
            basicDetailsDictionary[WebConstants.genderId] = self.selectedGenderId
            basicDetailsDictionary[WebConstants.dob] = self.dob
            self.basicDetailsDictionary[WebConstants.state] = "\(self.state)"
            self.basicDetailsDictionary[WebConstants.city] = "\(self.city)"
            self.basicDetailsDictionary[WebConstants.country] = "\(self.country)"
            self.basicDetailsDictionary[WebConstants.latitude] = "\(self.lat)"
            self.basicDetailsDictionary[WebConstants.longitude] = "\(self.lng)"
            self.basicDetailsDictionary[WebConstants.relationshipId] = self.relationshipId
            self.basicDetailsDictionary[WebConstants.isRelationshipPrivate] = self.isRelationshipPrivate
            self.basicDetailsDictionary[WebConstants.preferredWishingToHave] = self.wishingIds
            self.basicDetailsDictionary["isWishingPrivate"] = self.isWishingPrivate
            user.updateWith(basicDetailsDictionary)
            
            KUSERMODEL.setUserLoggedIn(true)
            KUSERMODEL.storedUser = user
            
            
            if basicDetailsDictionary[WebConstants.dob] as? String == "<null>" || basicDetailsDictionary[WebConstants.dob] as? String == "" {
                showMessage(with: ValidationError.selectDOB)
                self.bornTextField.text = ""
                self.dob = ""
            }
            else {
                StepTwoViewController.show(from: self.hostViewController, forcePresent: false, genderArray: self.genderArray, basicDetailsDictionary: basicDetailsDictionary) { success in
                }
            }
        }
    }
    
    func proceedForSelectGender() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { value in }
        if genderArray.count != 0 {
            controller.show(over: self.hostViewController, isComeFor: "Gender", isFriend: false, genderArray: self.genderArray, selectedGenderId: selectedGenderId) { id, value, value2 in
                self.iamTextField.text = value
                self.selectedGenderId = id
                self.enableDisableNextButton()
            } preferredCompletionHandler: { text, ids, priority  in
            }
        }
    }
    
    func proceedForSelectRelationship() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { _ in }
        
        controller.show(over: self.hostViewController, isComeFor: "Relationships", isFriend: false, genderArray: self.relationshipsArray, selectedGenderId: self.relationshipId) { id, value, value2 in
            self.relationshipId = id
            self.relationshipTextField.text = value
            self.relationshipTextField.textColor = UIColor.appTitleBlueColor
            self.isRelationshipPrivate = value2
            self.enableDisableNextButton()
            
            var params = [String:Any]()
            params[WebConstants.id] = self.user.id
            params[WebConstants.relationshipId] = id
            params[WebConstants.isRelationshipPrivate] = value2
            self.processForUpdateProfilePreferenceApiData(params: params)
            
        } preferredCompletionHandler: { text, ids, priority  in
        }
    }
    
    func proceedForSelectWishing() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { value in }
       
        controller.show(over: self.hostViewController, isComeFor: "AboutMeWishing", isFriend: false, genderArray: self.wishingArray, selectedGenderId: self.wishingIds.joined(separator: ",")) { id, value, value2 in
            
        } preferredCompletionHandler: { text, ids, priority  in
            self.wishingToHaveTextField.text = text
            self.wishingIds.removeAll()
            self.wishingIds = ids
            self.isWishingPrivate = priority
            self.enableDisableNextButton()
            
            var params = [String:Any]()
            params[WebConstants.id] = self.user.id
            params[WebConstants.preferredWishingToHave] = ids
            params["isWishingToHavePriority"] = priority
            self.processForUpdateProfilePreferenceApiData(params: params)
        }
    }
    
    func processForUpdateProfilePreferenceApiData(params: [String: Any]) {
       // showLoader()
        ApiManager.makeApiCall(APIUrl.UserApis.updateProfile,
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
    
    func proceedForSelectDate() {
        let controller = CalendarViewController.getController() as! CalendarViewController
        controller.dismissCompletion = { value in }
        controller.show(over: self.hostViewController, selectedDate:self.selectedDate, isCome: "step1", isFriend: false) { value, value2, value3  in
            self.bornTextField.text = value
            self.dob = value2
            self.selectedDate = value2
            self.enableDisableNextButton()
        }
    }
    
    func proceedToPreviousScreen() {
        GlobalVariables.shared.isComesFromBasicInfo = true
        KAPPDELEGATE.updateRootController(BasicInfoViewController.getController(),
                                          transitionDirection: .toLeft,
                                          embedInNavigationController: true)
    }
    
    // MARK: - API Call ...
    func genderApiCall(_ result:@escaping(ResponseModel?) -> Void) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        var params = [String:Any]()
        params["type"] = "1"
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
    
    func processForGetGenderData() {
        self.genderApiCall { model in
            self.genderArray = model?.data ?? []
        }
    }
    
    func proceedForCreateMatchMakingProfile() {
        KAPPDELEGATE.updateRootController(MatchingTabBar.getController(),
                                          transitionDirection: .fade,
                                          embedInNavigationController: true)
    }
    
    
    
    func checkLocationSettings(_ success:@escaping(Bool?) -> Void) {
        LocationManager.shared.updatedLocation  = { coordinates in
            if self.hostViewController != nil {
                if let coordinates = coordinates {
                    print(coordinates.latitude, coordinates.longitude)
                    let currentLocation: CLLocation =  CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
                    
                    self.getAddress(location: currentLocation) { [self] (result, state, city, country) in
                        print( "\(city ?? "")" + ", " + "\(country ?? "").")
                        
                        self.city = "\(city ?? "")"
                        self.country = "\(country ?? "")"
                        
                        self.locationnDetailsDictionary[WebConstants.latitude] = "\(coordinates.latitude)"
                        self.locationnDetailsDictionary[WebConstants.longitude] = "\(coordinates.longitude)"
                        self.locationnDetailsDictionary[WebConstants.city] = "\(city ?? "")"
                        self.locationnDetailsDictionary[WebConstants.state] = "\(state ?? "")"
                        self.locationnDetailsDictionary[WebConstants.country] = "\(country ?? "")"
                        
                        self.locationnDetailsDictionary[WebConstants.preferredLatitude] = "\(coordinates.latitude)"
                        self.locationnDetailsDictionary[WebConstants.preferredLongitude] = "\(coordinates.longitude)"
                        self.locationnDetailsDictionary[WebConstants.preferredCity] = "\(city ?? "")"
                        self.locationnDetailsDictionary[WebConstants.preferredState] = "\(state ?? "")"
                        self.locationnDetailsDictionary[WebConstants.preferredCountry] = "\(country ?? "")"
                        
                        self.user.updateWith(self.locationnDetailsDictionary)
                        GlobalVariables.shared.locationDetailsDictionary = self.locationnDetailsDictionary
                        KAPPSTORAGE.user = self.user
                        KUSERMODEL.storedUser = user
                        self.enableDisableNextButton()
                        success(true)
                    }
                    LocationManager.shared.stopMonitoring()
                }
            } else {
                LocationManager.shared.updatedLocation = nil
                success(false)
            }
        }
        
        if LocationManager.shared.canAskForAuthorization() {
            LocationManager.shared.requestAuthorization()
        } else if LocationManager.shared.locationServicesEnabled() == false {
            // LocationManager.shared.allowLocationServicesPopUp(self.hostViewController)
            self.locationnDetailsDictionary[WebConstants.latitude] = "0"
            self.locationnDetailsDictionary[WebConstants.longitude] = "0"
            self.locationnDetailsDictionary[WebConstants.city] = ""
            self.locationnDetailsDictionary[WebConstants.state] = ""
            self.locationnDetailsDictionary[WebConstants.country] = ""
            
            self.locationnDetailsDictionary[WebConstants.preferredLatitude] = "0"
            self.locationnDetailsDictionary[WebConstants.preferredLongitude] = "0"
            self.locationnDetailsDictionary[WebConstants.preferredCity] = ""
            self.locationnDetailsDictionary[WebConstants.preferredState] = ""
            self.locationnDetailsDictionary[WebConstants.preferredCountry] = ""
            
            self.user.updateWith(self.locationnDetailsDictionary)
            GlobalVariables.shared.locationDetailsDictionary = self.locationnDetailsDictionary
            KAPPSTORAGE.user = self.user
            KUSERMODEL.storedUser = user
            self.enableDisableNextButton()
            success(true)
        }
        else if LocationManager.shared.isAuthorized() == false {
            //LocationManager.shared.allowLocationAccessPopUp(self.hostViewController)
            self.locationnDetailsDictionary[WebConstants.latitude] = "0"
            self.locationnDetailsDictionary[WebConstants.longitude] = "0"
            self.locationnDetailsDictionary[WebConstants.city] = ""
            self.locationnDetailsDictionary[WebConstants.state] = ""
            self.locationnDetailsDictionary[WebConstants.country] = ""
            
            self.locationnDetailsDictionary[WebConstants.preferredLatitude] = "0"
            self.locationnDetailsDictionary[WebConstants.preferredLongitude] = "0"
            self.locationnDetailsDictionary[WebConstants.preferredCity] = ""
            self.locationnDetailsDictionary[WebConstants.preferredState] = ""
            self.locationnDetailsDictionary[WebConstants.preferredCountry] = ""
            
            self.user.updateWith(self.locationnDetailsDictionary)
            GlobalVariables.shared.locationDetailsDictionary = self.locationnDetailsDictionary
            KAPPSTORAGE.user = self.user
            KUSERMODEL.storedUser = user
            self.enableDisableNextButton()
            success(true)
        }
        else {
            LocationManager.shared.startMonitoring()
        }
    }
    
    // MARK: - Get address from location
    func getAddress(location:CLLocation,completion: @escaping (_ result:String?,_ state: String?,_ city: String?,_ country: String?) -> Void ) {
        //sharedLatitudeLongitude
        showLoader()
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = location.coordinate.latitude
        center.longitude = location.coordinate.longitude
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        var addressString : String = ""
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
            
            hideLoader()
            if (error != nil)
            {
                completion("","","","")
                print("reverse geodcode fail: \(error!.localizedDescription)")
                return
            }
            let pm = placemarks! as [CLPlacemark]
            
            if pm.count > 0 {
                let pm = placemarks![0]
                
                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality! + ", "
                }
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + ", "
                }
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + ", "
                }
                if pm.administrativeArea != nil {
                    addressString = addressString + pm.administrativeArea! + ", "
                }
                if pm.country != nil {
                    addressString = addressString + pm.country! + ", "
                }
                completion(addressString, pm.administrativeArea, pm.locality, pm.country)
            }
            else{
                completion("", "", "", "")
            }
        })
    }
    
}


extension StepOneViewModel: GMSAutocompleteViewControllerDelegate {
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
            self.lat = "\(place.coordinate.latitude)"
        }
        // Show longitude
        if place.coordinate.longitude.description.count != 0 {
            print(place.coordinate.longitude)
            self.lng = "\(place.coordinate.longitude)"
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
        
        self.liveInTextField.text = "\(place.name?.description ?? ""), " + "\(country)"
        
        self.state = "\(state)"
        self.city = "\(place.name?.description ?? "")"
        self.country = "\(country)"
        
//        self.basicDetailsDictionary[WebConstants.state] = "\(state)"
//        self.basicDetailsDictionary[WebConstants.city] = "\(place.name?.description ?? "")"
//        user.updateWith(basicDetailsDictionary)
//        KUSERMODEL.setUserLoggedIn(true)
//        KUSERMODEL.storedUser = user
        self.enableDisableNextButton()
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
