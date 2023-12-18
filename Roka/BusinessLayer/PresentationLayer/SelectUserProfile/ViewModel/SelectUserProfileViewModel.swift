//
//  SelectUserProfileViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 21/09/22.
//

import Foundation
import UIKit
import CoreLocation

class SelectUserProfileViewModel: BaseViewModel {
    var completionHandler: ((Bool) -> Void)?
    let minRowHeight: CGFloat = 210.0
    var titleNameArr = ["Find for Me", "Find for Friend", "Let’s do Both"]
    var descNameArr = ["Start your Love Story", "Create a private profile to help your friends find a match", "Dating + Matching"]
    var imagesArr = ["Mask1", "Mask2", "Mask3"]
    var locationnDetailsDictionary = [String:Any]()
    let user = UserModel.shared.user
    var storedUser = KAPPSTORAGE.user
    var city = ""
    var country = ""
    var count = 0
    var selectedIndex = -1
    var tableView: UITableView! { didSet { configureTableView() } }
    var receivedProfile: ProfilesModel?
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: TableViewNibIdentifier.userProfileNib, bundle: nil), forCellReuseIdentifier: TableViewCellIdentifier.userProfileCell)
        processForGetUserData()
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
                        KAPPSTORAGE.user = self.user
                        KUSERMODEL.storedUser = user
                        
                        self.count += 1
                        if self.count == 1{
                            if self.selectedIndex == 0 {
                                self.proceedForCreateProfileStepOne()
                            } else if self.selectedIndex == 1 {
                                if KAPPSTORAGE.isWalkthroughShown == "Yes"{
                                    self.proceedForCreateMatchMakingProfile()
                                }else{
                                    self.proceedForMatchMakingWalkThrough()
                                    self.processForRegisterApiData()
                                }
                            } else {
                                self.proceedForCreateProfileStepOne()
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
            
            self.count += 1
            if self.count == 1{
                if self.selectedIndex == 0 {
                    self.proceedForCreateProfileStepOne()
                } else if self.selectedIndex == 1 {
                    if KAPPSTORAGE.isWalkthroughShown == "Yes"{
                        self.proceedForCreateMatchMakingProfile()
                    }else{
                        self.proceedForMatchMakingWalkThrough()
                        self.processForRegisterApiData()
                    }
                } else {
                    self.proceedForCreateProfileStepOne()
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
            KAPPSTORAGE.user = self.user
            KUSERMODEL.storedUser = user
            
            self.count += 1
            if self.count == 1{
                if self.selectedIndex == 0 {
                    self.proceedForCreateProfileStepOne()
                } else if self.selectedIndex == 1 {
                    if KAPPSTORAGE.isWalkthroughShown == "Yes"{
                        self.proceedForCreateMatchMakingProfile()
                    }else{
                        self.proceedForMatchMakingWalkThrough()
                        self.processForRegisterApiData()
                    }
                } else {
                    self.proceedForCreateProfileStepOne()
                }
            }
        } else {
            LocationManager.shared.startMonitoring()
        }
    }
    
    // MARK: - API Call...
    func processForRegisterApiData() {
        let params = ["userType": 2, "isMatchMakingProfile":1]
        ApiManager.makeApiCall(APIUrl.UserApis.registerUser,
                               params: params,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .put) { response, _ in
            if !self.hasErrorIn(response) {
                let responseData = response![APIConstants.data] as! [String: Any]
                self.user.updateWith(responseData)
                UserModel.shared.storedUser = self.user
                hideLoader()
            }
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
    
    func proceedForCreateProfileStepOne() {
        StepOneViewController.show(from: self.hostViewController, forcePresent: false, city: self.city, country: self.country) { success in
        }
    }
    
    func proceedForCreateMatchMakingProfile() {
        KAPPDELEGATE.updateRootController(MatchingTabBar.getController(),
                                          transitionDirection: .fade,
                                          embedInNavigationController: true)
    }
    
    func proceedForMatchMakingWalkThrough() {
        HomeWalkThroughViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "MatchMaking") { success in
        }
    }
    
    func proceedForCreateMatchMakingProfileStepOne() {
        MatchMakingBasicInfoController.show(from: self.hostViewController, forcePresent: false, isComeFor: "", receivedProfile: receivedProfile) { success in
        }
    }
    
    // MARK: - API Call...
    func processForGetUserData() {
        ApiManager.makeApiCall(APIUrl.User.basePreFix,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .get) { response, _ in
                                if !self.hasErrorIn(response) {
                                   // let responseData = response![APIConstants.data] as! [String: Any]
                                }
                                hideLoader()
        }
    }
}

extension SelectUserProfileViewModel : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleNameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.userProfileCell, for: indexPath) as? UserProfileTableViewCell{
            
            cell.titleLabel.text = self.titleNameArr[indexPath.row]
            cell.descLabel.text = self.descNameArr[indexPath.row]
            cell.selectedTableIndex = indexPath.row
            
           // cell.titleName = self.titleNameArr[indexPath.row]
            cell.imageName = self.imagesArr[indexPath.row]
            //cell.descName = self.descNameArr[indexPath.row]
            cell.collectionView.tag =  indexPath.row
            cell.collectionView.reloadData()

            cell.callBackForDidSelectProfile = { selectedIndex in
                print(selectedIndex)
                self.selectedIndex = selectedIndex
                //self.proceedForCreateProfileStepOne()
               // if selectedIndex == 0{
                    self.checkLocationSettings()
               // }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tHeight = tableView.frame.height
        let temp = tHeight / CGFloat(3)
        return temp > minRowHeight ? temp : minRowHeight
    }
    
}
