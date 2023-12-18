//
//  BaseViewModel.swift
//  Covid19 tracking
//
//  Created by Aakash on 29/07/21.
//

import SwiftMessages
import UIKit

class BaseViewModel: NSObject {
    weak var hostViewController: BaseViewController!
    
    init(hostViewController: BaseViewController) {
        super.init()
        self.hostViewController = hostViewController
    }
}

extension BaseViewModel {
    @objc
    func viewLoaded() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.logoutCall(notification:)), name: Notification.Name("LogoutCall"), object: nil)
    }
    
    @objc func logoutCall(notification: Notification) {
        self.gotoLoginScreen()
    }
    
    func gotoLoginScreen() {
        UserModel.shared.logoutUser()
        KAPPDELEGATE.updateRootController(WelcomeViewController.getController(),
                                          transitionDirection: .toRight,
                                          embedInNavigationController: true)
    }
    
}

// MARK: - Error Handling
extension BaseViewModel {
    
    func hasErrorIn(_ response: [String: Any]?,
                    showError: Bool = true) -> Bool {
        return BaseViewModel.hasErrorIn(response,
                                        showError: showError,
                                        hostViewController: self.hostViewController)
    }
    
    class func hasErrorIn(_ response: [String: Any]?,
                          showError: Bool = true,
                          hostViewController: BaseViewController? = nil) -> Bool {
        guard let response = response,
            let code = response[APIConstants.code],
            let message = response[APIConstants.message] as? String else {
                if showError {
                    showMessage(with: GenericErrorMessages.internalServerError)
                }
                return true
        }
        
        if "\(code)" != "200" {
            if showError {
                showMessage(with: message)
            }
            if "\(code)" == "401" { // invalid access token. should go to welcome / login screen
                hostViewController?.gotoLoginScreen()
            }
            return true
        }
        return false
    }
    
    
}


// MARK: - Photo handling
extension BaseViewModel: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /// Show Picture options for choosing a new picture
    ///
    /// If the image exists (validated via imageUrl), 2 more options, View image and Remove image are displayed, otherwise, only 2 options are displayed i.e. Take phone and Choose photo.
    /// - Parameter imageUrl: the name/url of the existing image
    func showPicOptions() {
        let controller = UIAlertController(title: nil,
                                           message: nil,
                                           preferredStyle: .actionSheet)
        
        controller.addAction(UIAlertAction(title: "Cancel",
                                           style: .cancel ,
                                           handler: { _ in
        }))
        controller.addAction(UIAlertAction(title: "Camera",
                                           style: .default ,
                                           handler: { _ in
                                            self.choosePhoto(isCamera: true)
        }))
        controller.addAction(UIAlertAction(title: "Gallery",
                                           style: .default ,
                                           handler: { _ in
                                            self.choosePhoto(isCamera: false)
        }))
        
        if let popoverController = controller.popoverPresentationController {
            popoverController.sourceView = self.hostViewController.view
            popoverController.sourceRect = CGRect(x: self.hostViewController.view.bounds.midX, y: self.hostViewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        hostViewController.present(controller,
                                   animated: true,
                                   completion: nil)
    }
    
    func choosePhoto(isCamera: Bool) {
        if isCamera == true {
            checkPermission(.camera, permissionType: .camera)
        } else {
            checkPermission(.photoLibrary, permissionType: .photos)
        }
    }

    func checkPermission(_ sourceType: UIImagePickerController.SourceType,
                         permissionType: PermissionType) {
        let permissionManager = PermissionManager()
        let status = permissionManager.status(permissionType)
        if status.isAuthorized() {
            showImagePickerWith(sourceType)
        } else if permissionManager.canRequestPermission(permissionType: permissionType) {
            permissionManager.requestPermission(permissionType: permissionType) { granted in
                if granted {
                    self.showImagePickerWith(sourceType)
                } else {
                    permissionManager.showRestrictedAlert(permissionType,
                                                          host: self.hostViewController)
                }
            }
        } else {
            permissionManager.showRestrictedAlert(permissionType,
                                                  host: self.hostViewController)
        }
    }
    
    private func showImagePickerWith(_ sourceType: UIImagePickerController.SourceType) {
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = sourceType
            
            if GlobalVariables.shared.selectedProfileMode != "MatchMaking" {
                imagePicker.navigationBar.barTintColor = UIColor.loginBlueColor // Background color
            } else {
                imagePicker.navigationBar.barTintColor = UIColor.appTitleBlueColor // Background color
            }
            imagePicker.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            
            self.hostViewController.present(imagePicker,
                                            animated: true,
                                            completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
