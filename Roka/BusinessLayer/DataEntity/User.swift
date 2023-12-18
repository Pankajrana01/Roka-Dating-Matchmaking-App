//
//  User.swift
//  KarGoCustomer
//
//  Created by Applify on 22/07/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit
import CoreData

class User: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    var id: String = ""
    var userType: String = ""
    var accessToken: String = ""
    var city: String = ""
    var state: String = ""
    var firstName: String = ""
    var sessionId: String = ""
    var lastName: String = ""
    var email: String? = ""
    var password: String = ""
    var countryCode: String = ""
    var phoneNumber: String = ""
    var emailVerified = 0
    var phoneVerified: Bool = false
    var profilePic: String = ""
    var dob:String = ""
    var gender:String = ""
    var genderId:String = ""
    var latitude:String = ""
    var longitude:String = ""
    var referralCode:String = ""
    var registrationStep:Int = -1
    var preferredMaxAge = 0
    var preferredMinAge = 0
    var preferredLatitude:String = ""
    var preferredLongitude:String = ""
    var preferredCity:String = ""
    var preferredState:String = ""
    var preferredDistance = 0
    var isLocationSetDefault = 0
    var preferredGenders: [String] = []
    var userImages: [UserImages] = []
    var country:String = ""
    var preferredCountry:String = ""
    var placeHolderColour: String = ""
    var unreadNotificationCount = 0
    var isSubscriptionPlanActive: Int = 0
    var advertismentShowCount: Int = 0
    var isDeactivate: Int = 0
    var relationshipId: String = ""
    var preferredWishingToHave: [String] = []
    
    override init() { }
    
    init(id: String,
         userType:String,
         accessToken: String,
         city:String,
         state:String,
         firstName: String,
         lastName: String,
         email: String,
         countryCode: String,
         phoneNumber: String,
         emailVerified: Int,
         phoneVerified: Bool,
         sessionId: String,
         profilePic: String,
         dob:String,
         gender:String,
         genderId:String,
         latitude:String,
         longitude:String,
         referralCode:String,
         registrationStep:Int,
         preferredMaxAge:Int,
         preferredMinAge:Int,
         preferredLatitude:String,
         preferredLongitude:String,
         preferredCity:String,
         preferredState:String,
         preferredDistance:Int,
         isLocationSetDefault: Int,
         preferredGenders:[String],
         userImages: [UserImages],
         country:String,
         preferredCountry:String,
         placeHolderColour: String,
         unreadNotificationCount:Int,
         isSubscriptionPlanActive: Int,
         advertismentShowCount:Int,
         isDeactivate:Int,
         relationshipId: String,
         preferredWishingToHave: [String]) {
        
        self.id = id
        self.userType = userType
        self.city = city
        self.state = state
        self.accessToken = accessToken
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.countryCode = countryCode
        self.phoneNumber = phoneNumber
        self.emailVerified = emailVerified
        self.phoneVerified = phoneVerified
        self.sessionId = sessionId
        self.profilePic = profilePic
        self.dob = dob
        self.gender = gender
        self.genderId = genderId
        self.latitude = latitude
        self.longitude = longitude
        self.referralCode = referralCode
        self.registrationStep = registrationStep
        self.preferredMaxAge = preferredMaxAge
        self.preferredMinAge = preferredMinAge
        self.preferredLatitude = preferredLatitude
        self.preferredLongitude = preferredLongitude
        self.preferredCity = preferredCity
        self.preferredState = preferredState
        self.preferredDistance = preferredDistance
        self.isLocationSetDefault = isLocationSetDefault
        self.preferredGenders = preferredGenders
        self.userType = userType
        self.userImages = userImages
        self.country = country
        self.preferredCountry = preferredCountry
        self.placeHolderColour = placeHolderColour
        self.unreadNotificationCount = unreadNotificationCount
        self.isSubscriptionPlanActive = isSubscriptionPlanActive
        self.advertismentShowCount = advertismentShowCount
        self.isDeactivate = isDeactivate
        self.relationshipId = relationshipId
        self.preferredWishingToHave = preferredWishingToHave
    }
        
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as? String ?? ""
        let userType = aDecoder.decodeObject(forKey: "userType") as? String ?? ""
        let accessToken = aDecoder.decodeObject(forKey: "accessToken") as? String ?? ""
        let city = aDecoder.decodeObject(forKey: "city") as? String ?? ""
        let state = aDecoder.decodeObject(forKey: "state") as? String ?? ""
        let firstName = aDecoder.decodeObject(forKey: "firstName") as? String ?? ""
        let lastName = aDecoder.decodeObject(forKey: "lastName") as? String ?? ""
        
        let email = aDecoder.decodeObject(forKey: "email") as? String ?? ""
        let countryCode = aDecoder.decodeObject(forKey: "countryCode") as? String ?? ""
        let phoneNumber = aDecoder.decodeObject(forKey: "phoneNumber") as? String ?? ""

        let emailVerified = Int(aDecoder.decodeInt32(forKey: "isEmailVerified"))
        let phoneVerified = aDecoder.decodeBool(forKey: "phoneVerified")
        let sessionId = aDecoder.decodeObject(forKey: "sessionId") as? String ?? ""
        let profilePic = aDecoder.decodeObject(forKey: "profilePic") as? String ?? ""
        let dob = aDecoder.decodeObject(forKey: "dob") as? String ?? ""
        let gender = aDecoder.decodeObject(forKey: "gender") as? String ?? ""
        let genderId = aDecoder.decodeObject(forKey: "genderId") as? String ?? ""

        let latitude = aDecoder.decodeObject(forKey: "latitude") as? String ?? ""
        let longitude = aDecoder.decodeObject(forKey: "longitude") as? String ?? ""
        let referralCode = aDecoder.decodeObject(forKey: "referralCode") as? String ?? ""
        let registrationStep = Int(aDecoder.decodeInt32(forKey: "registrationStep"))
        
        let preferredMaxAge = Int(aDecoder.decodeInt32(forKey: "preferredMaxAge"))
        let preferredMinAge = Int(aDecoder.decodeInt32(forKey: "preferredMinAge"))
        let preferredLatitude = aDecoder.decodeObject(forKey: "preferredLatitude") as? String ?? ""
        let preferredLongitude = aDecoder.decodeObject(forKey: "preferredLongitude") as? String ?? ""
        let preferredCity = aDecoder.decodeObject(forKey: "preferredCity") as? String ?? ""
        let preferredState = aDecoder.decodeObject(forKey: "preferredState") as? String ?? ""
        let preferredDistance = Int(aDecoder.decodeInt32(forKey: "preferredDistance"))

        let isLocationSetDefault = Int(aDecoder.decodeInt32(forKey: "isLocationSetDefault"))
        
        let preferredGenders = aDecoder.decodeObject(forKey: "preferredGenders") as? [String] ?? []
        let country = aDecoder.decodeObject(forKey: "country") as? String ?? ""
        let preferredCountry = aDecoder.decodeObject(forKey: "preferredCountry") as? String ?? ""
        let placeHolderColour = aDecoder.decodeObject(forKey: "placeHolderColour") as? String ?? ""
        let unreadNotificationCount = Int(aDecoder.decodeInt32(forKey: "unreadNotificationCount"))
        
        let isSubscriptionPlanActive = aDecoder.decodeInteger(forKey: "isSubscriptionPlanActive")
        
        let advertismentShowCount = aDecoder.decodeInteger(forKey: "advertismentShowCount")
        
        let isDeactivate = aDecoder.decodeInteger(forKey: "isDeactivate")
        let relationshipId = aDecoder.decodeObject(forKey: "relationshipId") as? String ?? ""
        let preferredWishingToHave = aDecoder.decodeObject(forKey: "preferredWishingToHave") as? [String] ?? []
        
             self.init(id: id,
                  userType:userType,
                  accessToken: accessToken,
                  city:city,
                  state: state,
                  firstName: firstName,
                  lastName: lastName,
                  email: email,
                  countryCode: countryCode,
                  phoneNumber: phoneNumber,
                  emailVerified: emailVerified,
                  phoneVerified: phoneVerified,
                  sessionId: sessionId,
                  profilePic: profilePic,
                  dob: dob,
                  gender:gender,
                  genderId: genderId,
                  latitude: latitude,
                  longitude: longitude,
                  referralCode:referralCode,
                  registrationStep:registrationStep,
                  preferredMaxAge: preferredMaxAge,
                  preferredMinAge: preferredMinAge,
                  preferredLatitude: preferredLatitude,
                  preferredLongitude: preferredLongitude,
                  preferredCity: preferredCity,
                  preferredState: preferredState,
                  preferredDistance: preferredDistance,
                  isLocationSetDefault: isLocationSetDefault,
                  preferredGenders:preferredGenders,
                  userImages:KAPPSTORAGE.userImages,
                  country: country,
                  preferredCountry:preferredCountry,
                  placeHolderColour: placeHolderColour,
                  unreadNotificationCount: unreadNotificationCount,
                  isSubscriptionPlanActive: isSubscriptionPlanActive,
                  advertismentShowCount: advertismentShowCount,
                  isDeactivate:isDeactivate,
                  relationshipId:relationshipId,
                  preferredWishingToHave:preferredWishingToHave
             )
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(accessToken, forKey: "accessToken")
        aCoder.encode(city, forKey: "city")
        aCoder.encode(city, forKey: "state")
        aCoder.encode(country, forKey: "country")
        aCoder.encode(userType, forKey: "userType")

        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        
        aCoder.encode(email, forKey: "email")
        aCoder.encode(countryCode, forKey: "countryCode")
        aCoder.encode(phoneNumber, forKey: "phoneNumber")

        aCoder.encode(emailVerified, forKey: "isEmailVerified")
        aCoder.encode(phoneVerified, forKey: "phoneVerified")

        aCoder.encode(sessionId, forKey: "sessionId")

        aCoder.encode(profilePic, forKey: "profilePic")
        aCoder.encode(dob, forKey: "dob")
        aCoder.encode(gender, forKey: "gender")
        aCoder.encode(genderId, forKey: "genderId")

        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
        aCoder.encode(referralCode, forKey: "referralCode")
        aCoder.encode(registrationStep, forKey: "registrationStep")
        
        aCoder.encode(preferredMaxAge, forKey: "preferredMaxAge")
        aCoder.encode(preferredMinAge, forKey: "preferredMinAge")
        aCoder.encode(preferredLatitude, forKey: "preferredLatitude")
        aCoder.encode(preferredLongitude, forKey: "preferredLongitude")
        aCoder.encode(preferredCity, forKey: "preferredCity")
        aCoder.encode(preferredState, forKey: "preferredState")
        aCoder.encode(preferredDistance, forKey: "preferredDistance")
        aCoder.encode(isLocationSetDefault, forKey: "isLocationSetDefault")
        aCoder.encode(preferredGenders, forKey: "preferredGenders")
        aCoder.encode(preferredCountry, forKey: "preferredCountry")
        aCoder.encode(placeHolderColour, forKey: "placeHolderColour")
        aCoder.encode(unreadNotificationCount, forKey: "unreadNotificationCount")

        aCoder.encode(isSubscriptionPlanActive, forKey: "isSubscriptionPlanActive")
        aCoder.encode(advertismentShowCount, forKey: "advertismentShowCount")
        aCoder.encode(isDeactivate, forKey: "isDeactivate")
        
        aCoder.encode(relationshipId, forKey: "relationshipId")
        aCoder.encode(preferredWishingToHave, forKey: "preferredWishingToHave")
        
        KAPPSTORAGE.userImages = userImages
    }
}

extension User {
    func updateWith(_ dic: [String: Any]) {

        if let id = dic[WebConstants.id] {
            self.id = "\(id)"
        }
        
        if let userType = dic[WebConstants.userType] {
            self.userType = "\(userType)"
            KAPPSTORAGE.userType = "\(userType)"
        }
        
        if let accessToken = dic[WebConstants.accessToken] {
            self.accessToken = "\(accessToken)"
            if dic[WebConstants.accessToken] as? String != "" {
                KAPPSTORAGE.accessToken = "\(accessToken)"
            }
        }
        
        if let state = dic[WebConstants.state] {
            self.state = "\(state)"
        }
        
        if let city = dic[WebConstants.city] {
            self.city = "\(city)"
        }
        
        if let firstName = dic[WebConstants.firstName] {
            self.firstName = "\(firstName)"
        }
        
        if let lastName = dic[WebConstants.lastName] {
            self.lastName = "\(lastName)"
        }
        
        if let email = dic[WebConstants.email] {
            self.email = "\(email)"
        }
        
        if let phoneNumber = dic[WebConstants.phoneNumber] as? String {
            self.phoneNumber = "\(phoneNumber)"
        }
        
        if let countryCode = dic[WebConstants.countryCode] as? String {
            self.countryCode = "\(countryCode)"
        }
        
        if let emailVerified = dic[WebConstants.emailVerified] as? Int {
            self.emailVerified = emailVerified 
        }
        
        if let phoneVerified = dic[WebConstants.phoneVerified] {
            self.phoneVerified = "\(phoneVerified)".boolValue
        }
        
        if let sessionId = dic[WebConstants.sessionId] {
            self.sessionId = "\(sessionId)"
        }
        
        if let dob = dic[WebConstants.dob] {
            self.dob = "\(dob)"
        }
        
        if let gender = dic[WebConstants.gender] {
            self.gender = "\(gender)"
        }
        if let genderId = dic[WebConstants.genderId] {
            self.genderId = "\(genderId)"
        }
        
        if let latitude = dic[WebConstants.latitude] {
            self.latitude = "\(latitude)"
        }
        
        if let longitude = dic[WebConstants.longitude] {
            self.longitude = "\(longitude)"
        }
        
        if let referralCode = dic[WebConstants.referralCode] {
            self.referralCode = "\(referralCode)"
        }
        
        if let registrationStep = dic[WebConstants.registrationStep] {
            self.registrationStep = registrationStep as? Int ?? -1
            KAPPSTORAGE.registrationStep = "\(registrationStep)"
        }
        
        if let preferredMaxAge = dic[WebConstants.preferredMaxAge] {
            self.preferredMaxAge = preferredMaxAge as? Int ?? 0
        }
        if let preferredMinAge = dic[WebConstants.preferredMinAge] {
            self.preferredMinAge = preferredMinAge as? Int ?? 0
        }
        if let latitude = dic[WebConstants.preferredLatitude] {
            self.preferredLatitude = "\(latitude)"
        }
        
        if let longitude = dic[WebConstants.preferredLongitude] {
            self.preferredLongitude = "\(longitude)"
        }
        
        if let preferredCity = dic[WebConstants.preferredCity] {
            self.preferredCity = "\(preferredCity)"
        }
        
        if let preferredState = dic[WebConstants.preferredState] {
            self.preferredState = "\(preferredState)"
        }
        if let preferredDistance = dic[WebConstants.preferredDistance] {
            self.preferredDistance = preferredDistance as? Int ?? 0
        }
        
        if let isLocationSetDefault = dic[WebConstants.isLocationSetDefault] {
            self.isLocationSetDefault = isLocationSetDefault as? Int ?? 0
        }
        
        if let preferredGenders = dic[WebConstants.preferredGenders] {
            self.preferredGenders = preferredGenders as? [String] ?? []
        }
        
        if let preferredWishingToHave = dic[WebConstants.preferredWishingToHave] {
            self.preferredWishingToHave = preferredWishingToHave as? [String] ?? []
        }
        
        if let relationshipId = dic[WebConstants.relationshipId] {
            self.relationshipId = "\(relationshipId)"
        }
        
        if let rawUserImages = dic[WebConstants.userImages] as? [[String: Any]] {
            updateProfiles(rawUserImages)
        }
        if let country = dic[WebConstants.country] {
            self.country = "\(country)"
        }
        
        if let country = dic[WebConstants.preferredCountry] {
            self.preferredCountry = "\(country)"
        }
        if let placeHolderColour = dic[WebConstants.placeHolderColour] {
            self.placeHolderColour = "\(placeHolderColour)"
        }
        
        if let unreadNotificationCount = dic[WebConstants.unreadNotificationCount] {
            self.unreadNotificationCount = unreadNotificationCount as? Int ?? 0
        }
        if let isSubscriptionPlanActive = dic[WebConstants.isSubscriptionPlanActive] {
            self.isSubscriptionPlanActive = isSubscriptionPlanActive as? Int ?? 0
        }
        
        if let advertismentShowCount = dic[WebConstants.advertismentShowCount] {
            self.advertismentShowCount = advertismentShowCount as? Int ?? 0
        }
        if let isDeactivate = dic[WebConstants.isDeactivate] {
            self.isDeactivate = isDeactivate as? Int ?? 0
            KAPPSTORAGE.isDeactivate = "\(isDeactivate)"
        }
    }
    
    func updateProfiles(_ rawUserImages: [[String : Any]]) {
        var userImages = [UserImages]()
        rawUserImages.forEach( { userImages.append(UserImages(userImages: $0)) } )
        self.userImages = userImages
    }
    
}

class CreateProfileModel {
    var dob = ""
    var gender = ""
    var latitude = ""
    var longitude = ""
    var city = ""
    var state = ""
    var notificationEnabled = ""
    var userType = ""
    var preferredGendersPriority = ""
    var preferredGenders = ""
    var preferredMaxAge = ""
    var preferredMinAge = ""
    var preferredLatitude = ""
    var preferredLongitude = ""
    var preferredCity = ""
    var preferredState = ""
    var preferredDistance = ""
    var images = [NSDictionary]()
    var kycVideo = [NSDictionary]()

    init() { }
    init(dob:String, gender:String, latitude:String, longitude:String, city:String, state:String, notificationEnabled:String, userType:String, preferredGendersPriority:String, preferredGenders:String, preferredMaxAge:String, preferredMinAge:String, preferredLatitude:String, preferredLongitude:String, preferredCity:String, preferredState:String, preferredDistance:String, images:[NSDictionary], kycVideo:[NSDictionary]) {
        self.dob = dob
        self.gender = gender
        self.latitude = latitude
        self.longitude = longitude
        self.city = city
        self.state = state
        self.notificationEnabled = notificationEnabled
        self.userType = userType
        self.preferredGendersPriority = preferredGendersPriority
        self.preferredGenders = preferredGenders
        self.preferredMaxAge = preferredMaxAge
        self.preferredMinAge = preferredMinAge
        self.preferredLatitude = preferredLatitude
        self.preferredLongitude = preferredLongitude
        self.preferredCity = preferredCity
        self.preferredState = preferredState
        self.preferredDistance = preferredDistance
        self.images = images
        self.kycVideo = kycVideo
        
    }
}

class UploadProfileImages {
    var images = [UIImage]()
    var titles = [String]()
    
    init(images:[UIImage], titles:[String]) {
        self.images = images
        self.titles = titles
    }
}


class UserImages: NSObject, Codable, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    var file: String = ""
    var id: String = ""
    var title: String = ""
    var type: String = ""
    var isDp:Int = 0
    var isInappropriate:Int = 0
    var isTitleInappropriate:Int = 0

    init(file: String,
         id: String,
         title: String,
         type: String,
         isDp:Int,
         isInappropriate:Int, isTitleInappropriate: Int) {
        self.file = file
        self.id = id
        self.title = title
        self.type = type
        self.isDp = isDp
        self.isInappropriate = isInappropriate
        self.isTitleInappropriate = isTitleInappropriate
    }

    init(userImages: [String: Any]) {
        super.init()
        self.updateWith(userImages)
    }
    
    func updateWith(_ dic: [String: Any]) {
        if let file = dic[WebConstants.file] as? String {
            self.file = file
        }
        if let id = dic[WebConstants.id] as? String {
            self.id = id
        }
        if let title = dic[WebConstants.title] as? String {
            self.title = title
        }
        if let type = dic[WebConstants.type] as? String {
            self.type = type
        }
        if let isDp = dic["isDp"] as? Int {
            self.isDp = isDp
        }
        if let isInappropriate = dic["isInappropriate"] as? Int {
            self.isInappropriate = isInappropriate
        }
        if let isTitleInappropriate = dic["isTitleInappropriate"] as? Int {
            self.isTitleInappropriate = isTitleInappropriate
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(file, forKey: "file")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(isDp, forKey: "isDp")
        aCoder.encode(isInappropriate, forKey: "isInappropriate")
        aCoder.encode(isTitleInappropriate, forKey: "isTitleInappropriate")
    }

    required convenience init(coder aDecoder: NSCoder) {
        let file = aDecoder.decodeObject(forKey: "file") as? String ?? ""
        let id = aDecoder.decodeObject(forKey: "id") as? String ?? ""
        let title = aDecoder.decodeObject(forKey: "title") as? String ?? ""
        let type = aDecoder.decodeObject(forKey: "type") as? String ?? ""
        let isDp = aDecoder.decodeObject(forKey: "isDp") as? Int ?? 0
        let isInappropriate = aDecoder.decodeObject(forKey: "isInappropriate") as? Int ?? 0
        let isTitleInappropriate = aDecoder.decodeObject(forKey: "isTitleInappropriate") as? Int ?? 0

        self.init(file: file, id: id, title: title, type: type, isDp: isDp, isInappropriate: isInappropriate, isTitleInappropriate: isTitleInappropriate)
    }

}
