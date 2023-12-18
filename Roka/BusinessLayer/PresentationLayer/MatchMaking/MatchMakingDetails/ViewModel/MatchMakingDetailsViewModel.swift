//
//  MatchMakingDetailsViewModel.swift
//  Roka
//
//  Created by  Developer on 05/12/22.
//

import Foundation

class MatchMakingDetailsViewModel: BaseViewModel {
    var broswSkipDetailsDictionary = [String :Any]()
    var isSuggested: Bool = false
    var isComeFor = ""
    var isCome = ""
    var id = ""
    var pendingProfileArray: [ProfilesModel] = []
    var profileArray: [ProfilesModel] = [] {
        didSet {
            self.profileCellViewModels = profileArray.map({ model in
                return MatchMakingDetailsCollectionViewCellViewModel(model: model)
            })
            self.reservedProfileCellViewModels = self.profileCellViewModels
        }
    }
    var profileCellViewModels: [MatchMakingDetailsCollectionViewCellViewModel] = []
    var reservedProfileCellViewModels: [MatchMakingDetailsCollectionViewCellViewModel] = []
    
    // MARK: - API Call...
    func getFriendsMatchMakingData(_ result: @escaping(ProfilesResponseModel?) -> Void) {
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        var baseUrl = ""
        if isComeFor == "stackViewButton" && isSuggested {
            baseUrl = APIUrl.UserMatchMaking.getNewSuggestedProfiles
        } else {
             baseUrl = isSuggested ? APIUrl.UserMatchMaking.matchMakingSuggestedProfiles : APIUrl.UserMatchMaking.getMatchMakingProfiles
        }
        
        let params = ["id": id, "limit": 30, "skip": 0] as [String: Any]
        
        ApiManagerWithCodable<ProfilesResponseModel>.makeApiCall(baseUrl, params: params,
                                                                 headers: headers,
                                                                 method: .get) { (response, resultModel) in
            if resultModel?.statusCode == 200 {
                result(resultModel)
            } else {
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    // MARK: - API Call...
    func browseSkipApiCall(_ result: @escaping(ProfilesResponseModel?) -> Void) {
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        print("Header--->",headers)
        let baseUrl = APIUrl.UserApis.browserUser
        ApiManagerWithCodable<ProfilesResponseModel>.makeApiCall(baseUrl, params: self.broswSkipDetailsDictionary,
                                                                 headers: headers,
                                                                 method: .get) { (response, resultModel) in
            if resultModel?.statusCode == 200 {
                result(resultModel)
            } else {
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    // MARK: - API Call...
    func getNewSuggestedProfiles(_ result: @escaping(ProfilesResponseModel?) -> Void) {
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        let baseUrl = APIUrl.UserMatchMaking.getNewSuggestedProfiles
        
        let params = ["id": id, "limit": 30, "skip": 0] as [String: Any]
        
        ApiManagerWithCodable<ProfilesResponseModel>.makeApiCall(baseUrl, params: params,
                                                                 headers: headers,
                                                                 method: .get) { (response, resultModel) in
            if resultModel?.statusCode == 200 {
                result(resultModel)
            } else {
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func proceedToDetailScreen(profile: ProfilesModel, index:Int, isCome: String) {
        self.pendingProfileArray.removeAll()
        for i in 0..<profileArray.count{
            if i >= index {
                self.pendingProfileArray.append(profileArray[i])
            }
        }
        
        print(self.pendingProfileArray.count)
        
        PageFullViewVC.show(from: self.hostViewController, forcePresent: false, forceBackToHome: false, isFrom: "", isComeFor: isCome, selectedProfile: profile, allProfiles: self.pendingProfileArray, selectedIndex: 0) { success in
        }
    }
    
    func proceedToShareSearchScreen(model: [ProfilesModel] , _ result: @escaping(String?) -> Void) {
        ShareViewController.show(over: self.hostViewController, profileArray: model) { status in
            if status == "CreateGroup" {
                CreateGroupViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "group", profiles: model,isNeedToSendLastMessgaeId: true) { success in
                }
            } else {
                result("sucessforSharePopup")
            }
        }
    }
}

class MatchMakingDetailsCollectionViewCellViewModel {
    let model: ProfilesModel
    var isSelected = false
    init(model: ProfilesModel) {
        self.model = model
    }
}
