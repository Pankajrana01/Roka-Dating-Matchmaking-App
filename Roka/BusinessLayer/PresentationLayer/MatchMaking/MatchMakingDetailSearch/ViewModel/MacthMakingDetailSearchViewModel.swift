//
//  MacthMakingDetailSearchViewModel.swift
//  Roka
//
//  Created by  Developer on 08/12/22.
//

import Foundation

class MacthMakingDetailSearchViewModel: BaseViewModel{
    var isSuggested: Bool = false
    var isComeFor = ""
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
    
    func proceedToDetailScreen(profile: ProfilesModel, index:Int) {
        self.pendingProfileArray.removeAll()
        self.pendingProfileArray.append(profile)
    
        print(self.pendingProfileArray.count)
        
        FullViewDetailViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "MatchMakingProfile", selectedProfile: profile, allProfiles: self.pendingProfileArray, selectedIndex: 0) { success in
        }
        
//        FullViewDetailViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "MatchMakingProfile", selectedProfile: profile, allProfiles: profileArray, selectedIndex: index) { success in
//        }
    }
    
    func proceedToShareSearchScreen(model: [ProfilesModel]) {
        ShareViewController.show(over: self.hostViewController, profileArray: model) { status in
            if status == "CreateGroup"{
                CreateGroupViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "group", profiles: model,isNeedToSendLastMessgaeId: true) { success in
                }
            }
        }
    }
}

class MatchMakingDetailSearchCollectionViewCellViewModel {
    let model: ProfilesModel
    var isSelected = false
    init(model: ProfilesModel) {
        self.model = model
    }
}

