//
//  MatchMakingViewModel.swift
//  Roka
//
//  Created by  Developer on 21/11/22.
//

import Foundation
import CoreLocation


class MatchMakingViewModel: BaseViewModel {
    var isComeFor = ""
    var completionHandler: ((Bool) -> Void)?
    var profileArr: [ProfilesModel] = []
    var locationnDetailsDictionary = [String:Any]()
    var city = ""
    var country = ""
    var count = 0
    var selectedProfile : ProfilesModel?
    
    let user = UserModel.shared.user
    var storedUser = KAPPSTORAGE.user
    
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
    
    func proceedToMatchMakingEdit(selectedProfile:ProfilesModel) {
        GlobalVariables.shared.selectedFriendProfileId = selectedProfile.id ?? ""
        GlobalVariables.shared.selectedFriendProfileDOB = selectedProfile.dob ?? ""
        MatchMakingEditViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "MatchMakingProfile", selectedProfile: selectedProfile) { success in }
    }
    
    func proceedToMatchMakingBasicInfo() {
        MatchMakingBasicInfoController.show(from: self.hostViewController, forcePresent: false, isComeFor: "MatchMaking", receivedProfile: selectedProfile) { success in }
    }
    
    func proceedToMatchMakingSkipBrowse() {
        SkipBrowseViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "MatchMaking") { success in }
    }
    
    
    func proceedToMatchMakingDetailsPagerController(selectedProfile: ProfilesModel, isComeFor: String) {
        GlobalVariables.shared.selectedFriendProfileId = selectedProfile.id ?? ""
        MatchMakingDetailsPagerController.show(from: self.hostViewController, forcePresent: false, receivedProfile: selectedProfile, isComeFor: isComeFor)
    }
    
    func getFriendsProfile(_ result: @escaping(ProfilesResponseModel?) -> Void) {
        //showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        
        ApiManagerWithCodable<ProfilesResponseModel>.makeApiCall(APIUrl.UserMatchMaking.getfriendsProfile,
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
}
extension MatchMakingViewModel {
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
                        
                        LocationManager.shared.stopMonitoring()
                    }
                } else {
                    LocationManager.shared.updatedLocation = nil
                }
            }
        }
            if LocationManager.shared.canAskForAuthorization() {
                LocationManager.shared.requestAuthorization()
            } else if LocationManager.shared.locationServicesEnabled() == false {
                LocationManager.shared.allowLocationServicesPopUp(self.hostViewController)
            } else if LocationManager.shared.isAuthorized() == false {
                LocationManager.shared.allowLocationServicesPopUp(self.hostViewController)
            } else {
                LocationManager.shared.startMonitoring()
            }
    }
}
