//
//  GridCollectionViewCell.swift
//  Roka
//
//  Created by Pankaj Rana on 14/11/22.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var kingImage: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var distanceLable: UILabel!
    @IBOutlet weak var descLable: UILabel!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var imageCaption: UILabel!
    
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
            backImageView.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + trimmedString)), placeholderImage: #imageLiteral(resourceName: "Avatar"), completed: nil)
        } else {
               backImageView.image = #imageLiteral(resourceName: "Avatar")
        }
        
        let gender = profile?.Gender?.name?.prefix(1)

        nameLable.text = (profile.firstName ?? "")
        
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
            nameLable.text = (profile.firstName ?? "") + ", \(userAge)" + "\(gender ?? "")"
        }
        
        let city = profile.city == nil ? "" : profile.city
        let state = profile.state == nil ? "" : profile.state
        let country = profile.country == nil ? "" : profile.country
        if country == "" {
            descLable.text = (city == "" || city == "<null>") ?
            state : (state == "" || state == "<null>") ?
            city : "\(city ?? ""), \(state ?? "")"
        } else{
            descLable.text = (city == "" || city == "<null>") ?
            country : (country == "" || country == "<null>") ?
            city : "\(city ?? ""), \(country ?? "")"
        }
        
//        if let distance = profile.distance {
//            let strDistance = "\(distance)"
//            let fullArr = strDistance.components(separatedBy: ".")
//            if storedUser?.countryCode == "+91"{
//                if fullArr.count > 0{
//                    if Int(fullArr[0]) ?? 0 > 500 {
//                        distanceLable.text = ">500 Km"
//                    } else {
//                        distanceLable.text = "\(fullArr[0]) Km"
//                    }
//                } else {
//                    distanceLable.text = ""
//                }
//
//               // let roundedValue = round(distance * 100) / 100.0
//               // distanceLable.text = "\(String(format: "%.0f", distance)) Km"
//               // distanceLable.text = "\(distance) Km"
//            } else {
//                if fullArr.count > 0{
//                    if Int(fullArr[0]) ?? 0 > 500 {
//                        distanceLable.text = ">500 Miles"
//                    } else {
//                        distanceLable.text = "\(fullArr[0]) Miles"
//                    }
//                } else {
//                    distanceLable.text = ""
//                }
//                //let roundedValue = round(distance * 100) / 100.0
//                //distanceLable.text = "\(String(format: "%.0f", distance)) Miles"
//                //distanceLable.text = "\(distance) Miles"
//            }
//        } else {
//            if storedUser?.countryCode == "+91"{
//                distanceLable.text = "0 Km"
//            }else {
//                distanceLable.text = "0 Miles"
//            }
//        }
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        imageClick?(sender.tag)

    }
    
    func configure(index: Int) {
        self.saveButton.tag = index
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
