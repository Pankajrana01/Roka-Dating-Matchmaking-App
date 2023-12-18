//
//  LeftGiftCell.swift
//  Roka
//
//  Created by Applify  on 06/01/23.
//

import UIKit

class LeftGiftCell: UITableViewCell {

    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var viewMessageBubble: UIView!
    
    static let identifier = "LeftGiftCell"

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
        if let sender_id = messageModel?.sender_id {
            lblMessage.text = "\(chatRoomModel?.user_name?[sender_id] ?? "User") has sent a gift for you. Now you can chat for seven days"
        }
                                    
        let date = Date(timeIntervalSince1970: TimeInterval((messageModel?.message_time ?? 0) / 1000))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "hh:mm a"
        let dateString = dayTimePeriodFormatter.string(from: date)
        lblTime.text = dateString
    }
}

    
    
