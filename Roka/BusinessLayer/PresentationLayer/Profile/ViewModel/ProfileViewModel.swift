//
//  ProfileViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 10/10/22.
//

import Foundation
import UIKit
import CoreLocation

class ProfileViewModel: BaseViewModel {
    var isComeFor = ""
    var completionHandler: ((Bool) -> Void)?
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    
    var locationnDetailsDictionary = [String:Any]()
    var city = ""
    var country = ""
    var count = 0
    var selectedIndex = -1
    
    func proceedForCreateMatchMakingProfile() {
        KAPPDELEGATE.updateRootController(MatchingTabBar.getController(),
                                          transitionDirection: .fade,
                                          embedInNavigationController: true)
    }
    
    func proceedToSelectUserProfileScreen() {
        KAPPDELEGATE.updateRootController(SelectUserProfileViewController.getController(), transitionDirection: .fade, embedInNavigationController: true)
    }
    
    func proceedForDatingProfile() {
        KAPPDELEGATE.updateRootController(TabBarController.getController(),
                                          transitionDirection: .fade,
                                          embedInNavigationController: true)
    }
    
    func proceedForCreateProfileStepOne() {
        GlobalVariables.shared.isCreateForDatingProfile = "yes"
        KAPPDELEGATE.updateRootController(StepOneViewController.getController(), transitionDirection: .fade, embedInNavigationController: true)
    }
    
    func checkLocationSettings() {
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
            
                        self.count += 1
                        if self.count == 1{
                            let registrationStep = Int(KAPPSTORAGE.registrationStep) ?? -1
                            let userType = Int(KAPPSTORAGE.userType) ?? -1
                            
                            if self.selectedIndex == 0 {
                                if userType == 1 {
                                    if registrationStep == 1{
                                        self.proceedForCreateProfileStepOne()
                                    } else {
                                        self.proceedForDatingProfile()
                                    }
                                } else {
                                    if registrationStep == 1{
                                        self.proceedForCreateProfileStepOne()
                                    } else {
                                        self.proceedForDatingProfile()
                                    }
                                }
                            } else if self.selectedIndex == 1{
                                self.proceedForCreateMatchMakingProfile()
                            }
                        }
                    }
                    LocationManager.shared.stopMonitoring()
                }
            } else {
                LocationManager.shared.updatedLocation = nil
            }
        }
        
        if LocationManager.shared.canAskForAuthorization() {
            LocationManager.shared.requestAuthorization()
        } else if LocationManager.shared.locationServicesEnabled() == false {
            //LocationManager.shared.allowLocationServicesPopUp(self.hostViewController)
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

            self.count += 1
            if self.count == 1{
                let registrationStep = Int(KAPPSTORAGE.registrationStep) ?? -1
                let userType = Int(KAPPSTORAGE.userType) ?? -1
                
                if self.selectedIndex == 0 {
                    if userType == 1 {
                        if registrationStep == 1{
                            self.proceedForCreateProfileStepOne()
                        } else {
                            self.proceedForDatingProfile()
                        }
                    } else {
                        if registrationStep == 1{
                            self.proceedForCreateProfileStepOne()
                        } else {
                            self.proceedForDatingProfile()
                        }
                    }
                } else if self.selectedIndex == 1{
                    self.proceedForCreateMatchMakingProfile()
                }
            }
        } else if LocationManager.shared.isAuthorized() == false {
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

            self.count += 1
            if self.count == 1{
                let registrationStep = Int(KAPPSTORAGE.registrationStep) ?? -1
                let userType = Int(KAPPSTORAGE.userType) ?? -1
                
                if self.selectedIndex == 0 {
                    if userType == 1 {
                        if registrationStep == 1{
                            self.proceedForCreateProfileStepOne()
                        } else {
                            self.proceedForDatingProfile()
                        }
                    } else {
                        if registrationStep == 1{
                            self.proceedForCreateProfileStepOne()
                        } else {
                            self.proceedForDatingProfile()
                        }
                    }
                } else if self.selectedIndex == 1{
                    self.proceedForCreateMatchMakingProfile()
                }
            }
        } else {
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
    
    var modelArray: [SettingModel] = [
        SettingModel(image: "ic_profile", label: "Profile Preferences"),
        SettingModel(image: "ic_gallery", label: "My Photos"),
        SettingModel(image: "ic_profile", label: "Saved Profiles"),
        SettingModel(image: "ic_block", label: "Blocked Users"),
        SettingModel(image: "ic_refer&earn", label: "Refer and Earn"),
        SettingModel(image: "ic_subscription", label: "My Subscription"),
        SettingModel(image: "ic_notifications", label: "Notifications"),
        SettingModel(image: "ic_privacy", label: "Privacy"),
        SettingModel(image: "ic_terms&conditions", label: "Terms and Conditions"),
        SettingModel(image: "ic_help", label: "Help"),
        SettingModel(image: "ic_suggestions", label: "Have any suggestions?"),
        SettingModel(image: "ic_faq", label: "FAQs")
    ]
    
    var matchModelArray: [SettingModel] = [
        SettingModel(image: "ic_notifications", label: "Notifications"),
        SettingModel(image: "ic_privacy", label: "Privacy"),
        SettingModel(image: "ic_terms&conditions", label: "Terms and Conditions"),
        SettingModel(image: "ic_help", label: "Help"),
        SettingModel(image: "ic_block", label: "Blocked User"),
        SettingModel(image: "ic_suggestions", label: "Have any suggestions?"),
        SettingModel(image: "ic_faq", label: "FAQs")
    ]
    
    func proceedForLogout() {
        let controller = LogoutViewController.getController() as! LogoutViewController
        controller.dismissCompletion = { value  in }
        controller.show(over: self.hostViewController) { value  in
        }
    }
    
    func proceedForDeleteAccount() {
        let controller = DeleteAccountViewController.getController() as! DeleteAccountViewController
        controller.dismissCompletion = { value  in }
        controller.show(over: self.hostViewController, isComeFrom: "", friendId: "") { value  in
        }
    }
    
    func proceedForDeActivateAccount(_ result:@escaping(String?) -> Void) {
        let controller = DeactivateAccountViewController.getController() as! DeactivateAccountViewController
        controller.dismissCompletion = { value  in
            if value != "" {
                if value == "refreshMatchMaking" {
                    result("refreshMatchMaking")
                } else {
                    result("ChangeToMatachIngProfile")
                }
            }
        }
        if user.isDeactivate == 0 {
            controller.show(over: self.hostViewController, isComeFrom: "DatingProfile", isDeactivate: 1) { value  in
            }
        } else {
            controller.show(over: self.hostViewController, isComeFrom: "MatchMakingProfile", isDeactivate: 0) { value  in
            }
        }
    }
    
    func proceedForAccountDetailScreen() {
        AccountDetailsViewController.show(from: self.hostViewController, isComeFor: "Profile") { success in
        }
    }
    
    func proceedForVerifyKycScreen() {
        StepFourViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "Profile") { success in
        }
    }
    
    func proceedForEditProfileScreen() {
        GlobalVariables.shared.isDrinkingApiCalled = false
        GlobalVariables.shared.isSmokingApiCalled = false
        GlobalVariables.shared.isAgeRangeApiCalled = false
        
        MoreDetailViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "AboutMeProfile") { success in
        }
    }
    
    func proceedForBuyPremiumScreen() {
        BuyPremiumViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "Profile") { success in
        }
    }
    
    func proceedForKycPendingScreen() {
        let controller = PendingKYCViewController.getController() as! PendingKYCViewController
        controller.dismissCompletion = { value  in }
        controller.show(over: self.hostViewController) { value  in }
    }
    
    func proceedForKycVerificationPendingScreen() {
        let controller = PendingVerificationViewController.getController() as! PendingVerificationViewController
        controller.dismissCompletion = { value  in }
        controller.show(over: self.hostViewController) { value  in }
    }
    
    func proceedForNotificationsScreen() {
        NotificationsViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "Profile") { success in
        }
    }
    
    func proceedForEditProfilePreferenceScreen() {
        GlobalVariables.shared.isDrinkingApiCalled = false
        GlobalVariables.shared.isSmokingApiCalled = false
        GlobalVariables.shared.isAgeRangeApiCalled = false
        GlobalVariables.shared.isComeFormProfile = true
        MoreDetailViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "PreferenceProfile") { success in
        }
    }
    
    func proceedForSavedProfilesScreen() {
        SavedProfilePagerController.show(from: self.hostViewController, forcePresent: false)
    }
    
    func proceedForBlockedUsersScreen() {
        BlockedUsersViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "Profile") { success in
        }
    }
    
    func proceedForMySubscriptionScreen() {
        SubscriptionViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "Profile") { success in
        }
    }
    
    func proceedForSuggestionScreen() {
        SuggestionViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "Profile") { success in
        }
    }
    
    func proceedForReferAndEarnScreen() {
        ReferAndEarnViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "Profile") { success in
        }
    }
    
    func proceedForPrivacyScreen() {
        WebPageViewController.show(from: self.hostViewController, forcePresent: false, title: "Privacy", url: APIUrl.GeneralUrls.privacyPolicy, iscomeFrom: "Profile") { success in
        }
    }
    
    func proceedForTermsConditionsScreen() {
        WebPageViewController.show(from: self.hostViewController, forcePresent: false, title: "Terms and Conditions", url: APIUrl.GeneralUrls.termsAndConditions, iscomeFrom: "Profile") { success in
        }
    }
    
    func proceedForFAQScreen() {
        WebPageViewController.show(from: self.hostViewController, forcePresent: false, title: "FAQ's", url: APIUrl.GeneralUrls.faqs, iscomeFrom: "Profile") { success in
        }
    }
    
    func proceedForHelpScreen() {
        HelpViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "Profile") { success in
        }
    }
    
    func proceedForGalleryScreen() {
        GalleryViewController.show(from: self.hostViewController) { status in
        }
    }
    // MARK: - API Call...
    func processForGetUserData(_ result:@escaping([String: Any]?) -> Void) {
        //showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.User.basePreFix,
                               headers: headers,
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
    
    // MARK: - API Call...
    func processForGetUserProfileData(_ result:@escaping([String: Any]?) -> Void) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.UserApis.getUserProfileDetail,
                               headers: headers,
                               method: .get) { response, _ in
            if !self.hasErrorIn(response) {
                DispatchQueue.main.async {
                    let userResponseData = response![APIConstants.data] as! [String: Any]
                    result(userResponseData)
                    
                }
                hideLoader()
            }
        }
    }
}
