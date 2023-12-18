//
//  SwitchModeViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 06/10/22.
//

import Foundation
import UIKit
import CoreLocation

class SwitchModeViewModel: BaseViewModel {
    var completionHandler: ((String) -> Void)?
    var locationnDetailsDictionary = [String:Any]()
    var city = ""
    var country = ""
    var count = 0
    let user = UserModel.shared.user
    var storedUser = KAPPSTORAGE.user
    var selectedIndex = -1
    var isComeFor = ""
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
}
