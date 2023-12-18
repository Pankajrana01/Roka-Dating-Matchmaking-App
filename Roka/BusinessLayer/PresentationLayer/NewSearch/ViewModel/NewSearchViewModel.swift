//
//  NewSearchViewModel.swift
//  Roka
//
//  Created by  Developer on 02/11/22.
//

import Foundation
import UIKit

class NewSearchViewModel: BaseViewModel {
    var isComeFor = ""
    var completionHandler: ((Bool) -> Void)?
    
    // Saving temp data to send in filteredData.
    var tempMinAge: CGFloat = 18
    var tempMaxAge: CGFloat = 99
    var tempMinHeight: CGFloat = 4
    var tempMaxHeight: CGFloat = 6
    var tempGender: [String] = []
    var tempEthencity: [String] = []
    var tempReligion: [String] = []
    var tempRelationship: [String] = []
    var tempEducation: [String] = []
    var tempWorkIndustry: [String] = []
    var tempPassions: [String] = []
    var tempMovies: [String] = []
    var tempMusic: [String] = []
    var tempSmoking: [String] = []
    var tempDriking: [String] = []
    var tempTelevision: [String] = []
    var tempZodiaces: [String] = []
    var tempKids: [String] = []
    var tempPersonalities: [String] = []
    var tempHeightType = "Feet"
    
    var preferenceId = ""
    var filteredData: [String: Any] = [
        "title": "",
        "minAge": 18,
        "maxAge": 99,
        "minHeight": "4.0",
        "maxHeight": "6.0",
        "heightType": "Feet",
        "gender": [],
        "ethnicity": [],
        "religion": [],
        "relationship": [],
        "education": [],
        "workIndustry": [],
        "passions": [],
        "movies": [],
        "music": [],
        "tvSeries": [],
        "personality": [],
        "smokingIds": [],
        "drinkingIds": [],
        "zodiacIds": [],
        "kidsIds": []
    ]
    
    var modelArray: [SettingModel] = [
        SettingModel(image: "ic_age", label: "Age Range", isForward: false, isLine: false),
        SettingModel(image: "Ic_gender_1", label: "Gender", isForward: false, isLine: false),
        SettingModel(image: "ic_height_1", label: "Height", isForward: false, isLine: false),
        SettingModel(image: "ic_ethencity_1", label: "Ethnicity", isForward: false, isLine: false),
        SettingModel(image: "Ic_religion", label: "Religion", isForward: false, isLine: false),
//        SettingModel(image: "Ic_relationship_Status", label: "Relationship Status", isForward: false, isLine: false),
        SettingModel(image: "ic_education", label: "Education level", isForward: false, isLine: false),
        SettingModel(image: "ic_work_industry", label: "Work Industry", isForward: false, isLine: false),
        SettingModel(image: "ic_passions", label: "Passions", isForward: false, isLine: false),
        SettingModel(image: "ic_movies", label: "Movie/TV genre", isForward: false, isLine: false),
        SettingModel(image: "ic_music", label: "Music genre", isForward: false, isLine: false),
        SettingModel(image: "ic_smoking", label: "Smoking", isForward: false, isLine: false),
        SettingModel(image: "ic_drink", label: "Drinking", isForward: false, isLine: false),
//        SettingModel(image: "ic_zodiac", label: "Zodiac", isForward: false, isLine: false),
//        SettingModel(image: "ic_kids", label: "Kids", isForward: false, isLine: false),
//        SettingModel(image: "ic_personality", label: "Personality", isForward: false, isLine: false)
    ]
    
    var genders: [GenderRow] = []
    var ethencities: [GenderRow] = []
    var religions: [GenderRow] = []
    var relationships: [GenderRow] = []
    var educations: [GenderRow] = []
    var workIndustries: [GenderRow] = []
    var passions: [GenderRow] = []
    var movies: [GenderRow] = []
    var musics: [GenderRow] = []
    var smokings: [GenderRow] = []
    var drinkings: [GenderRow] = []
    var zodiaces: [GenderRow] = []
    var kids: [GenderRow] = []
    var personalities: [GenderRow] = []
}

extension NewSearchViewModel {
    
    func processForGetGenderData(type: String, _ result: @escaping() -> Void) {
        var params = [String:Any]()
        params["type"] = type
        self.getApiCall(params: params, url: APIUrl.BasicApis.genders) { model in
            self.genders.removeAll()
            if let model = model {
                for row in model.data {
                    self.genders.append(row)
                }
                result()
            }
        }
    }
    
    func processForGetEthentcityData(type: String, _ result: @escaping() -> Void) {
        var params = [String:Any]()
        params["type"] = type
        self.getApiCall(params: params, url: APIUrl.BasicApis.ethnicity) { model in
            self.ethencities.removeAll()
            if let model = model {
                for row in model.data {
                    self.ethencities.append(row)
                }
                result()
            }
        }
    }
    
    func processForGetReligionData(type: String, _ result: @escaping() -> Void) {
        var params = [String:Any]()
        params["type"] = type
        self.getApiCall(params: params, url: APIUrl.BasicApis.religions) { model in
            self.religions.removeAll()
            if let model = model {
                model.data.forEach { row in
                    self.religions.append(row)
                }
                result()
            }
        }
    }
    
    func processForGetRelationshipsData(type: String, _ result: @escaping() -> Void) {
        var params = [String:Any]()
        params["type"] = type
        self.getApiCall(params: params, url: APIUrl.BasicApis.relationships) { model in
            self.relationships.removeAll()
            if let model = model {
                for row in model.data {
                    self.relationships.append(row)
                }
                result()
            }
        }
    }
    
    func processForGetEducationData(type: String, _ result: @escaping() -> Void) {
        var params = [String:Any]()
        params["type"] = type
        self.getApiCall(params: params, url: APIUrl.BasicApis.educational) { model in
            self.educations.removeAll()
            if let model = model {
                for row in model.data {
                    self.educations.append(row)
                }
                result()
            }
        }
    }
    
    func processForGetWorkIndustryData(type: String, _ result: @escaping() -> Void) {
        var params = [String:Any]()
        params["type"] = type
        self.getApiCall(params: params, url: APIUrl.BasicApis.workIndustries) { model in
            self.workIndustries.removeAll()
            if let model = model {
                for row in model.data {
                    self.workIndustries.append(row)
                }
                result()
            }
        }
    }
    
    func processForGetPassionData(type: String, _ result: @escaping() -> Void) {
        var params = [String:Any]()
        params["type"] = type
        self.getApiCall(params: params, url: APIUrl.BasicApis.passions) { model in
            self.passions.removeAll()
            if let model = model {
                for row in model.data {
                    self.passions.append(row)
                }
                result()
            }
        }
    }
    
    func processForGetMovieData(type: String, _ result: @escaping() -> Void) {
        var params = [String:Any]()
        params["type"] = type
        self.getApiCall(params: params, url: APIUrl.BasicApis.movies) { model in
            self.movies.removeAll()
            if let model = model {
                for row in model.data {
                    self.movies.append(row)
                }
                result()
            }
        }
    }
    
    func processForGetMusicData(type: String, _ result: @escaping() -> Void) {
        var params = [String:Any]()
        params["type"] = type
        self.getApiCall(params: params, url: APIUrl.BasicApis.music) { model in
            self.musics.removeAll()
            if let model = model {
                for row in model.data {
                    self.musics.append(row)
                }
                result()
            }
        }
    }
    
    
    func processForGetSmokingData(type: String, _ result: @escaping() -> Void) {
        var params = [String:Any]()
        params["type"] = type
        self.getApiCall(params: params, url: APIUrl.BasicApis.smoking) { model in
            self.smokings.removeAll()
            if let model = model {
                for row in model.data {
                    self.smokings.append(row)
                }
                result()
            }
        }
    }
    
    func processForGetDrinkingData(type: String, _ result: @escaping() -> Void) {
        var params = [String:Any]()
        params["type"] = type
        self.getApiCall(params: params, url: APIUrl.BasicApis.drinking) { model in
            self.drinkings.removeAll()
            if let model = model {
                for row in model.data {
                    self.drinkings.append(row)
                }
                result()
            }
        }
    }
    
    func processForGetZodiacData(type: String, _ result: @escaping() -> Void) {
        var params = [String:Any]()
        params["type"] = type
        self.getApiCall(params: params, url: APIUrl.BasicApis.zodiac) { model in
            self.zodiaces.removeAll()
            if let model = model {
                for row in model.data {
                    self.zodiaces.append(row)
                }
                result()
            }
        }
    }
    
    func processForGetKidsData(type: String, _ result: @escaping() -> Void) {
        var params = [String:Any]()
        params["type"] = type
        self.getApiCall(params: params, url: APIUrl.BasicApis.kids) { model in
            self.kids.removeAll()
            if let model = model {
                for row in model.data {
                    self.kids.append(row)
                }
                result()
            }
        }
    }
    
    func processForGetPersonalityData(type: String, _ result: @escaping() -> Void) {
        var params = [String:Any]()
        params["type"] = type
        self.getApiCall(params: params, url: APIUrl.BasicApis.personality) { model in
            self.personalities.removeAll()
            if let model = model {
                for row in model.data {
                    self.personalities.append(row)
                }
                result()
            }
        }
    }
    
    func getPreferenceData(_ result: (() -> ())?) {
        guard !preferenceId.isEmpty else { return }
        clearData()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.UserApis.userSearchPreferences + "/\(preferenceId)",
                               headers: headers,
                               method: .get) { [weak self] response, _ in
            guard let strongSelf = self else { return }
            if !strongSelf.hasErrorIn(response) {
                let data = response![APIConstants.data] as! [String: Any]
                if let title = data["title"] as? String {
                    strongSelf.filteredData["title"] = title
                }
                if let minimumAge = data["userPreferences"] as? [Any], let dict = minimumAge[0] as? [String: Any], let minAge = dict["minAge"] as? CGFloat {
                    strongSelf.tempMinAge = minAge
                }
                if let maximumAge = data["userPreferences"] as? [Any], let dict = maximumAge[0] as? [String: Any], let maxAge = dict["maxAge"] as? CGFloat {
                    strongSelf.tempMaxAge = maxAge
                }
                if let genders = data["userGenderPreferences"] as? [[String: Any]] {
                    for gender in genders {
                        strongSelf.tempGender.append((gender["gendersId"] as? String) ?? "")
                    }
                }
                
//                if let minimumHeight = data["userPreferences"] as? [Any] {
//                    if let dict = minimumHeight[0] as? [String: Any] {
//                        if let minHeight = dict["minHeight"] {
//                            if let numberMinHeight = NumberFormatter().number(from: minHeight as! String) {
//                                let convertedMinHeight = CGFloat(truncating: numberMinHeight)
//                                strongSelf.tempMinHeight = convertedMinHeight
//                            }
//                        }
//                    }
//                }
                
                if let minimumHeight = data["userPreferences"] as? [Any], let dict = minimumHeight[0] as? [String: Any], let minHeight = dict["minHeight"] {
                    if minHeight is String {
                        if let numberMinHeight = NumberFormatter().number(from: minHeight as! String) {
                            let convertedMinHeight = CGFloat(truncating: numberMinHeight)
                            strongSelf.tempMinHeight = convertedMinHeight
                        }
                    } else {
                        strongSelf.tempMinHeight = dict["minHeight"] as? CGFloat ?? 0.0
                    }
                }
                if let maximumHeight = data["userPreferences"] as? [Any], let dict = maximumHeight[0] as? [String: Any], let maxHeight = dict["maxHeight"] {
                    if maxHeight is String {
                        if let numberMaxHeight = NumberFormatter().number(from: maxHeight as! String) {
                            let convertedMaxHeight = CGFloat(truncating: numberMaxHeight)
                            strongSelf.tempMaxHeight = convertedMaxHeight
                        }
                    } else {
                        strongSelf.tempMaxHeight = dict["maxHeight"] as? CGFloat ?? 0.0
                    }
                }
                if let heightType = data["userPreferences"] as? [Any], let dict = heightType[0] as? [String: Any], let hType = dict["heightType"] as? String {
                    strongSelf.tempHeightType = hType
                }
                if let ethicities = data["userEthnicityPreferences"] as? [[String: Any]] {
                    for ethnicity in ethicities {
                        strongSelf.tempEthencity.append((ethnicity["ethnicityId"] as? String) ?? "")
                    }
                }
                if let relationships = data["userRelationshipPreferences"] as? [[String: Any]] {
                    for relationship in relationships {
                        strongSelf.tempRelationship.append((relationship["relationshipId"] as? String) ?? "")
                    }
                }
                if let religions = data["userReligionPreferences"] as? [[String: Any]] {
                    for religion in religions {
                        strongSelf.tempReligion.append((religion["religionId"] as? String) ?? "")
                    }
                }
                if let educations = data["userQualificationPreferences"] as? [[String: Any]] {
                    for education in educations {
                        strongSelf.tempEducation.append((education["qualificationsId"] as? String) ?? "")
                    }
                }
                if let industries = data["userWorkIndustriesPreferences"] as? [[String: Any]] {
                    for industry in industries {
                        strongSelf.tempWorkIndustry.append((industry["workIndustryId"] as? String) ?? "")
                    }
                }
                if let musics = data["userMusicPreferences"] as? [[String: Any]] {
                    for music in musics {
                        strongSelf.tempMusic.append((music["musicId"] as? String) ?? "")
                    }
                }
                if let movies = data["userMoviesPreferences"] as? [[String: Any]] {
                    for movie in movies {
                        strongSelf.tempMovies.append((movie["movieId"] as? String) ?? "")
                    }
                }
                if let passions = data["userPassionPreferences"] as? [[String: Any]] {
                    for passion in passions {
                        strongSelf.tempPassions.append((passion["passionId"] as? String) ?? "")
                    }
                }
                if let smokings = data["userSmokingPreferences"] as? [[String: Any]] {
                    for smoking in smokings {
                        strongSelf.tempSmoking.append((smoking["smokingId"] as? String) ?? "")
                    }
                }
                if let drinkings = data["userDrinkingPreferences"] as? [[String: Any]] {
                    for drinking in drinkings {
                        strongSelf.tempDriking.append((drinking["drinkingId"] as? String) ?? "")
                    }
                }
                if let televisions = data["userTelevisionSeriesPreferances"] as? [[String: Any]] {
                    for television in televisions {
                        strongSelf.tempTelevision.append((television["televisionSeriesId"] as? String) ?? "")
                    }
                }
                if let zodiaces = data["userZodiacPreferences"] as? [[String: Any]] {
                    for zodiac in zodiaces {
                        strongSelf.tempZodiaces.append((zodiac["zodiacId"] as? String) ?? "")
                    }
                }
                if let kids = data["userKidsPreferences"] as? [[String: Any]] {
                    for kid in kids {
                        strongSelf.tempKids.append((kid["kidsId"] as? String) ?? "")
                    }
                }
                if let personalities = data["userPersonalityPrefrences"] as? [[String: Any]] {
                    for personality in personalities {
                        strongSelf.tempPersonalities.append((personality["personalityId"] as? String) ?? "")
                    }
                }
                strongSelf.updateFilteredData()
                result!()
            }
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
    
    func updateFilteredData() {
        filteredData["gender"] = tempGender
        filteredData["ethnicity"] = tempEthencity
        filteredData["relationship"] = tempRelationship
        filteredData["education"] = tempEducation
        filteredData["religion"] = tempReligion
        filteredData["workIndustry"] = tempWorkIndustry
        filteredData["passions"] = tempPassions
        filteredData["movies"] = tempMovies
        filteredData["music"] = tempMusic
        filteredData["smokingIds"] = tempSmoking
        filteredData["drinkingIds"] = tempDriking
        filteredData["zodiacIds"] = tempZodiaces
        filteredData["kidsIds"] = tempKids
        filteredData["personality"] = tempPersonalities
        filteredData["tvSeries"] = tempTelevision
        filteredData["minAge"] = tempMinAge
        filteredData["maxAge"] = tempMaxAge
        filteredData["minHeight"] = tempMinHeight
        filteredData["maxHeight"] = tempMaxHeight
        filteredData["heightType"] = tempHeightType
    }
    
    
    private func clearData() {
        tempGender.removeAll()
        tempMusic.removeAll()
        tempMovies.removeAll()
        tempPassions.removeAll()
        tempReligion.removeAll()
        tempEducation.removeAll()
        tempEthencity.removeAll()
        tempWorkIndustry.removeAll()
        tempRelationship.removeAll()
        tempSmoking.removeAll()
        tempDriking.removeAll()
        tempZodiaces.removeAll()
        tempKids.removeAll()
        tempPersonalities.removeAll()
        tempMinAge = 18
        tempMaxAge = 99
        tempMinHeight = 4
        tempMaxHeight = 6
        
        genders = []
        ethencities = []
        religions = []
        relationships = []
        educations  = []
        workIndustries = []
        passions = []
        movies = []
        musics = []
        smokings = []
        drinkings = []
        
    }
}
