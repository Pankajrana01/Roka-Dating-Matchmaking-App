//
//  StepFourViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 22/09/22.
//

import Foundation
import UIKit
import AVKit
class StepFourViewModel : BaseViewModel {
    var completionHandler: ((Bool) -> Void)?
    var nextButton: UIButton!
    var isComeFor = ""
    
    func allowCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            print("Denied, request permission from settings")
            presentCameraSettings()
        case .restricted:
            print("Restricted, device owner must approve")
        case .authorized:
            print("Authorized, proceed")
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    print("Permission granted, proceed")
                } else {
                    print("Permission denied")
                }
            }
        @unknown default:
            break
        }
    }

    func presentCameraSettings() {
        let alertController = UIAlertController(title: "Error",
                                      message: "Camera access is denied",
                                      preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        alertController.addAction(UIAlertAction(title: "Settings", style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                    // Handle
                })
            }
        })
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.hostViewController.view
            popoverController.sourceRect = CGRect(x: self.hostViewController.view.bounds.midX, y: self.hostViewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.hostViewController.present(alertController, animated: true)
    }
    func allowMicrophonePermission() {
        let recordingSession = AVAudioSession.sharedInstance()
        recordingSession.requestRecordPermission() { [unowned self] allowed in
            DispatchQueue.main.async {
                if allowed {
                    self.gotoNextStep()
                } else {
                    self.deniedMicroPhonePermission()
                }
            }
        }
    }
    
    func deniedMicroPhonePermission() {
        let alert = UIAlertController(title: "Error", message: "Microphone access is denied", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { action in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.hostViewController.view
            popoverController.sourceRect = CGRect(x: self.hostViewController.view.bounds.midX, y: self.hostViewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.hostViewController.present(alert, animated: true, completion: nil)
    }
    func askMicrophonePermissionIfNeeded() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .undetermined:
            self.allowMicrophonePermission()
        case .denied:
            self.deniedMicroPhonePermission()
        case .granted:
            self.gotoNextStep()
        @unknown default:
            break
        }
    }
    
    func gotoNextStep() {
        print("microphone permission is allow")
        proceedForCreateProfileKYC()
       // proceedForCreateProfile()
    }
    
    func proceedForCreateProfileKYC() {
        if self.isComeFor == "Profile" {
            VerifyKYCViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "Profile") { success in
            }
        } else if isComeFor == "KYC_DECLINE_PUSH" {
            
            VerifyKYCViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "KYC_DECLINE_PUSH") { success in
            }
        } else {
            VerifyKYCViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "") { success in
            }
        }
    }
    
    func proceedForCreateProfileStepFive() {
        ProfileCreatedViewController.show(from: self.hostViewController, forcePresent: false, iscomeFrom: "Skip") { success in
        }
    }
    
    func proceedForCreateProfile() {
        ProfileCreatedViewController.show(from: self.hostViewController, forcePresent: false, iscomeFrom: "") { success in
        }
    }
    
    func proceedForHome() {
        GlobalVariables.shared.isKycPendingPopupShow = true
        KAPPDELEGATE.updateRootController(TabBarController.getController(),
                                          transitionDirection: .fade,
                                          embedInNavigationController: true)
    }
}
