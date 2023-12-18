//
//  LocationManager.swift
//  Nielsen
//
//  Created by Dev on 14/03/19.
//  Copyright © 2019 Dev. All rights reserved.
//

import CoreLocation
import UIKit

class LocationManager: NSObject, CLLocationManagerDelegate {
    var updatedLocation: ((CLLocationCoordinate2D?) -> Void)?

    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        /*Another way to save power is to set the pausesLocationUpdatesAutomatically property
         of your location manager object to true.
         Enabling this property lets the system reduce power consumption by disabling location hardware
         when the user is unlikely to be moving.
         Pausing updates does not diminish the quality of those updates,
         but can improve battery life significantly. */
        //locationManager.pausesLocationUpdatesAutomatically = true
       // locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        return locationManager
    }()

    static let shared = LocationManager()

    override private  init() {
    }

    func initialize() {
        
    }

    func requestAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }

    func isAuthorized() -> Bool {
        let manager = CLLocationManager()
        return manager.authorizationStatus == .authorizedWhenInUse ||
        manager.authorizationStatus == .authorizedAlways
    }
    
    func canAskForAuthorization() -> Bool {
        let manager = CLLocationManager()
        return manager.authorizationStatus == .notDetermined
    }

    func locationServicesEnabled() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }

    func startMonitoring() {
        if CLLocationManager.significantLocationChangeMonitoringAvailable() {
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.startUpdatingLocation()
        } else {
            locationManager.startUpdatingLocation()

        }
        if let location = locationManager.location {
            updatedLocation?(location.coordinate)
        }        
    }
    
    func stopMonitoring() {
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            updatedLocation?(location.coordinate)
            stopMonitoring()
        }
    }

    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print(error.localizedDescription)
    }

    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        if self.canAskForAuthorization() == false,
            self.isAuthorized() == false {
            allowLocationAccessPopUp()
        } else if self.isAuthorized() {
            if let location = locationManager.location {
                updatedLocation?(location.coordinate)
                NotificationCenter.default.post(name: .AuthorizationAccess, object: nil)
            } else {
                updatedLocation?(nil)
            }
        }
    }
    
    @objc
    func appEnterForeground() {
        if self.canAskForAuthorization() == false {
            if self.isAuthorized() == false {
                allowLocationAccessPopUp()
            } else {
                locationManager.startUpdatingLocation()
            }
        } else {
            self.requestAuthorization()
        }
        
    }

    func allowLocationAccessPopUp(_ host: UIViewController? = AppDelegate.shared.window?.rootViewController) {
        guard let host = host else {
            return
        }
        NotificationCenter.default.removeObserver(self, name: .appEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appEnterForeground),
                                               name: .appEnterForeground,
                                               object: nil)
        host.showAlert(with: ValidationError.locationAccessErrorTitle,
                       message: ValidationError.locationAccessErrorMessage,
                       options: StringConstants.settings,
                       completion: { index in
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url,
                                                      options: [:],
                                                      completionHandler: nil)
                        }
        })
    }
    
    func allowLocationServicesPopUp(_ host: UIViewController? = AppDelegate.shared.window?.rootViewController) {
        NotificationCenter.default.removeObserver(self, name: .appEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appEnterForeground),
                                               name: .appEnterForeground,
                                               object: nil)
        guard let host = host else {
            return
        }
        host.showAlert(with: ValidationError.locationAccessErrorTitle,
                       message: ValidationError.locationAccessErrorMessage,
                       options: StringConstants.settings,
                       completion: { index in
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url,
                                                      options: [:],
                                                      completionHandler: nil)
                        }
        })
    }
}
