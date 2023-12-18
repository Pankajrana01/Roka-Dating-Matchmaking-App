//
//  LookingForLoveProfileConstant.swift
//  Roka
//
//  Created by Pankaj Rana on 21/09/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var lookingForLoveProfile: UIStoryboard {
        return UIStoryboard(name: "LookingForLoveProfile", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let stepOne              = "StepOneViewController"
    static let stepTwo              = "StepTwoViewController"
    static let stepThree            = "StepThreeViewController"
    static let stepFour             = "StepFourViewController"
    static let stepFive             = "StepFiveViewController"
    static let verifyKYC            = "VerifyKYCViewController"
    static let preview              = "previewViewController"
    static let profileCreated       = "ProfileCreatedViewController"
}


extension StringConstants {
    static let verifyKYC            = "Verify video"
}


extension CollectionViewNibIdentifier {
    static let uploadImageNib           = "UploadImagesCollectionViewCell"
}
extension CollectionViewCellIdentifier {
    static let uploadImagecell           = "UploadImagesCollectionViewCell"
}

extension ValidationError {
    static let selectGender            = "Please select Gender."
    static let selectSexual            = "Please select sexual preference."
    static let selectDOB               = "Please select date of birth."
    static let selectPreferedGender    = "Please select gender."
    static let selectPreferedLocation  = "Please select preferred location."
    static let selectLocation          = "Please select location."
    static let recordVideoForTenSec    = "Record video at-least for 10 sec"

}
