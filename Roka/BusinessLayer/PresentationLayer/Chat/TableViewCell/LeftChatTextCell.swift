//
//  LeftChatTextCell.swift
//  Roka
//
//  Created by ios on 06/12/22.
//

import UIKit

class LeftChatTextCell: UITableViewCell {

    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var viewMessageBubble: UIView!
    
    static let identifier = "LeftChatTextCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUpUI()
    }

    private func setUpUI() {
        DispatchQueue.main.async {
            self.viewMessageBubble.roundCorners(radius: 10, corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        }
    }
    
    func setUpMessageData(messageModel: MessageModel?, chatRoomModel: ChatRoomModel?) {
        if chatRoomModel?.dialog_type == 1 { // one to one chat
            senderName.isHidden = true
        } else {
            senderName.isHidden = false
            if let sender_id = messageModel?.sender_id {
                senderName.text = sender_id == UserModel.shared.user.id ? "You" : chatRoomModel?.user_name?[sender_id] ?? "Removed User"
            } 
        }
        
        lblMessage.text = messageModel?.message ?? ""
        
        let date = Date(timeIntervalSince1970: TimeInterval((messageModel?.message_time ?? 0) / 1000))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "hh:mm a"
        let dateString = dayTimePeriodFormatter.string(from: date)
        lblTime.text = dateString
    }
}
