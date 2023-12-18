//
//  LeftChatShareCell.swift
//  Roka
//
//  Created by Applify  on 26/12/22.
//

import UIKit

class LeftChatShareCell: UITableViewCell {

    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var thirdImage: UIImageView!
    @IBOutlet weak var fourthImage: UIImageView!
    @IBOutlet weak var labelCount: UILabel!
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var viewMessageBubble: UIView!
    
    @IBOutlet weak var stackViewOuterView: UIView!
    @IBOutlet weak var totalProileCountLbl: UILabel!


    var callBackAction: (() ->())?

    static let identifier = "LeftChatShareCell"

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
        let separated = messageModel?.attachment_url?.split(separator: ",").map { String($0) }
        if separated?.count ?? 0 > 0 {
            setupProfileImages(profiles: separated ?? [])
        }
//        if separated?.count == 1{
//        let nameSeparated = messageModel?.user_name?.split(separator: ",").map { String($0) }
//            self.totalProileCountLbl.text = nameSeparated?[0]
//        }
        
        if let sender_id = messageModel?.sender_id {
            lblMessage.text = "\(chatRoomModel?.user_name?[sender_id] ?? "User") has shared some dating profiles for you."
        }
                                                    
        let date = Date(timeIntervalSince1970: TimeInterval((messageModel?.message_time ?? 0) / 1000))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "hh:mm a"
        let dateString = dayTimePeriodFormatter.string(from: date)
        lblTime.text = dateString
    }
    
    @IBAction func openSharedProfiles(_ sender: UIButton) {
        callBackAction?()
    }
    
    func setupProfileImages(profiles: [String]) {
        switch profiles.count {
        case 1:
            self.firstImage.isHidden = false
            self.firstImage.sd_setImage(with: URL(string: KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + profiles[0]), placeholderImage: UIImage(named: "Img_Profile 2"), completed:nil)

            self.secondImage.isHidden = true
            self.thirdImage.isHidden = true
            self.fourthImage.isHidden = true
            self.labelCount.isHidden = true
            self.totalProileCountLbl.text = ""
            break
        case 2:
            self.firstImage.isHidden = false
            self.firstImage.sd_setImage(with: URL(string: KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + profiles[0]), placeholderImage: UIImage(named: "Img_Profile 2"), completed:nil)

            self.secondImage.isHidden = false
            self.secondImage.sd_setImage(with: URL(string: KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + profiles[1]), placeholderImage: UIImage(named: "Img_Profile 2"), completed:nil)

            self.thirdImage.isHidden = true
            self.fourthImage.isHidden = true
            self.labelCount.isHidden = true
            self.totalProileCountLbl.text = "\(profiles.count) Profiles"
            break
        case 3:
            self.firstImage.isHidden = false
            self.firstImage.sd_setImage(with: URL(string: KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + profiles[0]), placeholderImage: UIImage(named: "Img_Profile 2"), completed:nil)

            self.secondImage.isHidden = false
            self.secondImage.sd_setImage(with: URL(string: KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + profiles[1]), placeholderImage: UIImage(named: "Img_Profile 2"), completed:nil)
            
            self.thirdImage.isHidden = false
            self.thirdImage.sd_setImage(with: URL(string: KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + profiles[2]), placeholderImage: UIImage(named: "Img_Profile 2"), completed:nil)

            self.fourthImage.isHidden = true
            self.labelCount.isHidden = true
            self.totalProileCountLbl.text = "\(profiles.count) Profiles"
            break
        case 4:
            self.firstImage.isHidden = false
            self.firstImage.sd_setImage(with: URL(string: KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + profiles[0]), placeholderImage: UIImage(named: "Img_Profile 2"), completed:nil)

            self.secondImage.isHidden = false
            self.secondImage.sd_setImage(with: URL(string: KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + profiles[1]), placeholderImage: UIImage(named: "Img_Profile 2"), completed:nil)
            
            self.thirdImage.isHidden = false
            self.thirdImage.sd_setImage(with: URL(string: KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + profiles[2]), placeholderImage: UIImage(named: "Img_Profile 2"), completed:nil)
            
            self.fourthImage.isHidden = false
            self.fourthImage.sd_setImage(with: URL(string: KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + profiles[3]), placeholderImage: UIImage(named: "Img_Profile 2"), completed:nil)
            
            self.labelCount.isHidden = true
            self.totalProileCountLbl.text = "\(profiles.count) Profiles"
            break
        default:
            self.firstImage.isHidden = false
            self.firstImage.sd_setImage(with: URL(string: KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + profiles[0]), placeholderImage: UIImage(named: "Img_Profile 2"), completed:nil)

            self.secondImage.isHidden = false
            self.secondImage.sd_setImage(with: URL(string: KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + profiles[1]), placeholderImage: UIImage(named: "Img_Profile 2"), completed:nil)
            
            self.thirdImage.isHidden = false
            self.thirdImage.sd_setImage(with: URL(string: KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + profiles[2]), placeholderImage: UIImage(named: "Img_Profile 2"), completed:nil)
            
            self.fourthImage.isHidden = false
            self.fourthImage.sd_setImage(with: URL(string: KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + profiles[3]), placeholderImage: UIImage(named: "Img_Profile 2"), completed:nil)
            
            self.labelCount.isHidden = false
            self.labelCount.text = "\(profiles.count - 4)"
            self.totalProileCountLbl.text = "\(profiles.count) Profiles"
            break
        }
    }

}
