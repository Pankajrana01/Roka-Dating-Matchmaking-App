//
//  HomeConstant.swift
//  Roka
//
//  Created by Pankaj Rana on 23/09/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var home: UIStoryboard {
        return UIStoryboard(name: "Home", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let home                     = "HomeViewController"
    static let detail                   = "DetailViewController"
    static let report                   = "ReportViewController"
    static let pageController           = "PagerController"
    static let fullDetail               = "FullViewDetailViewController"
    static let detailAdsView            = "DetailAdsViewController"
    static let pageFullView             = "PageFullViewVC"
    static let cardView                 = "CardViewViewController"
}

extension CollectionViewNibIdentifier {
    static let homeNib                  = "HomeCollectionViewCell"
    static let imageCell                = "ImageCollectionViewCell"
    static let galleryCell              = "GalleryCollectionViewCell"
    static let wishCell                = "WishToHaveCollectionCell"
}
extension CollectionViewCellIdentifier {
    static let homecell                 = "HomeCollectionViewCell"
    static let imageCell                = "ImageCollectionViewCell"
    static let galleryCell              = "GalleryCollectionViewCell"
    static let wishCell                = "WishToHaveCollectionCell"
}

extension TableViewNibIdentifier{
    static let imageCell                = "ImageTableViewCell"
    static let interestCell             = "InterestTableViewCell"
    static let heightCell               = "HeightTableViewCell"
    static let moviesCell               = "MovieTableViewCell"
    static let socialCell               = "SocialTableViewCell"
    static let galleryCell              = "GalleryTableViewCell"
    static let wishToCell               = "HaveToWishTableViewCell"
    static let partnerCell              = "PartnerTableViewCell"
    static let userImageCell            = "UserImageTableCell"
    static let familyAnddFriendCell     = "FamilyAndFriendTableCell"
    static let PersonalityCell          = "PersonalityTableCell"
    static let WorkOutCell              = "WorkOutTableCell"
    static let socialssCell              = "SocialTableCell"
}
extension TableViewCellIdentifier {
    static let reportCell               = "reportTableViewCell"
    static let imageCell                = "ImageTableViewCell"
    static let interestCell             = "InterestTableViewCell"
    static let heightCell               = "HeightTableViewCell"
    static let moviesCell               = "MovieTableViewCell"
    static let socialCell               = "SocialTableViewCell"
    static let galleryCell              = "GalleryTableViewCell"
    static let wishToCell               = "HaveToWishTableViewCell"
    static let partnerCell              = "PartnerTableViewCell"
    static let userImageCell            = "UserImageTableCell"
    static let familyAnddFriendCell     = "FamilyAndFriendTableCell"
    static let PersonalityCell          = "PersonalityTableCell"
    static let WorkOutCell              = "WorkOutTableCell"
    static let socialssCell              = "SocialTableCell"
}

extension StringConstants {
    static let homeTitle           = "Roka Dating Home"
    static let homeDesc            = "Explore all the dating profiles from this section."
    
    static let notiTitle           = "Notifications"
    static let notiDesc            = "Find all the new and old notifications on this section."
    
    static let searchTitle           = "Search"
    static let searchDesc            = "Create and save customised filter to get the best matching profile suggestions."
    
    static let chatTitle           = "Chat"
    static let chatDesc            = "Find and manage your all the single and group chats from this section."
    
    static let profileTitle           = "My Profile"
    static let profileDesc            = "Manage your account settings and preferences from this section."
    
    static let reportSuccess          = "We have sent an email to admin regarding your query. Please wait for 24 hours we are working on it."
    static let BlockSuccess           = "Blocked successfully"
    static let unBlockSuccess           = "Unblocked successfully"

}

extension ValidationError {
    static let selectProblem           = "Please select at least one reason"

}
