//
//  ProfileCardView.swift
//  Roka
//
//  Created by Pankaj Rana on 18/10/23.
//

import Foundation
import UIKit

class ProfileCardView: UIView {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var kingImage: UIImageView!
    @IBOutlet weak var imageCaption: UILabel!
    @IBOutlet weak var verifiedImage: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    
    func profileDidSets(profile:ProfilesModel?) {
        imageView.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + (profile?.userImages?[0].file ?? ""))), placeholderImage: #imageLiteral(resourceName: "Avatar"), options: .refreshCached, completed: nil)
        
        imageCaption.text = profile?.userImages?[0].title
        let gender = profile?.Gender?.name?.prefix(1)
        userNameLabel.text = profile?.firstName
       
        if profile?.dob != nil && profile?.dob != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dobDate = dateFormatter.date(from: profile?.dob ?? "") ?? Date()
            let now = Date()
            let calendar = Calendar.current
            let ageComponents = calendar.dateComponents([.year], from: dobDate, to: now)
            let age = ageComponents.year!
            print(age)
            let userAge = profile?.userAge ?? 0
            userNameLabel.text = (profile?.firstName ?? "") + ", \(userAge)" + "\(gender ?? "")"
        }
        
        let city = profile?.city == nil ? "" : profile?.city
        let country = profile?.country == nil ? "" : profile?.country
        let state = profile?.state == nil ? "" : profile?.state
        if country == "" {
            locationLabel.text = (city == "" || city == "<null>") ? state : (state == "" || state == "<null>") ? city : "\(city ?? ""), \(state ?? "")"
        } else{
            locationLabel.text = (city == "" || city == "<null>") ? country : (country == "" || country == "<null>") ? city : "\(city ?? ""), \(country ?? "")"
        }
        
        if profile?.isSubscriptionPlanActive == 1{
            kingImage.isHidden = false
        } else {
            kingImage.isHidden = true
        }
        
        if profile?.isKycApproved == 0 {
            descLabel.isHidden = true
            verifiedImage.isHidden = true
        } else {
            descLabel.isHidden = false
            verifiedImage.isHidden = false
        }
    }
    
}
