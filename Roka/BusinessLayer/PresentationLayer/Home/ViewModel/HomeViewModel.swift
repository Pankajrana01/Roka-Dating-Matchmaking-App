//
//  HomeViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 23/09/22.
//

import Foundation
import UIKit

class HomeViewModel: BaseViewModel {
    var isComeFor = ""
    var profileArr: [ProfilesModel] = []
    var title = ""
    var current_page = 0
    var completionHandler: ((Bool) -> Void)?
    var isMoreRecordAvailable = false
    let user = UserModel.shared.user
    var storedUser = KAPPSTORAGE.user
    var type = ""
    let array = [
        HomeNotDataModel(image: UIImage(named: "Ic_no_dota_found")!, labelFirst: "Oops! No Profiles" , labelSecond: "See profiles near you here."),
        
        HomeNotDataModel(image: UIImage(named: "Ic_no_dota_found")!, labelFirst: "Oops! No Profiles", labelSecond: "See profiles For You based on your preferences here."),
        
        HomeNotDataModel(image: UIImage(named: "Ic_no_dota_found")!, labelFirst: "Oops! No Profiles", labelSecond: "See profiles you like here."),
        
        HomeNotDataModel(image: UIImage(named: "Ic_no_dota_found")!, labelFirst: "Oops! No Profiles", labelSecond: "See profiles who like you here."),
        
        HomeNotDataModel(image: UIImage(named: "Ic_no_dota_found")!, labelFirst: "Oops! No Profiles", labelSecond: "See profiles you have aligned with here.")
    ]
    
    func getNoDataValue(at index: Int) -> HomeNotDataModel {
        return self.array[index]
    }
    
    var collectionView: UICollectionView! { didSet { configureCollectionView() } }

    private func configureCollectionView() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = false
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        
        collectionView.register(UINib(nibName: CollectionViewNibIdentifier.homeNib, bundle: nil),
                                forCellWithReuseIdentifier: CollectionViewCellIdentifier.homecell)
        
        
    }
    
    
    func proceedToLandingWalkthrough() {
        LandingWalkThroughViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "") { success in

        }
    }
    
    
    func proceedForLogout() {
        let controller = LogoutViewController.getController() as! LogoutViewController
        controller.dismissCompletion = { value  in }
        controller.show(over: self.hostViewController) { value  in
        }
    }
    
    func proceedToDetailScreen(profile: ProfilesModel, index:Int) {
        PageFullViewVC.show(from: self.hostViewController, forcePresent: false, forceBackToHome: false, isFrom: self.title, isComeFor: "home", selectedProfile: profile, allProfiles: profileArr, selectedIndex: index) { success in

        }
    }
    
    func getProfileUrl(_ result:@escaping(String?) -> Void) {
        let url = self.title == "Nearby" ? APIUrl.LandingApis.nearByProfiles : self.title == "For you" ? APIUrl.LandingApis.suggestedProfiles : self.title == "Likes" ? APIUrl.LandingApis.likedProfilesV1 : self.title == "Aligned" ? APIUrl.LandingApis.matchedProfiles : APIUrl.LandingApis.nearByProfiles
        result(url)
    }
    
    func getProfiles(url:String, page:String, type:String) {
        var param = [String: Any]()
        self.type = type
        if type == "" {
            if self.title == "For you" || self.title == "Aligned" {
                param = [ "limit": 20, "skip": page] as [String: Any]
            } else {
                param = [ "limit": 20, "skip": page] as [String: Any]
            }
        } else {
            param = [ "limit": 20, "skip": page, "type": type] as [String: Any]
        }
        
        
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        showLoader()
        print("=======>>>>>",param, url)
        
        ApiManagerWithCodable<ProfilesResponseModel>.makeApiCall(url, params: param,
                                                                 headers: headers,
                                                                 method: .get) { (response, resultModel) in
            DispatchQueue.main.async {
                if let result = resultModel, result.statusCode == 200, result.data.count == 0 {
                    if page == "0" {
                        self.isMoreRecordAvailable = false
                        self.profileArr.removeAll()
                    }
                    if self.profileArr.count > 0 {
                        self.collectionView.isHidden = false
                    } else {
                        self.collectionView.isHidden = true
                    }
                    hideLoader()
                } else if resultModel?.statusCode == 200 {
                    if page == "0" {
                        self.isMoreRecordAvailable = false
                        self.profileArr.removeAll()
                    }
                    self.collectionView.isHidden = false
                    
                    if resultModel?.data.count == 20 {
                        self.isMoreRecordAvailable = true
                    } else {
                        self.isMoreRecordAvailable = false
                    }
                    self.profileArr.append(contentsOf: resultModel?.data ?? [])
                    //                DispatchQueue.global().async {
                    //                    DispatchQueue.main.async {
                    hideLoader()
                    self.collectionView.reloadData()
                    self.collectionView.layoutIfNeeded()
                    //                    }
                    //                }
                }
                else {
                    hideLoader()
                    showMessage(with: response?["message"] as? String ?? "")
                    self.collectionView.isHidden = true
                }
            }
        }
    }
    
    // MARK: - API Call...
    func processForGetUserProfileData(_ result:@escaping([String: Any]?) -> Void) {
//        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.UserApis.getUserProfileDetail,
                               headers: headers,
                               method: .get) { response, _ in
            if !self.hasErrorIn(response) {
                DispatchQueue.main.async {
                    let userResponseData = response![APIConstants.data] as! [String: Any]
                    result(userResponseData)
                    
                }
//                hideLoader()
            }
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
//            hideLoader()
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
    
    func proceedForBuyPremiumScreen() {
        BuyPremiumViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "Profile") { success in
        }
    }
}

extension HomeViewModel : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - Collection Delegate & DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if profileArr.count != 0 {
            return profileArr.count
        } else {
            return 0
        }
    }
    
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.homecell, for: indexPath) as? HomeCollectionViewCell {
            cell.savedProfileImage.isHidden = true
          //  cell.saveButton.isHidden = true
            cell.prepareForReuse()
            cell.profile = self.profileArr[indexPath.item]
            cell.favButton.tag = indexPath.row
            cell.saveButton.tag = indexPath.row
            switch self.title {
            case "Nearby":
                cell.bgView.backgroundColor = .appSkyLightBlueColor
                cell.bgView.borderColor = .clear
            case "For you":
                cell.bgView.backgroundColor = .white
                cell.bgView.borderColor = .forYouBorderColor
            case "Likes":
                cell.bgView.backgroundColor = .appLightBlueColor
                cell.bgView.borderColor = .clear
            case "Aligned":
                cell.bgView.backgroundColor = .appLightOrangeColor
                cell.bgView.borderColor = .clear
            default: break
            }
            
            cell.callBackForSelectLikeButtons = { index in
                if self.profileArr.count != 0 {
                    self.proceedToDetailScreen(profile: self.profileArr[index], index: index)
                }
            }
            
            cell.callBackForSelectChatButtons = { index in
                let profile = self.profileArr[index]
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
            }
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }

   @objc func favButtonAction(_ sender: UIButton){
//       var params = [String:Any]()
//       params[WebConstants.profileId] = self.profileArr[sender.tag].id
//       params[WebConstants.isLiked] = self.profileArr[sender.tag].isLiked == 1 ? 0 : 1
//       processForLikeProfileData(params: params)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenRect = UIScreen.main.bounds
        let screenHeight = screenRect.size.height
        if screenHeight >= 812 {
//            return CGSize.init(width: self.hostViewController.view.frame.size.width/2 - 20, height: self.hostViewController.view.frame.size.height/2.6)
            return CGSize.init(width: self.hostViewController.view.frame.size.width/2 - 20, height: 210)
        } else {
//            return CGSize.init(width: self.hostViewController.view.frame.size.width/2 - 20, height: self.hostViewController.view.frame.size.height/2.3)
            return CGSize.init(width: self.hostViewController.view.frame.size.width/2 - 20, height: 210)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        /// vertical spacing
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.profileArr.count != 0 {
            proceedToDetailScreen(profile: self.profileArr[indexPath.row], index: indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.profileArr.count - 1 && self.isMoreRecordAvailable {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.getProfileUrl { url in
                    self.current_page = self.profileArr.count
                    self.getProfiles(url: url ?? "", page: "\(self.current_page)", type: self.type)
                }
            }
        }
    }
}

