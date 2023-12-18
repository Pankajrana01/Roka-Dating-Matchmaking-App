//
//  GlobalVariables.swift
//  OSODCompany
//
//  Created by SIERRA on 8/7/18.
//  Copyright © 2018 SIERRA. All rights reserved.
//

import Foundation
import UIKit

class GlobalVariables: NSObject {
    // MARK: - Singleton Object Creation 
    static let shared: GlobalVariables = {
        let singletonObject = GlobalVariables()
        return singletonObject
    }()
    
    var selectedImages = [ImageModel]()
    var selectedGalleryImages = [GalleryModel]()
    var selectedTitles = [String]()
    var isComeFor = ""
    var cameraCancel = ""
    var isFirstTime = ""
    var isPreviewScreenBack = ""
    var isAgeRangeApiCalled = false
    var isDrinkingApiCalled = false
    var isSmokingApiCalled = false
    var isComeFormProfile = false
    var searchPreferenceId = ""
    var searchPreferenceCome = ""
    var locationDetailsDictionary = [String:Any]()
    var selectedFriendProfileId = ""
    var selectedFriendProfileDOB = ""
    var selectedProfileMode = "Dating"
    var isCreateForDatingProfile = ""
    var matchedProfileArr: [ProfilesModel] = []
    var isKycPendingPopupShow = false
    var homeCollectionTopConstant = 15.0
    var isProfileDisplayedCount = 0
    var isUnsavedMatchingProfile = false
    var isComesFromBasicInfo = false
    var basicInfoParams = [String:Any]()
}
