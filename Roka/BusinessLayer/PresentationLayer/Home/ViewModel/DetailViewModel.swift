//
//  DetailViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 06/10/22.
//

import Foundation
import UIKit

class DetailViewModel: BaseViewModel {
    var isComeFor = ""
    var completionHandler: ((Bool) -> Void)?
    var selectedProfile: ProfilesModel!
    
    func showAlertForReportBlockUser() {
        let alert = UIAlertController(title: "", message: "Do you want to report or block the user?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Report", style: .default, handler: { action in
            self.proceedToReportScreen()
        }))
        
        alert.addAction(UIAlertAction(title: "Block", style: .destructive, handler: { action in
            self.blockButtonTapped()
        }))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.hostViewController.view
            popoverController.sourceRect = CGRect(x: self.hostViewController.view.bounds.midX, y: self.hostViewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.hostViewController.present(alert, animated: true, completion: nil)
    }
    
    func proceedToReportScreen() {
        ReportViewController.show(from: self.hostViewController, isComeFor: "Detail", id: selectedProfile.id ?? "") { success in }
    }
    
    func proceedForShare() {
        ShareViewController.show(over: self.hostViewController, profileArray: []) { status in
            if status == "CreateGroup"{
                CreateGroupViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "group", profiles: [],isNeedToSendLastMessgaeId: true) { success in
                }
            }
        }
//        controller.createGroupPressed = {
//            CreateGroupChatController.show(from: self.hostViewController, forcePresent: false, isComeFor: "") { success in
//
//            }
//        }
    }
    
    func blockButtonTapped() {
        let alert = UIAlertController(title: "Are you sure you want to block this user?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
            self.blockUser()
        }))
        
        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { action in        }))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.hostViewController.view
            popoverController.sourceRect = CGRect(x: self.hostViewController.view.bounds.midX, y: self.hostViewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.hostViewController.present(alert, animated: true, completion: nil)
    }
    
    
    func blockUser() {
        var params = [String:Any]()
        params[WebConstants.profileId] = selectedProfile.id
        processForBlockProfileData(params: params)
    }
    
    // MARK: - API Call...
    func processForBlockProfileData(params: [String: Any]) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.LandingApis.blockUser,
                               params: params,
                               headers: headers,
                               method: .put) { response, _ in
            if !self.hasErrorIn(response) {
                let responseData = response![APIConstants.data] as! [String: Any]
                
                showSuccessMessage(with: StringConstants.BlockSuccess)
                delay(1){
                    for controller in self.hostViewController.navigationController!.viewControllers as Array {
                        if controller.isKind(of: PagerController.self) {
                            self.hostViewController.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                }
              //  self.hostViewController.backButtonTapped(self)
                
            }
            hideLoader()
        }
    }
}
