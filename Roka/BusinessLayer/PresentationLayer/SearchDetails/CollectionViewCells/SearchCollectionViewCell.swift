//
//  SearchCollectionViewCell.swift
//  Roka
//
//  Created by  Developer on 10/11/22.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var overLayImg: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var buttonImageSave: UIButton!

    var imageClick: ((Int) -> ())?
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    
    var profile : ProfilesModel! { didSet { categoryDidSet() } }
    
    func categoryDidSet() {
        
        let images = profile.userImages?.filter({($0.file != "" && $0.file != "<null>" && $0.isDp == 1)})
        if let images = images, !images.isEmpty {
            let image = images[0]
            let urlstring = image.file ?? ""
            let trimmedString = urlstring.replacingOccurrences(of: " ", with: "%20")
            imageProfile.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + trimmedString)), placeholderImage: #imageLiteral(resourceName: "Avatar"), completed: nil)
        } else {
            imageProfile.image = #imageLiteral(resourceName: "Avatar")
        }
//        let images = profile.userImages?.filter({($0.file != "" && $0.file != "<null>")})
//        if images?.count ?? 0 > 0 {
//            let profileImageFirst = images?.first
//            imageProfile.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + (profileImageFirst?.file ?? ""))), placeholderImage: #imageLiteral(resourceName: "Avatar"), completed: nil)
//
//        } else {
//            imageProfile.image = #imageLiteral(resourceName: "Avatar")
//        }
       
        let gender = profile?.Gender?.name?.prefix(1)

        labelName.text = (profile.firstName ?? "")
        
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
            labelName.text = (profile.firstName ?? "") + ", \(userAge)" + "\(gender ?? "")"
        }
        
        let city = profile.city == nil ? "" : profile.city
        let state = profile.state == nil ? "" : profile.state
        let country = profile.country == nil ? "" : profile.country
        if country == "" {
            labelAddress.text = (city == "" || city == "<null>") ?
            state : (state == "" || state == "<null>") ?
            city : "\(city ?? ""), \(state ?? "")"
        } else{
            labelAddress.text = (city == "" || city == "<null>") ?
            country : (country == "" || country == "<null>") ?
            city : "\(city ?? ""), \(country ?? "")"
        }
        
        if let distance = profile.distance {
            let strDistance = "\(distance)"
            let fullArr = strDistance.components(separatedBy: ".")
            if storedUser?.countryCode == "+91"{
                if fullArr.count > 0{
                    if Int(fullArr[0]) ?? 0 > 500 {
                        labelDistance.text = ">500 Km"
                    } else {
                        labelDistance.text = "\(fullArr[0]) Km"
                    }
                } else {
                    labelDistance.text = ""
                }
                //  let roundedValue = round(distance * 100) / 100.0
            } else {
                if fullArr.count > 0{
                    if Int(fullArr[0]) ?? 0 > 500 {
                        labelDistance.text = ">500 Miles"
                    } else {
                        labelDistance.text = "\(fullArr[0]) Miles"
                    }
                } else {
                    labelDistance.text = ""
                }
                
                //let roundedValue = round(distance * 100) / 100.0
               // labelDistance.text = "\(String(format: "%.0f", distance)) Miles"
              //labelDistance.text = "\(distance) Miles"
            }
        } else {
            if storedUser?.countryCode == "+91"{
                labelDistance.text = "0 Km"
            }else {
                labelDistance.text = "0 Miles"
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        
    }
    
    func configure(index: Int) {
        self.buttonImageSave.tag = index
    }
    
    private func setupUI() {
        backView.layer.cornerRadius = 20
        backView.clipsToBounds = true
        
        // Apply a shadow
        layer.cornerRadius = 20
        layer.masksToBounds = false
        layer.shadowRadius = 10.0
        layer.shadowOpacity = 0.10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 10)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Improve scrolling performance with an explicit shadowPath
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: 20
        ).cgPath
    }
    
    @IBAction func imageSaveClicked(_ sender: UIButton) {
        imageClick?(sender.tag)
    }
}
