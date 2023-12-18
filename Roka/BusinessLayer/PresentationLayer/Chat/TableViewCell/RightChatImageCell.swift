//
//  RightChatImageCell.swift
//  Roka
//
//  Created by ios on 06/12/22.
//

import UIKit
import SKPhotoBrowser

class RightChatImageCell: UITableViewCell {

    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgViewButton: UIButton!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var viewMessageBubble: UIView!


    static let identifier = "RightChatImageCell"
    
 //   var callBackForRightImageButton: ((_ leftImage:[LightboxImage], _ selectedIndex:Int) ->())?
    
    var callBackForRightImageButton: ((_ leftImage:[SKPhoto], _ selectedIndex:Int) ->())?

    
    var rightImage = [LightboxImage]()
    
    var rightFullImage = [SKPhoto]()


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
    
    func setUpImageData(messageModel: MessageModel?, chatRoomModel: ChatRoomModel?) {
        if chatRoomModel?.dialog_type == 1 { // one to one chat
            senderName.isHidden = true
        } else {
            senderName.isHidden = false
            if let sender_id = messageModel?.sender_id {
                senderName.text = chatRoomModel?.user_name?[sender_id] ?? "Removed User"
            }
        }
        
        if chatRoomModel?.dialog_type == 1 { // one to one chat
            senderName.isHidden = true
        } else {
            senderName.isHidden = false
            if let sender_id = messageModel?.sender_id {
                senderName.text = sender_id == UserModel.shared.user.id ? "You" : chatRoomModel?.user_name?[sender_id] ?? "Removed User"
            }
        }
        
        messageModel?.attachment_url == "" ? imgView.image =  UIImage(named: "Img_Profile 2") : imgView.sd_setImage(with: URL(string: KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + (messageModel?.attachment_url ?? "")), placeholderImage: UIImage(named: "Img_Profile 2"), completed:nil)

        if messageModel?.attachment_url != "" {
            self.rightFullImage.removeAll()
            let photos = SKPhoto.photoWithImageURL(KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + (messageModel?.attachment_url ?? ""))
            photos.shouldCachePhotoURLImage = false
            rightFullImage.append(photos)

                    
         //   self.rightImage.removeAll()
         //   self.rightImage.append(LightboxImage(imageURL: URL(string: KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + (messageModel?.attachment_url ?? ""))!, text: ""))
        }

        let date = Date(timeIntervalSince1970: TimeInterval((messageModel?.message_time ?? 0) / 1000))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "hh:mm a"
        let dateString = dayTimePeriodFormatter.string(from: date)
        lblTime.text = dateString
    }
    
    @IBAction func rightImageButtonTapped(_ sender: UIButton) {
        callBackForRightImageButton?(self.rightFullImage, sender.tag)
    }
}
