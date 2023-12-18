//
//  WebConstants.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

class GeneralAPiResponse: Codable {
    var statusCode: Int
    var message: String
    
    private enum CodingKeys: String, CodingKey { case statusCode, message }
            
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = try container.decode(Int.self, forKey: .statusCode)
        message = try container.decode(String.self, forKey: .message)
    }
}

struct APIConstants {
    static let code = "statusCode"
    static let response = "response"
    static let data = "data"
    static let rows  = "rows"
    static let message = "message"
    static let pageNumber = "page_number"
    static let responseType = "responseType"
    static let sessions = "sessions"
    static let status = "statusCode"
}

struct GenericErrorMessages {
    static let internalServerError = "Something went wrong. Try again."
    static let noInternet = "No internet connection."
}


struct APIUrl {
    static let host = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as! String
    static var baseUrl: String {
        return host + "api/v1/"
    }

    static let googleServicesBaseUrl = "https://maps.googleapis.com/maps/api/"
    
    struct GoogleApiUrls {
        static let autoCompleteUrl = "place/autocomplete/json"
        static let placeDetail = "place/details/json"
    }

    struct GeneralUrls {
        static let termsAndConditions = baseUrl + "common/terms"
        static let privacyPolicy = baseUrl + "common/privacy-policy"
        static let faqs = baseUrl + "common/faq"
    }
    
    struct BasicApis {
        private static let basePreFix   = baseUrl       + "common/"
        static let uploadImage          = basePreFix    + "getSignedURL"
        static let appVersion           = basePreFix    + "appVersion"
        static let getS3Floders         = basePreFix    + "s3folders"
        static let genders              = basePreFix    + "genders"
        static let ethnicity            = basePreFix    + "ethnicity"
        static let questionAboutUser    = basePreFix    + "questionAboutUser"
        static let religions            = basePreFix    + "religions"
        static let relationships        = basePreFix    + "relationships"
        static let wishingToHave        = basePreFix    + "wishingToHave"
        static let educational          = basePreFix    + "educationalQualifications"
        static let workIndustries       = basePreFix    + "workIndustries"
        static let passions             = basePreFix    + "passions"
        static let movies               = basePreFix    + "movies"
        static let music                = basePreFix    + "music"
        static let televisionSeries     = basePreFix    + "televisionSeries"
        static let drinking             = basePreFix    + "drinking"
        static let smoking              = basePreFix    + "smoking"
        static let zodiac               = basePreFix    + "zodiac"
        static let kids                 = basePreFix    + "kids"
        static let personality          = basePreFix    + "personality"
        static let reportReasons        = basePreFix    + "reportReasons"
        static let getSubscriptions     = basePreFix    + "getSubscriptions"
        static let sexualOrientation    = basePreFix    + "sexualOrientation"
        static let workout              = basePreFix    + "workout"
        static let sports               = basePreFix    + "sports"
        static let books                = basePreFix    + "books"
    }
    
    struct User {
        static let basePreFix           = baseUrl       + "user/"
    }
    
    struct UserApis {
        private static let basePreFix   = baseUrl        + "user/"
        static let verifyReferralCode   = basePreFix     + "verifyReferralCode"
        static let register             = basePreFix     + "signUp"
        static let login                = basePreFix     + "otpLogin"
        static let verifyPhoneNumber    = basePreFix     + "verifyPhoneNumber"
        static let resendOtpForVerification = basePreFix + "resendOtpForVerification"
        static let accountRecovery      = basePreFix     + "accountRecovery"
        static let registerUser         = basePreFix     + "registerUserV2"
        static let updateProfile        = basePreFix     + "updateProfile"
        static let updateProfilePrefrences = basePreFix  + "updateProfilePrefrences"
        static let getUserProfileDetail = basePreFix     + "getUserProfileDetail"
        static let getUserPreferenceDetail = basePreFix  + "getUserPreferenceDetail"
        static let logout                = basePreFix    + "logout"
        static let suggestion            = basePreFix    + "suggestion"
        static let userPhoneBookList     = basePreFix    + "userPhoneBookList"
        static let userPhoneBookListV2   = basePreFix    + "userPhoneBookListV2"
        
        static let blockContacts         = basePreFix    + "blockContacts"
        static let unblockContacts       = basePreFix    + "unblockContacts"
        static let blockUser             = basePreFix    + "blockUser"
        static let unblockUser           = basePreFix    + "unblockUser"

        static let getUserReferralCode   = basePreFix    + "getUserReferralCode"
        static let notificationSettings  = basePreFix    + "notificationSettings"
        static let gallery               = basePreFix    + "gallery"
        static let updateGallery         = basePreFix    + "updateGalleryV2"
        static let userSearchPreferences = baseUrl       + "userSearchPreferences"
        static let saveProfile           = basePreFix    + "saveProfile"
        static let savedProfiles         = basePreFix    + "savedProfiles"
        static let notifications         = basePreFix    + "notifications"
        static let emailForVerification  = basePreFix    + "emailForVerification"
        static let groups                = basePreFix    + "groups"
        static let getUsersDetailedListingByIds = basePreFix    + "getUsersDetailedListingByIds"
        static let invite = basePreFix    + "invite"
        static let activateDeactivate              = basePreFix    + "activateDeactivate"
        static let browserUser                         = basePreFix    + "browserUser"
    }
 
    struct UserMatchMaking {
        private static let basePreFix                 = baseUrl     + "userMatchMaking/"
        static let getfriendsProfile                  = basePreFix  + "getfriendsProfile"
        static let createFriendsProfile               = basePreFix  + "createFriendsProfile"
        static let updateMatchMakingGallery           = basePreFix  + "updateMatchMakingGallery"
        static let updateFriendsProfile               = basePreFix  + "updateFriendsProfile"
        static let updateFriendsProfilePrefrences     = basePreFix  + "updateFriendsProfilePrefrences"
        static let getUserMatchMakingProfileDetail    = basePreFix  + "getUserMatchMakingProfileDetail"
        static let getUserMatchMakingPreferenceDetail = basePreFix  + "getUserMatchMakingPreferenceDetail"
        static let getMatchMakingProfiles             = basePreFix  + "savedMatchMakingProfiles"
        static let matchMakingSuggestedProfiles       = basePreFix  + "matchMakingSuggestedProfiles"
        static let saveMatchMakingProfile             = basePreFix  + "saveMatchMakingProfile"
        static let getUserMatchMakingProfileData      = basePreFix  + "getUserMatchMakingProfileData"
        static let getNewSuggestedProfiles            = basePreFix  + "matchMakingNewSuggestedProfiles"
        static let likeProfile                        = basePreFix    + "likeUnlikeProfile"
        static let rejectProfile                      = basePreFix    + "rejectUnRejectProfile"
        static let reportProfile                      = basePreFix    + "reportProfile"
        static let blockUser                          = basePreFix    + "blockUser"
        static let deleteMatchMakingUser              = basePreFix    + "deleteMatchMakingUser"
        
        static let updateFriendsProfileV1             = basePreFix    + "updateFriendsProfileV1"
    }
    struct AuthenticationApis {
        static let validateEmail = "users/validateEmail"
        static let signUp = "users/signUp"
        static let login = "users/login"
        static let logout = "users/logout"
        static let accessTokenLogin = "users/accessTokenLogin"
        static let verifyEmailOTP = "users/sendVerifyEmailCode"
        static let verifyEmail = "users/matchVerifyEmailCode"
        static let changePassword = "users/changePassword"
        static let setNotificationStatus = "users/setNotificationStatus"
    }

    struct ResetPassword {
        static let validate = "users/sendResetPasswordCode"
        static let otpVerify = "users/matchResetPasswordCode"
        static let resetPassword = "users/resetPassword"
    }

    struct LandingApis {
        private static let basePreFix   = baseUrl       + "user/"
        static let allProfiles          = basePreFix    + "allProfiles"
        static let suggestedProfiles    = basePreFix    + "suggestedProfiles"
        static let likedProfiles        = basePreFix    + "likedProfiles"
        static let likedProfilesV1      = basePreFix    + "likedProfilesV1"
        static let matchedProfiles      = basePreFix    + "matchedProfiles"
        static let nearByProfiles       = basePreFix    + "nearByProfiles"
        static let likeProfile          = basePreFix    + "likeUnlikeProfile"
        static let reportProfile        = basePreFix    + "reportProfile"
        static let blockUser            = basePreFix    + "blockUser"
        static let rejectProfile        = basePreFix    + "rejectUnRejectProfile"
        static let imageModulation      = basePreFix    + "groups/imageModulation"
    }
    
    struct InAppPurchase {
        private static let basePreFix   = baseUrl       + "user/cards/"
        static let sandBox = "https://sandbox.itunes.apple.com/verifyReceipt"
        static let live = "https://buy.itunes.apple.com/verifyReceipt"
        
        static let inAppPurchase        = basePreFix    + "inAppPurchase"
        static let sendGiftCard         = basePreFix    + "sendGiftCardIos"
        static let mySubscriptions      = basePreFix    + "mySubscriptions"


    }
    
    
    struct UserSearchPreferences {
        private static let basePreFix   = baseUrl       + "userSearchPreferences/"
      
        static let chosenByMe           = basePreFix    + "chosenByMe"
        static let allProfilesBySearchPreferences      = basePreFix    + "allProfilesBySearchPreferences"


    }
    
    struct Chat {
        private static let basePreFix   = baseUrl       + "chat/"
        static let clearChat = basePreFix + "clearChat"
        static let chatHistory = basePreFix + "chatHistory"
    }
}


