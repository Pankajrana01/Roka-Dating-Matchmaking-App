//
//  CardViewViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 17/10/23.
//

import Foundation
import UIKit
import Koloda

class CardViewViewModel: BaseViewModel {
    
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    var isComeFor = ""
    var forceBackToHome = false
    var notifications = [Notifications]()
    
    var completionHandler: ((Bool) -> Void)?
    var selectedProfile: ProfilesModel!
    var allProfiles: [ProfilesModel] = []
    var copyAllProfiles: [ProfilesModel] = []
    var selectedIndex = 0
    var previousSelectedIndex = 0
    var index = 0
    var displayIndex = 0
    var previousIndex = 0
    var controllerIndex = 0
    
    var preferencesArray: [Rows] = []
    var preferencesTitleArray: [String] = []
    var passionName:[String] = []
    var preferencesPassionArray: [String] = []
    var preferencesPassionTitleArray: [String] = []
    var heightArry: [String] = []
    var heightTitleArry: [String] = []
    var religionArry: [String] = []
    var religionTitleArry: [String] = []
    var twiiterLink = ""
    var instagramLink = ""
    var linkedInLink = ""
    var searchPreferenceId = ""
    var callBacktoMainScreen: ((Int) -> ())?
    var callBackForReject: ((Int) -> ())?
    var callBacktoPreviosScreen: ((Int) -> ())?
    var callBacktoUndoAction: ((Int) ->())?
    var callBacktoSaveAction: ((Int, Int) ->())?
    var isFrom = ""
    
    weak var shareButtonView: UIView!
    weak var undoButtonView: UIButton!
    weak var likeButtonView: UIButton!
    weak var crossButtonView: UIButton!
    weak var saveButtonView: UIButton!
    weak var nextButtonView: UIButton!
    weak var prevoiusButtonView: UIButton!
    weak var sideMenuStack: UIStackView!
    weak var nameLabel: UILabel!
    
    var swipeFor = ""
    
    weak var kolodaView: KolodaView! {
        didSet {
            kolodaView.dataSource = self
            kolodaView.delegate = self
        }
    }
    
    func buttonsDidSets(profile: ProfilesModel) {
        DispatchQueue.main.async {
            if self.allProfiles.indices.contains(self.kolodaView.currentCardIndex) {
                self.selectedProfile = profile
                print(self.kolodaView.currentCardIndex)
                self.selectedIndex = self.kolodaView.currentCardIndex
                self.nameLabel.text = self.allProfiles[self.selectedIndex].firstName
                
                if self.selectedIndex > 0 {
                    if self.previousSelectedIndex != self.selectedIndex {
                        self.undoButtonView.isHidden = false
                    } else {
                        self.undoButtonView.isHidden = true
                    }
                } else {
                    self.undoButtonView.isHidden = true
                }
                // update like and chat button state ...
                if let liked = self.allProfiles[self.selectedIndex].isLiked {
                    if liked == 1 {
                        // self.likeImage.image = UIImage(named: "Ic_chat")
                        self.likeButtonView.setImage(UIImage(named: "Ic_chat"), for: .normal)
                    } else {
                        // self.likeImage.image = UIImage(named: "Im_whiteLike")
                        self.likeButtonView.setImage(UIImage(named: "Im_whiteLike"), for: .normal)
                    }
                }
                // update save button state ...
                if let liked = self.allProfiles[self.selectedIndex].isSaved {
                    if liked == 1 {
                        // self.saveImage.image = UIImage(named: "Im_Saved_tick")
                        self.saveButtonView.setImage(UIImage(named: "Im_Saved_tick"), for: .normal)
                    } else {
                        //self.saveImage.image = UIImage(named: "Ic_save 1")
                        self.saveButtonView.setImage(UIImage(named: "Ic_save 1"), for: .normal)
                    }
                }
                if self.isComeFor == "Profile" {
                    self.sideMenuStack.isHidden = true
                    self.saveButtonView.isHidden = true
                    self.prevoiusButtonView.isHidden = true
                    self.nextButtonView.isHidden = true
                }
                else if self.isComeFor == "SavedPreferences" {
                    self.sideMenuStack.isHidden = false
                    self.saveButtonView.isHidden = false
                    self.likeButtonView.isHidden = true
                    self.crossButtonView.isHidden = true
                    let lastElement = self.allProfiles.count - 1
                    print(lastElement)
                    
                    if self.selectedIndex == lastElement {
                        self.nextButtonView.isHidden = true
                    } else {
                        self.nextButtonView.isHidden = false
                    }
                    
                    if self.controllerIndex == 0 {
                        self.prevoiusButtonView.isHidden = true
                    } else {
                        self.prevoiusButtonView.isHidden = false
                    }
                    
                }
                else if self.isComeFor == "MatchMakingProfile" {
                    self.sideMenuStack.isHidden = false
                    self.undoButtonView.isHidden = true
                    self.likeButtonView.isHidden = true
                    self.crossButtonView.isHidden = true
                    
                    let lastElement = self.allProfiles.count - 1
                    print(lastElement)
                    
                    if self.selectedIndex == lastElement {
                        self.nextButtonView.isHidden = true
                    } else {
                        self.nextButtonView.isHidden = false
                    }
                    
                    if self.selectedIndex == 0 {
                        self.prevoiusButtonView.isHidden = true
                    } else {
                        self.prevoiusButtonView.isHidden = false
                    }
                    
                } else if self.isComeFor == "BrowseAndSkip" {
                    self.sideMenuStack.isHidden = false
                    self.undoButtonView.isHidden = true
                    self.likeButtonView.isHidden = true
                    self.crossButtonView.isHidden = true
                    self.saveButtonView.isHidden = true
                    
                    let lastElement = self.allProfiles.count - 1
                    print(lastElement)
                    
                    if self.selectedIndex == lastElement {
                        self.nextButtonView.isHidden = true
                    } else {
                        self.nextButtonView.isHidden = false
                    }

                    if self.selectedIndex == 0 {
                        self.prevoiusButtonView.isHidden = true
                    } else {
                        self.prevoiusButtonView.isHidden = false
                    }
                } else {
                    self.sideMenuStack.isHidden = false
                    self.saveButtonView.isHidden = true //false
                    self.prevoiusButtonView.isHidden = true
                    self.nextButtonView.isHidden = true
                    if self.isFrom == "Likes" || self.isFrom == "Aligned" {
                        self.undoButtonView.isHidden = true
                    }
                }
                
                self.sideMenuStack.layoutIfNeeded()
                self.sideMenuStack.translatesAutoresizingMaskIntoConstraints = false
            }
        }
    }
    
    func proceedForCrossAction() {
        self.swipeFor = "Cross"
        self.kolodaView.swipe(.left)
    }
    
    
    func callBackForSelectCrossButton() {
        print(selectedIndex)
        if self.allProfiles.indices.contains(selectedIndex) {
            if selectedIndex == 0 {
                self.proceesForReject(index: selectedIndex)
            } else {
                self.proceesForReject(index: selectedIndex-1)
            }
        } else {
            self.popBackToController()
        }
    }

    func proceedForLikeAction() {
        self.swipeFor = "like/Unlike"
        self.kolodaView.swipe(.right)
    }
    
    func callBackForSelectLikeButton() {
        print(selectedIndex)
        if self.allProfiles.indices.contains(selectedIndex) {
            if selectedIndex == 0 {
                self.proceesForLike(index: selectedIndex)
            } else {
                self.proceesForLike(index: selectedIndex-1)
            }
        } else {
            self.popBackToController()
        }
    }
    
    func proceedForUndoButtonAction() {
        self.swipeFor = "Undo"
        self.callBackForSelectUndoButton()
    }
    
    func callBackForSelectUndoButton() {
        if UserModel.shared.storedUser?.isSubscriptionPlanActive == 1 {
            print(selectedIndex, previousIndex)
            self.undoProfile(selectedIndex: selectedIndex, previousIndex: selectedIndex - 1) { response in
            }
        } else {
            self.callBacktoUndoAction?(selectedIndex)
            let popup = UIStoryboard(name: "Popups", bundle: nil)
            if let popupvc = popup.instantiateViewController(withIdentifier: "UpgradeSubcriptionViewController") as? UpgradeSubcriptionViewController {
                popupvc.callBacktoMainScreen = {
                    BuyPremiumViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "Profile") { success in
                    }
                }
                if self.allProfiles.indices.contains(selectedIndex) {
                    popupvc.name = self.allProfiles[selectedIndex].firstName ?? ""
                }
                self.swipeFor = ""
                popupvc.modalPresentationStyle = .overCurrentContext
                self.hostViewController.present(popupvc, animated: true)
            }
        }
    }
    
    func callBackForSelectShareButton() {
        print(selectedIndex)
        self.proceedForShare(selectedIndex: selectedIndex)
    }
    
    func callBackForSelectChatButton() {
        if self.allProfiles.indices.contains(selectedIndex) {
            let profile = self.allProfiles[selectedIndex]
            // 2 Matched, 1 Liked
            var userImage = ""
            let images = profile.userImages?.filter({($0.file != "" && $0.file != "<null>" && $0.isDp == 1)})
            if let images = images, !images.isEmpty {
                let image = images[0]
                userImage = image.file == "" ? "dp" : image.file ?? "dp"
            }
            
            let sendDataModel = FirebaseSendDataModel(id: profile.id, dialogStatus: profile.isYourProfileLiked == 1 ? 2 : 1, userName: "\(profile.firstName ?? "") \(profile.lastName ?? "")", userPic: userImage, isSubscriptionPlanActive: profile.isSubscriptionPlanActive, isConnection: 0, countryCode: profile.countryCode, phoneNumber: profile.phoneNumber, isPhoneVerified: 1)
            
            showLoader()
            FirestoreManager.checkForChatRoom(sendDataModel: sendDataModel) { status, existingProfile in
                hideLoader()
                if status {
                    ChatViewController.show(from: self.hostViewController, isChatUserExist: false, forcePresent: false, chatRoom: existingProfile!)
                }
            }
        } else {
            self.popBackToController()
        }
    }
    
    func callBackForSelectSaveButton() {
        print(selectedIndex)
        if self.allProfiles.indices.contains(selectedIndex) {
            if self.allProfiles[selectedIndex].isSaved == 0 {
                if self.isComeFor == "MatchMakingProfile" {
                    self.proceesForMatchMakingSave(index: selectedIndex) { response in
                    }
                } else {
                    self.proceesForSave(index: selectedIndex) { response in
                        
                    }
                }
            } else {
                if self.isComeFor == "MatchMakingProfile" {
                    self.proceesForMatchMakingSave(index: selectedIndex) { response in
                        
                    }
                } else{
                    self.proceesForSave(index: selectedIndex) { response in
                        
                    }
                }
            }
        } else {
            self.popBackToController()
        }
    }
    
    func callBackForSelectNextButton() {
        print(selectedIndex)
        self.swipeFor = "Next"
        self.kolodaView.swipe(.right)
    }
    
    func callBackForSelectPreviousButton() {
        print(selectedIndex)
        self.swipeFor = "Previous"
        self.kolodaView.revertAction()
    }
    
}

// MARK: KolodaViewDelegate

extension CardViewViewModel: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        //kolodaView.resetCurrentCardIndex()
        popBackToController()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        print("did select call...")
    }

}

// MARK: KolodaViewDataSource

extension CardViewViewModel: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return allProfiles.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let bundle = Bundle(for: ProfileCardView.self)
        let nib = UINib(nibName: String(describing: ProfileCardView.self), bundle: bundle)
        if let view = nib.instantiate(withOwner: self, options: nil)[0] as? ProfileCardView {
            view.profileDidSets(profile: self.allProfiles[index])
            self.buttonsDidSets(profile: self.allProfiles[index])
            return view
        } else {
            return UIView()
        }
    }

    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
    }

    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        print(direction.rawValue)
        switch direction {
        case .left :
            // Unlike.....
            // Need to implement this logic ,beacuse match maker can not  like aur dislike the profile , so no need to implemenet the Api for (like/ dislike), same for left aur right swipe
            if GlobalVariables.shared.selectedProfileMode != "MatchMaking"{
                if self.swipeFor == "Cross" {
                    self.callBackForSelectCrossButton()
                } else if self.swipeFor == "Previous" {
                    
                } else {
                    self.callBackForSelectCrossButton()
                }
            }
        case .right :
            if self.swipeFor == "like/Unlike" {
                self.callBackForSelectLikeButton()
            } else if self.swipeFor == "Undo" {
                self.callBackForSelectUndoButton()
            } else if self.swipeFor == "Next" {
                
            }
            // Need to implement this logic ,beacuse match maker can not  like aur dislike the profile , so no need to implemenet the Api for (like/ dislike), same for left aur right swipe
            else if GlobalVariables.shared.selectedProfileMode == "MatchMaking"{
                
            }
            else {
                self.callBackForSelectLikeButton()
            }
        default: break
        }
        
        self.buttonsDidSets(profile: self.allProfiles[index])
    }
    
    func koloda(_ koloda: KolodaView, shouldDragCardAt index: Int) -> Bool {
        print(index)
        if UserModel.shared.user.id == selectedProfile.id{
            return false
        }
        return true
    }
}


extension CardViewViewModel {
    func popBackToController() {
        for controller in self.hostViewController.navigationController!.viewControllers as Array {
            if controller.isKind(of: PagerController.self) {
                self.hostViewController.navigationController!.popToViewController(controller, animated: true)
                break
            }
            if controller.isKind(of: SearchDetailsPagerController.self) {
                self.hostViewController.navigationController!.popToViewController(controller, animated: true)
                break
            }
            
            if controller.isKind(of: SavedProfilePagerController.self) {
                self.hostViewController.navigationController!.popToViewController(controller, animated: true)
                break
            }
            
            if controller.isKind(of: MatchMakingViewController.self) {
                self.hostViewController.navigationController?.popViewController(animated: true)
                break
            }
            
            if controller.isKind(of: ProfileViewController.self) {
                self.hostViewController.navigationController?.popViewController(animated: true)
                break
            }
        }
    }
    
    func proceesForLike(index:Int) {
        var params = [String:Any]()
        let profile = allProfiles[index]
        params[WebConstants.profileId] = profile.id
        params[WebConstants.isLiked] = profile.isLiked == 1 ? 0 : 1
        
        let userIdsArray = [UserModel.shared.user.id, profile.id ?? ""].sorted{ $0 < $1 }
        let chatDialogId = userIdsArray.joined(separator: ",")
        
        FirestoreManager.justCheckIfChatRoomExist(chatDialogId: chatDialogId) { exist, model in
            if (exist && profile.isYourProfileLiked == 1) {
                FirestoreManager.updateDialogStatus(chatRoom: model)
            }
        }
        if profile.isLiked == 0 {
            processForLikeProfileData(params: params, index: index)
        }
    }
    
    func processForLikeProfileData(params: [String: Any], index:Int) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.LandingApis.likeProfile,
                               params: params,
                               headers: headers,
                               method: .put) { response, _ in
            if !self.hasErrorIn(response) {
                if let responseData = response![APIConstants.data] as? [String: Any]{
                    if responseData.count != 0 {
                        if responseData["id"] as? String != ""{
                            self.notifications.removeAll()
                            let userName = "\(self.selectedProfile.firstName ?? "") " + "\(self.selectedProfile.lastName ?? "")"
                            
                            var userImage = ""
                            for i in 0..<(self.selectedProfile.userImages?.count ?? 0){
                                if self.selectedProfile.userImages?[i].isDp as? Int == 1{
                                    userImage = self.selectedProfile.userImages?[i].file as? String ?? ""
                                }
                            }
                            
                            self.notifications.append(Notifications(id: "",
                                                                    senderID: self.selectedProfile.id,
                                                                    receiverID: "",
                                                                    platformType: 0,
                                                                    notificationType: 0,
                                                                    title: "",
                                                                    createdAt: "",
                                                                    userImage: userImage,
                                                                    userName: userName,
                                                                    message: ""))
                            if self.isFrom == "For you" {
                                KAPPSTORAGE.islikeSeleted = "0"
                            } else if self.isFrom == "Nearby" {
                                KAPPSTORAGE.islikeSeleted = "3"
                            } else if self.isFrom == "Likes" {
                                KAPPSTORAGE.islikeSeleted = "1"
                            }
                            self.proceedForMatchedProfileScreen(notification: self.notifications[0])
                        }
                    } else {
                        showSuccessMessage(with: "Profile liked successfully")
                        if self.allProfiles.indices.contains(index) {
                            self.allProfiles[index].isLiked = 1
                            self.previousSelectedIndex = index
                        } else {
                            self.popBackToController()
                        }
                    }
                }
            }
            hideLoader()
        }
    }
    func proceedForMatchedProfileScreen(notification:Notifications) {
        MatchedViewController.show(over: self.hostViewController, isCome: "NotificationScreen", userInfo: [:], notificationData: notification) { success in
        }
    }
    
    func proceedToDetailScreen(profile: ProfilesModel) {
        PageFullViewVC.show(from: self.hostViewController, forcePresent: false, forceBackToHome: false, isFrom: self.nameLabel.text ?? "", isComeFor: "home", selectedProfile: profile, allProfiles: copyAllProfiles, selectedIndex: self.selectedIndex) { success in
        }
    }
    
    func processForUnLikeProfileData(params: [String: Any], _ result:@escaping(String?) -> Void) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.LandingApis.likeProfile,
                               params: params,
                               headers: headers,
                               method: .put) { response, _ in
            if !self.hasErrorIn(response) {
                _ = response![APIConstants.data] as! [String: Any]
                self.allProfiles[self.selectedIndex].isLiked = 0
                result("success")
            }
            hideLoader()
        }
    }
    
    func proceesForSave(index:Int, _ result:@escaping(String?) -> Void) {
        var params = [String:Any]()
        params[WebConstants.profileId] = allProfiles[index].id
        params[WebConstants.status] = allProfiles[index].isSaved == 1 ? 0 : 1
        params[WebConstants.searchPreferenceId] = GlobalVariables.shared.searchPreferenceId
       
        if allProfiles[index].isSaved == 1 {
            processForUnSavedProfileData(index: index, params: params) { response in
                result("Success")
            }
        } else {
            processForSavedProfileData(index: index, params: params) { response in
                result("Success")
            }
        }
        
    }
    
    func processForSavedProfileData(index:Int, params: [String: Any],  _ result:@escaping(String?) -> Void) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.UserApis.saveProfile,
                               params: params,
                               headers: headers,
                               method: .post) { response, _ in
            if !self.hasErrorIn(response) {
                _ = response![APIConstants.data] as! [String: Any]
                showSuccessMessage(with: StringConstants.savedProfileSuccess)
                if self.allProfiles.indices.contains(index) {
                    self.allProfiles[index].isSaved = 1
                    self.selectedProfile.isSaved = 1
                    self.buttonsDidSets(profile: self.allProfiles[index])

                } else {
                    self.popBackToController()
                }
            }
            hideLoader()
        }
    }
    
    func processForUnSavedProfileData(index:Int, params: [String: Any] ,  _ result:@escaping(String?) -> Void) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.UserApis.saveProfile,
                               params: params,
                               headers: headers,
                               method: .post) { response, _ in
            if !self.hasErrorIn(response) {
                _ = response![APIConstants.data] as! [String: Any]
                showSuccessMessage(with: StringConstants.unsavedProfileSuccess)

                if self.allProfiles.indices.contains(index) {
                    self.allProfiles[index].isSaved = 0
                    self.selectedProfile.isSaved = 0
                    self.buttonsDidSets(profile: self.allProfiles[index])
                } else {
                    self.popBackToController()
                }
            }
            hideLoader()
        }
    }
    
    func processForUnSavedProfileData2(params: [String: Any], _ result:@escaping(String?) -> Void) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.UserApis.saveProfile,
                               params: params,
                               headers: headers,
                               method: .post) { response, _ in
            if !self.hasErrorIn(response) {
                _ = response![APIConstants.data] as! [String: Any]
                showSuccessMessage(with: StringConstants.unsavedProfileSuccess)

                self.allProfiles[self.selectedIndex].isSaved = 0
                result("success")
            }
            hideLoader()
        }
    }
    
    func proceesForMatchMakingSave(index:Int, _ result:@escaping(String?) -> Void) {
        var params = [String:Any]()
        params[WebConstants.profileId] = allProfiles[index].id
        params[WebConstants.status] = allProfiles[index].isSaved == 1 ? 0 : 1
        params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
        processForMatchMakingSavedProfileData(params: params, index: index) { response in
            result("Success")
        }
        
    }
    
    func processForMatchMakingSavedProfileData(params: [String: Any], index:Int, _ result:@escaping(String?) -> Void) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.UserMatchMaking.saveMatchMakingProfile,
                               params: params,
                               headers: headers,
                               method: .post) { response, _ in
            if !self.hasErrorIn(response) {
                _ = response![APIConstants.data] as! [String: Any]
               
                if self.allProfiles[index].isSaved == 1 {
                    self.allProfiles[index].isSaved = 0
                } else {
                    self.allProfiles[index].isSaved = 1
                }
                
                self.buttonsDidSets(profile: self.allProfiles[index])
//                self.tableView.reloadData()
                let popup = UIStoryboard(name: "SaveProfile", bundle: nil)
                if let popupvc = popup.instantiateViewController(withIdentifier: "SuccessfulViewController") as? SuccessfulViewController {
                    popupvc.callbacktopreviousscreen = {
                        if self.allProfiles[index].isSaved == 1 {
                            self.selectedProfile.isSaved = 1
                            self.callBacktoSaveAction?(index, 1)
                        } else {
                            self.selectedProfile.isSaved = 0
                            self.callBacktoSaveAction?(index, 0)
                        }
                    }
                    if self.allProfiles[index].isSaved == 1 {
                        popupvc.status = "Profile saved successfully for \(self.allProfiles[index].firstName ?? "")"
                    } else {
                        popupvc.status = "Profile unsaved successfully for \(self.allProfiles[index].firstName ?? "")"
                    }
                    popupvc.modalPresentationStyle = .overCurrentContext
                    self.hostViewController.present(popupvc, animated: true)
                }
                result("Success")
            }
            hideLoader()
        }
    }
    func proceedToReportScreen() {
        ReportViewController.show(from: self.hostViewController, isComeFor: "Detail", id: selectedProfile.id ?? "") { success in }
    }
    
    func proceedForShare(selectedIndex: Int) {
        ShareViewController.show(over: self.hostViewController, profileArray: [self.allProfiles[selectedIndex]])  { status in
            if status == "CreateGroup"{
                CreateGroupViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "group", profiles: [self.allProfiles[selectedIndex]],isNeedToSendLastMessgaeId: true) { success in
                }
            }
        }
    }
    
    func proceesForReject(index:Int) {
        var params = [String:Any]()
        params[WebConstants.profileId] = allProfiles[index].id
        params[WebConstants.isRejected] =  "1"
        allProfiles[index].isLiked = 0
        processForRejectProfileData(params: params, index:index)
    }
    
    func processForRejectProfileData(params: [String: Any], index:Int) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.LandingApis.rejectProfile,
                               params: params,
                               headers: headers,
                               method: .put) { response, _ in
            if !self.hasErrorIn(response) {
                _ = response![APIConstants.data] as! [String: Any]
                showMessage(with: "You have rejected this profile.", theme: .success)
                if self.allProfiles.indices.contains(index) {
                    self.previousSelectedIndex = index
                } else {
                    self.popBackToController()
                }
            }
            hideLoader()
        }
    }
    
    func processForUnRejectProfileData(params: [String: Any], _ result:@escaping(String?) -> Void) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.LandingApis.rejectProfile,
                               params: params,
                               headers: headers,
                               method: .put) { response, _ in
            if !self.hasErrorIn(response) {
                _ = response![APIConstants.data] as! [String: Any]
                result("success")
            }
            hideLoader()
        }
    }
    
    func undoProfile(selectedIndex: Int, previousIndex:Int, _ result:@escaping(String?) -> Void) {
        if allProfiles[selectedIndex-1].isLiked == 1 {
            var params = [String:Any]()
            params[WebConstants.profileId] = allProfiles[selectedIndex-1].id
            params[WebConstants.isLiked] = allProfiles[selectedIndex-1].isLiked == 1 ? 0 : 1
            
            processForUnLikeProfileData(params: params) { status in
                if status == "success" {
                    if self.allProfiles[selectedIndex-1].isSaved == 1 {
                        var params = [String:Any]()
                        params[WebConstants.profileId] = self.allProfiles[selectedIndex-1].id
                        params[WebConstants.status] = self.allProfiles[selectedIndex-1].isSaved == 1 ? 0 : 1
                        params[WebConstants.searchPreferenceId] = GlobalVariables.shared.searchPreferenceId
                        
                        self.processForUnSavedProfileData2(params: params) { status in
                            if status == "success" {
                                if self.allProfiles.indices.contains(selectedIndex) {
                                    result("success")
                                } else {
                                    self.popBackToController()
                                }
                            }
                        }
                    } else {
                        if self.allProfiles.indices.contains(selectedIndex) {
                            showMessage(with: "You have unliked the previous profile", theme: .success)
                            self.allProfiles[selectedIndex-1].isLiked = 0
                            self.previousSelectedIndex = selectedIndex - 1
                            self.kolodaView.revertAction()
                            result("success")
                        } else {
                            self.popBackToController()
                        }
                    }
                }
            }
        } else {
            var params = [String:Any]()
            params[WebConstants.profileId] = allProfiles[selectedIndex-1].id
            params[WebConstants.isRejected] =  "0"
            
            processForUnRejectProfileData(params: params) { status in
                if status == "success" {
                    if self.allProfiles[selectedIndex-1].isSaved == 1 {
                        var params = [String:Any]()
                        params[WebConstants.profileId] = self.allProfiles[selectedIndex-1].id
                        params[WebConstants.status] = self.allProfiles[selectedIndex-1].isSaved == 1 ? 0 : 1
                        params[WebConstants.searchPreferenceId] = GlobalVariables.shared.searchPreferenceId
                       
                        self.processForUnSavedProfileData2(params: params) { status in
                            if status == "success" {
                                if self.allProfiles.indices.contains(self.selectedIndex) {
                                    result("success")
                                } else {
                                    self.popBackToController()
                                }
                            }
                        }
                    } else {
                        if self.allProfiles.indices.contains(selectedIndex-1) {
                            showMessage(with: "Profile unliked successfully", theme: .success)
                            self.previousSelectedIndex = selectedIndex - 1
                            self.kolodaView.revertAction()
                        } else {
                            self.popBackToController()
                        }
                    }
                }
            }
        }
    }
}
