//
//  InboxCell.swift
//  Roka
//
//  Created by Applify  on 21/11/22.
//

import UIKit

class InboxCell: UITableViewCell {

    @IBOutlet weak var isUserVeriefImage: UIImageView!

    @IBOutlet weak var chatRoomImage: UIImageView!
    @IBOutlet weak var onlineView: UIView!

    @IBOutlet weak var chatRoomName: UILabel!
    @IBOutlet weak var chatRoomLastMsg: UILabel!
    @IBOutlet weak var unReadCountView: UIView!
    @IBOutlet weak var unReadCount: UILabel!
    @IBOutlet weak var lastDateTime: UILabel!
    @IBOutlet weak var filterStatus: UILabel!
    @IBOutlet weak var filterStatusView: UIView!

    static let identifier = "InboxCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chatRoomImage.layer.cornerRadius = chatRoomImage.frame.size.width / 2
        chatRoomImage.clipsToBounds = true
    }
    
    func setUpInbox(model: ChatRoomModel) {
        
        if model.dialog_type == 1 { //One to one
            var otherUserKey = ""
            for (key, _) in model.user_id ?? [:] {
                if key != UserModel.shared.user.id { //Other User
                    otherUserKey = key
                    break
                }
            }
            
            if otherUserKey != "" {
                let pic = model.user_pic?[otherUserKey] ?? "dp"
                pic == "dp" ? self.chatRoomImage.image = #imageLiteral(resourceName: "Avatar") : self.chatRoomImage.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + pic)), placeholderImage: #imageLiteral(resourceName: "Avatar"), completed: nil)
                
                self.chatRoomName.text = UserModel.shared.user.id == model.dialog_admin ? model.user_name?[otherUserKey] ?? "" : model.user_number?[otherUserKey] ?? ""
            }
            
        } else { //Group chat
            //ic_group
            let pic = model.pic ?? "dp"
            pic == "dp" ? self.chatRoomImage.image = #imageLiteral(resourceName: "ic_group") : self.chatRoomImage.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + pic)), placeholderImage: #imageLiteral(resourceName: "ic_group"), completed: nil)
            self.chatRoomName.text = model.name
        }
        
        
        if model.last_message?[UserModel.shared.user.id] ?? FirestoreManager.lastMessageRegex == FirestoreManager.lastMessageRegex {
            chatRoomLastMsg.text = ""
            lastDateTime.text = ""

        } else {
            if model.last_message_type == 4 {
                chatRoomLastMsg.text = "Share Profile"
                
            } else if model.last_message_type == 2 {
                chatRoomLastMsg.text = "Image"
                
            } else {
                let lastMessageText = model.last_message?[UserModel.shared.user.id] ?? ""
                let index = lastMessageText.index(lastMessageText.startIndex, offsetBy:lastMessageText.count >= 15 ? 15 : lastMessageText.count)
                let substring = lastMessageText.substring(to:index)
                chatRoomLastMsg.text = substring + (substring.count >= 15 ? "..." : "")
            }
            
            setupLastDateTime(time: model.last_message_time ?? 0)
        }
        
        let unreadCount = model.unread_count?[UserModel.shared.user.id] ?? 0
        self.unReadCountView.isHidden = unreadCount > 0 ? false : true
        self.unReadCount.text = "\(unreadCount)"
        
        let dialog_status = model.dialog_status?[UserModel.shared.user.id]
        self.filterStatusView.backgroundColor =  UIColor(hex: dialog_status == 1 ? "2F50AA" : (dialog_status == 2 ? "F2474D" : (dialog_status == 3 ? "FF7243" : "CBCBCB")))
        self.filterStatus.text = dialog_status == 1 ? "Liked" : (dialog_status == 2 ? "Matched" : (dialog_status == 3 ? "Contact" : "Other"))
        
        var otherUserKeys = ""
        for (key, _) in model.user_id ?? [:] {
            if key != UserModel.shared.user.id { //Other User
                otherUserKeys = key
                break
            }
        }
        if model.dialog_type == 1 {
            let premimumStatus = model.premium_status?[otherUserKeys]
            if premimumStatus == 1{
                self.self.isUserVeriefImage.isHidden = false
            }else{
                self.self.isUserVeriefImage.isHidden = true
            }
        }else{
            self.self.isUserVeriefImage.isHidden = true
        }
        
    }
    
    func setupLastDateTime(time: Int64) {
        if time > 0 {
            let date = Date(timeIntervalSince1970: TimeInterval(time / 1000))
            let dayTimePeriodFormatter = DateFormatter()
            dayTimePeriodFormatter.dateFormat = "dd MMM YYYY, hh:mm a"
            let dateString = dayTimePeriodFormatter.string(from: date)
            
            dayTimePeriodFormatter.dateFormat = "dd MMM YYYY"
            let dtStr = dayTimePeriodFormatter.string(from: date)
            let todaydtStr = dayTimePeriodFormatter.string(from: Date())
            
            if dtStr == todaydtStr {
                dayTimePeriodFormatter.dateFormat = "hh:mm a"
                let dateStringgg = dayTimePeriodFormatter.string(from: date)
              //  lastDateTime.text = "Today, \(dateStringgg)"
                lastDateTime.text = "\(dateStringgg)"
            } else {
                lastDateTime.text = dateString
            }
        } else {
            lastDateTime.text = ""
        }
    }
}
