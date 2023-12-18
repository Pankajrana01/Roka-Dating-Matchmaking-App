//
//  LeftChatTextReplyCell.swift
//  Roka
//
//  Created by ios on 06/12/22.
//

import UIKit

class LeftChatTextReplyCell: UITableViewCell {

    @IBOutlet weak var senderName: UILabel!

    @IBOutlet weak var mainBubbleView: UIView!
    @IBOutlet weak var innerBubbleView: UIView!
    @IBOutlet weak var lblReply: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lblReplyImage: UIImageView!
    @IBOutlet weak var lblReplyImageWidth: NSLayoutConstraint!
    
    var cellTapped:(() -> Void)?

    static let identifier = "LeftChatTextReplyCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUpUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    private func setUpUI() {
        DispatchQueue.main.async {
            self.mainBubbleView.roundCorners(radius: 10, corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner])
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.scrollToOriginal))
            self.mainBubbleView.addGestureRecognizer(gesture)
        }
    }
    
    var replyMessageData: (MessageModel?, ChatRoomModel?) {
        didSet {
            let messageModel = replyMessageData.0
            let chatRoom = replyMessageData.1
            
            if chatRoom?.dialog_type == 1 { // one to one chat
                senderName.isHidden = true
            } else {
                senderName.isHidden = false
                if let sender_id = messageModel?.sender_id {
                    senderName.text = sender_id == UserModel.shared.user.id ? "You" : chatRoom?.user_name?[sender_id] ?? "Removed User"
                }
            }
            
            if let replyId = messageModel?.reply_id, !replyId.isEmpty {
                if let name = chatRoom?.user_name?[replyId] {
                    self.lblName.text = name
                }
                if messageModel?.reply_type == 2 {
                    // if reply to message is image
                    self.lblReply.text = "Image"
                    lblReplyImageWidth.constant = 40.0
                    messageModel?.reply_msg == "" ? lblReplyImage.image =  UIImage(named: "Img_Profile 2") : lblReplyImage.sd_setImage(with: URL(string: KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + (messageModel?.reply_msg ?? "")), placeholderImage: UIImage(named: "Img_Profile 2"), completed:nil)
                    
                } else {
                    self.lblReply.text = messageModel?.reply_type == 4 ? "Profile Shared" : messageModel?.reply_msg
                    lblReplyImageWidth.constant = 0.0
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
    
    @objc func scrollToOriginal() {
        cellTapped?()
    }
}
