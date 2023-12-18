//
//  NotificationTableViewCell.swift
//  Roka
//
//  Created by  Developer on 29/11/22.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var DescImage: UIImageView!
    
    static let identifier = "NotificationTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        self.selectionStyle = .none
    }
    
    private func setupUI() {
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.layer.masksToBounds = true
    }
    
    func configure(model: Notifications) {
        if model.isRead == 0{
            self.bgView.backgroundColor = UIColor.appSeparator
        } else {
            self.bgView.backgroundColor = UIColor.clear
        }
        
       // self.bgView.backgroundColor = UIColor.clear
//        if model.notificationType == 0 || model.notificationType == 8{
//            let longString = "\(model.title ?? "") \n" + "\(model.message ?? "")"
//
//            let name = "\(model.title ?? "") \n"
//            let longestWordRange = (longString as NSString).range(of: name)
//
//            let attributedString = NSMutableAttributedString(string: longString, attributes: [NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Regular", size: 14.0)!, NSAttributedString.Key.foregroundColor : UIColor.appBorder])
//
//            attributedString.setAttributes([NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Medium", size: 16.0)!, NSAttributedString.Key.foregroundColor : UIColor.appBorder], range: longestWordRange)
//
//            self.labelDescription.attributedText = attributedString
//
//        } else {
//            let longString = "\(model.userName ?? "")".capitalized + " \(model.message ?? "")"
//            let name = "\(model.userName ?? "")".capitalized
//            let longestWordRange = (longString as NSString).range(of: name)
//
//            let attributedString = NSMutableAttributedString(string: longString, attributes: [NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Regular", size: 14.0)!, NSAttributedString.Key.foregroundColor : UIColor.appBorder])
//
//            attributedString.setAttributes([NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Medium", size: 16.0)!, NSAttributedString.Key.foregroundColor : UIColor.appBorder], range: longestWordRange)
//
//            //self.labelTitle.text = model.title
//            self.labelDescription.attributedText = attributedString
//
//        }
//        if let matchedUserImage = model.userImage{
//            let imageUrl: String = KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + matchedUserImage
//
//            self.profileImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "Avatar"), options: .refreshCached)
//        } else {
//            self.profileImage.image = #imageLiteral(resourceName: "Avatar")
//        }
        
        
        self.labelDescription.text = model.message
        
        if model.notificationType == 8{
            self.profileImage.image = #imageLiteral(resourceName: "New_Kyc_Unapprove_Img")
        }else if model.notificationType == 7{
            self.profileImage.image  = #imageLiteral(resourceName: "New_Kyc_Approved_Icon")
        }else if model.notificationType == 5 || model.notificationType == 10 || model.notificationType == 1{
            if let matchedUserImage = model.userImage{
                let imageUrl: String = KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + matchedUserImage
                
                self.profileImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "Avatar"), options: .refreshCached)
            } else {
                self.profileImage.image = #imageLiteral(resourceName: "Avatar")
            }
        }else if model.notificationType == 0{
            self.profileImage.image = #imageLiteral(resourceName: "New_Notification_Imgs")
        }else{
            self.profileImage.image = #imageLiteral(resourceName: "New_Notification_Imgs")
        }

        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?

        if let date = dateFormatter.date(from:model.createdAt ?? "") {
            self.labelTime.text = "\(timeAgoSinceDate(todate: date))"
        }
    }
}

func timeAgoSinceDate(todate:Date) -> String {
    // From Time
    let fromDate = todate
    
    // To Time
    let toDate = Date()
    
    // Estimationlet calendar: Calendar = Calendar.current
    let calendar: Calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: fromDate, to: toDate)
    print(components)
    
    // Year
    if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {
        
        return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
    }
    
    // Month
    if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {
        
        return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
    }
    
    // Day
    if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {
        
        return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
    }
    
    // Hours
    if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
        
        return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
    }
    
    // Minute
    if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
        
        return interval == 1 ? "\(interval)" + " " + "min ago" : "\(interval)" + " " + "min ago"
    }
    
    // Seconds
    if let interval = Calendar.current.dateComponents([.second], from: fromDate, to: toDate).second, interval > 0 {
        
        return interval == 1 ? "\(interval)" + " " + "sec ago" : "\(interval)" + " " + "sec ago"
    }
    
    return "now"
}
