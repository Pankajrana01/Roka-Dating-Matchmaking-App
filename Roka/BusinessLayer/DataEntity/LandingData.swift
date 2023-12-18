//
//  LandingData.swift
//  Roka
//
//  Created by Pankaj Rana on 28/09/22.
//

import Foundation
import UIKit

class HomeCategory {
    var image: UIImage!
    var name: String!
    var location: String!
    var isFav: Bool!
    init(name: String, image: UIImage, location: String, isFav: Bool) {
        self.image  = image
        self.name   = name
        self.location = location
        self.isFav = isFav
    }
}


class AboutMe {
    var image: UIImage?
    var name: String?
    var subTitle: String?
    init(name: String, image: UIImage, subTitle: String) {
        self.image  = image
        self.name   = name
        self.subTitle = subTitle
    }
}

class MyPreferences {
    var image: UIImage?
    var name: String?
    var subTitle: String?
    init(name: String, image: UIImage, subTitle: String) {
        self.image  = image
        self.name   = name
        self.subTitle = subTitle
    }
}

// MARK: - Response Model class
class ResponseModel: Codable {
    let statusCode: Int
    let message: String
    let data: [GenderRow]

    init(statusCode: Int, message: String, data: [GenderRow]) {
        self.statusCode = statusCode
        self.message = message
        self.data = data
    }
}

// MARK: - ReportList Response Model class
class ReportListResponseModel: Codable {
    let statusCode: Int
    let message: String
    let data: ResponseData

    init(statusCode: Int, message: String, data: ResponseData) {
        self.statusCode = statusCode
        self.message = message
        self.data = data
    }
}

// MARK: - Response Data
class ResponseData: Codable {
    let count: Int
    let rows: [GenderRow]

    init(count: Int, rows: [GenderRow]) {
        self.count = count
        self.rows = rows
    }
}

// MARK: - GenderRow
class GenderRow: Codable {
    let id, name: String
    var isSelected: Bool?

    init(id: String, name: String, isSelected:Bool) {
        self.id = id
        self.name = name
        self.isSelected = isSelected
    }
}


// MARK: - Response Data
class ResponseQuestionData: Codable {
    let statusCode: Int
    let message: String
    let data: [QuestionsData]

    init(statusCode: Int, message: String, data: [QuestionsData]) {
        self.statusCode = statusCode
        self.message = message
        self.data = data
    }
}
// MARK: - GenderRow
class QuestionsData: Codable {
    let id, question: String
    var answer: String?

    init(id: String, question: String, answer:String) {
        self.id = id
        self.question = question
        self.answer = answer
    }
}

// MARK: - Profile Model class
struct ProfilesResponseModel: Codable {
    let statusCode: Int
    let message: String
    let data: [ProfilesModel]
}
struct SingleProfilesResponseModel: Codable {
    let statusCode: Int
    let message: String
    let data: ProfilesModel
}

struct InviteProfilesResponseModel: Codable {
    let statusCode: Int
    let message: String
    let data: String
}

struct ProfilesModel: Codable {
    let city: String?
    let country: String?
    let countryCode: String?
    var distance: Float? = 0.0
    let dob: String?
    let email: String?
    let firstName: String?
    let gender: String?
    let genderId: String?
    let height: String?
    let heightType: String?
    let id: String?
    let lastName: String?
    let latitude: String?
    let longitude: String?
    let notificationEnabled: Int?
    let parentUserId: String?
    let phoneNumber: String?
    let referralCode: String?
    let placeHolderColour:String?
    let instagram: String?
    let twitter: String?
    let linkdin: String?
    var isReject: String?
    
    let registrationStep: Int?
    let state: String?
    let userAge: Int?
    let userType: Int?
    
    let isEmailVerified: Int?
    var isLiked: Int? = 0
    var isYourProfileLiked: Int? = 0
    
    var isSaved: Int? = 0
    let isDobPrivate: Int?
    let isDrinking: Int?
    let isDrinkingPrivate: Int?
    let isEducationPrivate: Int?
    let isEthnicityPrivate: Int?
    let isSexualOrientationPrivate: Int?
    let isKidsPrivate: Int?
    let isBooksPrivate: Int?
    let isWorkoutPrivate: Int?
    let isZodiacPrivate: Int?
    let isPersonalityPrivate: Int?
    let isGenderPrivate: Int?
    let isHeightPrivate: Int?
    let isSportsPrivate: Int?
    let isMoviesPrivate: Int?
    let isMusicPrivate: Int?
    let isPassionsPrivate: Int?
    let isRelationshipPrivate: Int?
    let isReligionPrivate: Int?
    let isSmoking: Int?
    let isSmokingPrivate: Int?
    let isTvSeriesPrivate: Int?
    let isWorkIndustryPrivate: Int?
    let isSubscriptionPlanActive: Int?
    let isKycApproved: Int?
    let isWishingToHavePrivate: Int?
    
    let userImages: [ProfilesImages]?
    var drinking: Rows?
    var smoking: Rows?
    var kid: Rows?
    var personality: Rows?
    var sexualOrientation: Rows?
    var workout: Rows?
    var zodiac: Rows?
    var Gender: Rows?
    var Ethnicity: Rows?
    var Religion: Rows?
    var Relationship: Rows?
    var Education:Rows?
    var WorkIndustry: Rows?
    var userPassion: [UserPassion]?
    var userMovies: [UserMovies]?
    var userMusic: [userMusic]?
    var usersSports: [usersSports]?
    var usersBooks: [usersBooks]?
    var newSuggestedProfilesCount: Int?
    var userGenderPreferences: [UserGenderPreference]?
    var userPreferences: [UserPreference]?
    var userQuestionAnswer: [UserUserQuestionAnswer]?
    var userWishingToHavePreferences: [UserWishingToHavePreference]?
}

struct UserUserQuestionAnswer: Codable {
    var answer: String?
    var id: String?
    var questionAbout: QuestionAbout?
    var questionId: String?
    var userId: String?
}

struct QuestionAbout: Codable {
    var id: String?
    var question: String?
}

struct UserWishingToHavePreference: Codable {
    var id: String?
    var wishingToHave: WishingToHave?
    var wishingToHaveId: String?
}

struct WishingToHave: Codable {
    var id: String?
    var name: String?
}

struct UserPreference: Codable {
    let id: String?
    let isDeleted: Int?
    let createdAt, updatedAt, userID: String?
    let minAge, maxAge, ageRangePriority: Int?
    var minHeight, maxHeight: String?
    let heightPriority: Int?
    var heightType, fitnessLevel: String?
    let fitnessLevelPriority, isDrinking, isSmoking, booksPriority: Int?
    let isDrinkingPriority, isSmokingPriority, ethnicityPriority, genderPriority: Int?
    let personalityPriority, televisionSeriesPriority, moviesPriority, musicPriority: Int?
    let passionPriority, educationQualificationsPriority, relationshipPriority, religionPriority: Int?
    let sportsPriority, workIndustryPriority, zodiacPriority, kidsPriority: Int?
    var zodiacID, kidsID, drinkingID, smokingID: String?
    let isLocationSetDefault: Int?
    let latitude, longitude, city, state: String?
    let country: String?
    let distance: Int?
    var searchPreferenceID: String?
    let userType: Int?

    enum CodingKeys: String, CodingKey {
        case id, isDeleted, createdAt, updatedAt
        case userID = "userId"
        case minAge, maxAge, ageRangePriority, minHeight, maxHeight, heightPriority, heightType, fitnessLevel, fitnessLevelPriority, isDrinking, isSmoking, booksPriority, isDrinkingPriority, isSmokingPriority, ethnicityPriority, genderPriority, personalityPriority, televisionSeriesPriority, moviesPriority, musicPriority, passionPriority, educationQualificationsPriority, relationshipPriority, religionPriority, sportsPriority, workIndustryPriority, zodiacPriority, kidsPriority
        case zodiacID = "zodiacId"
        case kidsID = "kidsId"
        case drinkingID = "drinkingId"
        case smokingID = "smokingId"
        case isLocationSetDefault, latitude, longitude, city, state, country, distance
        case searchPreferenceID = "searchPreferenceId"
        case userType
    }
}
struct ProfilesImages: Codable {
    let file: String?
    let id: String?
    let title: String?
    let type: String?
    let isDp: Int?
    let isInappropriate: Int?
    let isTitleInappropriate: Int?
}

struct Rows: Codable {
    let id: String?
    let name: String?
}

struct UserPassion: Codable {
    let id: String?
    let passion: Passion?
    let passionId: String?
}

struct Passion: Codable {
    let id: String?
    let name: String?
}

struct UserMovies: Codable {
    let id: String?
    let movie: Movie?
    let moviesId: String?
}

struct Movie: Codable {
    let id: String?
    let name: String?
}

struct userMusic: Codable {
    let id: String?
    let music: Music?
    let musicId: String?
}

struct Music: Codable {
    let id: String?
    let name: String?
}

struct usersSports: Codable {
    let id: String?
    let sport: Sport?
}

struct Sport: Codable {
    let id: String?
    let name: String?
}

struct usersBooks: Codable {
    let id: String?
    let book: Book?
}

struct Book: Codable {
    let id: String?
    let name: String?
}

struct UserGenderPreference: Codable {
    let id, gendersID: String?
    let genderPriority: Int?
    let gender: Rows?
}
struct GalleryModel {
    var file: String?
    var id: String?
    var isDp: Int?
    var isInappropriate: Int?
    var isTitleInappropriate: Int?
    var title: String?
    var type: String?
    var image: UIImage?
    
    init(file: String, id: String, isDp: Int, isInappropriate: Int, isTitleInappropriate: Int, title: String, type: String, image: UIImage) {
        self.file   = file
        self.id    = id
        self.isDp    = isDp
        self.isInappropriate    = isInappropriate
        self.isTitleInappropriate    = isTitleInappropriate
        self.title    = title
        self.type = type
        self.image = image
    }
}
// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
