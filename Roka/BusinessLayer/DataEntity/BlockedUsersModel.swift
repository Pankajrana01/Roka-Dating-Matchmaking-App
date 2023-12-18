//
//  BlockedUsersModel.swift
//  Roka
//
//  Created by  Developer on 26/10/22.
//

import Foundation

struct BlockedUsersModel {
    let image: String
    let name: String
    let isBlock: Bool // may be required to remove from the array.
}

struct BlockedUsers {
    var id: String?
    var name: String?
    var countryCode: String?
    var number: String?
    var lastName : String?
    var userImage : String?
    
    init(id:String, name: String, countryCode: String, number:String,lastName : String,userImage:String) {
        self.id    = id
        self.name   = name
        self.countryCode   = countryCode
        self.number   = number
        self.lastName   = lastName
        self.userImage = userImage

    }
}

struct UserPhoneBookListModel: Codable {
    let statusCode: Int?
    let message: String?
    let data: [UserPhoneBookModel]?
}

struct UserPhoneBookModel: Codable {
    var id: String?
    var name: String?
    var countryCode: String?
    var number: String?
    var firstName: String?
    var lastName: String?
    var dp: String?

    var isBlocked: Int?
    var isPhoneVerified: Int?
    var userId: String?
    var isHavingDatingProfile: Int?
    var isPhoneBook: Int?
    
    var isLiked: Int?
    var isSaved: Int?
    var isSubscriptionPlanActive: Int?
    var isYourProfileLiked: Int?
    var isSent: Int? = 0

}
