//
//  BasicInfoViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 21/09/22.
//

import Foundation
import UIKit
import GooglePlaces
import FirebaseDatabase
import CodableFirebase

class BasicInfoViewModel: BaseViewModel {
    var completionHandler: ((Bool) -> Void)?
    var lastNameTextField: UnderlinedTextField!
    var firstNameTextField: UnderlinedTextField!
    var emailNameTextField: UnderlinedTextField!
    var buttonVerify: UIButton!
    weak var relationshipNameTxt: UILabel!
    
    var isComeFor = ""
    var nextButton: UIButton!
    var isLocationSetDefault = 1
    var user = UserModel.shared.user
    var storedUser = KAPPSTORAGE.user

    var rangeSlider2: RangeSeekSlider!
    var rangeSlider2Label: UILabel!
    var slider2Max = ""

    weak var toggleButton: UIButton!
    weak var preferredLocationTextFiled: UnderlinedTextField!
    weak var locationTextField: UnderlinedTextField!
    var isLocationSelectedFor = ""
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
    var relationshipId = ""
    var relationshipsArray = [GenderRow]()
    
    
    var preferredDetailsDictionary = [String:Any]()

    
    func openGooglePlacesController(type: String){
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.isLocationSelectedFor = type
        // Display the autocomplete view controller.
        self.hostViewController.present(autocompleteController, animated: true, completion: {
            self.hostViewController.navigationController?.isNavigationBarHidden = false
        })
        
    }
    
    func enableDisableNextButton() {
        if self.firstNameTextField.text == "" && self.lastNameTextField.text == "" { //&& self.emailNameTextField.text == ""
            self.nextButton.alpha = 0.5
            self.nextButton.isUserInteractionEnabled = false
        } else if self.firstNameTextField.text == "" || self.lastNameTextField.text == ""{ // || self.emailNameTextField.text == ""
            self.nextButton.alpha = 0.5
            self.nextButton.isUserInteractionEnabled = false
        } else {
            self.nextButton.alpha = 1.0
            self.nextButton.isUserInteractionEnabled = true
        }
    }
    
    func recoveryEmailInfoButton() {
        let controller = RecoveryEmailViewController.getController() as! RecoveryEmailViewController
        controller.dismissCompletion = { value  in }
        controller.show(over: self.hostViewController) { }
    }
    
    func proceedToNextScreen() {
        DispatchQueue.main.async {
            KAPPDELEGATE.initializeDatingNavigationBar()
        }
        GlobalVariables.shared.selectedProfileMode = "Dating"
        GlobalVariables.shared.isComesFromBasicInfo = true
        KAPPDELEGATE.updateRootController(StepOneViewController.getController(),
                                          transitionDirection: .fade,
                                          embedInNavigationController: true)

//        StepOneViewController.show(from: self.hostViewController, forcePresent: false, city: self.city, country: self.country) { success in
//        }
    }
    
    func proceedForCreateMatchMakingProfile() {
        DispatchQueue.main.async {
            KAPPDELEGATE.initializeMatchMakingNavigationBar()
        }
        GlobalVariables.shared.selectedProfileMode = "MatchMaking"
        KAPPDELEGATE.updateRootController(MatchingTabBar.getController(),
                                          transitionDirection: .fade,
                                          embedInNavigationController: true)
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
}
// MARK:-
// MARK:- add validations
extension BasicInfoViewModel {
    func checkValidation(firstNameTextField: UITextField, lastNameTextField: UITextField, emailNameTextField:UITextField){
        if self.isComeFor == "Profile" {
            if let params = validateModelWithUserInputs(firstNameTextField: firstNameTextField, lastNameTextField: lastNameTextField, emailNameTextField:emailNameTextField) {
                print(params)
                self.processForUpdateProfileApiData(params: params)
            }
        } else{
            if let params = validateModelWithUserBasicInputs(firstNameTextField: firstNameTextField, lastNameTextField: lastNameTextField, emailNameTextField:emailNameTextField) {
                print(params)
                self.processForBasicInfoData(params: params)
            }
        }
    }
    
    func validateModelWithUserInputs(firstNameTextField: UITextField, lastNameTextField: UITextField, emailNameTextField:UITextField) -> [String: Any]? {
        let emailAddress = emailNameTextField.text?.trimmed ?? ""
        let firstName = firstNameTextField.text?.trimmed ?? ""
        let lastName = lastNameTextField.text?.trimmed ?? ""
        
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
        else if lastName.isEmpty {
            lastNameTextField.becomeFirstResponder()
            showMessage(with: ValidationError.emptyLastName)
            return nil
        }
        else if lastName.count < 3 || lastName.count > 30 {
            firstNameTextField.becomeFirstResponder()
            showMessage(with: ValidationError.invalidLastName)
            return nil
        }
//        else if emailAddress.isEmpty {
//            emailNameTextField.becomeFirstResponder()
//            showMessage(with: ValidationError.emptyEmail)
//            return nil
//        }
        else if emailAddress.isValidEmailAddress == false && !emailAddress.isEmpty {
            emailNameTextField.becomeFirstResponder()
            showMessage(with: ValidationError.invalidEmail)
            return nil
        }
        
        else if locationTextField.text == "" {
            showMessage(with: ValidationError.selectLocation)
            return nil
        }
        else if preferredLocationTextFiled.text == "" {
            showMessage(with: ValidationError.selectPreferedLocation)
            return nil
        }
        
        var params = [String:Any]()
        params[WebConstants.firstName] = firstName
        params[WebConstants.lastName] = lastName
        params[WebConstants.email] = emailAddress
        
        params["latitude"] = "\(self.lat)"
        params["longitude"] = "\(self.lng)"
        params["city"] = "\(self.city)"
        params["state"] = "\(self.state)"
        params["country"] = "\(self.country)"
        params["preferredLatitude"] = "\(self.preferedlat)"
        params["preferredLongitude"] = "\(self.preferedlng)"
        params["preferredCity"] = "\(self.preferedcity)"
        params["preferredState"] = "\(self.preferedstate)"
        params["preferredCountry"] = "\(self.preferedcountry)"
        
        if self.isComeFor != "Profile"{
            params[WebConstants.registrationStep] = 1
        }
        
        return params
    }
    
    func validateModelWithUserBasicInputs(firstNameTextField: UITextField, lastNameTextField: UITextField, emailNameTextField:UITextField) -> [String: Any]? {
        let emailAddress = emailNameTextField.text?.trimmed ?? ""
        let firstName = firstNameTextField.text?.trimmed ?? ""
        let lastName = lastNameTextField.text?.trimmed ?? ""
        
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
        else if lastName.isEmpty {
            lastNameTextField.becomeFirstResponder()
            showMessage(with: ValidationError.emptyLastName)
            return nil
        }
        else if lastName.count < 3 || lastName.count > 30 {
            firstNameTextField.becomeFirstResponder()
            showMessage(with: ValidationError.invalidLastName)
            return nil
        }
//        else if emailAddress.isEmpty {
//            emailNameTextField.becomeFirstResponder()
//            showMessage(with: ValidationError.emptyEmail)
//            return nil
//        }
        else if emailAddress.isValidEmailAddress == false && !emailAddress.isEmpty {
            emailNameTextField.becomeFirstResponder()
            showMessage(with: ValidationError.invalidEmail)
            return nil
        }
//        else if self.relationshipId == "" {
//            showMessage(with: ValidationError.emptyRelationshipStatus)
//            return nil
//        }
        
        var params = [String:Any]()
        params[WebConstants.firstName] = firstName
        params[WebConstants.lastName] = lastName
        params[WebConstants.email] = emailAddress
        params[WebConstants.registrationStep] = 1
      //  params[WebConstants.relationshipId] = self.relationshipId
        
        GlobalVariables.shared.basicInfoParams.removeAll()
        GlobalVariables.shared.basicInfoParams = params
        return params
    }
    // MARK: - API Call...
    func processForBasicInfoData(params: [String: Any]) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.UserApis.registerUser,
                               params: params,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .put) { response, _ in
            if !self.hasErrorIn(response) {
                let responseData = response![APIConstants.data] as! [String: Any]
                self.user.updateWith(responseData)
                UserModel.shared.setUserLoggedIn(true)
                UserModel.shared.storedUser = self.user
                hideLoader()
//                self.fetchAllChatsAndUpdateName {
//                    hideLoader()
//                    if self.isComeFor == "MatchMaking" {
//                        self.proceedForCreateMatchMakingProfile()
//                    } else {
//                        // self.proceedToNextScreen()
//                    }
//                }
//
                if self.isComeFor == "MatchMaking" {
                    self.proceedForCreateMatchMakingProfile()
                } else {
                     self.proceedToNextScreen()
                }
            } else {
                hideLoader()
            }
        }
    }
    
    // MARK: - API Call...
    func processForVerifyEmail(email:String) {
        if email.isEmpty {
            emailNameTextField.becomeFirstResponder()
            showMessage(with: ValidationError.emptyEmail)
        }
        else if email.isValidEmailAddress == false {
            emailNameTextField.becomeFirstResponder()
            showMessage(with: ValidationError.invalidEmail)
        } else {
            showLoader()
            var params = [String:Any]()
            params[WebConstants.email] = email
            ApiManager.makeApiCall(APIUrl.UserApis.emailForVerification,
                                   params: params,
                                   headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                                   method: .put) { response, _ in
                if !self.hasErrorIn(response) {
                    showSuccessMessage(with: "Verification mail sent successfully.")
                    self.hostViewController.navigationController?.popViewController(animated: true)
                }
                hideLoader()
            }
        }
    }
    
    // MARK: - API Call...
    func processForUpdateProfileApiData(params: [String: Any]) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.UserApis.updateProfile,
                               params: params,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .put) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [String: Any]
                                    showSuccessMessage(with: StringConstants.updatedProfile)
                                    self.user.updateWith(responseData)
                                    KUSERMODEL.setUserLoggedIn(true)
                                    self.hostViewController.navigationController?.popViewController(animated: true)
                                }
            
                                hideLoader()
        }
    }
    
    // MARK: - API Call...
    func processForGetUserData(_ result:@escaping([String: Any]?) -> Void) {
    showLoader()
        ApiManager.makeApiCall(APIUrl.User.basePreFix,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .get) { response, _ in
                                if !self.hasErrorIn(response) {
                                    DispatchQueue.main.async {
                                        let responseData = response![APIConstants.data] as! [String: Any]
                                        self.user.updateWith(responseData)
                                        result(responseData)
                                    }
                                }
            hideLoader()
        }
    }
        
    func fetchAllChatsAndUpdateName(handler: @escaping (() -> Void)) {
        showLoader()
        Database.database().reference().child("Chats")
            .queryOrdered(byChild: "user_id/\(UserModel.shared.user.id)").queryEqual(toValue: UserModel.shared.user.id).observeSingleEvent(of: .value, with: { [self](snapshot) in
            if let snapDict = snapshot.value as? [String:AnyObject] {
                for item in snapDict {
                    do {
                        var model = try FirebaseDecoder().decode(ChatRoomModel.self, from: item.value)
                        model.user_name?[UserModel.shared.user.id] = "\(user.firstName) \(user.lastName )"
                        model.user_number?[UserModel.shared.user.id] = "\(user.firstName) \(user.lastName )"
                        FirestoreManager.uptadeUsernameOnFirebase(chatRoom: model)
                        
                    } catch let error {
                        print(error)
                    }
                }
                handler()

            } else {
                print("SnapDict is null")
                handler()
            }
        })
    }
    
    func updateVerifyEmailStatus(text:String) {
        if self.user.email == text {
            if self.user.emailVerified == 1 {
                self.buttonVerify.isHidden = false
                self.buttonVerify.tintColor = UIColor.appPurpleColor
             //   self.buttonVerify.borderColor = UIColor.systemGreen
             //   self.buttonVerify.borderWidth = 1
             //   self.buttonVerify.clipsToBounds = true
                self.buttonVerify.setTitle("Verified", for: .normal)
            } else {
                self.buttonVerify.isHidden = false
                self.buttonVerify.tintColor = UIColor.appPurpleColor
             //   self.buttonVerify.borderColor = UIColor.appYellowColor
             //   self.buttonVerify.borderWidth = 1
             //   self.buttonVerify.clipsToBounds = true
                self.buttonVerify.setTitle("Verify", for: .normal)
            }
        } else {
            self.buttonVerify.isHidden = false
            self.buttonVerify.tintColor = UIColor.appPurpleColor
         //   self.buttonVerify.borderColor = UIColor.appYellowColor
         //   self.buttonVerify.borderWidth = 1
         //   self.buttonVerify.clipsToBounds = true
            self.buttonVerify.setTitle("Verify", for: .normal)
        }
    }
    
    func processForGetRelationshipsData() {
        var params = [String:Any]()
        params["type"] = "1"
        self.getApiCall(params: params, url: APIUrl.BasicApis.relationships) { model in
            self.relationshipsArray = model?.data ?? []
        }
    }
    
    func getApiCall(params: [String:Any], url: String, _ result: @escaping(ResponseModel?) -> Void) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        
        ApiManagerWithCodable<ResponseModel>.makeApiCall(url, params: params,
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
    
    func proceedForSelectRelationship() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { _ in }
        
        controller.show(over: self.hostViewController, isComeFor: "BasicRelationships", isFriend: false, genderArray: self.relationshipsArray, selectedGenderId: self.relationshipId) { id, value, value2 in
            self.relationshipId = id
            self.relationshipNameTxt.text = value
            self.relationshipNameTxt.textColor = UIColor.black
           
        } preferredCompletionHandler: { text, ids, priority  in
        }
    }
    
}
// MARK: - UITextField Delegates.
extension BasicInfoViewModel: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
      
        if textField == emailNameTextField {
            if self.isComeFor == "Profile" {
                updateVerifyEmailStatus(text: newString)
            }
        }
        
        if (string == " ") {
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        enableDisableNextButton()
    }

}


extension BasicInfoViewModel: GMSAutocompleteViewControllerDelegate {
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
            
            self.preferredLocationTextFiled.text = "\(place.name?.description ?? ""), " + "\(country)"
            self.preferedcity = "\(place.name?.description ?? "")"
            self.preferedstate = "\(state)"
            self.preferedcountry = "\(country)"
            
        } else {
            self.preferredLocationTextFiled.text = "\(place.name?.description ?? ""), " + "\(country)"
            self.preferedcity = "\(place.name?.description ?? "")"
            self.preferedstate = "\(state)"
            self.preferedcountry = "\(country)"
        }
        
        if self.preferredLocationTextFiled.text != "\(self.city), " + "\(self.country)" {
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


// MARK: - RangeSeekSliderDelegate

extension BasicInfoViewModel: RangeSeekSliderDelegate {
    
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
