//
//  NotificationResponseModel.swift
//  Roka
//
//  Created by  Developer on 29/11/22.
//

import Foundation

// MARK: - NotificationResponseModel
struct NotificationResponseModel: Codable {
    let statusCode: Int?
    let message: String?
    let data: NotificationData?
}

// MARK: - NotificationData
struct NotificationData: Codable {
    let count: Int?
    let rows: [Notifications]?
}

// MARK: - Row
struct Notifications: Codable {
    let id, senderID, receiverID: String?
    let platformType, notificationType: Int?
    let title, createdAt, userImage, userName, message: String?
    var isRead: Int?
    var userAge: Int?
    var gender: String?

    enum CodingKeys: String, CodingKey {
        case id
        case senderID = "senderId"
        case receiverID = "receiverId"
        case platformType, notificationType, title, message, isRead , createdAt, userImage, userName
    }
}
