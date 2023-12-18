//
//  ImageCollectionViewCell.swift
//  Roka
//
//  Created by Pankaj Rana on 18/10/22.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var imageCaption: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var descBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var kingImage: UIImageView!
    
    var userImage: ProfilesImages! { didSet { userImageDidSet() } }
    var profile : ProfilesModel! { didSet { profileDidSet() } }
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    
    func profileDidSet() {
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
        
        if let distance = profile.distance {
            let strDistance = "\(distance)"
            let fullArr = strDistance.components(separatedBy: ".")
            if storedUser?.countryCode == "+91"{
                if fullArr.count > 0{
                    if Int(fullArr[0]) ?? 0 > 500 {
                        descLabel.text = ">500 Km"
                    } else {
                        descLabel.text = "\(fullArr[0]) Km"
                    }
                } else {
                    descLabel.text = ""
                }
               // let roundedValue = round(distance * 100) / 100.0
              //  descLabel.text = "\(String(format: "%.0f", distance)) Km"
               // descLabel.text = "\(distance) Km"
            } else {
                if fullArr.count > 0{
                    if Int(fullArr[0]) ?? 0 > 500 {
                        descLabel.text = ">500 Miles"
                    } else {
                        descLabel.text = "\(fullArr[0]) Miles"
                    }
                } else {
                    descLabel.text = ""
                }
                //let roundedValue = round(distance * 100) / 100.0
               // descLabel.text = "\(String(format: "%.0f", distance)) Miles"
                //descLabel.text = "\(distance) Miles"
            }
        } else {
            if storedUser?.countryCode == "+91"{
                descLabel.text = ""
            }else {
                descLabel.text = ""
            }
        }
        
        if profile.isSubscriptionPlanActive == 1{
            kingImage.isHidden = false
        } else {
            kingImage.isHidden = true
        }
        
        
    }
    
    func userImageDidSet() {
        backImageView.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + (userImage.file ?? ""))), placeholderImage: #imageLiteral(resourceName: "Avatar"), completed: nil)
        
        imageCaption.text = userImage.title


    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
