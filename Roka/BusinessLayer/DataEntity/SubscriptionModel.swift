//
//  SubscriptionModel.swift
//  Roka
//
//  Created by Pankaj Rana on 11/11/22.
//

import Foundation
import UIKit

struct PremiumModel {
    let country: String?
    let currency: String?
    let id: String?
    let planPrice: NSNumber?
    let planType: Int?
    let description : String?
    let mostPopular : String?
    
    init(country: String, currency: String, id: String, planPrice: NSNumber, planType: Int,description:String,mostPopular:String) {
        self.country = country
        self.currency = currency
        self.id = id
        self.planType = planType
        self.planPrice = planPrice
        self.description = description
        self.mostPopular = mostPopular
    }
}
struct SubscriptionsModel {
    let country: String?
    let createdAt: String?
    let customerId: String?
    let paymentReciept: String?
    let paymentGateway: Int?
    let planExpiryDate: String?
    let planPrice: NSNumber?
    let planStartDate: String?
    let planType: String?
    let userId: String?
    
    init(country: String, createdAt: String, customerId:String, paymentReciept:String,  paymentGateway: Int, planExpiryDate:String, planPrice:NSNumber, planStartDate:String, planType:String, userId:String) {
        self.country = country
        self.createdAt = createdAt
        self.customerId = customerId
        self.paymentReciept = paymentReciept
        self.paymentGateway = paymentGateway
        self.planExpiryDate = planExpiryDate
        self.planPrice = planPrice
        self.planStartDate = planStartDate
        self.planType = planType
        self.userId = userId
    }
}
