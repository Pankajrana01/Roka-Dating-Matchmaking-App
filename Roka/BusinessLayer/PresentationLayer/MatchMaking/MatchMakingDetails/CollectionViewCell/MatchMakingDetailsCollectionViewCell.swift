//
//  MatchMakingDetailsCollectionViewCell.swift
//  Roka
//
//  Created by  Developer on 05/12/22.
//

import UIKit

class MatchMakingDetailsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var kingImage: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var fullButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var callBackShareButton: (() -> ())?
    var callBackFullButton: ((_ tag: Int) -> ())?

    static let identifier = "MatchMakingDetailsCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(viewModel: MatchMakingDetailsCollectionViewCellViewModel) {
//        self.shareButton.tag = index
        let model = viewModel.model
        let images = model.userImages?.filter({($0.file != "" && $0.file != "<null>" && $0.isDp == 1)})
        if let images = images, !images.isEmpty {
            let image = images[0]
            let urlstring = image.file ?? ""
            let trimmedString = urlstring.replacingOccurrences(of: " ", with: "%20")
            
            profileImage.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + trimmedString)), placeholderImage: #imageLiteral(resourceName: "Avatar"), completed: nil)
        } else {
               profileImage.image = #imageLiteral(resourceName: "Avatar")
        }
        
        if viewModel.isSelected {
            self.shareButton.setImage(UIImage(named: "Ic_tick_2"), for: .normal)
        } else {
            self.shareButton.setImage(UIImage(named: "Ic_share 2"), for: .normal)
        }

        let gender = model.Gender?.name?.prefix(1)
        nameLabel.text = (model.firstName ?? "")
        
        if model.dob != nil && model.dob != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dobDate = dateFormatter.date(from: model.dob!) ?? Date()
            let now = Date()
            let calendar = Calendar.current
            let ageComponents = calendar.dateComponents([.year], from: dobDate, to: now)
            let age = ageComponents.year!
            print(age)
            let userAge = model.userAge ?? 0
            nameLabel.text = (model.firstName ?? "") + ", \(userAge)" + "\(gender ?? "")"
        }
        
        let city = model.city == nil ? "" : model.city
        let state = model.state == nil ? "" : model.state
        let country = model.country == nil ? "" : model.country
        if country == "" {
            descLabel.text = (city == "" || city == "<null>") ?
            state : (state == "" || state == "<null>") ?
            city : "\(city ?? ""), \(state ?? "")"
        } else {
            descLabel.text = (city == "" || city == "<null>") ?
            country : (country == "" || country == "<null>") ?
            city : "\(city ?? ""), \(country ?? "")"
        }
        
        if model.isSubscriptionPlanActive == 1 {
            kingImage.isHidden = false
        } else {
            kingImage.isHidden = true
        }
    }
    
    @IBAction func shareButtonClicked(_ sender: UIButton) {
        // Share button action here..
        callBackShareButton?()
    }
    
    @IBAction func fullButtonClicked(_ sender: UIButton) {
        // Full button action here..
        callBackFullButton?(sender.tag)
    }
}
