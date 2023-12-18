//
//  FullViewDetailViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 18/10/22.
//

import Foundation
import UIKit

class FullViewDetailViewModel: BaseViewModel {
    
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    var isComeFor = ""
    var forceBackToHome = false
    var notifications = [Notifications]()

    var completionHandler: ((Bool) -> Void)?
    var selectedProfile: ProfilesModel!
    var allProfiles: [ProfilesModel] = []
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
    
    var callBackForSelectCrossButton: ((_ selectedIndex:Int) ->())?
    var callBackForSelectUndoButton: ((_ selectedIndex:Int, _ prevoiusIndex:Int) ->())?
    var callBackForSelectShareButton: ((_ selectedIndex:Int) ->())?
    var callBackForSelectLikeButton: ((_ selectedIndex:Int) ->())?
    var callBackForSelectChatButton: ((_ selectedIndex:Int) ->())?
    var callBackForSelectSaveButton: ((_ selectedIndex:Int) ->())?
    var callBackForDownArrowButton: ((_ selectedIndex:Int) ->())?
    var callBackForSelectNextButton: ((_ selectedIndex:Int) ->())?
    var callBackForSelectPreviousButton: ((_ selectedIndex:Int) ->())?
    var callBackForOpenDetailAdsView: ((_ selectedIndex:Int) ->())?
    
    weak var tableView: UITableView! { didSet { configureTableView() } }
  
    private func configureTableView() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.insetsContentViewsToSafeArea = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50.0

        tableView.register(UINib(nibName: TableViewNibIdentifier.imageCell, bundle: nil), forCellReuseIdentifier: TableViewCellIdentifier.imageCell)
        
        tableView.register(UINib(nibName: TableViewNibIdentifier.interestCell, bundle: nil), forCellReuseIdentifier: TableViewCellIdentifier.interestCell)
        
        tableView.register(UINib(nibName: TableViewNibIdentifier.wishToCell, bundle: nil), forCellReuseIdentifier: TableViewCellIdentifier.wishToCell)
        
        tableView.register(UINib(nibName: TableViewNibIdentifier.partnerCell, bundle: nil), forCellReuseIdentifier: TableViewCellIdentifier.partnerCell)
        
        tableView.register(UINib(nibName: TableViewNibIdentifier.userImageCell, bundle: nil), forCellReuseIdentifier: TableViewCellIdentifier.userImageCell)
        
        tableView.register(UINib(nibName: TableViewNibIdentifier.familyAnddFriendCell, bundle: nil), forCellReuseIdentifier: TableViewCellIdentifier.familyAnddFriendCell)
        
        tableView.register(UINib(nibName: TableViewNibIdentifier.PersonalityCell, bundle: nil), forCellReuseIdentifier: TableViewCellIdentifier.PersonalityCell)
        
        tableView.register(UINib(nibName: TableViewNibIdentifier.WorkOutCell, bundle: nil), forCellReuseIdentifier: TableViewCellIdentifier.WorkOutCell)
        
        tableView.register(UINib(nibName: TableViewNibIdentifier.heightCell, bundle: nil), forCellReuseIdentifier: TableViewCellIdentifier.heightCell)
        
        tableView.register(UINib(nibName: TableViewNibIdentifier.moviesCell, bundle: nil), forCellReuseIdentifier: TableViewCellIdentifier.moviesCell)
        
        tableView.register(UINib(nibName: TableViewNibIdentifier.socialCell, bundle: nil), forCellReuseIdentifier: TableViewCellIdentifier.socialCell)
        
        tableView.register(UINib(nibName: TableViewNibIdentifier.galleryCell, bundle: nil), forCellReuseIdentifier: TableViewCellIdentifier.galleryCell)
        
        tableView.register(UINib(nibName: TableViewNibIdentifier.socialssCell, bundle: nil), forCellReuseIdentifier: TableViewCellIdentifier.socialssCell)
        
        self.preferencesArray.removeAll()
        self.preferencesTitleArray.removeAll()
        self.preferencesPassionArray.removeAll()
        self.preferencesPassionTitleArray.removeAll()
        self.heightArry.removeAll()
        self.heightTitleArry.removeAll()
        self.religionArry.removeAll()
        self.religionTitleArry.removeAll()
        
       //.......0
        if (allProfiles[selectedIndex].height != nil) {
            if allProfiles[selectedIndex].isHeightPrivate == 0{
                let heightType = allProfiles[selectedIndex].heightType
                let height = allProfiles[selectedIndex].height ?? ""
                if heightType == "Feet"{
                    if height != "" {
                        let val1 = height.components(separatedBy: ".")
                        if val1.count == 2{
                            let val2 = "\(val1[0])′"
                            let val3 = "\(val1[1])“"
                            let val4 = "\(val2)" + " " + "\(val3) ft"
                            print(val4)
                            self.heightArry.append(val4)
                            self.heightTitleArry.append("Height")
                        }else {
                            let val2 = "\(val1[0])′"
                            let val4 = "\(val2)"
                            print(val4)
                            self.heightArry.append(val4)
                            self.heightTitleArry.append("Height")
                        }
                    }
                } else {
                    let val = "\(height) cm"
                    self.heightArry.append(val)
                    self.heightTitleArry.append("Height")
                }
            }
        }
    
        if (allProfiles[selectedIndex].Religion != nil) {
            if allProfiles[selectedIndex].isReligionPrivate == 0{
                if (allProfiles[selectedIndex].height == nil) {
                    self.heightArry.append(allProfiles[selectedIndex].Religion?.name ?? "")
                    self.heightTitleArry.append("Religion")
                } else {
                    self.religionArry.append(allProfiles[selectedIndex].Religion?.name ?? "")
                    self.religionTitleArry.append("Religion")
                }
            }
        }
        
   //........1
        
        if (allProfiles[selectedIndex].Relationship != nil) {
            if allProfiles[selectedIndex].isRelationshipPrivate == 0{
                self.heightArry.append(allProfiles[selectedIndex].Relationship?.name ?? "")
                self.heightTitleArry.append("Relationship Status")
            }
        }
        
        if (allProfiles[selectedIndex].Education != nil) {
            if allProfiles[selectedIndex].isEducationPrivate == 0{
                if (allProfiles[selectedIndex].Relationship == nil) {
                    self.heightArry.append(allProfiles[selectedIndex].Education?.name ?? "")
                    self.heightTitleArry.append("Education level")
                } else {
                    self.religionArry.append(allProfiles[selectedIndex].Education?.name ?? "")
                    self.religionTitleArry.append("Education level")
                }
            }
        }
        
        //.......2
        if (allProfiles[selectedIndex].drinking != nil) {
            if allProfiles[selectedIndex].isDrinkingPrivate == 0{
                self.heightArry.append(allProfiles[selectedIndex].drinking?.name ?? "")
                self.heightTitleArry.append("Drinking")
            }
            
        }
        
        if (allProfiles[selectedIndex].smoking != nil) {
            if allProfiles[selectedIndex].isSmokingPrivate == 0{
                if (allProfiles[selectedIndex].drinking == nil) {
                    self.heightArry.append(allProfiles[selectedIndex].smoking?.name ?? "")
                    self.heightTitleArry.append("Smoking")
                } else {
                    self.religionArry.append(allProfiles[selectedIndex].smoking?.name ?? "")
                    self.religionTitleArry.append("Smoking")
                }
            }
        }
        
        //........3
        if (allProfiles[selectedIndex].sexualOrientation != nil) {
            if allProfiles[selectedIndex].isSexualOrientationPrivate == 0{
                self.heightArry.append(allProfiles[selectedIndex].sexualOrientation?.name ?? "")
                self.heightTitleArry.append("Sexual Orientation")
            }
        }
        
        if (allProfiles[selectedIndex].workout != nil) {
            if allProfiles[selectedIndex].isWorkoutPrivate == 0{
                if (allProfiles[selectedIndex].sexualOrientation == nil) {
                    self.heightArry.append(allProfiles[selectedIndex].workout?.name ?? "")
                    self.heightTitleArry.append("Workout")
                } else {
                    self.religionArry.append(allProfiles[selectedIndex].workout?.name ?? "")
                    self.religionTitleArry.append("Workout")
                }
            }
        }
      
        //........4
        if (allProfiles[selectedIndex].zodiac != nil) {
            if allProfiles[selectedIndex].isZodiacPrivate == 0{
                self.heightArry.append(allProfiles[selectedIndex].zodiac?.name ?? "")
                self.heightTitleArry.append("Zodiac")
            }
        }
        
        if (allProfiles[selectedIndex].kid != nil) {
            if allProfiles[selectedIndex].isKidsPrivate == 0{
                if (allProfiles[selectedIndex].zodiac == nil) {
                    self.heightArry.append(allProfiles[selectedIndex].kid?.name ?? "")
                    self.heightTitleArry.append("Kids")
                } else {
                    self.religionArry.append(allProfiles[selectedIndex].kid?.name ?? "")
                    self.religionTitleArry.append("Kids")
                }
            }
        }
        
        //........5
        if (allProfiles[selectedIndex].Ethnicity != nil) {
            if allProfiles[selectedIndex].isEthnicityPrivate == 0{
                self.heightArry.append(allProfiles[selectedIndex].Ethnicity?.name ?? "")
                self.heightTitleArry.append("Ethnicity")
            }
        }
        
        if (allProfiles[selectedIndex].personality != nil) {
            if allProfiles[selectedIndex].isPersonalityPrivate == 0{
                if (allProfiles[selectedIndex].Ethnicity == nil) {
                    self.heightArry.append(allProfiles[selectedIndex].personality?.name ?? "")
                    self.heightTitleArry.append("Personality")
                } else {
                    self.religionArry.append(allProfiles[selectedIndex].personality?.name ?? "")
                    self.religionTitleArry.append("Personality")
                }
            }
        }
    
        
        //----------6
        if (allProfiles[selectedIndex].WorkIndustry != nil) {
            if allProfiles[selectedIndex].isWorkIndustryPrivate == 0{
                self.preferencesArray.append(allProfiles[selectedIndex].WorkIndustry!)
                self.preferencesTitleArray.append("Work Industry")
            }
        }
        
        if (allProfiles[selectedIndex].userPassion != nil) {
            self.passionName.removeAll()
            if allProfiles[selectedIndex].isPassionsPrivate == 0{
                if allProfiles[selectedIndex].userPassion?.count != 0{
                    for i in 0..<(allProfiles[selectedIndex].userPassion?.count ?? 0){
                        let val = allProfiles[selectedIndex].userPassion?[i].passion?.name ?? ""
                        self.passionName.append(val)
                    }
                    let str = self.passionName.joined(separator: ", ")
                    self.preferencesPassionArray.append(str)
                    self.preferencesPassionTitleArray.append("Passion")
                }
            }
        }
        
        if (allProfiles[selectedIndex].userMovies != nil) {
            self.passionName.removeAll()
            if allProfiles[selectedIndex].isMoviesPrivate == 0{
                if allProfiles[selectedIndex].userMovies?.count != 0{
                    for i in 0..<(allProfiles[selectedIndex].userMovies?.count ?? 0){
                        let val = allProfiles[selectedIndex].userMovies?[i].movie?.name ?? ""
                        self.passionName.append(val)
                    }
                    let str = self.passionName.joined(separator: ", ")
                    self.preferencesPassionArray.append(str)
                    self.preferencesPassionTitleArray.append("Movie/TV genre")
                }
            }
        }
        
        if (allProfiles[selectedIndex].userMusic != nil) {
            self.passionName.removeAll()
            if allProfiles[selectedIndex].isPassionsPrivate == 0{
                if allProfiles[selectedIndex].userMusic?.count != 0{
                    for i in 0..<(allProfiles[selectedIndex].userMusic?.count ?? 0){
                        let val = allProfiles[selectedIndex].userMusic?[i].music?.name ?? ""
                        self.passionName.append(val)
                    }
                    let str = self.passionName.joined(separator: ", ")
                    self.preferencesPassionArray.append(str)
                    self.preferencesPassionTitleArray.append("Music genre")
                }
            }
        }
        
        if (allProfiles[selectedIndex].usersSports != nil) {
            self.passionName.removeAll()
            if allProfiles[selectedIndex].isSportsPrivate == 0{
                if allProfiles[selectedIndex].usersSports?.count != 0{
                    for i in 0..<(allProfiles[selectedIndex].usersSports?.count ?? 0){
                        let val = allProfiles[selectedIndex].usersSports?[i].sport?.name ?? ""
                        self.passionName.append(val)
                    }
                    let str = self.passionName.joined(separator: ", ")
                    self.preferencesPassionArray.append(str)
                    self.preferencesPassionTitleArray.append("Sports")
                }
            }
        }
        if (allProfiles[selectedIndex].usersBooks != nil) {
            self.passionName.removeAll()
            if allProfiles[selectedIndex].isBooksPrivate == 0{
                if allProfiles[selectedIndex].usersBooks?.count != 0{
                    for i in 0..<(allProfiles[selectedIndex].usersBooks?.count ?? 0){
                        let val = allProfiles[selectedIndex].usersBooks?[i].book?.name ?? ""
                        self.passionName.append(val)
                    }
                    let str = self.passionName.joined(separator: ", ")
                    self.preferencesPassionArray.append(str)
                    self.preferencesPassionTitleArray.append("Books")
                }
            }
        }
        
        
        
        if (allProfiles[selectedIndex].instagram != nil) {
            if let instagram = allProfiles[selectedIndex].instagram {
                self.instagramLink = instagram
            }
        }
        
        if (allProfiles[selectedIndex].twitter != nil) {
            if let instagram = allProfiles[selectedIndex].twitter {
                self.twiiterLink = instagram
            }
        }
        
        if (allProfiles[selectedIndex].linkdin != nil) {
            if let instagram = allProfiles[selectedIndex].linkdin {
                self.linkedInLink = instagram
            }
        }
        
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
    }
    
    func rightSwipe(){
        print("Right Swipe")
    }
    
    func leftSwipe(){
        print("lift Swipe")
    }
    
    // MARK: - API Call...
    func processForGetUserPreferenceProfileData(_ result:@escaping([String: Any]?) -> Void) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.UserApis.getUserPreferenceDetail,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .get) { response, _ in
            if !self.hasErrorIn(response) {
                DispatchQueue.main.async {
                    if let userResponseData = response![APIConstants.data] as? [String: Any] {
                        if let userPreferences = userResponseData["userPreferences"] as? [[String:Any]] {
                            _ = userPreferences[0]
                        }
                    }
                }
            }
        }
    }
    
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
    
    func proceedForHome() {
        KAPPDELEGATE.updateRootController(TabBarController.getController(),
                                          transitionDirection: .toLeft,
                                          embedInNavigationController: true)
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
                _ = response![APIConstants.data] as! [String: Any]
                
                showSuccessMessage(with: StringConstants.BlockSuccess)
                delay(0.5){
                    self.popBackToController()
                }
              //  self.hostViewController.backButtonTapped(self)
                
            }
            hideLoader()
        }
    }
    
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
            processForLikeProfileData(params: params)
        } else {
            if self.allProfiles.indices.contains(self.selectedIndex) {
                self.allProfiles[self.selectedIndex].isLiked = 1
                let lastElement = self.allProfiles.count - 1
                if self.selectedIndex == lastElement {
                    self.popBackToController()
                } else {
                    self.callBacktoMainScreen?(index)
                }
            } else {
                self.popBackToController()
            }
        }
    }
    
    func processForLikeProfileData(params: [String: Any]) {
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
                        if self.allProfiles.indices.contains(self.selectedIndex) {
                            self.allProfiles[self.selectedIndex].isLiked = 1
                            let lastElement = self.allProfiles.count - 1
                            if self.selectedIndex == lastElement {
                                self.popBackToController()
                            } else {
                                self.callBacktoMainScreen?(self.selectedIndex)
                            }
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
//                    self.callBacktoMainScreen?()
//                    self.selectedIndex += 1
                    self.selectedProfile.isSaved = 1
                    self.tableView.reloadData()
                   result("Success")
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

                self.allProfiles[index].isSaved = 0
//                self.selectedIndex += 1
                if self.allProfiles.indices.contains(index) {
//                    self.callBacktoMainScreen?()
                    self.selectedProfile.isSaved = 0
                    self.tableView.reloadData()
                    result("Success")
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
                        self.tableView.reloadData()
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
//                self.selectedIndex += 1
                showMessage(with: "You have rejected this profile.", theme: .success)
                if self.allProfiles.indices.contains(index) {
                    let lastElement = self.allProfiles.count - 1
                    if self.selectedIndex == lastElement {
                        self.popBackToController()
                    } else {
                        self.callBackForReject?(index)
                    }
                    
//                    self.tableView.reloadData()
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
                                if self.allProfiles.indices.contains(self.selectedIndex) {
                                    self.tableView.reloadData()
                                    result("success")
                                } else {
                                    self.popBackToController()
                                }
                            }
                        }
                    } else {
                        if self.allProfiles.indices.contains(self.selectedIndex) {
                            showMessage(with: "You have unliked the previous profile", theme: .success)
                            self.callBacktoPreviosScreen?(self.selectedIndex)
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
                                    self.tableView.reloadData()
                                    result("success")
                                } else {
                                    self.popBackToController()
                                }
                            }
                        }
                    } else {
                        if self.allProfiles.indices.contains(self.selectedIndex) {
                            showMessage(with: "Profile unliked successfully", theme: .success)
                            self.callBacktoPreviosScreen?(self.selectedIndex)
                        } else {
                            self.popBackToController()
                        }
                    }
                }
            }
        }
    }
    func scrollToBottom(indexPath: IndexPath) {
        if self.allProfiles.count != 0{
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
        
            let numberOfSections = self.tableView.numberOfSections
            let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)

            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }

    func openPreviewController(images: [LightboxImage], selectedIndex : Int) {
        let controller = LightboxController(images: images, startIndex: selectedIndex)
        controller.dynamicBackground = true
        KAPPSTORAGE.isLightBoxOpenForChat = ""
        self.hostViewController.present(controller, animated: true, completion: nil)
    }
    
    
    func proceedForNextProfile(selectedIndex: Int) {
//        self.selectedIndex += 1
//        self.tableView.reloadData()
        self.callBacktoMainScreen?(selectedIndex)
    }
    
    func proceedForPreviousProfile(selectedIndex: Int) {
//        self.selectedIndex -= 1
//        self.tableView.reloadData()
        self.callBacktoPreviosScreen?(selectedIndex)
    }
    
    func proceedForOpenDetailAdsView(){
        let controller = DetailAdsViewController.getController() as! DetailAdsViewController
        controller.dismissCompletion = { value  in }
        controller.show(over: self.hostViewController) { value  in }
    }
    
    
    
    //MARK: Handle icons Actions ....
    
    func proceedForSelectUndoButton(selectedIndex: Int, previousIndex: Int) {
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
                popupvc.modalPresentationStyle = .overCurrentContext
                self.hostViewController.present(popupvc, animated: true)
            }
        }
    }
    
    func proceedForSelectCrossButton(selectedIndex:Int) {
        print(selectedIndex)
        if self.allProfiles.indices.contains(selectedIndex) {
            self.proceesForReject(index: selectedIndex)
        } else {
            self.popBackToController()
        }
    }
    
    func proceedForSelectLikeButton(selectedIndex:Int) {
        print(selectedIndex)
        if self.allProfiles.indices.contains(selectedIndex) {
            self.proceesForLike(index: selectedIndex)
        } else {
            self.popBackToController()
        }
    }
    
    func proceedForSelectChatButton(selectedIndex: Int) {
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
    
    func proceedForSelectSaveButton(selectedIndex:Int, _ result:@escaping(String?) -> Void) {
        print(selectedIndex)
        if self.allProfiles.indices.contains(selectedIndex) {
            if self.allProfiles[selectedIndex].isSaved == 0 {
                if self.isComeFor == "MatchMakingProfile" {
                    self.proceesForMatchMakingSave(index: selectedIndex) { response in
                        result("Success")
                    }
                } else {
                    self.proceesForSave(index: selectedIndex) { response in
                        result("Success")
                    }
                }
            } else {
                if self.isComeFor == "MatchMakingProfile" {
                    self.proceesForMatchMakingSave(index: selectedIndex) { response in
                        result("Success")
                    }
                } else{
                    self.proceesForSave(index: selectedIndex) { response in
                        result("Success")
                    }
                }
            }
        } else {
            self.popBackToController()
        }
    }
}

extension FullViewDetailViewModel:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 16
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(selectedIndex)
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else if section == 2 {
            if self.allProfiles.indices.contains(selectedIndex) {
                var profilesss: ProfilesModel?
                profilesss = self.allProfiles[selectedIndex]
                if profilesss?.userWishingToHavePreferences?.count == 0 || profilesss?.userWishingToHavePreferences == nil || profilesss?.isWishingToHavePrivate == 0 {
                    return 0
                } else {
                    return 1
                }
            }
            return 0
        } else if section == 3 {
            if allProfiles[selectedIndex].Education?.name != "" || allProfiles[selectedIndex].WorkIndustry?.name != "" {
                if allProfiles[selectedIndex].Education?.name != nil || allProfiles[selectedIndex].WorkIndustry?.name != nil {
                    return 1
                }
            }
            else if allProfiles[selectedIndex].userQuestionAnswer?.count != 0 {
                for i in 0..<(allProfiles[selectedIndex].userQuestionAnswer?.count ?? 0) {
                    if allProfiles[selectedIndex].userQuestionAnswer?[i].questionAbout?.question == "What do i look for in my partner?" {
                        if allProfiles[selectedIndex].userQuestionAnswer?[i].answer != "" {
                            return 1
                        }
                    }
                }
            } else if allProfiles[selectedIndex].Education?.name == "" || allProfiles[selectedIndex].WorkIndustry?.name == "" || allProfiles[selectedIndex].Education?.name == nil || allProfiles[selectedIndex].WorkIndustry?.name == nil || allProfiles[selectedIndex].isWorkIndustryPrivate == 0 || allProfiles[selectedIndex].isEducationPrivate == 0 {
                return 0
            } else {
                return 0
            }
            return 0
        } else if section == 4 {
            return 1
        } else if section == 5 {
            if allProfiles[selectedIndex].userPassion?.count != 0 {
                return 1
            } else if allProfiles[selectedIndex].userQuestionAnswer?.count != 0 {
                for i in 0..<(allProfiles[selectedIndex].userQuestionAnswer?.count ?? 0) {
                    if allProfiles[selectedIndex].userQuestionAnswer?[i].questionAbout?.question == "My family and friend describe me as." {
                        if allProfiles[selectedIndex].userQuestionAnswer?[i].answer != "" {
                            return 1
                        }
                    }
                }
            } else if allProfiles[selectedIndex].userPassion?.count != 0 || allProfiles[selectedIndex].isPassionsPrivate != 0 {
                return 1
            } else {
                return 0
            }
            return 0
        } else if section == 6 {
            if self.allProfiles.indices.contains(selectedIndex) {
                if self.allProfiles[selectedIndex].userImages?.count ?? 0 >= 3 {
                    return 1
                }
            }
            return 0
        } else if section == 7 {
            return 1
        } else if section == 8 {
            if self.allProfiles.indices.contains(selectedIndex) {
                if self.allProfiles[selectedIndex].userImages?.count ?? 0 >= 4 {
                    return 1
                }
            }
            return 0
        } else if section == 9 {
            return 1
        } else if section == 10 {
            if self.allProfiles.indices.contains(selectedIndex) {
                if self.allProfiles[selectedIndex].userImages?.count ?? 0 == 5 {
                    return 1
                } else if self.allProfiles[selectedIndex].userImages?.count ?? 0 == 6 {
                    return 2
                } else if self.allProfiles[selectedIndex].userImages?.count ?? 0 == 7 {
                    return 3
                }
            }
            return 0
        } else if section == 11 {
            if self.instagramLink == "" && self.twiiterLink == "" && self.linkedInLink == ""{
                return 0
            } else {
                return 1
            }
        }
        return 0
//        else if section == 12 {
//            return 0 //self.preferencesArray.count
//        } else if section == 13 {
//            return 0 //self.preferencesPassionArray.count
//        } else if section == 14 {
//            if self.instagramLink == "" && self.twiiterLink == "" && self.linkedInLink == ""{
//                return 0
//            } else {
//                return 0
//            }
//        } else {
//            return 0
//        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.imageCell, for: indexPath) as? ImageTableViewCell {
                cell.index = selectedIndex
                cell.cellIndex = indexPath.row
                cell.previousIndex = previousSelectedIndex
                cell.isComeFor = self.isComeFor
                cell.allProfiles = self.allProfiles
            
                if user.isSubscriptionPlanActive == 0 {
                    cell.undoButtonView.isHidden = true
                } else {
                    if previousSelectedIndex != index {
                        cell.undoButtonView.isHidden = false
                    } else {
                        cell.undoButtonView.isHidden = true
                    }
                }
                // update like and chat button state ...
                if let liked = selectedProfile.isLiked {
                    if liked == 1 {
                        cell.likeImage.image = UIImage(named: "Ic_chat")
                    } else {
                        cell.likeImage.image = UIImage(named: "Im_whiteLike")
                    }
                }
                // update save button state ...
                if let liked = selectedProfile.isSaved {
                    if liked == 1 {
                        cell.saveImage.image = UIImage(named: "Im_Saved_tick")
                    } else {
                        cell.saveImage.image = UIImage(named: "Ic_save 1")
                    }
                }
                if isComeFor == "Profile" {
                    cell.sideMenuStack.isHidden = true
                    cell.saveButtonView.isHidden = true
                    cell.prevoiusButtonView.isHidden = true
                    cell.nextButtonView.isHidden = true
                } else if isComeFor == "SavedPreferences" {
                    cell.sideMenuStack.isHidden = false
                    cell.saveButtonView.isHidden = false
                    cell.likeButtonView.isHidden = true
                    cell.crossButtonView.isHidden = true
                    let lastElement = self.allProfiles.count - 1
                    print(lastElement)
                    
                    if selectedIndex == lastElement {
                        cell.nextButtonView.isHidden = true
                    } else {
                        cell.nextButtonView.isHidden = false
                    }

                    if controllerIndex == 0 {
                        cell.prevoiusButtonView.isHidden = true
                    } else {
                        cell.prevoiusButtonView.isHidden = false
                    }
                    
                } else if isComeFor == "MatchMakingProfile" {
                    cell.sideMenuStack.isHidden = false
                    cell.undoButtonView.isHidden = true
                    cell.likeButtonView.isHidden = true
                    cell.crossButtonView.isHidden = true

                    let lastElement = self.allProfiles.count - 1
                    print(lastElement)
                    
                    if selectedIndex == lastElement {
                        cell.nextButtonView.isHidden = true
                    } else {
                        cell.nextButtonView.isHidden = false
                    }

                    if controllerIndex == 0 {
                        cell.prevoiusButtonView.isHidden = true
                    } else {
                        cell.prevoiusButtonView.isHidden = false
                    }
                    
                } else if isComeFor == "BrowseAndSkip" {
                    cell.sideMenuStack.isHidden = false
                    cell.undoButtonView.isHidden = true
                    cell.likeButtonView.isHidden = true
                    cell.crossButtonView.isHidden = true
                    cell.saveButtonView.isHidden = true
                    
                    let lastElement = self.allProfiles.count - 1
                    print(lastElement)
                    
                    if selectedIndex == lastElement {
                        cell.nextButtonView.isHidden = true
                    } else {
                        cell.nextButtonView.isHidden = false
                    }

                    if controllerIndex == 0 {
                        cell.prevoiusButtonView.isHidden = true
                    } else {
                        cell.prevoiusButtonView.isHidden = false
                    }
                } else {
                    cell.sideMenuStack.isHidden = false
                    cell.saveButtonView.isHidden = true //false
                    cell.prevoiusButtonView.isHidden = true
                    cell.nextButtonView.isHidden = true
                    if isFrom == "Likes" || isFrom == "Aligned" {
                        cell.undoButtonView.isHidden = true
                    } else {
                        if controllerIndex == 0 {
                            cell.undoButtonView.isHidden = true
                        } else {
                            cell.undoButtonView.isHidden = false
                        }
                    }
                }
                
                
                
                cell.sideMenuStack.isHidden = true
                
                if self.allProfiles.indices.contains(selectedIndex) {
                    cell.profile = self.allProfiles[selectedIndex]
                }
//                cell.collectionView.tag = indexPath.row
//                cell.collectionView.reloadData()
                
                
                cell.callBackForSelectCrossButton = { selectedIndex in
                    print(selectedIndex)
                    if self.allProfiles.indices.contains(selectedIndex) {
                        self.proceesForReject(index: selectedIndex)
                    } else {
                        self.popBackToController()
                    }
                }
                cell.callBackForSelectUndoButton = { selectedIndex, previousIndex in
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
                            popupvc.modalPresentationStyle = .overCurrentContext
                            self.hostViewController.present(popupvc, animated: true)
                        }
                    }
                }
                cell.callBackForSelectShareButton = { selectedIndex in
                    print(selectedIndex)
                    self.proceedForShare(selectedIndex: selectedIndex)
                }
                cell.callBackForSelectLikeButton = { selectedIndex in
                    print(selectedIndex)
                    if self.allProfiles.indices.contains(selectedIndex) {
                        self.proceesForLike(index: selectedIndex)
                    } else {
                        self.popBackToController()
                    }
                }
                
                cell.callBackForSelectChatButton = { selectedIndex in
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
                
                cell.callBackForDownArrowButton = { selectedIndex in
                    print(selectedIndex)
                    self.scrollToBottom(indexPath: indexPath)
                }
                
                cell.callBackForSelectSaveButton = { selectedIndex in
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
                
                cell.callBackForSelectNextButton = { selectedIndex in
                    print(selectedIndex)
                    self.proceedForNextProfile(selectedIndex: selectedIndex)
                }
                
                cell.callBackForSelectPreviousButton = { selectedIndex in
                    print(selectedIndex)
                    self.proceedForPreviousProfile(selectedIndex: selectedIndex)
                }
                
                cell.callBackForOpenDetailAdsView = { selectedIndex in
                    print(selectedIndex)
                    self.proceedForOpenDetailAdsView()
                }
                
                return cell
            }
        }
        else if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.interestCell, for: indexPath) as? InterestTableViewCell {
                if self.allProfiles.indices.contains(selectedIndex) {
                    cell.profile = self.allProfiles[selectedIndex]
                }
                return cell
            }
        }
        else if indexPath.section == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.wishToCell, for: indexPath) as? HaveToWishTableViewCell {
                if self.allProfiles.indices.contains(selectedIndex) {
                    cell.profile = self.allProfiles[selectedIndex]
                }
                return cell
            }
        }
        else if indexPath.section == 3 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.partnerCell, for: indexPath) as? PartnerTableViewCell {
                if self.allProfiles.indices.contains(selectedIndex) {
                    cell.profile = self.allProfiles[selectedIndex]
                }
                return cell
            }
        }
        else if indexPath.section == 4 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.userImageCell, for: indexPath) as? UserImageTableCell {
                cell.userImageView.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + (self.allProfiles[selectedIndex].userImages?[1].file ?? ""))), placeholderImage: #imageLiteral(resourceName: "Avatar"), completed: nil)
                return cell
            }
        }
        else if indexPath.section == 5 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.familyAnddFriendCell, for: indexPath) as? FamilyAndFriendTableCell {
                if self.allProfiles.indices.contains(selectedIndex) {
                    cell.profile = self.allProfiles[selectedIndex]
                }
                return cell
            }
        }
        else if indexPath.section == 6 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.userImageCell, for: indexPath) as? UserImageTableCell {
                cell.userImageView.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + (self.allProfiles[selectedIndex].userImages?[2].file ?? ""))), placeholderImage: #imageLiteral(resourceName: "Avatar"), completed: nil)
                return cell
            }
        }
        else if indexPath.section == 7 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.PersonalityCell, for: indexPath) as? PersonalityTableCell {
                if self.allProfiles.indices.contains(selectedIndex) {
                    cell.profile = self.allProfiles[selectedIndex]
                }
                return cell
            }
        }
        else if indexPath.section == 8 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.userImageCell, for: indexPath) as? UserImageTableCell {
                cell.userImageView.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + (self.allProfiles[selectedIndex].userImages?[3].file ?? ""))), placeholderImage: #imageLiteral(resourceName: "Avatar"), completed: nil)
                return cell
            }
        }
        else if indexPath.section == 9 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.WorkOutCell, for: indexPath) as? WorkOutTableCell {
                if self.allProfiles.indices.contains(selectedIndex) {
                    cell.profile = self.allProfiles[selectedIndex]
                }
                return cell
            }
        }
        else if indexPath.section == 10 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.userImageCell, for: indexPath) as? UserImageTableCell {
                var currentIndex = indexPath.row + 4
                cell.userImageView.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + (self.allProfiles[selectedIndex].userImages?[currentIndex].file ?? ""))), placeholderImage: #imageLiteral(resourceName: "Avatar"), completed: nil)
                return cell
            }
        }
        else if indexPath.section == 14 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.heightCell, for: indexPath) as? HeightTableViewCell {
                
                if self.heightTitleArry.count != 0 {
                    if self.heightArry.indices.contains(indexPath.row) {
                        let title1 = self.heightTitleArry[indexPath.row]  + "\n"
                        let desc1 = self.heightArry[indexPath.row]
                        
                        let longString = title1 + desc1
                        if longString != "\n" {
                            let longestWordRange = (longString as NSString).range(of: desc1)
                            
                            let attributedString = NSMutableAttributedString(string: longString, attributes: [NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Medium", size: 18.0)!, NSAttributedString.Key.foregroundColor : UIColor.white])
                            
                            attributedString.setAttributes([NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Regular", size: 16.0)!, NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.8)], range: longestWordRange)
                            cell.titleOne.attributedText = attributedString.withLineSpacing(5)
                        } else {
                            cell.titleOne.text = ""
                        }
                    }
                } else {
                    cell.titleOne.text = ""
                }
                
                if self.religionTitleArry.count != 0 {
                    if self.religionArry.indices.contains(indexPath.row) {
                        
                        let title2 = self.religionTitleArry[indexPath.row] + "\n"
                        let desc2 = self.religionArry[indexPath.row]
                        
                        let longString2 = title2 + desc2
                        if longString2 != "\n" {
                            let longestWordRange2 = (longString2 as NSString).range(of: desc2)
                            
                            let attributedString2 = NSMutableAttributedString(string: longString2, attributes: [NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Medium", size: 18.0)!, NSAttributedString.Key.foregroundColor : UIColor.white])
                            
                            attributedString2.setAttributes([NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Regular", size: 16.0)!, NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.8)], range: longestWordRange2)
                            
                            
                            cell.titleTwo.attributedText = attributedString2.withLineSpacing(5)
                        } else {
                            cell.titleTwo.text = ""
                        }
                    }
                } else {
                    cell.titleTwo.text = ""
                }
                
                return cell
            }
        }
        else if indexPath.section == 12 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.moviesCell, for: indexPath) as? MovieTableViewCell {
                cell.titleLabel.text = self.preferencesTitleArray[indexPath.row]
                cell.descLable.text = self.preferencesArray[indexPath.row].name
                return cell
            }
        }
        else if indexPath.section == 13 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.moviesCell, for: indexPath) as? MovieTableViewCell {
                cell.titleLabel.text = self.preferencesPassionTitleArray[indexPath.row]
                cell.descLable.text = self.preferencesPassionArray[indexPath.row]
                return cell
            }
        }
        else if indexPath.section == 11 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.socialssCell, for: indexPath) as? SocialTableCell {
                
                if self.instagramLink == "" && self.twiiterLink == "" && self.linkedInLink == "" {
//                    cell.socialLabelTitle.isHidden = false//true
                    cell.instagramImage.isHidden = false //true
                    cell.twitterImage.isHidden = false //true
                    cell.linkedInImage.isHidden = false //true
                }
                if self.instagramLink != "" {
//                    if self.instagramLink.lowercased().range(of:"instagram") != nil {
//                        cell.socialLabelTitle.isHidden = false
                        cell.instagramImage.isHidden = false
//                    } else {
//                        cell.instagramImage.isHidden = true
//                    }
                } else {
                    cell.instagramImage.isHidden = true
                }
                
                if self.twiiterLink != "" {
//                    if self.twiiterLink.lowercased().range(of:"twitter") != nil {
//                        cell.socialLabelTitle.isHidden = false
                        cell.twitterImage.isHidden = false
//                    }else {
//                        cell.twitterImage.isHidden = true
//                    }
                } else {
                    cell.twitterImage.isHidden = true
                }
                
                if self.linkedInLink != "" {
//                    if self.linkedInLink.lowercased().range(of:"linkedin") != nil {
//                        cell.socialLabelTitle.isHidden = false
                        cell.linkedInImage.isHidden = false
//                    }else{
//                        cell.linkedInImage.isHidden = true
//                    }
                } else {
                    cell.linkedInImage.isHidden = true
                }
                
                return cell
            }
        }
        else if indexPath.section == 15 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.galleryCell, for: indexPath) as? GalleryTableViewCell{
                cell.collectionView.tag = indexPath.row

                if self.allProfiles.count != 0 {
                    if self.allProfiles.indices.contains(self.selectedIndex) {
                        cell.userImages = self.allProfiles[selectedIndex].userImages
                    }
                }
                DispatchQueue.main.async {
                    cell.collectionView.reloadData()
                }
                
                cell.callBackForPreviewImages = { images, selectedIndex in
                    self.openPreviewController(images: images, selectedIndex: selectedIndex)
                }
                
                
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
//            let screenRect = UIScreen.main.bounds
//            let screenHeight = screenRect.size.height
//            if #available(iOS 13.0, *) {
//                let window = KAPPDELEGATE.window
//                let topPadding = window?.safeAreaInsets.top
//                let bottomPadding = window?.safeAreaInsets.bottom
//                print(topPadding as Any, bottomPadding as Any)
//            }
//            print(self.hostViewController.tabBarController?.tabBar.frame.size.height as Any)
//            if let tabbarHeight = self.hostViewController.tabBarController?.tabBar.frame.size.height as? CGFloat {
//                return screenHeight - tabbarHeight
//            }
//            return screenHeight
            return 520
        } else if indexPath.section == 11 {
            return 50
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            return UIView()
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.section == 0{
//            if indexPath.row == 0{
//                if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.imageCell, for: indexPath) as? ImageTableViewCell{
//                    cell.animateDownArrow()
//                }
//            }
//        }
//    }
}
