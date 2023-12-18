//
//  GenderViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 22/09/22.
//

import Foundation
import UIKit

class genderTableViewCell:UITableViewCell{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tickImage: UIImageView!
}

class GenderViewModel: BaseViewModel {
    var completionHandler: ((String, String, Int) -> Void)?
    var preferredCompletionHandler: ((String, [String], Int) -> Void)?
    var popupViewHeight: NSLayoutConstraint!
    weak var tableView: UITableView! { didSet { configureTableView() } }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    var privateButton: UIButton!
    
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    var isComeFor = ""
    var isBasicPrivate = false
    var isFriend = false
    var selectedGenderId = ""
    var sliderView: UIView!
    var rangeSlider1: RangeSeekSlider!
    var tableViewBottom: NSLayoutConstraint!
    var sliderViewHeight: NSLayoutConstraint!
    var genderArray = [GenderRow]()
    var ethnicityArray = [GenderRow]()
    var religionArray = [GenderRow]()
    var relationshipsArray = [GenderRow]()
    var educationArray = [GenderRow]()
    var workIndustryArray = [GenderRow]()
    var passionArray = [GenderRow]()
    var workoutArray = [GenderRow]()
    var sportsArray = [GenderRow]()
    var booksArray = [GenderRow]()
    var sexualArray = [GenderRow]()
    var moviesArray = [GenderRow]()
    var musicArray = [GenderRow]()
    var DrinkingArray = [GenderRow]()
    var smokingArray = [GenderRow]()
    var tvSeriesArray = [GenderRow]()
    var zodiacArray = [GenderRow]()
    var kidsArray = [GenderRow]()
    var personalityArray = [GenderRow]()
    var wishighArray = [GenderRow]()
    var isSelectedIndex = -1
    var selectedGenderValue = ""
    var selectedGenderID = ""
    var selectedLookingForValue = ""
    var genderArrayIndex = [String]()
    var isPrivate = 1
    var priority = 100
    var selectedPriority = 100
    var userResponseData = [String: Any]()
    
    var isSmokingPriority = 0
    var isSmoking = 0
    var isDrinking = 0
    var isDrinkingPriority = 0
    
    // MARK: - API Call...
    func processForGetUserProfileData() {
        var url = ""
        var params = [String:Any]()
        
        if isFriend {
            url = APIUrl.UserMatchMaking.getUserMatchMakingProfileDetail
            params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
        } else {
            url = APIUrl.UserApis.getUserProfileDetail
            params = [:]
        }
        ApiManager.makeApiCall(url,
                               params: params,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .get) { response, _ in
            if !self.hasErrorIn(response) {
                DispatchQueue.main.async {
                    self.userResponseData = response![APIConstants.data] as! [String: Any]
                    if self.isComeFor == "Drinking" {
                        //                        if let drinking = self.userResponseData["isDrinking"] as? Int {
                        //                            if drinking == 1{
                        //                                self.isSelectedIndex = 0
                        //                                self.selectedGenderValue = "Yes"
                        //                            }else{
                        //                                self.isSelectedIndex = 1
                        //                                self.selectedGenderValue = "No"
                        //                            }
                        //                        }
                        if self.userResponseData["isDrinkingPrivate"] as? Int == 0 {
                            self.privateButton.setImage(UIImage(named: "ic_toggle_off_generic"), for: .normal)
                            self.isPrivate = 0
                        } else {
                            self.privateButton.setImage(UIImage(named: "ic_toggle_active_generic"), for: .normal)
                            self.isPrivate = 1
                        }
                    }
                    else if self.isComeFor == "Smoking" {
                        //                        if let smoking = self.userResponseData["isSmoking"] as? Int {
                        //                            if smoking == 1{
                        //                                self.isSelectedIndex = 0
                        //                                self.selectedGenderValue = "Yes"
                        //                            }else{
                        //                                self.isSelectedIndex = 1
                        //                                self.selectedGenderValue = "No"
                        //                            }
                        //                        }
                        
                        if self.userResponseData["isSmokingPrivate"] as? Int == 0 {
                            self.privateButton.setImage(UIImage(named: "ic_toggle_off_generic"), for: .normal)
                            self.isPrivate = 0
                        } else {
                            self.privateButton.setImage(UIImage(named: "ic_toggle_active_generic"), for: .normal)
                            self.isPrivate = 1
                        }
                        
                    }
                    else if self.isComeFor == "Ethencity" {
                        if self.userResponseData["isEthnicityPrivate"] as? Int == 0 {
                            self.privateButton.setImage(UIImage(named: "ic_toggle_off_generic"), for: .normal)
                            self.isPrivate = 0
                        } else {
                            self.privateButton.setImage(UIImage(named: "ic_toggle_active_generic"), for: .normal)
                            self.isPrivate = 1
                        }
                    }
                    else if self.isComeFor == "Religion" {
                        if self.userResponseData["isReligionPrivate"] as? Int == 0 {
                            self.privateButton.setImage(UIImage(named: "ic_toggle_off_generic"), for: .normal)
                            self.isPrivate = 0
                        } else {
                            self.privateButton.setImage(UIImage(named: "ic_toggle_active_generic"), for: .normal)
                            self.isPrivate = 1
                        }
                    }
                    else if self.isComeFor == "Relationships" {
                        if self.userResponseData["isRelationshipPrivate"] as? Int == 0 {
                            self.privateButton.setImage(UIImage(named: "ic_toggle_off_generic"), for: .normal)
                            self.isPrivate = 0
                        } else {
                            self.privateButton.setImage(UIImage(named: "ic_toggle_active_generic"), for: .normal)
                            self.isPrivate = 1
                        }
                    }
                    else if self.isComeFor == "Gender" {
                        if self.userResponseData["isGenderPrivate"] as? Int == 0 {
                            self.privateButton.setImage(UIImage(named: "ic_toggle_off_generic"), for: .normal)
                            self.isPrivate = 0
                        } else {
                            self.privateButton.setImage(UIImage(named: "ic_toggle_active_generic"), for: .normal)
                            self.isPrivate = 1
                        }
                    }
                    
                    else if self.isComeFor == "Education" {
                        if self.userResponseData["isEducationPrivate"] as? Int == 0 {
                            self.privateButton.setImage(UIImage(named: "ic_toggle_off_generic"), for: .normal)
                            self.isPrivate = 0
                        } else {
                            self.privateButton.setImage(UIImage(named: "ic_toggle_active_generic"), for: .normal)
                            self.isPrivate = 1
                        }
                    }
                    else if self.isComeFor == "Work" {
                        if self.userResponseData["isWorkIndustryPrivate"] as? Int == 0 {
                            self.privateButton.setImage(UIImage(named: "ic_toggle_off_generic"), for: .normal)
                            self.isPrivate = 0
                        } else {
                            self.privateButton.setImage(UIImage(named: "ic_toggle_active_generic"), for: .normal)
                            self.isPrivate = 1
                        }
                    }
                    else if self.isComeFor == "Zodiac" {
                        if self.userResponseData["isZodiacPrivate"] as? Int == 0 {
                            self.privateButton.setImage(UIImage(named: "ic_toggle_off_generic"), for: .normal)
                            self.isPrivate = 0
                        } else {
                            self.privateButton.setImage(UIImage(named: "ic_toggle_active_generic"), for: .normal)
                            self.isPrivate = 1
                        }
                    }
                    else if self.isComeFor == "Kids" {
                        if self.userResponseData["isKidsPrivate"] as? Int == 0 {
                            self.privateButton.setImage(UIImage(named: "ic_toggle_off_generic"), for: .normal)
                            self.isPrivate = 0
                        } else {
                            self.privateButton.setImage(UIImage(named: "ic_toggle_active_generic"), for: .normal)
                            self.isPrivate = 1
                        }
                    }
                    else if self.isComeFor == "Personality" {
                        if self.userResponseData["isPersonalityPrivate"] as? Int == 0 {
                            self.privateButton.setImage(UIImage(named: "ic_toggle_off_generic"), for: .normal)
                            self.isPrivate = 0
                        } else {
                            self.privateButton.setImage(UIImage(named: "ic_toggle_active_generic"), for: .normal)
                            self.isPrivate = 1
                        }
                    }
                    
                    else if self.isComeFor == "Sexual" {
                        if self.userResponseData["isSexualOrientationPrivate"] as? Int == 0 {
                            self.privateButton.setImage(UIImage(named: "ic_toggle_off_generic"), for: .normal)
                            self.isPrivate = 0
                        } else {
                            self.privateButton.setImage(UIImage(named: "ic_toggle_active_generic"), for: .normal)
                            self.isPrivate = 1
                        }
                    }
                    
                    else if self.isComeFor == "Workout" {
                        if self.userResponseData["isWorkoutPrivate"] as? Int == 0 {
                            self.privateButton.setImage(UIImage(named: "ic_toggle_off_generic"), for: .normal)
                            self.isPrivate = 0
                        } else {
                            self.privateButton.setImage(UIImage(named: "ic_toggle_active_generic"), for: .normal)
                            self.isPrivate = 1
                        }
                        if self.userResponseData["isWorkoutPrivate"] as? Int == 0 {
                            self.privateButton.setImage(UIImage(named: "ic_toggle_off_generic"), for: .normal)
                            self.isPrivate = 0
                        } else {
                            self.privateButton.setImage(UIImage(named: "ic_toggle_active_generic"), for: .normal)
                            self.isPrivate = 1
                        }
                    }
                    else if self.isComeFor == "Sports" {
                        if self.userResponseData["isSportsPrivate"] as? Int == 0 {
                            self.privateButton.setImage(UIImage(named: "ic_toggle_off_generic"), for: .normal)
                            self.isPrivate = 0
                        } else {
                            self.privateButton.setImage(UIImage(named: "ic_toggle_active_generic"), for: .normal)
                            self.isPrivate = 1
                        }
                        //Preference Ethnicity
                        if let genders = self.userResponseData["usersSports"] as? [[String:Any]] {
                            for gender in genders {
                                if let gen = gender["sport"] as? [String:Any]{
                                    for i in 0..<self.sportsArray.count {
                                        if gen["id"] as? String == self.sportsArray[i].id{
                                            self.genderArrayIndex[i] = "YES"
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    else if self.isComeFor == "Books" {
                        if self.userResponseData["isBooksPrivate"] as? Int == 0 {
                            self.privateButton.setImage(UIImage(named: "ic_toggle_off_generic"), for: .normal)
                            self.isPrivate = 0
                        } else {
                            self.privateButton.setImage(UIImage(named: "ic_toggle_active_generic"), for: .normal)
                            self.isPrivate = 1
                        }
                        //Preference Ethnicity
                        if let genders = self.userResponseData["usersBooks"] as? [[String:Any]] {
                            for gender in genders {
                                if let gen = gender["book"] as? [String:Any]{
                                    for i in 0..<self.booksArray.count {
                                        if gen["id"] as? String == self.booksArray[i].id {
                                            self.genderArrayIndex[i] = "YES"
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    else if self.isComeFor == "AboutMeWishing" {
                        if self.userResponseData["isWishingToHavePrivate"] as? Int == 0 {
                            self.privateButton.setImage(UIImage(named: "ic_toggle_off_generic"), for: .normal)
                            self.isPrivate = 0
                        } else {
                            self.privateButton.setImage(UIImage(named: "ic_toggle_active_generic"), for: .normal)
                            self.isPrivate = 1
                        }
                        
                        //Preference Wishing
                        if let genders = self.userResponseData["userWishingToHavePreferences"] as? [[String:Any]] {
                            for gender in genders {
                                if let gen = gender["wishingToHave"] as? [String:Any]{
                                    for i in 0..<self.wishighArray.count {
                                        if gen["id"] as? String == self.wishighArray[i].id {
                                            self.genderArrayIndex[i] = "YES"
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    if self.tableView != nil { self.tableView.reloadData() }
                }
            }
            hideLoader()
        }
    }
    
    func processForGetUserPreferenceProfileData() {
        showLoader()
        var url = ""
        var params = [String:Any]()
        
        if isFriend {
            url = APIUrl.UserMatchMaking.getUserMatchMakingPreferenceDetail
            params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
            
        } else {
            url = APIUrl.UserApis.getUserPreferenceDetail
            params = [:]
        }
        
        ApiManager.makeApiCall(url, params: params,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .get) { response, _ in
            if !self.hasErrorIn(response) {
                DispatchQueue.main.async {
                    self.userResponseData = response![APIConstants.data] as! [String: Any]
                    self.user.updateWith(self.userResponseData)
                    KUSERMODEL.setUserLoggedIn(true)
                    
                    
                    if self.isComeFor == "PreferenceGender" {
                        //Preference Gender
                        if let genders = self.userResponseData["userGenderPreferences"] as? [[String:Any]] {
                            for gender in genders {
                                if let gen = gender["gender"] as? [String:Any] {
                                    for i in 0..<self.genderArray.count {
                                        if gen["id"] as? String == self.genderArray[i].id {
                                            self.genderArrayIndex[i] = "YES"
                                        }
                                    }
                                }
                            }
                            if genders.count != 0 {
                                if let userPreferences = self.userResponseData["userPreferences"] as? [[String:Any]] {
                                    let userPreference = userPreferences[0]
                                    if let genderPriority = userPreference["genderPriority"] as? Int {
                                        self.selectedPriority = genderPriority
                                        self.rangeSlider1Initialize()
                                        self.rangeSlider1.layoutSubviews()
                                    }
                                }
                            }
                        }
                    }
                    else if self.isComeFor == "PreferenceEthencity" {
                        //Preference Ethnicity
                        if let genders = self.userResponseData["userEthnicityPreferences"] as? [[String:Any]] {
                            for gender in genders {
                                if let gen = gender["ethnicity"] as? [String:Any] {
                                    for i in 0..<self.ethnicityArray.count {
                                        if gen["id"] as? String == self.ethnicityArray[i].id {
                                            self.genderArrayIndex[i] = "YES"
                                        }
                                    }
                                }
                            }
                            if genders.count != 0{
                                if let userPreferences = self.userResponseData["userPreferences"] as? [[String:Any]] {
                                    let userPreference = userPreferences[0]
                                    if let genderPriority = userPreference["ethnicityPriority"] as? Int {
                                        self.selectedPriority = genderPriority
                                        self.rangeSlider1Initialize()
                                        self.rangeSlider1.layoutSubviews()
                                    }
                                }
                            }
                        }
                    }
                    else if self.isComeFor == "PreferenceReligion" {
                        //Preference religion
                        if let genders = self.userResponseData["userReligionPreferences"] as? [[String:Any]] {
                            for gender in genders {
                                if let gen = gender["religion"] as? [String:Any] {
                                    for i in 0..<self.religionArray.count {
                                        if gen["id"] as? String == self.religionArray[i].id{
                                            self.genderArrayIndex[i] = "YES"
                                        }
                                    }
                                }
                            }
                            if genders.count != 0{
                                if let userPreferences = self.userResponseData["userPreferences"] as? [[String:Any]] {
                                    let userPreference = userPreferences[0]
                                    if let genderPriority = userPreference["religionPriority"] as? Int{
                                        self.selectedPriority = genderPriority
                                        self.rangeSlider1Initialize()
                                        self.rangeSlider1.layoutSubviews()
                                    }
                                }
                            }
                        }
                    }
                    else if self.isComeFor == "PreferenceRelationships" {
                        //Preference Relationship
                        if let genders = self.userResponseData["userRelationshipPreferences"] as? [[String:Any]] {
                            for gender in genders {
                                if let gen = gender["relationship"] as? [String:Any] {
                                    for i in 0..<self.relationshipsArray.count {
                                        if gen["id"] as? String == self.relationshipsArray[i].id{
                                            self.genderArrayIndex[i] = "YES"
                                        }
                                    }
                                }
                            }
                            if genders.count != 0{
                                if let userPreferences = self.userResponseData["userPreferences"] as? [[String:Any]] {
                                    let userPreference = userPreferences[0]
                                    if let genderPriority = userPreference["relationshipPriority"] as? Int {
                                        self.selectedPriority = genderPriority
                                        self.rangeSlider1Initialize()
                                        self.rangeSlider1.layoutSubviews()
                                    }
                                }
                            }
                        }
                    }
                    else if self.isComeFor == "PreferenceEducation" {
                        //Preference educationQualification
                        if let genders = self.userResponseData["userQualificationPreferences"] as? [[String:Any]] {
                            for gender in genders {
                                if let gen = gender["educationQualification"] as? [String:Any] {
                                    for i in 0..<self.educationArray.count {
                                        if gen["id"] as? String == self.educationArray[i].id{
                                            self.genderArrayIndex[i] = "YES"
                                        }
                                    }
                                }
                            }
                            if genders.count != 0{
                                if let userPreferences = self.userResponseData["userPreferences"] as? [[String:Any]] {
                                    let userPreference = userPreferences[0]
                                    if let genderPriority = userPreference["educationQualificationsPriority"] as? Int {
                                        self.selectedPriority = genderPriority
                                        self.rangeSlider1Initialize()
                                        self.rangeSlider1.layoutSubviews()
                                    }
                                }
                            }
                        }
                    }
                    else if self.isComeFor == "PreferenceWork" {
                        //Preference WorkIndustriesPreferences
                        if let genders = self.userResponseData["userWorkIndustriesPreferences"] as? [[String:Any]] {
                            for gender in genders {
                                if let gen = gender["workIndustry"] as? [String:Any] {
                                    for i in 0..<self.workIndustryArray.count {
                                        if gen["id"] as? String == self.workIndustryArray[i].id {
                                            self.genderArrayIndex[i] = "YES"
                                        }
                                    }
                                }
                            }
                            if genders.count != 0 {
                                if let userPreferences = self.userResponseData["userPreferences"] as? [[String:Any]] {
                                    let userPreference = userPreferences[0]
                                    if let genderPriority = userPreference["workIndustryPriority"] as? Int {
                                        self.selectedPriority = genderPriority
                                        self.rangeSlider1Initialize()
                                        self.rangeSlider1.layoutSubviews()
                                    }
                                }
                            }
                        }
                    }
                    else if self.isComeFor == "PreferencePassion" {
                        //Preference PassionPreferences
                        if let genders = self.userResponseData["userPassionPreferences"] as? [[String:Any]] {
                            for gender in genders {
                                if let gen = gender["passion"] as? [String:Any] {
                                    for i in 0..<self.passionArray.count {
                                        if gen["id"] as? String == self.passionArray[i].id {
                                            self.genderArrayIndex[i] = "YES"
                                        }
                                    }
                                }
                            }
                            if genders.count != 0 {
                                if let userPreferences = self.userResponseData["userPreferences"] as? [[String:Any]] {
                                    let userPreference = userPreferences[0]
                                    if let genderPriority = userPreference["passionPriority"] as? Int {
                                        self.selectedPriority = genderPriority
                                        self.rangeSlider1Initialize()
                                        self.rangeSlider1.layoutSubviews()
                                    }
                                }
                            }
                        }
                    }
                    
                    else if self.isComeFor == "PreferenceZodiac" {
                        //Preference PassionPreferences
                        if let genders = self.userResponseData["userZodiacPreferences"] as? [[String:Any]] {
                            for gender in genders {
                                for i in 0..<self.zodiacArray.count {
                                    if gender["zodiacId"] as? String == self.zodiacArray[i].id {
                                        self.genderArrayIndex[i] = "YES"
                                    }
                                }
                            }
                            if genders.count != 0 {
                                if let userPreferences = self.userResponseData["userPreferences"] as? [[String:Any]] {
                                    let userPreference = userPreferences[0]
                                    if let genderPriority = userPreference["zodiacPriority"] as? Int {
                                        self.selectedPriority = genderPriority
                                        self.rangeSlider1Initialize()
                                        self.rangeSlider1.layoutSubviews()
                                    }
                                }
                            }
                        }
                    }
                    else if self.isComeFor == "PreferenceKids" {
                        //Preference PassionPreferences
                        if let genders = self.userResponseData["userKidsPreferences"] as? [[String:Any]] {
                            for gender in genders {
                                for i in 0..<self.kidsArray.count {
                                    if gender["kidsId"] as? String == self.kidsArray[i].id {
                                        self.genderArrayIndex[i] = "YES"
                                    }
                                }
                            }
                            if genders.count != 0{
                                if let userPreferences = self.userResponseData["userPreferences"] as? [[String:Any]] {
                                    let userPreference = userPreferences[0]
                                    if let genderPriority = userPreference["kidsPriority"] as? Int {
                                        self.selectedPriority = genderPriority
                                        self.rangeSlider1Initialize()
                                        self.rangeSlider1.layoutSubviews()
                                    }
                                }
                            }
                        }
                    }
                    else if self.isComeFor == "PreferencePersonality" {
                        //Preference PassionPreferences
                        if let genders = self.userResponseData["userPersonalityPrefrences"] as? [[String:Any]] {
                            for gender in genders {
                                for i in 0..<self.personalityArray.count {
                                    if gender["personalityId"] as? String == self.personalityArray[i].id {
                                        self.genderArrayIndex[i] = "YES"
                                    }
                                }
                            }
                            if genders.count != 0{
                                if let userPreferences = self.userResponseData["userPreferences"] as? [[String:Any]] {
                                    let userPreference = userPreferences[0]
                                    if let genderPriority = userPreference["personalityPriority"] as? Int {
                                        self.selectedPriority = genderPriority
                                        self.rangeSlider1Initialize()
                                        self.rangeSlider1.layoutSubviews()
                                    }
                                }
                            }
                        }
                    }
                    
                    else if self.isComeFor == "PreferenceAboutMeWishing" {
                        //Preference PassionPreferences
                        if let genders = self.userResponseData["userWishingToHavePreferences"] as? [[String:Any]] {
                            for gender in genders {
                                if let gen = gender["wishingToHave"] as? [String:Any] {
                                    for i in 0..<self.wishighArray.count {
                                        if gen["id"] as? String == self.wishighArray[i].id {
                                            self.genderArrayIndex[i] = "YES"
                                        }
                                    }
                                }
                            }
                            if genders.count != 0 {
                                if let userPreferences = self.userResponseData["userPreferences"] as? [[String:Any]] {
                                    let userPreference = userPreferences[0]
                                    if let genderPriority = userPreference["isWishingToHavePriority"] as? Int {
                                        self.selectedPriority = genderPriority
                                        self.rangeSlider1Initialize()
                                        self.rangeSlider1.layoutSubviews()
                                    }
                                }
                            }
                        }
                    }
                    
                    else if self.isComeFor == "PreferenceSmoking" {
                        if let genders = self.userResponseData["userSmokingPreferences"] as? [[String:Any]] {
                            for gender in genders {
                                for i in 0..<self.smokingArray.count {
                                    if gender["smokingId"] as? String == self.smokingArray[i].id{
                                        self.genderArrayIndex[i] = "YES"
                                    }
                                }
                            }
                            if let userPreferences = self.userResponseData["userPreferences"] as? [[String:Any]] {
                                let userPreference = userPreferences[0]
                                self.isSmokingPriority = userPreference["isSmokingPriority"] as? Int ?? 0
                                
                                if genders.count == 0 {
                                    self.selectedPriority = 100
                                    self.rangeSlider1Initialize()
                                    self.rangeSlider1.layoutSubviews()
                                } else {
                                    self.selectedPriority = self.isSmokingPriority
                                    self.rangeSlider1Initialize()
                                    self.rangeSlider1.layoutSubviews()
                                }
                            }
                        }
                        
                    } else if self.isComeFor == "PreferenceDrinking" {
                        if let genders = self.userResponseData["userDrinkingPreferences"] as? [[String:Any]] {
                            for gender in genders {
                                for i in 0..<self.DrinkingArray.count {
                                    if gender["drinkingId"] as? String == self.DrinkingArray[i].id {
                                        self.genderArrayIndex[i] = "YES"
                                    }
                                }
                            }
                            
                            if let userPreferences = self.userResponseData["userPreferences"] as? [[String:Any]] {
                                let userPreference = userPreferences[0]
                                self.isDrinkingPriority = userPreference["isDrinkingPriority"] as? Int ?? 0
                                
                                if genders.count == 0 {
                                    self.selectedPriority = 100
                                    self.rangeSlider1Initialize()
                                    self.rangeSlider1.layoutSubviews()
                                } else {
                                    self.selectedPriority = self.isDrinkingPriority
                                    self.rangeSlider1Initialize()
                                    self.rangeSlider1.layoutSubviews()
                                }
                            }
                        }
                    }
                    
                    
                    if self.tableView != nil { self.tableView.reloadData() }
                }
            }
            hideLoader()
        }
    }
    
    func rangeSlider1Initialize() {
        rangeSlider1.delegate = self
        rangeSlider1.minValue = 0
        rangeSlider1.maxValue = 100
        rangeSlider1.selectedMaxValue = CGFloat(selectedPriority)
        self.priority = selectedPriority
    }
    
    func refreshUI() {
        if isComeFor == "Gender" ||
            isComeFor == "MoreDetailGender" ||
            isComeFor == "Ethencity" ||
            isComeFor == "Religion" ||
            isComeFor == "Relationships" ||
            isComeFor == "Education" ||
            isComeFor == "Work" ||
            isComeFor == "Passion" ||
            isComeFor == "Movies" ||
            isComeFor == "Music" ||
            isComeFor == "Drinking" ||
            isComeFor == "Smoking" ||
            isComeFor == "TV" ||
            isComeFor == "Zodiac" ||
            isComeFor == "Kids" ||
            isComeFor == "Personality" ||
            isComeFor == "Sexual" ||
            isComeFor == "Workout" ||
            isComeFor == "Sports" ||
            isComeFor == "Books"
        {
            self.tableViewBottom.constant = 20
            self.sliderView.isHidden = true
            self.sliderViewHeight.constant = 0
            self.processForGetUserProfileData()
            
        } else if isComeFor == "BasicRelationships" {
            for _ in 0..<genderArray.count {
                self.genderArrayIndex.append("NO")
            }
            self.tableViewBottom.constant = 20
            self.sliderView.isHidden = true
            self.sliderViewHeight.constant = 0
            self.processForGetUserPreferenceProfileData()
        }
          else if self.isComeFor == "Sports" {
            self.tableViewBottom.constant = 20
            self.sliderView.isHidden = true
              self.sliderViewHeight.constant = 0
            self.processForGetUserProfileData()
            
        } else if self.isComeFor == "Books" {
            self.tableViewBottom.constant = 20
            self.sliderView.isHidden = true
            self.sliderViewHeight.constant = 0
            self.processForGetUserProfileData()
            
        } else if isComeFor == "AboutMeWishing" {
            self.tableViewBottom.constant = 20
            self.sliderView.isHidden = true
            self.sliderViewHeight.constant = 0
            self.processForGetUserProfileData()
        }
        
        else if isComeFor == "Wishing" {
            for _ in 0..<wishighArray.count {
                self.genderArrayIndex.append("NO")
            }
            
            let ids = self.selectedGenderId.components(separatedBy: ",")
            for id in ids {
                for i in 0..<self.wishighArray.count {
                    if id == self.wishighArray[i].id {
                        self.genderArrayIndex[i] = "YES"
                    }
                }
            }
            
            self.tableViewBottom.constant = 20
            self.sliderView.isHidden = true
            self.sliderViewHeight.constant = 0
            self.processForGetUserProfileData()
        }  else {
            self.tableViewBottom.constant = 100
            self.sliderView.isHidden = false
            self.sliderViewHeight.constant = 90
            self.genderArrayIndex.removeAll()
            
            if isComeFor == "PreferredGender" {
                for _ in 0..<genderArray.count {
                    self.genderArrayIndex.append("NO")
                }
                let ids = self.selectedGenderId.components(separatedBy: ",")
                for id in ids {
                    for i in 0..<self.genderArray.count {
                        if id == self.genderArray[i].id {
                            self.genderArrayIndex[i] = "YES"
                        } 
                    }
                }

            }
            else if self.isComeFor == "PreferenceAboutMeWishing" {
                for _ in 0..<wishighArray.count {
                    self.genderArrayIndex.append("NO")
                }
                
                let ids = self.selectedGenderId.components(separatedBy: ",")
                for id in ids {
                    for i in 0..<self.wishighArray.count {
                        if id == self.wishighArray[i].id {
                            self.genderArrayIndex[i] = "YES"
                        }
                    }
                }
            }
            else if isComeFor == "PreferenceGender" {
                for _ in 0..<genderArray.count {
                    self.genderArrayIndex.append("NO")
                }
    //            self.tableViewBottom.constant = 20
    //            self.sliderView.isHidden = true
//                self.processForGetUserPreferenceProfileData()
            }
            else if isComeFor == "PreferenceEthencity" {
                for _ in 0..<ethnicityArray.count {
                    self.genderArrayIndex.append("NO")
                }
            } else if isComeFor == "PreferenceReligion" {
                for _ in 0..<religionArray.count {
                    self.genderArrayIndex.append("NO")
                }
            } else if isComeFor == "PreferenceRelationships" {
                for _ in 0..<relationshipsArray.count {
                    self.genderArrayIndex.append("NO")
                }
            } else if isComeFor == "PreferenceEducation" {
                for _ in 0..<educationArray.count {
                    self.genderArrayIndex.append("NO")
                }
            } else if isComeFor == "PreferenceWork" {
                for _ in 0..<workIndustryArray.count {
                    self.genderArrayIndex.append("NO")
                }
            } else if isComeFor == "PreferencePassion" {
                for _ in 0..<passionArray.count {
                    self.genderArrayIndex.append("NO")
                }
            } else if isComeFor == "PreferenceSmoking" {
                for _ in 0..<smokingArray.count {
                    self.genderArrayIndex.append("NO")
                }
            } else if isComeFor == "PreferenceDrinking" {
                for _ in 0..<DrinkingArray.count {
                    self.genderArrayIndex.append("NO")
                }
            } else if isComeFor == "sexualPreference" {
                self.tableViewBottom.constant = 20
                self.sliderView.isHidden = true
                self.sliderViewHeight.constant = 0
                for _ in 0..<sexualArray.count {
                    self.genderArrayIndex.append("NO")
                }
                self.refreshPopupHeight(arr: self.sexualArray)
                let ids = self.selectedGenderId.components(separatedBy: ",")
                for id in ids {
                    for i in 0..<self.genderArray.count {
                        if id == self.genderArray[i].id {
                            self.genderArrayIndex[i] = "YES"
                        }
                    }
                }
            } else if isComeFor == "sexualPreference2" {
                self.tableViewBottom.constant = 20
                self.sliderView.isHidden = true
                self.sliderViewHeight.constant = 0
                for _ in 0..<sexualArray.count {
                    self.genderArrayIndex.append("NO")
                }
                self.refreshPopupHeight(arr: self.sexualArray)
                let ids = self.selectedGenderId.components(separatedBy: ",")
                for id in ids {
                    for i in 0..<self.genderArray.count {
                        if id == self.genderArray[i].id {
                            self.genderArrayIndex[i] = "YES"
                        }
                    }
                }
            }else if isComeFor == "PreferenceZodiac" {
                for _ in 0..<zodiacArray.count {
                    self.genderArrayIndex.append("NO")
                }
            } else if isComeFor == "PreferenceKids" {
                for _ in 0..<kidsArray.count {
                    self.genderArrayIndex.append("NO")
                }
            } else if isComeFor == "PreferencePersonality" {
                for _ in 0..<personalityArray.count {
                    self.genderArrayIndex.append("NO")
                }
            }  else {
                for _ in 0..<genderArray.count {
                    self.genderArrayIndex.append("NO")
                }
            }
            self.processForGetUserPreferenceProfileData()
        }
        
    }
    
    func refreshPopupHeight(arr:[GenderRow]) {
        UIView.animate(withDuration: 2.0, delay: 0.5, options: .transitionFlipFromTop) {
            if self.isComeFor == "PreferenceEthencity" ||
                self.isComeFor == "PreferenceReligion" ||
                self.isComeFor == "PreferenceRelationships" ||
                self.isComeFor == "PreferenceEducation" ||
                self.isComeFor == "PreferenceWork" ||
                self.isComeFor == "PreferencePassion" ||
                self.isComeFor == "PreferenceSmoking" ||
                self.isComeFor == "PreferenceDrinking" ||
                self.isComeFor == "sexualPreference" ||
                self.isComeFor == "sexualPreference2" ||
                self.isComeFor == "PreferenceZodiac" ||
                self.isComeFor == "PreferenceKids" ||
                self.isComeFor == "PreferencePersonality" ||
                self.isComeFor == "Wishing" ||
                self.isComeFor == "PreferenceAboutMeWishing" ||
                self.isComeFor == "sexualPreference" ||
                self.isComeFor == "PreferenceGender"
            {
                if arr.count > 9 {
                    self.popupViewHeight.constant = 44.0 * 10 + 160 + 120 + 80
                } else {
                    self.popupViewHeight.constant = 44.0 * CGFloat(arr.count) + 160 + 120 + 80
                }
            } else {
                if arr.count > 9 {
                    self.popupViewHeight.constant = 44.0 * 10 + 160 + 80
                } else {
                    self.popupViewHeight.constant = 44.0 * CGFloat(arr.count) + 160 + 120 + 80
                }
            }
        } completion: { completion in }
    }
    func saveButtonAction() {
        var name = [String]()
        var ids = [String]()
        if isComeFor == "Gender" ||
            isComeFor == "MoreDetailGender" ||
            isComeFor == "Ethencity" ||
            isComeFor == "Religion" ||
            isComeFor == "Relationships" ||
            isComeFor == "Education" ||
            isComeFor == "Work" ||
            isComeFor == "Passion" ||
            isComeFor == "Movies" ||
            isComeFor == "Music" ||
            isComeFor == "Drinking" ||
            isComeFor == "Smoking" ||
            isComeFor == "TV" ||
            isComeFor == "Zodiac" ||
            isComeFor == "Kids" ||
            isComeFor == "Personality" ||
            isComeFor == "Sexual" ||
            isComeFor == "Workout" ||
            isComeFor == "BasicRelationships"
        {
            if selectedGenderValue == "" {
                showMessage(with: StringConstants.selectValue)
            } else {
                completionHandler?(selectedGenderID, selectedGenderValue, isPrivate)
                (self.hostViewController as! BaseAlertViewController).dismiss()
            }
        }
        else if isComeFor == "Sports" {
            for i in 0..<genderArrayIndex.count {
                if self.genderArrayIndex[i] == "YES" {
                    name.append(self.sportsArray[i].name)
                    ids.append(self.sportsArray[i].id)
                }
            }
            self.selectedLookingForValue = name.joined(separator: ", ")
            if self.selectedLookingForValue == "" {
//                showMessage(with: StringConstants.selectOneValue)
                // Remove Check
                preferredCompletionHandler?(selectedLookingForValue, ids, isPrivate)
                (self.hostViewController as! BaseAlertViewController).dismiss()
                // ----
            } else {
                preferredCompletionHandler?(selectedLookingForValue, ids, isPrivate)
                (self.hostViewController as! BaseAlertViewController).dismiss()
            }
        } else if isComeFor == "Books" {
            for i in 0..<genderArrayIndex.count {
                if self.genderArrayIndex[i] == "YES" {
                    name.append(self.booksArray[i].name)
                    ids.append(self.booksArray[i].id)
                }
            }
            self.selectedLookingForValue = name.joined(separator: ", ")
            if self.selectedLookingForValue == "" {
//                showMessage(with: StringConstants.selectOneValue)
                // Remove Check
                preferredCompletionHandler?(selectedLookingForValue, ids, isPrivate)
                (self.hostViewController as! BaseAlertViewController).dismiss()
                // ----
            } else {
                preferredCompletionHandler?(selectedLookingForValue, ids, isPrivate)
                (self.hostViewController as! BaseAlertViewController).dismiss()
            }
        }
        else {
            if isComeFor == "PreferenceEthencity" {
                for i in 0..<genderArrayIndex.count {
                    if self.genderArrayIndex[i] == "YES" {
                        name.append(self.ethnicityArray[i].name)
                        ids.append(self.ethnicityArray[i].id)
                    }
                }
            } else if isComeFor == "PreferenceReligion" {
                for i in 0..<genderArrayIndex.count {
                    if self.genderArrayIndex[i] == "YES" {
                        name.append(self.religionArray[i].name)
                        ids.append(self.religionArray[i].id)
                    }
                }
            } else if isComeFor == "PreferenceRelationships" {
                for i in 0..<genderArrayIndex.count {
                    if self.genderArrayIndex[i] == "YES" {
                        name.append(self.relationshipsArray[i].name)
                        ids.append(self.relationshipsArray[i].id)
                    }
                }
            } else if isComeFor == "Wishing" {
                for i in 0..<genderArrayIndex.count {
                    if self.genderArrayIndex[i] == "YES" {
                        name.append(self.wishighArray[i].name)
                        ids.append(self.wishighArray[i].id)
                    }
                }
            } else if isComeFor == "PreferenceEducation" {
                for i in 0..<genderArrayIndex.count {
                    if self.genderArrayIndex[i] == "YES" {
                        name.append(self.educationArray[i].name)
                        ids.append(self.educationArray[i].id)
                    }
                }
            } else if isComeFor == "PreferenceWork" {
                for i in 0..<genderArrayIndex.count {
                    if self.genderArrayIndex[i] == "YES" {
                        name.append(self.workIndustryArray[i].name)
                        ids.append(self.workIndustryArray[i].id)
                    }
                }
            } else if isComeFor == "PreferencePassion" {
                for i in 0..<genderArrayIndex.count {
                    if self.genderArrayIndex[i] == "YES" {
                        name.append(self.passionArray[i].name)
                        ids.append(self.passionArray[i].id)
                    }
                }
            } else if isComeFor == "PreferenceSmoking" {
                for i in 0..<genderArrayIndex.count {
                    if self.genderArrayIndex[i] == "YES" {
                        name.append(self.smokingArray[i].name)
                        ids.append(self.smokingArray[i].id)
                    }
                }
                //name.append(selectedGenderValue)
            } else if isComeFor == "PreferenceDrinking" {
                //name.append(selectedGenderValue)
                for i in 0..<genderArrayIndex.count {
                    if self.genderArrayIndex[i] == "YES" {
                        name.append(self.DrinkingArray[i].name)
                        ids.append(self.DrinkingArray[i].id)
                    }
                }
            } else if isComeFor == "sexualPreference" {
                //name.append(selectedGenderValue)
                for i in 0..<genderArrayIndex.count {
                    if self.genderArrayIndex[i] == "YES" {
                        name.append(self.sexualArray[i].name)
                        ids.append(self.sexualArray[i].id)
                    }
                }
            } else if isComeFor == "sexualPreference2" {
                //name.append(selectedGenderValue)
                for i in 0..<genderArrayIndex.count {
                    if self.genderArrayIndex[i] == "YES" {
                        name.append(self.sexualArray[i].name)
                        ids.append(self.sexualArray[i].id)
                    }
                }
            } else if isComeFor == "PreferenceZodiac" {
                //name.append(selectedGenderValue)
                for i in 0..<genderArrayIndex.count {
                    if self.genderArrayIndex[i] == "YES" {
                        name.append(self.zodiacArray[i].name)
                        ids.append(self.zodiacArray[i].id)
                    }
                }
            } else if self.isComeFor == "PreferenceKids" {
                for i in 0..<genderArrayIndex.count {
                    if self.genderArrayIndex[i] == "YES" {
                        name.append(self.kidsArray[i].name)
                        ids.append(self.kidsArray[i].id)
                    }
                }
            } else if isComeFor == "PreferencePersonality" {
                for i in 0..<genderArrayIndex.count {
                    if self.genderArrayIndex[i] == "YES" {
                        name.append(self.personalityArray[i].name)
                        ids.append(self.personalityArray[i].id)
                    }
                }
            } else if isComeFor == "Sports" {
                for i in 0..<genderArrayIndex.count {
                    if self.genderArrayIndex[i] == "YES" {
                        name.append(self.sportsArray[i].name)
                        ids.append(self.sportsArray[i].id)
                    }
                }
            } else if isComeFor == "Books" {
                for i in 0..<genderArrayIndex.count {
                    if self.genderArrayIndex[i] == "YES" {
                        name.append(self.booksArray[i].name)
                        ids.append(self.booksArray[i].id)
                    }
                }
            } else if isComeFor == "AboutMeWishing" {
                for i in 0..<genderArrayIndex.count {
                    if self.genderArrayIndex[i] == "YES" {
                        name.append(self.wishighArray[i].name)
                        ids.append(self.wishighArray[i].id)
                    }
                }
            }
            else if self.isComeFor == "PreferenceAboutMeWishing" {
                for i in 0..<genderArrayIndex.count {
                    if self.genderArrayIndex[i] == "YES" {
                        name.append(self.wishighArray[i].name)
                        ids.append(self.wishighArray[i].id)
                    }
                }
            } else {
                for i in 0..<genderArrayIndex.count {
                    if self.genderArrayIndex[i] == "YES" {
                        name.append(self.genderArray[i].name)
                        ids.append(self.genderArray[i].id)
                    }
                }
            }
            self.selectedLookingForValue = name.joined(separator: ", ")
            if self.selectedLookingForValue == "" {
//                showMessage(with: StringConstants.selectOneValue)
                // remove Check ---
                if isComeFor == "AboutMeWishing" {
//                    showMessage(with: StringConstants.selectOneValue)
                    preferredCompletionHandler?(selectedLookingForValue, ids, self.priority)
                    (self.hostViewController as! BaseAlertViewController).dismiss()
                } else {
                    preferredCompletionHandler?(selectedLookingForValue, ids, self.priority)
                    (self.hostViewController as! BaseAlertViewController).dismiss()
                }
                // -----
            } else {
                if isComeFor == "AboutMeWishing" {
                    preferredCompletionHandler?(selectedLookingForValue, ids, self.isPrivate)
                } else {
                    preferredCompletionHandler?(selectedLookingForValue, ids, self.priority)
                }
                (self.hostViewController as! BaseAlertViewController).dismiss()
            }
        }
        
        
    }
}
// MARK: - RangeSeekSliderDelegate
extension GenderViewModel: RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider === rangeSlider1 {
            print("Custom slider updated. Min Value: \(Int(minValue)) Max Value: \(Int(maxValue))")
            self.priority = Int(maxValue)
        }  else {
            print("Custom slider updated. Min Value: \(Int(minValue)) Max Value: \(Int(maxValue))")
        }
    }

    func didStartTouches(in slider: RangeSeekSlider) {
        print("did start touches")
    }

    func didEndTouches(in slider: RangeSeekSlider) {
        print("did end touches")
    }
}
// MARK: - API Call ...
extension GenderViewModel {
    func processForGetEthentcityData(type: String) {
        var params = [String:Any]()
        params["type"] = type
        if isFriend {
            params[WebConstants.friendsId] = GlobalVariables.shared.selectedFriendProfileId
        }
        self.getApiCall(params: params, url: APIUrl.BasicApis.ethnicity) { model in
            self.ethnicityArray = model?.data ?? []
            self.refreshUI()
            self.tableView.reloadData()
            self.refreshPopupHeight(arr: self.ethnicityArray)
        }
    }

    func processForGetReligionData(type: String) {
        var params = [String:Any]()
        params["type"] = type
        if isFriend {
            params[WebConstants.friendsId] = GlobalVariables.shared.selectedFriendProfileId
        }
        self.getApiCall(params: params, url: APIUrl.BasicApis.religions) { model in
            self.religionArray = model?.data ?? []
            self.refreshUI()
            self.tableView.reloadData()
            self.refreshPopupHeight(arr: self.religionArray)
        }
    }
    
    func processForGetRelationshipsData(type: String) {
        var params = [String:Any]()
        params["type"] = type
        if isFriend {
            params[WebConstants.friendsId] = GlobalVariables.shared.selectedFriendProfileId
        }
        self.getApiCall(params: params, url: APIUrl.BasicApis.relationships) { model in
            self.relationshipsArray = model?.data ?? []
            self.refreshUI()
            self.tableView.reloadData()
            self.refreshPopupHeight(arr: self.relationshipsArray)
        }
    }
    
    func processForGetWishingData(type: String) {
        var params = [String:Any]()
        params["type"] = type
        
        if isFriend {
            params[WebConstants.friendsId] = GlobalVariables.shared.selectedFriendProfileId
        }
        
        self.getApiCall(params: params, url: APIUrl.BasicApis.wishingToHave) { model in
            self.wishighArray = model?.data ?? []
            for _ in 0..<self.wishighArray.count {
                self.genderArrayIndex.append("NO")
            }
            self.refreshUI()
            self.tableView.reloadData()
            self.refreshPopupHeight(arr: self.wishighArray)
        }
    }
    
    func processForGetEducationData(type: String) {
        var params = [String:Any]()
        params["type"] = type
        if isFriend {
            params[WebConstants.friendsId] = GlobalVariables.shared.selectedFriendProfileId
        }
        self.getApiCall(params: params, url: APIUrl.BasicApis.educational) { model in
            self.educationArray = model?.data ?? []
            self.refreshUI()
            self.tableView.reloadData()
            self.refreshPopupHeight(arr: self.educationArray)
        }
    }
    
    func processForGetWorkIndustryData(type: String) {
        var params = [String:Any]()
        params["type"] = type
        if isFriend {
            params[WebConstants.friendsId] = GlobalVariables.shared.selectedFriendProfileId
        }
        self.getApiCall(params: params, url: APIUrl.BasicApis.workIndustries) { model in
            self.workIndustryArray = model?.data ?? []
            self.refreshUI()
            self.tableView.reloadData()
            self.refreshPopupHeight(arr: self.workIndustryArray)
        }
    }
    
    func processForGetPassionData(type: String) {
        var params = [String:Any]()
        params["type"] = type
        if isFriend {
            params[WebConstants.friendsId] = GlobalVariables.shared.selectedFriendProfileId
        }
        self.getApiCall(params: params, url: APIUrl.BasicApis.passions) { model in
            self.passionArray = model?.data ?? []
            self.refreshUI()
            self.tableView.reloadData()
            self.refreshPopupHeight(arr: self.passionArray)
        }
    }
    
    func processForGetSexualData(type: String) {
        var params = [String:Any]()
        params["type"] = type
        if isFriend {
            params[WebConstants.friendsId] = GlobalVariables.shared.selectedFriendProfileId
        }
        self.getApiCall(params: params, url: APIUrl.BasicApis.sexualOrientation) { model in
            self.sexualArray = model?.data ?? []
            self.refreshUI()
            self.tableView.reloadData()
            self.refreshPopupHeight(arr: self.sexualArray)
        }
    }
    
    func processForGetMovieData(type: String) {
        var params = [String:Any]()
        params["type"] = type
        if isFriend {
            params[WebConstants.friendsId] = GlobalVariables.shared.selectedFriendProfileId
        }
        self.getApiCall(params: params, url: APIUrl.BasicApis.movies) { model in
            self.moviesArray = model?.data ?? []
            self.refreshUI()
            self.tableView.reloadData()
            self.refreshPopupHeight(arr: self.moviesArray)
        }
    }
    
    func processForGetMusicData(type: String) {
        var params = [String:Any]()
        params["type"] = type
        if isFriend {
            params[WebConstants.friendsId] = GlobalVariables.shared.selectedFriendProfileId
        }
        self.getApiCall(params: params, url: APIUrl.BasicApis.music) { model in
            self.musicArray = model?.data ?? []
            self.refreshUI()
            self.tableView.reloadData()
            self.refreshPopupHeight(arr: self.musicArray)
        }
    }
    
    func processForGetDrinkingData(type: String) {
        var params = [String:Any]()
        params["type"] = type
        if isFriend {
            params[WebConstants.friendsId] = GlobalVariables.shared.selectedFriendProfileId
        }
        self.getApiCall(params: params, url: APIUrl.BasicApis.drinking) { model in
            self.DrinkingArray = model?.data ?? []
            self.refreshUI()
            self.tableView.reloadData()
            self.refreshPopupHeight(arr: self.DrinkingArray)
        }
    }
    func processForGetSmokingData(type: String) {
        var params = [String:Any]()
        params["type"] = type
        if isFriend {
            params[WebConstants.friendsId] = GlobalVariables.shared.selectedFriendProfileId
        }
        self.getApiCall(params: params, url: APIUrl.BasicApis.smoking) { model in
            self.smokingArray = model?.data ?? []
            self.refreshUI()
            self.tableView.reloadData()
            self.refreshPopupHeight(arr: self.smokingArray)
        }
    }
    
    func processForGetZodiacData(type: String) {
        var params = [String:Any]()
        params["type"] = type
        if isFriend {
            params[WebConstants.friendsId] = GlobalVariables.shared.selectedFriendProfileId
        }
        self.getApiCall(params: params, url: APIUrl.BasicApis.zodiac) { model in
            self.zodiacArray = model?.data ?? []
            self.refreshUI()
            self.tableView.reloadData()
            self.refreshPopupHeight(arr: self.zodiacArray)
        }
    }
    func processForGetKidsData(type: String) {
        var params = [String:Any]()
        params["type"] = type
        if isFriend {
            params[WebConstants.friendsId] = GlobalVariables.shared.selectedFriendProfileId
        }
        self.getApiCall(params: params, url: APIUrl.BasicApis.kids) { model in
            self.kidsArray = model?.data ?? []
            self.refreshUI()
            self.tableView.reloadData()
            self.refreshPopupHeight(arr: self.kidsArray)
        }
    }
    
    func processForGetPersonalityData(type: String) {
        var params = [String:Any]()
        params["type"] = type
        if isFriend {
            params[WebConstants.friendsId] = GlobalVariables.shared.selectedFriendProfileId
        }
        self.getApiCall(params: params, url: APIUrl.BasicApis.personality) { model in
            self.personalityArray = model?.data ?? []
            self.refreshUI()
            self.tableView.reloadData()
            self.refreshPopupHeight(arr: self.personalityArray)
        }
    }
    
    func processForGetSexualOrientationData(type: String) {
        var params = [String:Any]()
        params["type"] = type
        if isFriend {
            params[WebConstants.friendsId] = GlobalVariables.shared.selectedFriendProfileId
        }
        self.getApiCall(params: params, url: APIUrl.BasicApis.sexualOrientation) { model in
            self.sexualArray = model?.data ?? []
            self.refreshUI()
            self.tableView.reloadData()
            self.refreshPopupHeight(arr: self.sexualArray)
        }
    }
    func processForGetWorkoutData(type: String) {
        var params = [String:Any]()
        params["type"] = type
        if isFriend {
            params[WebConstants.friendsId] = GlobalVariables.shared.selectedFriendProfileId
        }
        self.getApiCall(params: params, url: APIUrl.BasicApis.workout) { model in
            self.workoutArray = model?.data ?? []
            self.refreshUI()
            self.tableView.reloadData()
            self.refreshPopupHeight(arr: self.workoutArray)
        }
    }
    func processForGetBooksData(type: String) {
        var params = [String:Any]()
        params["type"] = type
        if isFriend {
            params[WebConstants.friendsId] = GlobalVariables.shared.selectedFriendProfileId
        }
        self.getApiCall(params: params, url: APIUrl.BasicApis.books) { model in
            self.booksArray = model?.data ?? []
            for _ in 0..<self.booksArray.count {
                self.genderArrayIndex.append("NO")
            }
            self.refreshUI()
            self.tableView.reloadData()
            self.refreshPopupHeight(arr: self.booksArray)
        }
    }
    
    func processForGetSportsData(type: String) {
        var params = [String:Any]()
        params["type"] = type
        if isFriend {
            params[WebConstants.friendsId] = GlobalVariables.shared.selectedFriendProfileId
        }
        self.getApiCall(params: params, url: APIUrl.BasicApis.sports) { model in
            self.sportsArray = model?.data ?? []
            for _ in 0..<self.sportsArray.count {
                self.genderArrayIndex.append("NO")
            }
            self.refreshUI()
            self.tableView.reloadData()
            self.refreshPopupHeight(arr: self.sportsArray)
        }
    }
    func processForGetTVData(type: String) {
        var params = [String:Any]()
        params["type"] = type
        if isFriend {
            params[WebConstants.friendsId] = GlobalVariables.shared.selectedFriendProfileId
        }
        self.getApiCall(params: params, url: APIUrl.BasicApis.televisionSeries) { model in
            self.tvSeriesArray = model?.data ?? []
            self.refreshUI()
            self.tableView.reloadData()
            self.refreshPopupHeight(arr: self.tvSeriesArray)
        }
    }
    
    func getApiCall(params: [String:Any], url: String, _ result: @escaping(ResponseModel?) -> Void) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        
        ApiManagerWithCodable<ResponseModel>.makeApiCall(url, params: params,
                                                         headers: headers,
                                                         method: .get) { (response, resultModel) in
            hideLoader()
            if resultModel?.statusCode == 200 {
                result(resultModel)
            } else {
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
}

extension GenderViewModel : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isComeFor == "Gender" || isComeFor == "MoreDetailGender" || isComeFor == "PreferredGender" {
            return self.genderArray.count
        } else if isComeFor == "Ethencity" || isComeFor == "PreferenceEthencity" {
            return self.ethnicityArray.count
        } else if isComeFor == "Religion" || isComeFor == "PreferenceReligion" {
            return self.religionArray.count
        } else if isComeFor == "Relationships" || isComeFor == "PreferenceRelationships" {
            return self.relationshipsArray.count
        } else if isComeFor == "Education" || isComeFor == "PreferenceEducation" {
            return self.educationArray.count
        } else if isComeFor == "Work" || isComeFor == "PreferenceWork" {
            return self.workIndustryArray.count
        } else if isComeFor == "Passion" || isComeFor == "PreferencePassion" {
            return self.passionArray.count
        } else if isComeFor == "Movies" {
            return self.moviesArray.count
        } else if isComeFor == "Music" {
            return self.musicArray.count
        } else if isComeFor == "Drinking" || isComeFor == "PreferenceDrinking" {
            return self.DrinkingArray.count
        } else if isComeFor == "Smoking" || isComeFor == "PreferenceSmoking" {
            return self.smokingArray.count
        } else if isComeFor == "TV" {
            return self.tvSeriesArray.count
        } else if isComeFor == "PreferenceGender" || isComeFor == "BasicRelationships" {
            return self.genderArray.count
        } else if isComeFor == "sexualPreference" || isComeFor == "sexualPreference2" {
            return self.sexualArray.count
        } else if isComeFor == "PreferenceZodiac" || isComeFor == "Zodiac" {
            return self.zodiacArray.count
        } else if self.isComeFor == "PreferenceKids"  || isComeFor == "Kids" {
            return self.kidsArray.count
        } else if isComeFor == "PreferencePersonality" || isComeFor == "Personality" {
            return self.personalityArray.count
        } else if isComeFor == "Sexual" {
            return self.sexualArray.count
        } else if self.isComeFor == "Workout" {
            return self.workoutArray.count
        } else if self.isComeFor == "Books" {
            return self.booksArray.count
        } else if self.isComeFor == "Sports" {
            return self.sportsArray.count
        } else if isComeFor == "Wishing" || isComeFor == "AboutMeWishing" || isComeFor == "PreferenceAboutMeWishing" {
            return self.wishighArray.count
        }
          else{
            return self.genderArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.genderCell, for: indexPath) as? genderTableViewCell{
            if isComeFor == "Gender" {
                cell.titleLabel.text = self.genderArray[indexPath.row].name
                if isSelectedIndex == -1 {
                    if self.selectedGenderId == self.genderArray[indexPath.row].id {
                        cell.tickImage.isHidden = false
                        cell.tickImage.image = UIImage(named: "ic_tick_gender")
                        self.selectedGenderValue = "\(self.genderArray[indexPath.row].name)"
                        self.selectedGenderID = "\(self.genderArray[indexPath.row].id)"
                    } else {
                        cell.tickImage.isHidden = false
                        cell.tickImage.image = UIImage(named: "")
                    }
                } else {
                    if isSelectedIndex == indexPath.row {
                        cell.tickImage.isHidden = false
                        cell.tickImage.image = UIImage(named: "ic_tick_gender")
                    } else {
                        cell.tickImage.isHidden = false
                        cell.tickImage.image = UIImage(named: "")
                    }
                }
            }
            else if isComeFor == "BasicRelationships" {
                cell.titleLabel.text = self.genderArray[indexPath.row].name
                if isSelectedIndex == -1 {
                    if self.selectedGenderId == self.genderArray[indexPath.row].id {
                        cell.tickImage.isHidden = false
                        cell.tickImage.image = UIImage(named: "ic_tick_gender")
                        self.selectedGenderValue = "\(self.genderArray[indexPath.row].name)"
                        self.selectedGenderID = "\(self.genderArray[indexPath.row].id)"
                    } else {
                        cell.tickImage.isHidden = false
                        cell.tickImage.image = UIImage(named: "")
                    }
                } else {
                    if isSelectedIndex == indexPath.row {
                        cell.tickImage.isHidden = false
                        cell.tickImage.image = UIImage(named: "ic_tick_gender")
                    } else {
                        cell.tickImage.isHidden = false
                        cell.tickImage.image = UIImage(named: "")
                    }
                }
            }
            else if isComeFor == "MoreDetailGender" {
                cell.titleLabel.text = self.genderArray[indexPath.row].name
                if isSelectedIndex == -1{
                    if let genders = self.userResponseData["Gender"] as? [String:Any] {
                        if genders["id"] as? String == self.genderArray[indexPath.row].id{
                            cell.tickImage.isHidden = false
                            cell.tickImage.image = UIImage(named: "ic_tick_gender")
                            self.selectedGenderValue = "\(self.genderArray[indexPath.row].name)"
                            self.selectedGenderID = "\(self.genderArray[indexPath.row].id)"
                        }else{
                            cell.tickImage.isHidden = true
                        }
                    }else {
                        cell.tickImage.isHidden = true
                    }
                } else {
                    if isSelectedIndex == indexPath.row {
                        cell.tickImage.isHidden = false
                        cell.tickImage.image = UIImage(named: "ic_tick_gender")
                    }else{
                        cell.tickImage.isHidden = true
                    }
                }
                
            } else if isComeFor == "Ethencity" {
                cell.titleLabel.text = self.ethnicityArray[indexPath.row].name
                if isSelectedIndex == -1{
                    if let genders = self.userResponseData["Ethnicity"] as? [String:Any] {
                        if genders["id"] as? String == self.ethnicityArray[indexPath.row].id{
                            cell.tickImage.isHidden = false
                            cell.tickImage.image = UIImage(named: "ic_tick_gender")
                            self.selectedGenderValue = "\(self.ethnicityArray[indexPath.row].name)"
                            self.selectedGenderID = "\(self.ethnicityArray[indexPath.row].id)"
                        }else{
                            cell.tickImage.isHidden = true
                        }
                    }else {
                        cell.tickImage.isHidden = true
                    }
                } else {
                    if isSelectedIndex == indexPath.row{
                        cell.tickImage.isHidden = false
                        cell.tickImage.image = UIImage(named: "ic_tick_gender")
                    }else{
                        cell.tickImage.isHidden = true
                    }
                }
            } else if isComeFor == "Religion" {
                cell.titleLabel.text = self.religionArray[indexPath.row].name
                if isSelectedIndex == -1{
                    if let genders = self.userResponseData["Religion"] as? [String:Any] {
                        if genders["id"] as? String == self.religionArray[indexPath.row].id{
                            cell.tickImage.isHidden = false
                            cell.tickImage.image = UIImage(named: "ic_tick_gender")
                            self.selectedGenderValue = "\(self.religionArray[indexPath.row].name)"
                            self.selectedGenderID = "\(self.religionArray[indexPath.row].id)"
                        }else{
                            cell.tickImage.isHidden = true
                        }
                    }else {
                        cell.tickImage.isHidden = true
                    }
                } else {
                    if isSelectedIndex == indexPath.row{
                        cell.tickImage.isHidden = false
                        cell.tickImage.image = UIImage(named: "ic_tick_gender")
                    }else{
                        cell.tickImage.isHidden = true
                    }
                }
            } else if isComeFor == "Relationships" {
                cell.titleLabel.text = self.relationshipsArray[indexPath.row].name
                if isSelectedIndex == -1 {
                    if let genders = self.userResponseData["Relationship"] as? [String:Any] {
                        if genders["id"] as? String == self.relationshipsArray[indexPath.row].id {
                            cell.tickImage.isHidden = false
                            cell.tickImage.image = UIImage(named: "ic_tick_gender")
                            self.selectedGenderValue = "\(self.relationshipsArray[indexPath.row].name)"
                            self.selectedGenderID = "\(self.relationshipsArray[indexPath.row].id)"
                        } else {
                            cell.tickImage.isHidden = true
                        }
                    } else {
                        cell.tickImage.isHidden = true
                    }
                } else {
                    if isSelectedIndex == indexPath.row {
                        cell.tickImage.isHidden = false
                        cell.tickImage.image = UIImage(named: "ic_tick_gender")
                    }else{
                        cell.tickImage.isHidden = true
                    }
                }
            } else if isComeFor == "Education" {
                cell.titleLabel.text = self.educationArray[indexPath.row].name
                if isSelectedIndex == -1{
                    if let educationQualificationId = self.userResponseData["educationQualificationId"] as? String {
                        if educationQualificationId == self.educationArray[indexPath.row].id{
                            cell.tickImage.isHidden = false
                            cell.tickImage.image = UIImage(named: "ic_tick_gender")
                            self.selectedGenderValue = "\(self.educationArray[indexPath.row].name)"
                            self.selectedGenderID = "\(self.educationArray[indexPath.row].id)"
                        }else{
                            cell.tickImage.isHidden = true
                        }
                    } else {
                        cell.tickImage.isHidden = true
                    }
                } else {
                    if isSelectedIndex == indexPath.row{
                        cell.tickImage.isHidden = false
                        cell.tickImage.image = UIImage(named: "ic_tick_gender")
                    }else{
                        cell.tickImage.isHidden = true
                    }
                }
            } else if isComeFor == "Work" {
                cell.titleLabel.text = self.workIndustryArray[indexPath.row].name
                if isSelectedIndex == -1{
                    if let genders = self.userResponseData["WorkIndustry"] as? [String:Any] {
                        if genders["name"] as? String == self.workIndustryArray[indexPath.row].name{
                            cell.tickImage.isHidden = false
                            cell.tickImage.image = UIImage(named: "ic_tick_gender")
                            self.selectedGenderValue = "\(self.workIndustryArray[indexPath.row].name)"
                            self.selectedGenderID = "\(self.workIndustryArray[indexPath.row].id)"
                        }else{
                            cell.tickImage.isHidden = true
                        }
                    }else {
                        cell.tickImage.isHidden = true
                    }
                } else {
                    if isSelectedIndex == indexPath.row{
                        cell.tickImage.isHidden = false
                        cell.tickImage.image = UIImage(named: "ic_tick_gender")
                    }else{
                        cell.tickImage.isHidden = true
                    }
                }
            } else if isComeFor == "Zodiac" {
                cell.titleLabel.text = self.zodiacArray[indexPath.row].name
                if isSelectedIndex == -1{
                    if let genders = self.userResponseData["zodiac"] as? [String:Any] {
                        if genders["name"] as? String == self.zodiacArray[indexPath.row].name{
                            cell.tickImage.isHidden = false
                            cell.tickImage.image = UIImage(named: "ic_tick_gender")
                            self.selectedGenderValue = "\(self.zodiacArray[indexPath.row].name)"
                            self.selectedGenderID = "\(self.zodiacArray[indexPath.row].id)"
                        }else{
                            cell.tickImage.isHidden = true
                        }
                    }else {
                        cell.tickImage.isHidden = true
                    }
                } else {
                    if isSelectedIndex == indexPath.row{
                        cell.tickImage.isHidden = false
                        cell.tickImage.image = UIImage(named: "ic_tick_gender")
                    }else{
                        cell.tickImage.isHidden = true
                    }
                }
            } else if isComeFor == "Kids" {
                cell.titleLabel.text = self.kidsArray[indexPath.row].name
                if isSelectedIndex == -1{
                    if let genders = self.userResponseData["kid"] as? [String:Any] {
                        if genders["name"] as? String == self.kidsArray[indexPath.row].name{
                            cell.tickImage.isHidden = false
                            cell.tickImage.image = UIImage(named: "ic_tick_gender")
                            self.selectedGenderValue = "\(self.kidsArray[indexPath.row].name)"
                            self.selectedGenderID = "\(self.kidsArray[indexPath.row].id)"
                        }else{
                            cell.tickImage.isHidden = true
                        }
                    }else {
                        cell.tickImage.isHidden = true
                    }
                } else {
                    if isSelectedIndex == indexPath.row{
                        cell.tickImage.isHidden = false
                        cell.tickImage.image = UIImage(named: "ic_tick_gender")
                    }else{
                        cell.tickImage.isHidden = true
                    }
                }
            } else if isComeFor == "Personality" {
                cell.titleLabel.text = self.personalityArray[indexPath.row].name
                if isSelectedIndex == -1{
                    if let genders = self.userResponseData["personality"] as? [String:Any] {
                        if genders["name"] as? String == self.personalityArray[indexPath.row].name{
                            cell.tickImage.isHidden = false
                            cell.tickImage.image = UIImage(named: "ic_tick_gender")
                            self.selectedGenderValue = "\(self.personalityArray[indexPath.row].name)"
                            self.selectedGenderID = "\(self.personalityArray[indexPath.row].id)"
                        }else{
                            cell.tickImage.isHidden = true
                        }
                    }else {
                        cell.tickImage.isHidden = true
                    }
                } else {
                    if isSelectedIndex == indexPath.row{
                        cell.tickImage.isHidden = false
                        cell.tickImage.image = UIImage(named: "ic_tick_gender")
                    }else{
                        cell.tickImage.isHidden = true
                    }
                }
            } else if isComeFor == "Sexual" {
                cell.titleLabel.text = self.sexualArray[indexPath.row].name
                if isSelectedIndex == -1{
                    if let genders = self.userResponseData["sexualOrientation"] as? [String:Any] {
                        if genders["name"] as? String == self.sexualArray[indexPath.row].name{
                            cell.tickImage.isHidden = false
                            cell.tickImage.image = UIImage(named: "ic_tick_gender")
                            self.selectedGenderValue = "\(self.sexualArray[indexPath.row].name)"
                            self.selectedGenderID = "\(self.sexualArray[indexPath.row].id)"
                        }else{
                            cell.tickImage.isHidden = true
                        }
                    }else {
                        cell.tickImage.isHidden = true
                    }
                } else {
                    if isSelectedIndex == indexPath.row{
                        cell.tickImage.isHidden = false
                        cell.tickImage.image = UIImage(named: "ic_tick_gender")
                    }else{
                        cell.tickImage.isHidden = true
                    }
                }
            } else if isComeFor == "Workout" {
                cell.titleLabel.text = self.workoutArray[indexPath.row].name
                if isSelectedIndex == -1{
                    if let genders = self.userResponseData["workout"] as? [String:Any] {
                        if genders["name"] as? String == self.workoutArray[indexPath.row].name{
                            cell.tickImage.isHidden = false
                            cell.tickImage.image = UIImage(named: "ic_tick_gender")
                            self.selectedGenderValue = "\(self.workoutArray[indexPath.row].name)"
                            self.selectedGenderID = "\(self.workoutArray[indexPath.row].id)"
                        }else{
                            cell.tickImage.isHidden = true
                        }
                    }else {
                        cell.tickImage.isHidden = true
                    }
                } else {
                    if isSelectedIndex == indexPath.row{
                        cell.tickImage.isHidden = false
                        cell.tickImage.image = UIImage(named: "ic_tick_gender")
                    }else{
                        cell.tickImage.isHidden = true
                    }
                }
            }else if isComeFor == "Passion" {
                cell.titleLabel.text = self.passionArray[indexPath.row].name
                
                if isSelectedIndex == indexPath.row{
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "ic_tick_gender")
                    self.selectedGenderValue = "\(self.passionArray[indexPath.row].name)"
                    self.selectedGenderID = "\(self.passionArray[indexPath.row].id)"
                }else{
                    cell.tickImage.isHidden = true
                }
                
            } else if isComeFor == "Movies" {
                cell.titleLabel.text = self.moviesArray[indexPath.row].name
                
                if isSelectedIndex == indexPath.row{
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "ic_tick_gender")
                }else{
                    cell.tickImage.isHidden = true
                }
                
            } else if isComeFor == "Music" {
                cell.titleLabel.text = self.musicArray[indexPath.row].name
                
                if isSelectedIndex == indexPath.row{
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "ic_tick_gender")
                }else{
                    cell.tickImage.isHidden = true
                }
                
            } else if isComeFor == "Drinking" {
                cell.titleLabel.text = self.DrinkingArray[indexPath.row].name
                if isSelectedIndex == -1{
                    if let genders = self.userResponseData["drinking"] as? [String:Any] {
                        if genders["name"] as? String == self.DrinkingArray[indexPath.row].name{
                            cell.tickImage.isHidden = false
                            cell.tickImage.image = UIImage(named: "ic_tick_gender")
                            self.selectedGenderValue = "\(self.DrinkingArray[indexPath.row].name)"
                            self.selectedGenderID = "\(self.DrinkingArray[indexPath.row].id)"
                        }else{
                            cell.tickImage.isHidden = true
                        }
                    }else {
                        cell.tickImage.isHidden = true
                    }
                } else {
                    if isSelectedIndex == indexPath.row{
                        cell.tickImage.isHidden = false
                        cell.tickImage.image = UIImage(named: "ic_tick_gender")
                    }else{
                        cell.tickImage.isHidden = true
                    }
                }
            } else if isComeFor == "Smoking" {
                cell.titleLabel.text = self.smokingArray[indexPath.row].name
                if isSelectedIndex == -1{
                    if let genders = self.userResponseData["smoking"] as? [String:Any] {
                        if genders["name"] as? String == self.smokingArray[indexPath.row].name{
                            cell.tickImage.isHidden = false
                            cell.tickImage.image = UIImage(named: "ic_tick_gender")
                            self.selectedGenderValue = "\(self.smokingArray[indexPath.row].name)"
                            self.selectedGenderID = "\(self.smokingArray[indexPath.row].id)"
                        }else{
                            cell.tickImage.isHidden = true
                        }
                    }else {
                        cell.tickImage.isHidden = true
                    }
                } else {
                    if isSelectedIndex == indexPath.row{
                        cell.tickImage.isHidden = false
                        cell.tickImage.image = UIImage(named: "ic_tick_gender")
                    }else{
                        cell.tickImage.isHidden = true
                    }
                }
            } else if isComeFor == "TV" {
                cell.titleLabel.text = self.tvSeriesArray[indexPath.row].name
                
                if isSelectedIndex == indexPath.row{
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "ic_tick_gender")
                }else{
                    cell.tickImage.isHidden = true
                }
                
            }  else if isComeFor == "Sports" {
                cell.titleLabel.text = self.sportsArray[indexPath.row].name
                
                if self.genderArrayIndex[indexPath.row] == "YES" {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "SelectRectangle")
                }else{
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "UnSelectRectangle")
                }
            } else if isComeFor == "Books" {
                cell.titleLabel.text = self.booksArray[indexPath.row].name
                
                if self.genderArrayIndex[indexPath.row] == "YES" {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "SelectRectangle")
                }else{
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "UnSelectRectangle")
                }
            } else if isComeFor == "PreferenceGender" {
                cell.titleLabel.text = self.genderArray[indexPath.row].name
                
                if self.genderArrayIndex[indexPath.row] == "YES" {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "SelectRectangle")
                }else{
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "UnSelectRectangle")
                }
            }
            else if isComeFor == "Wishing" {
                cell.titleLabel.text = self.wishighArray[indexPath.row].name
                
                if self.genderArrayIndex[indexPath.row] == "YES" {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "SelectRectangle")
                } else {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "UnSelectRectangle")
                }
            }
            
            else if isComeFor == "AboutMeWishing" || isComeFor == "PreferenceAboutMeWishing" {
                cell.titleLabel.text = self.wishighArray[indexPath.row].name
                
                if self.genderArrayIndex[indexPath.row] == "YES" {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "SelectRectangle")
                } else {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "UnSelectRectangle")
                }
            }
            
            else if isComeFor == "PreferenceEthencity" {
                cell.titleLabel.text = self.ethnicityArray[indexPath.row].name
                
                if self.genderArrayIndex[indexPath.row] == "YES" {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "SelectRectangle")
                }else{
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "UnSelectRectangle")
                }
            }
            else if isComeFor == "PreferenceReligion" {
                cell.titleLabel.text = self.religionArray[indexPath.row].name
                
                if self.genderArrayIndex[indexPath.row] == "YES" {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "SelectRectangle")
                }else{
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "UnSelectRectangle")
                }
            }
            else if isComeFor == "PreferenceRelationships" {
                cell.titleLabel.text = self.relationshipsArray[indexPath.row].name
                
                if self.genderArrayIndex[indexPath.row] == "YES" {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "SelectRectangle")
                }else{
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "UnSelectRectangle")
                }
            }
            else if isComeFor == "PreferenceEducation" {
                cell.titleLabel.text = self.educationArray[indexPath.row].name
                
                if self.genderArrayIndex[indexPath.row] == "YES" {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "SelectRectangle")
                }else{
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "UnSelectRectangle")
                }
            }
            else if isComeFor == "PreferenceWork" {
                cell.titleLabel.text = self.workIndustryArray[indexPath.row].name
                
                if self.genderArrayIndex[indexPath.row] == "YES" {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "SelectRectangle")
                }else{
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "UnSelectRectangle")
                }
            }
            else if isComeFor == "PreferencePassion" {
                cell.titleLabel.text = self.passionArray[indexPath.row].name
                
                if self.genderArrayIndex[indexPath.row] == "YES" {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "SelectRectangle")
                }else{
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "UnSelectRectangle")
                }
            }
            
            else if isComeFor == "sexualPreference" {
                cell.titleLabel.text = self.sexualArray[indexPath.row].name
                
                if self.genderArrayIndex[indexPath.row] == "YES" {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "SelectRectangle")
                }else{
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "UnSelectRectangle")
                }
            } else if isComeFor == "sexualPreference2" {
                cell.titleLabel.text = self.sexualArray[indexPath.row].name
                
                if self.genderArrayIndex[indexPath.row] == "YES" {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "SelectRectangle")
                }else{
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "UnSelectRectangle")
                }
            }
            
            else if isComeFor == "PreferenceZodiac" {
                cell.titleLabel.text = self.zodiacArray[indexPath.row].name
                
                if self.genderArrayIndex[indexPath.row] == "YES" {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "SelectRectangle")
                }else{
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "UnSelectRectangle")
                }
            }
            
            else if self.isComeFor == "PreferenceKids" {
                cell.titleLabel.text = self.kidsArray[indexPath.row].name
                
                if self.genderArrayIndex[indexPath.row] == "YES" {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "SelectRectangle")
                }else{
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "UnSelectRectangle")
                }
            }
            else if isComeFor == "PreferencePersonality" {
                cell.titleLabel.text = self.personalityArray[indexPath.row].name
                
                if self.genderArrayIndex[indexPath.row] == "YES" {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "SelectRectangle")
                }else{
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "UnSelectRectangle")
                }
            }
            else if isComeFor == "PreferenceDrinking" {
                cell.titleLabel.text = self.DrinkingArray[indexPath.row].name
                
                if self.genderArrayIndex[indexPath.row] == "YES" {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "SelectRectangle")
                }else{
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "UnSelectRectangle")
                }
                
//                if isSelectedIndex == indexPath.row{
//                    cell.tickImage.isHidden = false
//                    cell.tickImage.image = UIImage(named: "ic_tick_gender")
//                }else{
//                    cell.tickImage.isHidden = true
//                }
            }
            else if isComeFor == "PreferenceSmoking" {
                cell.titleLabel.text = self.smokingArray[indexPath.row].name
                
                if self.genderArrayIndex[indexPath.row] == "YES" {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "SelectRectangle")
                }else{
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "UnSelectRectangle")
                }
                
//                if isSelectedIndex == indexPath.row{
//                    cell.tickImage.isHidden = false
//                    cell.tickImage.image = UIImage(named: "ic_tick_gender")
//                }else{
//                    cell.tickImage.isHidden = true
//                }
            }
            else{
                cell.titleLabel.text = self.genderArray[indexPath.row].name
                
                if self.genderArrayIndex[indexPath.row] == "YES" {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "SelectRectangle")
                }else{
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "UnSelectRectangle")
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isComeFor == "Gender" || isComeFor == "MoreDetailGender" || isComeFor == "BasicRelationships" {
            self.isSelectedIndex = indexPath.row
            self.selectedGenderValue = "\(self.genderArray[indexPath.row].name)"
            self.selectedGenderID = "\(self.genderArray[indexPath.row].id)"
        }
        else if isComeFor == "Ethencity" {
            self.isSelectedIndex = indexPath.row
            self.selectedGenderValue = "\(self.ethnicityArray[indexPath.row].name)"
            self.selectedGenderID = "\(self.ethnicityArray[indexPath.row].id)"
        }
        else if isComeFor == "Religion" {
            self.isSelectedIndex = indexPath.row
            self.selectedGenderValue = "\(self.religionArray[indexPath.row].name)"
            self.selectedGenderID = "\(self.religionArray[indexPath.row].id)"
        }
        else if isComeFor == "Relationships" {
            self.isSelectedIndex = indexPath.row
            self.selectedGenderValue = "\(self.relationshipsArray[indexPath.row].name)"
            self.selectedGenderID = "\(self.relationshipsArray[indexPath.row].id)"
        }
        else if isComeFor == "Education" {
            self.isSelectedIndex = indexPath.row
            self.selectedGenderValue = "\(self.educationArray[indexPath.row].name)"
            self.selectedGenderID = "\(self.educationArray[indexPath.row].id)"
        }
        else if isComeFor == "Work" {
            self.isSelectedIndex = indexPath.row
            self.selectedGenderValue = "\(self.workIndustryArray[indexPath.row].name)"
            self.selectedGenderID = "\(self.workIndustryArray[indexPath.row].id)"
        }
        else if isComeFor == "Zodiac" {
            self.isSelectedIndex = indexPath.row
            self.selectedGenderValue = "\(self.zodiacArray[indexPath.row].name)"
            self.selectedGenderID = "\(self.zodiacArray[indexPath.row].id)"
        }
        else if isComeFor == "Kids" {
            self.isSelectedIndex = indexPath.row
            self.selectedGenderValue = "\(self.kidsArray[indexPath.row].name)"
            self.selectedGenderID = "\(self.kidsArray[indexPath.row].id)"
        }
        else if isComeFor == "Personality" {
            self.isSelectedIndex = indexPath.row
            self.selectedGenderValue = "\(self.personalityArray[indexPath.row].name)"
            self.selectedGenderID = "\(self.personalityArray[indexPath.row].id)"
        }
        else if isComeFor == "Sexual" {
            self.isSelectedIndex = indexPath.row
            self.selectedGenderValue = "\(self.sexualArray[indexPath.row].name)"
            self.selectedGenderID = "\(self.sexualArray[indexPath.row].id)"
        }
        else if isComeFor == "Workout" {
            self.isSelectedIndex = indexPath.row
            self.selectedGenderValue = "\(self.workoutArray[indexPath.row].name)"
            self.selectedGenderID = "\(self.workoutArray[indexPath.row].id)"
        }
        else if isComeFor == "Passion" {
            self.isSelectedIndex = indexPath.row
            self.selectedGenderValue = "\(self.passionArray[indexPath.row].name)"
            self.selectedGenderID = "\(self.passionArray[indexPath.row].id)"
        }
        else if isComeFor == "sexualPreference" {
            if self.genderArrayIndex[indexPath.row] == "YES" {
                self.genderArrayIndex[indexPath.row] = "NO"
            } else {
                self.genderArrayIndex[indexPath.row] = "YES"
            }
        }else if isComeFor == "sexualPreference2" {
            if self.genderArrayIndex[indexPath.row] == "YES" {
                self.genderArrayIndex[indexPath.row] = "NO"
            } else {
                self.genderArrayIndex[indexPath.row] = "YES"
            }
        }
        else if isComeFor == "Movies" {
            self.isSelectedIndex = indexPath.row
            self.selectedGenderValue = "\(self.moviesArray[indexPath.row].name)"
            self.selectedGenderID = "\(self.moviesArray[indexPath.row].id)"
        }
        else if isComeFor == "Music" {
            self.isSelectedIndex = indexPath.row
            self.selectedGenderValue = "\(self.musicArray[indexPath.row].name)"
            self.selectedGenderID = "\(self.musicArray[indexPath.row].id)"
        }
        else if isComeFor == "Drinking" {
            self.isSelectedIndex = indexPath.row
            self.selectedGenderValue = "\(self.DrinkingArray[indexPath.row].name)"
            self.selectedGenderID = "\(self.DrinkingArray[indexPath.row].id)"
        }
        else if isComeFor == "Smoking" {
            self.isSelectedIndex = indexPath.row
            self.selectedGenderValue = "\(self.smokingArray[indexPath.row].name)"
            self.selectedGenderID = "\(self.smokingArray[indexPath.row].id)"
        }
        else if isComeFor == "TV" {
            self.isSelectedIndex = indexPath.row
            self.selectedGenderValue = "\(self.tvSeriesArray[indexPath.row].name)"
            self.selectedGenderID = "\(self.tvSeriesArray[indexPath.row].id)"
        }
        else if isComeFor == "PreferenceGender" {
            if self.genderArrayIndex[indexPath.row] == "YES" {
                self.genderArrayIndex[indexPath.row] = "NO"
            } else {
                self.genderArrayIndex[indexPath.row] = "YES"
            }
        }
        else if isComeFor == "Wishing" {
            if self.genderArrayIndex[indexPath.row] == "YES" {
                self.genderArrayIndex[indexPath.row] = "NO"
            } else {
                self.genderArrayIndex[indexPath.row] = "YES"
            }
        }
        else if isComeFor == "PreferenceEthencity" {
            if self.genderArrayIndex[indexPath.row] == "YES" {
                self.genderArrayIndex[indexPath.row] = "NO"
            } else {
                self.genderArrayIndex[indexPath.row] = "YES"
            }
        }
        else if isComeFor == "PreferenceReligion" {
            if self.genderArrayIndex[indexPath.row] == "YES" {
                self.genderArrayIndex[indexPath.row] = "NO"
            } else {
                self.genderArrayIndex[indexPath.row] = "YES"
            }
        }
        else if isComeFor == "PreferenceDrinking" {
            if self.genderArrayIndex[indexPath.row] == "YES" {
                self.genderArrayIndex[indexPath.row] = "NO"
            } else {
                self.genderArrayIndex[indexPath.row] = "YES"
            }
        }
        else if isComeFor == "PreferenceSmoking" {
            if self.genderArrayIndex[indexPath.row] == "YES" {
                self.genderArrayIndex[indexPath.row] = "NO"
            } else {
                self.genderArrayIndex[indexPath.row] = "YES"
            }
        }
        else if isComeFor == "PreferenceZodiac" {
            if self.genderArrayIndex[indexPath.row] == "YES" {
                self.genderArrayIndex[indexPath.row] = "NO"
            } else {
                self.genderArrayIndex[indexPath.row] = "YES"
            }
        }
        else if self.isComeFor == "PreferenceKids" {
            if self.genderArrayIndex[indexPath.row] == "YES" {
                self.genderArrayIndex[indexPath.row] = "NO"
            } else {
                self.genderArrayIndex[indexPath.row] = "YES"
            }
        }
        else if isComeFor == "PreferencePersonality" {
            if self.genderArrayIndex[indexPath.row] == "YES" {
                self.genderArrayIndex[indexPath.row] = "NO"
            } else {
                self.genderArrayIndex[indexPath.row] = "YES"
            }
        }
        else if isComeFor == "Sports" {
            if self.genderArrayIndex[indexPath.row] == "YES" {
                self.genderArrayIndex[indexPath.row] = "NO"
            } else {
                self.genderArrayIndex[indexPath.row] = "YES"
            }
        }
        
        else if isComeFor == "Books" {
            if self.genderArrayIndex[indexPath.row] == "YES" {
                self.genderArrayIndex[indexPath.row] = "NO"
            } else {
                self.genderArrayIndex[indexPath.row] = "YES"
            }
        }
        else {
            if self.genderArrayIndex[indexPath.row] == "YES" {
                self.genderArrayIndex[indexPath.row] = "NO"
//                if let index = self.genderArrayIndex.firstIndex(where: {$0 ==  self.genderArrayIndex[indexPath.row]}) {
//                    self.genderArrayIndex.remove(at: index)
//                }
            } else {
                self.genderArrayIndex[indexPath.row] = "YES"
            }
        }
        
        self.tableView.reloadData()

    }
    
}
