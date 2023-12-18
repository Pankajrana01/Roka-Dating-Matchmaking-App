//
//  ChatInviteCell.swift
//  Roka
//
//  Created by Applify  on 21/11/22.
//

import UIKit

class ChatInviteCell: UITableViewCell {
    @IBOutlet weak var onlineView: UIView!

    @IBOutlet weak var chatRoomImage: UIImageView!
    @IBOutlet weak var chatRoomName: UILabel!
    @IBOutlet weak var chatRoomLastMsg: UILabel!
    @IBOutlet weak var unReadCountView: UIView!
    @IBOutlet weak var unReadCount: UILabel!
    @IBOutlet weak var lastDateTime: UILabel!
    
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var declineBtn: UIButton!

    static let identifier = "ChatInviteCell"
    
    var acceptPressed:((String) -> Void)?
    var rejectPressed:((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chatRoomImage.layer.cornerRadius = chatRoomImage.frame.size.width / 2
        chatRoomImage.clipsToBounds = true
    }
    
    var chatInviteData: ChatRoomModel? {
        didSet {
            var otherUserKey = ""
            for (key, _) in chatInviteData?.user_id ?? [:] {
                if key != UserModel.shared.user.id { //Other User
                    otherUserKey = key
                    break
                }
            }
            
            if otherUserKey != "" {
                let pic = chatInviteData?.user_pic?[otherUserKey] ?? ""
                self.chatRoomImage.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + pic)), placeholderImage: #imageLiteral(resourceName: "img_home6"), completed: nil)
                
                self.chatRoomName.text = UserModel.shared.user.id == chatInviteData?.dialog_admin ? chatInviteData?.user_name?[otherUserKey] ?? "" : chatInviteData?.user_number?[otherUserKey] ?? ""
            }
            
            if chatInviteData?.last_message?[UserModel.shared.user.id] ?? FirestoreManager.lastMessageRegex == FirestoreManager.lastMessageRegex {
                chatRoomLastMsg.text = ""
                lastDateTime.text = ""

            } else {
                if chatInviteData?.last_message_type == 4 {
                    chatRoomLastMsg.text = "Share Profile"
                    
                } else if chatInviteData?.last_message_type == 2 {
                    chatRoomLastMsg.text = "Image"
                    
                } else {
                    let lastMessageText = chatInviteData?.last_message?[UserModel.shared.user.id] ?? ""
                    let index = lastMessageText.index(lastMessageText.startIndex, offsetBy:lastMessageText.count >= 15 ? 15 : lastMessageText.count)
                    let substring = lastMessageText.substring(to:index)
                    chatRoomLastMsg.text = substring + (substring.count >= 15 ? "..." : "")
                    setupLastDateTime(time: chatInviteData?.last_message_time ?? 0)
                }
            }
            
            let unreadCount = chatInviteData?.unread_count?[UserModel.shared.user.id] ?? 0
            self.unReadCountView.isHidden = unreadCount > 0 ? false : true
            self.unReadCount.text = "\(unreadCount)"
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
               // lastDateTime.text = "Today, \(dateStringgg)"
                lastDateTime.text = "\(dateStringgg)"

            } else {
                lastDateTime.text = dateString
            }
        } else {
            lastDateTime.text = ""
        }
    }

    @IBAction func declineAction(_ sender: UIButton) {
        var otherUserKey = ""
        for (key, _) in chatInviteData?.user_id ?? [:] {
            if key != UserModel.shared.user.id { //Other User
                otherUserKey = key
                break
            }
        }
        self.rejectPressed?(otherUserKey)
    }
    
    @IBAction func acceptAction(_ sender: UIButton) {
        var otherUserKey = ""
        for (key, _) in chatInviteData?.user_id ?? [:] {
            if key != UserModel.shared.user.id { //Other User
                otherUserKey = key
                break
            }
        }
        self.acceptPressed?(otherUserKey)
    }
}
