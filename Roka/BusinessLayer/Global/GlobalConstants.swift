//
//  GlobalConstants.swift
//  Covid19 tracking
//
//  Created by Aakash on 29/07/21.
//

import Foundation
import UIKit


let KAPPDELEGATE                         = AppDelegate.shared

let KAPPSTORAGE                          = AppStorage.shared

let KUSERMODEL                           = UserModel.shared

let APPNAME                              = "Roka"

let DefaultSelectedCountryCode           = "+91"

let MONTHLY_PLAN                         = "9.99"

let HAlF_YEARLY_PLAN                     = "4.99"

let YEARLY_PLAN                          = "3.99"

let kAPPKEY                              = "16988b96d"


struct ViewControllerIdentifier {}

struct TableViewCellIdentifier {}

struct TableViewNibIdentifier {}

struct CollectionViewCellIdentifier {}

struct CollectionViewNibIdentifier {}

struct SucessMessage {}

struct NibCellIdentifier {}


enum LayoutType: String {
    case grid = "grid"
    case list = "list"
    case full_view = "full_view"
}


let PlaceholderBGColor = ["53148E", "FF8C8B", "A14DF1", "DED7FF", "687385","AD9BFF","853333","FFCCD9","623B61","FFB3B1","000000"]


struct StringConstants {
    static let settings                     = "Settings"
    static let tryAgain                     = "Try Again"
}

struct WebConstants {
    static let s3Url                            = "s3Url"
    static let s3Folders                        = "s3Folders"
    static let directories                      = "directories"
    static let users                            = "users"
    static let user                             = "USER"
    static let userId                           = "userId"
    static let limit                            = "limit"
    static let skip                             = "skip"
    static let firstName                        = "firstName"
    static let friendId                         = "friendId"
    static let numberList                       = "numberList"
    static let lastName                         = "lastName"
    static let email                            = "email"
    static let countryCode                      = "countryCode"
    static let password                         = "password"
    static let name                             = "name"
    static let url                              = "url"
    static let planType                         = "planType"
    static let transactionIdentifier            = "transactionIdentifier"
    static let planPrice                         = "planPrice"
    static let authorization                    = "authorization"
    static let accountNumber                    = "accountNumber"
    static let accountId                        = "accountId"
    static let defaultBank                      = "defaultBank"
    static let passbook                         = "passbook"
    static let earnedAmount                     = "earnedAmount"
    static let receivedAmount                   = "receivedAmount"
    static let pendingAmount                    = "pendingAmount"
    static let responseType                     = "responseType"
    static let userImages                       = "userImages"
    static let platform                         = "platformType"
    static let tvCode                           = "tvCode"
    static let deviceToken                      = "deviceToken"
    static let deviceName                       = "deviceName"
    static let deviceType                       = "deviceType"
    static let sessionId                        = "sessionId"
    static let dob                              = "dob"
    static let gender                           = "gender"
    static let genderPriority                   = "genderPriority"
    static let genderId                         = "genderId"
    static let isGenderPrivate                  = "isGenderPrivate"
    static let ethnicityId                      = "ethnicityId"
    static let ethnicity                        = "ethnicity"
    static let isEthnicityPrivate               = "isEthnicityPrivate"
    static let ethnicityPriority                = "ethnicityPriority"
    static let religionId                       = "religionId"
    static let isReligionPrivate                = "isReligionPrivate"
    static let relationshipId                   = "relationshipId"
    static let isRelationshipPrivate            = "isRelationshipPrivate"
    static let preferredWishingToHave           = "preferredWishingToHave"
    static let educationQualificationId         = "educationQualificationId"
    static let zodiacId                         = "zodiacId"
    static let isEducationPrivate               = "isEducationPrivate"
    static let kidsId                           = "kidsId"
    static let isKidsPrivate                    = "isKidsPrivate"
    static let personalityId                    = "personalityId"
    static let isPersonalityPrivate             = "isPersonalityPrivate"
    static let sexualOrientationId              = "sexualOrientationId"
    static let isSexualOrientationPrivate       = "isSexualOrientationPrivate"
    static let workoutId                        = "workoutId"
    static let workoutIds                       = "workoutIds"
    static let isWorkoutPrivate                 = "isWorkoutPrivate"
    static let sports                           = "sports"
    static let isSportsPrivate                  = "isSportsPrivate"
    static let books                            = "books"
    static let bookIds                          = "bookIds"
    static let isBooksPrivate                   = "isBooksPrivate"
    static let isZodiacPrivate                  = "isZodiacPrivate"
    static let workIndustryId                   = "workIndustryId"
    static let isWorkIndustryPrivate            = "isWorkIndustryPrivate"
    static let passions                         = "passions"
    static let isPassionsPrivate                = "isPassionsPrivate"
    static let movies                           = "movies"
    static let isMoviesPrivate                  = "isMoviesPrivate"
    static let moviesPriority                   = "moviesPriority"
    static let music                            = "music"
    static let musicPriority                    = "musicPriority"
    static let isMusicPrivate                   = "isMusicPrivate"
    static let tvSeries                         = "tvSeries"
    static let isTvSeriesPrivate                = "isTvSeriesPrivate"
    static let televisionSeriesPriority         = "televisionSeriesPriority"
    static let zodiacPriority                   = "zodiacPriority"
    static let kidsPriority                     = "kidsPriority"
    static let isDrinking                       = "isDrinking"
    static let drinkingId                       = "drinkingId"
    static let drinkingIds                      = "drinkingIds"
    static let smokingId                        = "smokingId"
    static let smokingIds                       = "smokingIds"
    static let zodiacIds                        = "zodiacIds"
    static let kidsIds                          = "kidsIds"
    static let personality                      = "personality"
    static let personalityPriority              = "personalityPriority"
    static let isDrinkingPrivate                = "isDrinkingPrivate"
    static let isDrinkingPriority               = "isDrinkingPriority"
    static let isSmoking                        = "isSmoking"
    static let isSmokingPrivate                 = "isSmokingPrivate"
    static let isSmokingPriority                = "isSmokingPriority"
    static let preferredGenders                 = "preferredGenders"
    static let phoneNumber                      = "phoneNumber"
    static let otp                              = "otp"
    static let message                          = "message"
    static let oldPassword                      = "oldPassword"
    static let newPassword                      = "newPassword"
    static let id                               = "id"
    static let friendsId                        = "friendsId"
    static let questionAbout                    = "questionAbout"
    static let twitter                          = "twitter"
    static let linkdin                          = "linkdin"
    static let instagram                        = "instagram"
    static let userType                         = "userType"
    static let timeleft                         = "timeLeft"
    static let contentId                        = "contentId"
    static let clapOrNot                        = "clapOrNot"
    static let emailOrPhoneNumber               = "emailOrPhoneNumber"
    static let contentDetails                   = "contentDetails"
    static let concert                          = "concert"
    static let profileId                        = "profileId"
    static let isLiked                          = "isLiked"
    static let status                           = "status"
    static let searchPreferenceId               = "searchPreferenceId"
    static let isRejected                       = "isRejected"
    static let file                             = "file"
    static let amount                           = "amount"
    static let currency                         = "currency"
    static let defaultforPayments               = "  Default for payments"
    static let accessToken                      = "accessToken"
    static let city                             = "city"
    static let country                          = "country"
    static let state                             = "state"
    static let addedtoWatchlist                 = "Added to Watchlist"
    static let socialId                         = "socialId"
    static let userCountry                      = "userCountry"
    static let loginType                        = "loginType"
    static let facebookId                       = "facebookId"
    static let appleId                          = "appleId"
    static let gmailId                          = "gmailId"
    static let oauthToken                       = "oauthToken"
    static let token                            = "token"
    static let danceStudioCode                  = "danceStudioCode"
    static let image                            = "image"
    static let landscape                        = "landscape"
    static let portrait                         = "portrait"
    static let directory                        = "directory"
    static let referredBy                       = "referredBy"
    static let emailVerified                    = "isEmailVerified"
    static let phoneVerified                    = "phoneVerified"
    static let profilePic                       = "profilePic"
    static let title                            = "title"
    static let type                             = "type"
    static let streamFile                       = "streamFile"
    static let subtitle                         = "subtitle"
    static let keyword                          = "keyword"
    static let profiles                         = "profiles"
    static let profileImage                     = "profileImage"
    static let profileName                      = "profileName"
    static let emailAlreadyVerified             = "EMAIL_ALREADY_VERIFIED"
    
    static let height                           = "height"
    static let heightType                       = "heightType"
    static let isHeightPrivate                  = "isHeightPrivate"
    static let minHeight                        = "minHeight"
    static let maxHeight                        = "maxHeight"
    static let heightPriority                   = "heightPriority"
    static let religionPriority                 = "religionPriority"
    static let religion                         = "religion"
    static let reasons                          = "reasons"
    static let relationship                     = "relationship"
    static let relationshipPriority             = "relationshipPriority"
    static let educationPriority                = "educationPriority"
    static let education                        = "education"
    static let workIndustryPriority             = "workIndustryPriority"
    static let workIndustry                     = "workIndustry"
    static let passionsPriority                 = "passionsPriority"
    static let isStandingOvation                = "isStandingOvation"
    static let isDanceStudioPrivate             = "isDanceStudioPrivate"
    static let standingOvation                  = "standingOvation"
    static let inWatchList                      = "inWatchList"
    static let isLocationSetDefault              = "isLocationSetDefault"
    static let unreadNotificationCount          = "unreadNotificationCount"
    static let preferredDistance                 = "preferredDistance"
    static let distance                          = "distance"
    static let preferredState                    = "preferredState"
    static let preferredCountry                  = "preferredCountry"
    static let placeHolderColour                 = "placeHolderColour"
    static let isSubscriptionPlanActive          = "isSubscriptionPlanActive"
    static let advertismentShowCount             = "advertismentShowCount"
    static let isDeactivate                      = "isDeactivate"
    static let preferredCity                     = "preferredCity"
    static let preferredLongitude                = "preferredLongitude"
    static let preferredLatitude                 = "preferredLatitude"
    static let preferredMinAge                   = "preferredMinAge"
    static let preferredMaxAge                   = "preferredMaxAge"
    static let registrationStep                  = "registrationStep"
    static let referralCode                      = "referralCode"
    static let longitude                         = "longitude"
    static let latitude                          = "latitude"
    static let createProfile                     = "createProfile"
    
    static let minAge                            = "minAge"
    static let maxAge                            = "maxAge"
    static let ageRangePriority                  = "ageRangePriority"
    
    static let logoutMesaage                    = "Your login session has been expired, please login again to continue."
    static let continueWatching                 = "Continue Watching"
    // dummy video URL ...pankajrana
    static let forBiggerJoyrides                = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4"
    
    static let bigBuckBunny                     = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
    
    // dummy show name ...pankajrana
    static let theNutcracker                     = "The Nutcracker"
    static let theSleepingBeauty                 = "The Sleeping Beauty"
    static let new                               = "NEW"
    static let popular                           = "POPULAR"
    static let description                       = "description"
    static let showSubTitle                      = "Subtitle"
    static let reqShowDesc                       = "Other Information"
    static let reqShowSubTitle                   = "Overview"
    
}
struct ValidationError {
    static let maxuploadImages     = "You have reached max 6 images limit."
    static let minuploadImages     = "Please select at-least 2 images."
    static let selectImage        = "Please select image."
    static let locationAccessErrorTitle     = "Turn on Location Services"
    static let locationAccessErrorMessage   = "Allow Location Access to share, set your location on app & allocate nearby service providers to you."
}

enum Platform: String {
    case iOS = "IOS", android = "ANDROID"
}


enum UIUserInterfaceIdiom : Int {
    case unspecified
    case phone // iPhone and iPod touch style UI
    case pad   // iPad style UI (also includes macOS Catalyst)
}


public extension UIDevice {

    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                       return "iPod touch (5th generation)"
            case "iPod7,1":                                       return "iPod touch (6th generation)"
            case "iPod9,1":                                       return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":           return "iPhone 4"
            case "iPhone4,1":                                     return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                        return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                        return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                        return "iPhone 5s"
            case "iPhone7,2":                                     return "iPhone 6"
            case "iPhone7,1":                                     return "iPhone 6 Plus"
            case "iPhone8,1":                                     return "iPhone 6s"
            case "iPhone8,2":                                     return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                        return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                        return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4":                      return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                      return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                      return "iPhone X"
            case "iPhone11,2":                                    return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                      return "iPhone XS Max"
            case "iPhone11,8":                                    return "iPhone XR"
            case "iPhone12,1":                                    return "iPhone 11"
            case "iPhone12,3":                                    return "iPhone 11 Pro"
            case "iPhone12,5":                                    return "iPhone 11 Pro Max"
            case "iPhone13,1":                                    return "iPhone 12 mini"
            case "iPhone13,2":                                    return "iPhone 12"
            case "iPhone13,3":                                    return "iPhone 12 Pro"
            case "iPhone13,4":                                    return "iPhone 12 Pro Max"
            case "iPhone14,4":                                    return "iPhone 13 mini"
            case "iPhone14,5":                                    return "iPhone 13"
            case "iPhone14,2":                                    return "iPhone 13 Pro"
            case "iPhone14,3":                                    return "iPhone 13 Pro Max"
            case "iPhone8,4":                                     return "iPhone SE"
            case "iPhone12,8":                                    return "iPhone SE (2nd generation)"
            case "iPhone14,6":                                    return "iPhone SE (3rd generation)"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":      return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":                 return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":                 return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                          return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                            return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                          return "iPad (7th generation)"
            case "iPad11,6", "iPad11,7":                          return "iPad (8th generation)"
            case "iPad12,1", "iPad12,2":                          return "iPad (9th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":                 return "iPad Air"
            case "iPad5,3", "iPad5,4":                            return "iPad Air 2"
            case "iPad11,3", "iPad11,4":                          return "iPad Air (3rd generation)"
            case "iPad13,1", "iPad13,2":                          return "iPad Air (4th generation)"
            case "iPad13,16", "iPad13,17":                        return "iPad Air (5th generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":                 return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":                 return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":                 return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                            return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                          return "iPad mini (5th generation)"
            case "iPad14,1", "iPad14,2":                          return "iPad mini (6th generation)"
            case "iPad6,3", "iPad6,4":                            return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                            return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":      return "iPad Pro (11-inch) (1st generation)"
            case "iPad8,9", "iPad8,10":                           return "iPad Pro (11-inch) (2nd generation)"
            case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7":  return "iPad Pro (11-inch) (3rd generation)"
            case "iPad6,7", "iPad6,8":                            return "iPad Pro (12.9-inch) (1st generation)"
            case "iPad7,1", "iPad7,2":                            return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":      return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                          return "iPad Pro (12.9-inch) (4th generation)"
            case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11":return "iPad Pro (12.9-inch) (5th generation)"
            case "AppleTV5,3":                                    return "Apple TV"
            case "AppleTV6,2":                                    return "Apple TV 4K"
            case "AudioAccessory1,1":                             return "HomePod"
            case "AudioAccessory5,1":                             return "HomePod mini"
            case "i386", "x86_64", "arm64":                       return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                              return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()

}

struct TwitterConstants {
//    static let CONSUMER_KEY = "nFCcyHfrY4iEiKEqCi7KZK68o"
//    static let CONSUMER_SECRET_KEY = "RMDfGFsJrTPfvDanbog0lRmF4Jq2CdmtlxTGM0dY43tU7qlzBk"
//    static let CALLBACK_URL = "roka://"
    static let CONSUMER_KEY = "K9BXB7vFd1KHs1X2trxqzgFUv"
    static let CONSUMER_SECRET_KEY = "QhoVIyRDm3LxCNoQCFuIv9Nh6dgQeJwX1uOOMPdwNDpK6zHKgB"
    static let CALLBACK_URL = "roka://"
}

struct LinkedInConstants {
    static let CLIENT_ID = "863iphj25vdm8g"
    static let CLIENT_SECRET = "eCW1dbQ4ehQcsaJI"
    static let REDIRECT_URI = "https://www.linkedin.com/company/roka-dating/"
    static let SCOPE = "r_liteprofile%20r_emailaddress" //Get lite profile info and e-mail address
    
    static let AUTHURL = "https://www.linkedin.com/oauth/v2/authorization"
    static let TOKENURL = "https://www.linkedin.com/oauth/v2/accessToken"
}

struct InstagramConstants {
    static let CLIENT_ID = "1091781911539420"
    static let CLIENT_SECRET = "06e9159241ac2a2838cd922f9cc8dd17"
    static let REDIRECT_URI = "https://43.205.201.211:8080/login"
    static let SCOPE = "user_profile"
    static let AUTHURL = "https://api.instagram.com/oauth/authorize"
}
