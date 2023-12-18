//
//  MatchMakingCollectionViewCell.swift
//  Roka
//
//  Created by  Developer on 21/11/22.
//

import UIKit

class MatchMakingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var centerImage: UIImageView!
    @IBOutlet weak var add_editButton: UIButton!
    @IBOutlet weak var labelAddFriend_name: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelSuggestions: UILabel!
    @IBOutlet weak var fullButton: UIButton!
    @IBOutlet weak var bgColorView: UIView!
    @IBOutlet weak var bgColorLable: UILabel!
    @IBOutlet weak var buttonStackView: UIButton!
    @IBOutlet weak var addFriendImage: UIImageView!
    
    static let identifier = "MatchMakingCollectionViewCell"
    
    var callBackForAdd_edit: ((_ tag: Int) -> ())?
    var callBackForFull_Button: ((_ tag: Int) -> ())?
    var callBackForStackViewButton: ((_ tag: Int) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backImage.layer.cornerRadius = backImage.frame.height/2
        self.backImage.layer.masksToBounds = true
        bgColorView.layer.cornerRadius = bgColorView.frame.size.height / 2
        bgColorView.clipsToBounds = true
    }
    
    func configure(index: Int, model: ProfilesModel?) {
        if index == 0 {
            self.backImage.image = UIImage(named: "Ellipse")
            self.centerImage.image = UIImage(named: "Ic_image")
            self.add_editButton.setImage(UIImage(named: ""), for: .normal)
          //  self.labelAddFriend_name.text = "Add more friends"
            self.labelAddFriend_name.text = ""
            self.centerImage.isHidden = false
            self.labelAddress.isHidden = true
            self.labelSuggestions.isHidden = true
            bgColorView.isHidden = true
            addFriendImage.isHidden = false
            borderView.isHidden = true
        } else {
            self.backImage.image = UIImage(named: "Avatar")
            self.add_editButton.setImage(UIImage(named: "ic_edit-1"), for: .normal)
            self.centerImage.isHidden = true
            self.labelAddress.isHidden = true
            self.labelSuggestions.isHidden = false
            addFriendImage.isHidden = true
            borderView.isHidden = false
        }
        
        fullButton.tag = index
        add_editButton.tag = index
        buttonStackView.tag = index
        
        guard let model = model else { return }
        let images = model.userImages?.filter({($0.file != "" && $0.file != "<null>")})
        if images?.count ?? 0 > 0 {
            let profileImageFirst = images?.first
            backImage.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + (profileImageFirst?.file ?? ""))), placeholderImage: #imageLiteral(resourceName: "Avatar"), completed: nil)
            bgColorView.isHidden = true
        } else {
            bgColorView.isHidden = false
            bgColorView.backgroundColor = UIColor(hex: model.placeHolderColour ?? "")
            bgColorLable.text = (model.firstName ?? "").prefix(1).capitalized
        }
        
        let gender = model.Gender?.name?.prefix(1)
        
        labelAddFriend_name.text = (model.firstName ?? "") + ", \(gender ?? "")"
        
//        if model.dob != nil && model.dob != "" {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            let dobDate = dateFormatter.date(from: model.dob!) ?? Date()
//            let now = Date()
//            let calendar = Calendar.current
//            let ageComponents = calendar.dateComponents([.year], from: dobDate, to: now)
//            let age = ageComponents.year!
//            print(age)
//            let userAge = model.userAge ?? 0
//            labelAddFriend_name.text = (model.firstName ?? "") + ", \(userAge)" + "\(gender ?? "")"
//        }
    
        let city = model.city == nil ? "" : model.city
        let state = model.state == nil ? "" : model.state
        let country = model.country == nil ? "" : model.country
        if country == "" {
            labelAddress.text = (city == "" || city == "<null>") ?
            state : (state == "" || state == "<null>") ?
            city : "\(city ?? ""), \(state ?? "")"
        } else{
            labelAddress.text = (city == "" || city == "<null>") ?
            country : (country == "" || country == "<null>") ?
            city : "\(city ?? ""), \(country ?? "")"
        }
        if let suggetsedProfilesCount = model.newSuggestedProfilesCount, model.newSuggestedProfilesCount != 0 {
//        if let suggetsedProfilesCount = model.newSuggestedProfilesCount {
            self.labelSuggestions.text = "\(suggetsedProfilesCount) New profiles"
            self.buttonStackView.isUserInteractionEnabled = true
        } else {
            self.labelSuggestions.text = ""
//            self.labelSuggestions.text = "No new profile suggested"
            self.buttonStackView.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func add_editButtonAction(_ sender: UIButton) {
        callBackForAdd_edit?(sender.tag)        
    }
    
    @IBAction func fullButtonAction(_ sender: UIButton) {
        callBackForFull_Button?(sender.tag)
    }
    
    @IBAction func buttonStackViewClicked(_ sender: UIButton) {
        callBackForStackViewButton?(sender.tag)
    }
    
}
