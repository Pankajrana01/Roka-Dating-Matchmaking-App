//
//  AppDelegate.swift
//  Roka
//
//  Created by Applify  on 19/09/22.
//

import Foundation
import UIKit

//let fontRegular : NSString = NSString(format: "SFProDisplay-Regular")
//let fontBold : NSString = NSString(format: "SFProDisplay-Bold")
//let fontHeavy : NSString = NSString(format: "SFProDisplay-Heavy")
//let fontMedium : NSString = NSString(format: "SFProDisplay-Medium")

struct TimeFormat {
    static let formatFromServer                                         = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    static let formatEventDetails                                       = "d MMM yyyy"
    static let formatEventDetailss                                      = "d-MM-yyyy"
}

struct AppConstants {
    
}

extension ValidationError {
    static let emptyEmail                       = "Please enter email."
    static let emptyUsername                    = "Please enter username."
    static let emptyUserEmail                   = "Please enter Email/Username."
    static let emptySuggestion                  = "Please enter your suggestion"

    static let invalidEmail                     = "Please enter valid email address"
    
    static let emptyRelationshipStatus          = "Please select relationship status"
    static let emptyWishingStatus               = "Please select wishing to have"
    
    static let invalidEmailUserName             = "Please enter a valid Email/Username."
    static let invalidUserName                  = "Username should be minimum 3 and maximum of 60 characters."
    static let emptyPassword                    = "Please enter Set password."
    static let emptyPasswordLogin               = "Please enter password."
    static let emptyConfirmPassword             = "Please enter Confirm password."
    static let invalidPasswordChar              = "Set password must contain at least 1 uppercase, 1 lowercase, 1 special character and 1 number."
    static let invalidPasswordCharLogin         = "Password must contain at least 1 uppercase, 1 lowercase, 1 special character and 1 number."
    static let invalidNewPasswordChar           = "New password must contain at least 1 uppercase, 1 lowercase, 1 special character and 1 number."
    static let invalidCurrentPasswordChar       = "Current password must contain at least 1 uppercase, 1 lowercase, 1 special character and 1 number."
    static let invalidPasswordLength            = "Password must contain at least 8 characters."
    static let invalidPassword                  = "Password must contain 8 alphanumeric Characters."
    static let emptyFullName                    = "Please enter the full name."
    static let emptyFirstName                   = "Please enter the first name."
    static let emptyLastName                    = "Please enter the last name."
    static let emptyName                        = "Please enter the name."
    static let invalidFirstName                 = "The first name should be a minimum of 3 and a maximum of 30 characters."
    static let invalidLastName                  = "The last name should be a minimum of 3 and a maximum of 30 characters."
    static let invalidFullNameCount             = "Name should be minimum 3 and maximum of 30 characters."
    static let emptyEmailAndPhone               = "Please enter email address or phone number."
    static let emptyOTP                         = "Please enter OTP."
    static let invalidOTP                       = "Please Enter Valid OTP."
    static let newPassword                      = "Please enter new password."
    static let confirmPassword                  = "Please enter confirm password."
    static let passwordMismatch                 = "New password and Confirm password do not match."
}
