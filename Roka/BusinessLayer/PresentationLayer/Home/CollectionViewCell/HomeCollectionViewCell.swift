//
//  HomeCollectionViewCell.swift
//  Roka
//
//  Created by Pankaj Rana on 25/09/22.
//

import UIKit
import SDWebImage

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var kingimage: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var savedProfileImage: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favButton: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileWidth: NSLayoutConstraint!
    @IBOutlet weak var profileHeight: NSLayoutConstraint!
    
    var imageClick: ((Int) -> ())?
    var profile : ProfilesModel! { didSet { categoryDidSet() } }
    
    var callBackForSelectLikeButtons: ((_ selectedIndex:Int) ->())?
    var callBackForSelectChatButtons: ((_ selectedIndex:Int) ->())?

    
    func categoryDidSet() {
       
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        
        let images = profile.userImages?.filter({($0.file != "" && $0.file != "<null>" && $0.isDp == 1)})
        if let images = images, !images.isEmpty {
            let image = images[0]
            
            let urlstring = image.file ?? ""
            let trimmedString = urlstring.replacingOccurrences(of: " ", with: "%20")
            
            profileImage.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + trimmedString)), placeholderImage: #imageLiteral(resourceName: "Avatar"), options: .refreshCached, completed: nil)
        } else {
               profileImage.image = #imageLiteral(resourceName: "Avatar")
        }

        let gender = profile?.Gender?.name?.prefix(1)

        nameLabel.text = (profile.firstName ?? "")
        
        if profile.dob != nil && profile.dob != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dobDate = dateFormatter.date(from: profile.dob!) ?? Date()
            let now = Date()
            let calendar = Calendar.current
            let ageComponents = calendar.dateComponents([.year], from: dobDate, to: now)
            let age = ageComponents.year!
            print(age)
            
            let userAge = profile.userAge ?? 0
    
            if profile.isSubscriptionPlanActive == 1 {
                let stringWithImage = NSMutableAttributedString(string: "\((profile.firstName ?? "") + ", \(userAge)" + "\(gender ?? "")")")

//                let imageAttachment = NSTextAttachment()
//                imageAttachment.image = UIImage(named: "Ic_king")
//
//                let completeImageString = NSAttributedString(attachment: imageAttachment)
//
//                stringWithImage.append(NSAttributedString(string: " "))
//                stringWithImage.append(completeImageString)

                nameLabel.attributedText = stringWithImage
                kingimage.isHidden = false
            } else {
                kingimage.isHidden = true
                nameLabel.text = (profile.firstName ?? "") + ", \(userAge)" + "\(gender ?? "")"
            }
        }
        
        let city = profile.city == nil ? "" : profile.city
        let state = profile.state == nil ? "" : profile.state
        let country = profile.country == nil ? "" : profile.country
        if country == "" {
            descLabel.text = (city == "" || city == "<null>") ?
            state : (state == "" || state == "<null>") ?
            city : "\(city ?? ""), \(state ?? "")"
        } else {
            descLabel.text = (city == "" || city == "<null>") ?
            country : (country == "" || country == "<null>") ?
            city : "\(city ?? ""), \(country ?? "")"
        }
        
        if let liked = profile.isLiked {
           // favButton.setImage(UIImage(named: liked == 1 ? "ic_heart_selected-1" : "ic_heart_unselected-1"), for: .normal)
            favButton.image = UIImage(named: liked == 1 ? "ic_heart_selected-1" : "ic_heart_unselected-1")
        }
    
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
       // imageClick?(sender.tag) //ic_heart_selected-1
        if favButton.image == UIImage(named: "ic_heart_selected-1") {
            self.callBackForSelectChatButtons?(sender.tag)
        }else{
            self.callBackForSelectLikeButtons?(sender.tag)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.profileImage.image = UIImage(named: "avatar")
        self.nameLabel.text = ""
        self.descLabel.text = ""
    }
}
