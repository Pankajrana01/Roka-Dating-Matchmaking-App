//
//  MovieViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 11/10/22.
//

import Foundation
import UIKit

class MovieViewModel:BaseViewModel {
    var completionHandler: ((Int, [String]) -> Void)?
    var isCome = ""
    var isFriend = false
    var moviesArray = [GenderRow]()
    var musicArray = [GenderRow]()
    var passionArray = [GenderRow]()
    var tvSeriesArray = [GenderRow]()
    var workArray = [GenderRow]()
    var booksArray = [GenderRow]()
    var sportsArray = [GenderRow]()
    var workoutArray = [GenderRow]()
    var selectedMoviesArray = [GenderRow]()
    var selectedMusicArray = [GenderRow]()
    var selectedPassionArray = [GenderRow]()
    var selectedTvSeriesArray = [GenderRow]()
    var selectedWorkArray = [GenderRow]()
    var isPrivate = 0
    weak var rangeSlider2: RangeSeekSlider!
    var priority = 100
    var selectedPriority = 100
    var userResponseData = [String: Any]()
    
    func rangeSlider2Initialize() {
        rangeSlider2.delegate = self
        rangeSlider2.minValue = 0
        rangeSlider2.maxValue = 100
        rangeSlider2.selectedMaxValue = CGFloat(selectedPriority)
        self.priority = selectedPriority
        
        //rangeSlider1.setMinAndMaxValue(0, maxValue: 100)
//        let rangeValues = Array(0...100)
//        rangeSlider2.setRangeValues(rangeValues)
//        rangeSlider2.setValueChangedCallback { (minValue, maxValue) in
//            print("rangeSlider min value:\(minValue)")
//            print("rangeSlider max value:\(maxValue)")
//            self.priority = maxValue
//        }
//        rangeSlider2.setMinValueDisplayTextGetter { (minValue) -> String? in
//            return ""
//        }
//        rangeSlider2.setMaxValueDisplayTextGetter { (maxValue) -> String? in
//            return ""
//        }
    }
    
    // MARK: - API Call...
    func processForGetUserProfileData(_ result:@escaping([String: Any]?) -> Void) {
        showLoader()
        var url = ""
        var params = [String:Any]()
        
        if isFriend {
            url = APIUrl.UserMatchMaking.getUserMatchMakingProfileDetail
            params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
        } else {
            url = APIUrl.UserApis.getUserProfileDetail
            params = [:]
        }
        ApiManager.makeApiCall(url, params: params,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .get) { response, _ in
            if !self.hasErrorIn(response) {
                self.userResponseData = response![APIConstants.data] as! [String: Any]
                result(self.userResponseData)

            }
            hideLoader()
        }
    }
    
    func processForGetUserPreferenceProfileData(_ result:@escaping([String: Any]?) -> Void) {
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
                self.userResponseData = response![APIConstants.data] as! [String: Any]
                result(self.userResponseData)
            }
            hideLoader()
        }
    }
    
    func processForGetMovieData(type: String, _ result:@escaping(Bool?) -> Void) {
        var params = [String:Any]()
        params["type"] = type
        if isFriend {
            params[WebConstants.friendsId] = GlobalVariables.shared.selectedFriendProfileId
        }
        self.getApiCall(params: params, url: APIUrl.BasicApis.movies) { model in
            self.moviesArray = model?.data ?? []
            result(true)
        }
    }
    func processForGetMusicData(type: String, _ result:@escaping(Bool?) -> Void) {
        var params = [String:Any]()
        params["type"] = type
        if isFriend {
            params[WebConstants.friendsId] = GlobalVariables.shared.selectedFriendProfileId
        }
        self.getApiCall(params: params, url: APIUrl.BasicApis.music) { model in
            self.musicArray = model?.data ?? []
            result(true)
        }
    }
    func processForGetPassionData(type: String, _ result:@escaping(Bool?) -> Void) {
        var params = [String:Any]()
        params["type"] = type
        if isFriend {
            params[WebConstants.friendsId] = GlobalVariables.shared.selectedFriendProfileId
        }
        self.getApiCall(params: params, url: APIUrl.BasicApis.passions) { model in
            self.passionArray = model?.data ?? []
            result(true)
        }
    }
    
    func processForGetWorkData(type: String, _ result:@escaping(Bool?) -> Void) {
        var params = [String:Any]()
        params["type"] = type
        if isFriend {
            params[WebConstants.friendsId] = GlobalVariables.shared.selectedFriendProfileId
        }
        self.getApiCall(params: params, url: APIUrl.BasicApis.workIndustries) { model in
            self.workArray = model?.data ?? []
            result(true)
        }
    }
    func processForGetBooksData(type: String, _ result:@escaping(Bool?) -> Void) {
        var params = [String:Any]()
        params["type"] = type
        if isFriend {
            params[WebConstants.friendsId] = GlobalVariables.shared.selectedFriendProfileId
        }
        self.getApiCall(params: params, url: APIUrl.BasicApis.books) { model in
            self.booksArray = model?.data ?? []
            result(true)
        }
    }
    
    func processForGetSportsData(type: String, _ result:@escaping(Bool?) -> Void) {
        var params = [String:Any]()
        params["type"] = type
        if isFriend {
            params[WebConstants.friendsId] = GlobalVariables.shared.selectedFriendProfileId
        }
        self.getApiCall(params: params, url: APIUrl.BasicApis.sports) { model in
            self.sportsArray = model?.data ?? []
            result(true)
        }
    }
    
    func processForGetWorkoutData(type: String, _ result:@escaping(Bool?) -> Void) {
        var params = [String:Any]()
        params["type"] = type
        if isFriend {
            params[WebConstants.friendsId] = GlobalVariables.shared.selectedFriendProfileId
        }
        self.getApiCall(params: params, url: APIUrl.BasicApis.workout) { model in
            self.workoutArray = model?.data ?? []
            result(true)
        }
    }
    
    func processForGetTVData(type: String, _ result:@escaping(Bool?) -> Void) {
        var params = [String:Any]()
        params["type"] = type
        if isFriend {
            params[WebConstants.friendsId] = GlobalVariables.shared.selectedFriendProfileId
        }
        self.getApiCall(params: params, url: APIUrl.BasicApis.televisionSeries) { model in
            self.tvSeriesArray = model?.data ?? []
            result(true)
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

// MARK: - RangeSeekSliderDelegate
extension MovieViewModel: RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
       if slider === rangeSlider2 {
            print("Custom slider updated. Min Value: \(Int(minValue)) Max Value: \(Int(maxValue))")
            self.priority = Int(maxValue)
        } else {
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
