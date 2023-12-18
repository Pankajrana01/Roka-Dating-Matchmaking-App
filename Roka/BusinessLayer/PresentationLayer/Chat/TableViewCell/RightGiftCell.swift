//
//  RightGiftCell.swift
//  Roka
//
//  Created by Applify  on 06/01/23.
//

import UIKit

class RightGiftCell: UITableViewCell {

    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var viewMessageBubble: UIView!
    
    static let identifier = "RightGiftCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUpUI()
    }

    private func setUpUI() {
        DispatchQueue.main.async {
            self.viewMessageBubble.roundCorners(radius: 10, corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner])
        }
    }
    
    func setUpMessageData(messageModel: MessageModel?, chatRoomModel: ChatRoomModel?) {
        if chatRoomModel?.dialog_type == 1 { //One to one
            var otherUserKey = ""
            for (key, _) in chatRoomModel?.user_id ?? [:] {
                if key != UserModel.shared.user.id { //Other User
                    otherUserKey = key
                    break
                }
            }
            lblMessage.text = "Sent to \(chatRoomModel?.user_name?[otherUserKey] ?? "User")"
        }
                                 
        let date = Date(timeIntervalSince1970: TimeInterval((messageModel?.message_time ?? 0) / 1000))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "hh:mm a"
        let dateString = dayTimePeriodFormatter.string(from: date)
        lblTime.text = dateString
    }
}
