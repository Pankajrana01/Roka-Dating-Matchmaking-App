//
//  PopupConstant.swift
//  Roka
//
//  Created by Pankaj Rana on 22/09/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var popups: UIStoryboard {
        return UIStoryboard(name: "Popups", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let gender                      = "GenderViewController"
    static let calendar                    = "CalendarViewController"
    static let selectCounrty               = "SelectCountryViewController"
    static let logout                      = "LogoutViewController"
    static let switchMode                  = "SwitchModeViewController"
    static let height                      = "HeightViewController"
    static let ageRange                    = "AgeRangeViewController"
    static let preferenceHeight            = "PreferenceHeightViewController"
    static let movies                      = "MoviesViewController"
    static let addLinks                    = "AddLinksViewController"
    static let layout                      = "LayoutViewController"
    static let deleteAccount               = "DeleteAccountViewController"
    static let broadcast                   = "BroadCastPushViewController"
    static let matched                     = "MatchedViewController"
    static let removeSocialMedia           = "RemoveSocialMedialPopUpViewController"
    static let pendingKYC                  = "PendingKYCViewController"
    static let pendingVerification         = "PendingVerificationViewController"
    static let deactivateAccount           = "DeactivateAccountViewController"
    static let question                    = "QuestionsViewController"
    static let subcriptionUpgrade          = "UpgradeSubcriptionViewController"
    static let deactivate                  = "DeactivateViewController"
    static let delete                      = "DeletesViewController"
    static let distance                    = "PreferredDistanceViewController"
}

extension StringConstants {
    static let selectGender                 = "Select your gender"
    static let selectFGender                = "Select friend’s gender"
    static let selectPrefGender             = "Select preferred gender"
    static let selectWishing                = "I wish to have"
    static let selectPreferedWishing        = "Select preferred wishes to have"
    static let selectEthencity              = "Select your ethnicity"
    static let selectPreferredEthencity     = "Select preferred ethnicity"
    static let selectReligion               = "Select your religion"
    static let selectPreferredReligion      = "Select preferred religion"
    static let selectRelationship           = "Select preferred relationship status"
    static let relationship                 = "Relationship status"
    static let selectEducation              = "Select your education level"
    static let selectPreferredEducation     = "Select preferred education level"
    static let selectWork                   = "Select your work industry"
    static let selectPreferredWork          = "Select preferred work industry"
    static let selectPreferredWorkout       = "Select preferred workout"
    static let selectPreferredSport         = "Select preferred sports"
    static let selectPassion                = "Select your passions"
    static let selectPreferredPassion       = "Select preferred passions"
    static let selectSexualPreference       = "Find for your friend"
    static let selectMovies                 = "Movies"
    static let selectMusic                  = "Musics"
    static let selectDrinking               = "Drinking"
    static let selectPreferredDrinking      = "Select preferred drinking"
    static let selectSmoking                = "Smoking"
    static let selectPreferredSmoking       = "Select preferred smoking"
    static let selectZodiac                 = "Zodiac"
    static let selectPreferredZodiac        = "Select preferred zodiac"
    static let selectKids                   = "Kids"
    static let selectPreferredKids          = "Select preferred kids"
    static let selectPersonality            = "Personality"
    static let selectPreferredPersonality   = "Select preferred personality"
    static let selectSexual                 = "Sexual Orientation"
    static let selectWorkout                = "Workout"
    static let selectSports                 = "Sports"
    static let selectBooks                  = "Books"
    static let selectTV                     = "TV Series"
    static let updatedProfile               = "Profile updated successfully"
    static let updatedFriendsProfile        = "Friends profile updated successfully"
    static let updatedPrefProfile           = "Profile preference updated successfully"
    static let selectOneValue               = "Select at least one option"
    static let selectValue                  = "Please select the value first"
    static let addAnswers                   = "Please add answers first"
    static let invalidLink                  = "Please enter a valid link"

}

extension TableViewCellIdentifier{
    static let genderCell                  = "genderTableViewCell"
}
extension ValidationError{
    
}
