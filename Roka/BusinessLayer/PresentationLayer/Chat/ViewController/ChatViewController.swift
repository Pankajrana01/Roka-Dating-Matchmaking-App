//
//  ChatViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 14/10/22.
//

import UIKit
import AVFoundation
import FirebaseDatabase
import IQKeyboardManagerSwift
import SKPhotoBrowser

class ChatViewController: BaseViewController {
    
    @IBOutlet weak var moreBtn: UIBarButtonItem!

    @IBOutlet weak var backBtn: UIBarButtonItem!
    // MARK: - OutLets
    @IBOutlet weak var chatInfoView: UIView!
    @IBOutlet weak var chatRoomImage: UIImageView!
    @IBOutlet weak var chatRoomName: UILabel!
    
    @IBOutlet weak var tblVwMessages: UITableView!
    @IBOutlet weak var replyViewHgt: NSLayoutConstraint!
    @IBOutlet weak var replyName: UILabel!
    @IBOutlet weak var replyMessage: UILabel!
    @IBOutlet weak var replyMediaImage: UIImageView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var cannotMsgLbl: UILabel!
    @IBOutlet weak var acceptDeclineView: UIStackView!
    @IBOutlet weak var blurView: UIView!

    @IBOutlet weak var messageViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var groupDetailView: UIView!
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var thirdImage: UIImageView!
    @IBOutlet weak var fourthImage: UIImageView!
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var groupNamesMsg: UILabel!
    
    @IBOutlet weak var blurViewStaticInfoLbl: UILabel!

    @IBOutlet weak var topStaticLabel: UILabel!
    
    @IBOutlet weak var bloackUserStaicView: UIView!
    
    @IBOutlet weak var upgradeToPreminumNewView: UIView!
    @IBOutlet weak var upgradeNewPreminumNewStaticLbl: UILabel!

    @IBOutlet weak var whenMessageLimitFinishNeedToShowUpgradePreminumView: UIView!
    @IBOutlet weak var upgradeNewPreminumUserNameNewLbl: UILabel!



    
    // MARK: - Variables
    lazy var viewModel: ChatViewModel? = ChatViewModel(hostViewController: self)
    var sendButton: UIButton?
    var blockStatus = 0
    var blurPopupShown = false
    var oldKeyboardHeight :CGFloat = 0.0

    var fullViewImage = [LightboxImage]()
    
    var fullImages = [SKPhoto]()
    
    // MARK: - ViewLifeCycle
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.chat
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.chat
    }
    
    
    override func getViewModel() -> BaseViewModel {
        return viewModel!
    }
    
    class func show(from viewController: UIViewController,
                    isChatUserExist: Bool = true,
                    forcePresent: Bool = false,
                    chatRoom: ChatRoomModel) {
        let controller = self.getController() as! ChatViewController
        controller.hidesBottomBarWhenPushed = true
        controller.viewModel?.chatRoom = chatRoom
        controller.viewModel?.isChatUserExist = isChatUserExist
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    class func getController(with isCome: String,
                             chatRoom: ChatRoomModel) -> BaseViewController {
        let controller = self.getController() as! ChatViewController
        controller.viewModel?.chatRoom = chatRoom
        controller.viewModel?.isCome = isCome
        controller.hidesBottomBarWhenPushed = true
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SKPhotoBrowserOptions.displayAction = false
        self.upgradeToPreminumNewView.isHidden = true
        self.whenMessageLimitFinishNeedToShowUpgradePreminumView.isHidden = true
        // Do any additional setup after loading the view.
       // self.navigationController?.isNavigationBarHidden = false
        self.setUpUI()
        if viewModel?.chatRoom?.dialog_status?[UserModel.shared.user.id] == 4 {
            acceptDeclineView.isHidden = false
            self.messageView.isHidden = true
            self.cannotMsgLbl.isHidden = true
        } else {
            acceptDeclineView.isHidden = true
            self.messageView.isHidden = false
            self.cannotMsgLbl.isHidden = true
        }
        self.blurView.isHidden = true
        
        let leftIconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 50 , height: 40))
        let attachmentButton = UIButton.init(frame: CGRect(x: 5, y: 0, width: 34, height: 34))
        attachmentButton.backgroundColor = .black
        attachmentButton.cornerRadius = 17
        attachmentButton.setImage(UIImage.init(named: "new_add_Chat_Img"), for: .normal)
        attachmentButton.titleLabel?.font =  .systemFont(ofSize: 25.0, weight: .semibold)
        attachmentButton.addTarget(self, action: #selector(addAttachmentAction), for: .touchUpInside)
        leftIconContainer.addSubview(attachmentButton)
        messageTextField.leftView = leftIconContainer
        messageTextField.leftViewMode = .always
        
        let rightIconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        sendButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        sendButton?.setImage(UIImage.init(named: "send"), for: .normal)
        sendButton?.addTarget(self, action: #selector(sendAction), for: .touchUpInside)
        sendButton?.alpha = 0.5
        rightIconContainer.addSubview(sendButton!)
        messageTextField.rightView = rightIconContainer
        messageTextField.rightViewMode = .always
        messageTextField.delegate = self
        replyViewHgt.constant = 0.0
                
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        tblVwMessages.addGestureRecognizer(longPress)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(openChatDetailAction))
        chatInfoView.addGestureRecognizer(gesture)
        
        FirestoreManager.updateUnReadCount(chatRoom: viewModel?.chatRoom)
        loadLocalData()
        
        self.viewModel?.observeIfChatRoomRemoved {
            DispatchQueue.main.async {
                if self.viewModel?.chatRoom?.dialog_status?[UserModel.shared.user.id] != 4 {
                    self.callBackForPopViewController()
                }
            }
        }
        
        self.viewModel?.observeIfChatRoomChanged(handler: { model in
            DispatchQueue.main.async {
                let userNotExists = self.viewModel?.chatRoom?.user_id?[UserModel.shared.user.id] == nil
                if userNotExists { //In case user exit/removed from group
                    self.callBackForPopViewController()

                } else if self.viewModel?.chatRoom?.dialog_status?[UserModel.shared.user.id] != 4 {
                    if model?.dialog_type == 1 {
                        if self.viewModel?.otherUserId != "" && (model?.block_status?[self.viewModel?.otherUserId ?? ""] ?? 0 == 1 || model?.block_status?[UserModel.shared.user.id] ?? 0 == 1) {
                            self.messageView.isHidden = true
                            self.cannotMsgLbl.isHidden = false
                        } else {
                            self.messageView.isHidden = false
                            self.cannotMsgLbl.isHidden = true
                        }
                    } else {
                        let pic = self.viewModel?.chatRoom?.pic ?? "dp"
                        pic == "dp" ? self.chatRoomImage.image = #imageLiteral(resourceName: "ic_group") : self.chatRoomImage.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + pic)), placeholderImage: #imageLiteral(resourceName: "ic_group"), completed: nil)
                        self.chatRoomName.text = self.viewModel?.chatRoom?.name
                    }
                }
            }
        })
        
        if self.viewModel?.chatRoom?.message_sent?[UserModel.shared.user.id] == 1 && self.viewModel?.chatRoom?.message_sent?[self.viewModel?.otherUserId ?? ""] == 1 && self.viewModel?.chatRoom?.premium_status?[UserModel.shared.user.id] == 0 && !(self.viewModel?.checkIfGiftKeyValid() ?? false) {
                //If the user is a Freemium Member and no gift key available, Both users messaged and last message is from other user -> Show Blur effect
            self.blurView.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupData()
        self.upgradeNewPreminumUserNameNewLbl.text = "Hi \(UserModel.shared.user.firstName)"
        self.blurViewStaticInfoLbl.text = "Hi \(UserModel.shared.user.firstName), \(self.chatRoomName.text ?? "") messaging limit has been reached.Please get a Spark gift for her so that you may both continue your messaging."
        
        self.navigationController?.isNavigationBarHidden = false
        IQKeyboardManager.shared.enable = false
        registerKeyboardNotification()
        
        if GlobalVariables.shared.selectedProfileMode == "MatchMaking" {
            self.chatRoomName.textColor = .black
            backBtn.image = UIImage (named: "Ic_back_1")
            moreBtn.image = UIImage (named: "new_Three_Dots_Img")
            moreBtn.tintColor = .black
            self.topStaticLabel.backgroundColor = UIColor.loginBlueColor
        }else{
            self.chatRoomName.textColor = .white
            backBtn.image = UIImage (named: "ic_back_white")
            moreBtn.image = UIImage (named: "Ic_three_dots")
            moreBtn.tintColor = .white
            self.topStaticLabel.backgroundColor = UIColor.appTitleBlueColor
        }

    }
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupData(){
        if viewModel?.chatRoom?.dialog_type == 1 { //One to one
            viewModel?.fetchOtherUserId()
            
            if viewModel?.otherUserId != "" {
                let pic = viewModel?.chatRoom?.user_pic?[viewModel?.otherUserId ?? ""] ?? ""
                self.chatRoomImage.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + pic)), placeholderImage: #imageLiteral(resourceName: "Avatar"), completed: nil)
                
                self.chatRoomName.text = UserModel.shared.user.id == viewModel?.chatRoom?.dialog_admin ? viewModel?.chatRoom?.user_name?[viewModel?.otherUserId ?? ""] ?? "" : viewModel?.chatRoom?.user_number?[viewModel?.otherUserId ?? ""] ?? ""
                blockStatus = viewModel?.chatRoom?.block_status?[UserModel.shared.user.id] ?? 0
                
                if (viewModel?.chatRoom?.dialog_status?[UserModel.shared.user.id] != 4 && viewModel?.chatRoom?.block_status?[viewModel?.otherUserId ?? ""] ?? 0 == 1 || viewModel?.chatRoom?.block_status?[UserModel.shared.user.id] ?? 0 == 1){ //One to One chat
                    self.messageView.isHidden = true
                    self.cannotMsgLbl.isHidden = false
                  //  self.upgradeToPreminumNewView.isHidden = false

                }
            }
            groupDetailView.isHidden = true
            
            if let bloackS  = self.blockStatus == 0 ? true : false{
                self.bloackUserStaicView.isHidden = bloackS
            }
            
        } else { //Group Chat
            let pic = viewModel?.chatRoom?.pic ?? "dp"
            pic == "dp" ? self.chatRoomImage.image = #imageLiteral(resourceName: "ic_group") : self.chatRoomImage.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + pic)), placeholderImage: #imageLiteral(resourceName: "ic_group"), completed: nil)
            self.chatRoomName.text = viewModel?.chatRoom?.name
            
            if (viewModel?.chatRoom?.last_message_id == "") {
                groupDetailView.isHidden = false
                var members: [MemberModel] = []
                for (key, value) in viewModel?.chatRoom?.user_name ?? [:] {
                    let img = viewModel?.chatRoom?.user_pic?[key] ?? "dp"
                    let name = UserModel.shared.user.id == viewModel?.chatRoom?.dialog_admin ? value : viewModel?.chatRoom?.user_number?[key] ?? ""
                    members.append(MemberModel.init(memberId: key, name: name, img: img))
                }
                members = members.sorted(by: { $0.name < $1.name })
                if let itemIndex = members.firstIndex(where: {$0.memberId == viewModel?.chatRoom?.dialog_admin}) {
                    members = viewModel?.rearrange(array: members , fromIndex: itemIndex, toIndex: 0) ?? []
                }
                groupNamesMsg.text = members.count > 2 ? "\(members[0].name), \(members[1].name) and \(members.count - 2) more" : "\(members[0].name)"
                setupGroupProfileImages(members: members)
            } else {
                groupDetailView.isHidden = true
            }
        }
    }
    
    func registerKeyboardNotification(){
      //  NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrames), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
      //  NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrames), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        
    }
    
    @objc func keyboardWillShow(notification: Notification) {
    
        guard let userInfo = (notification as Notification).userInfo, let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let newHeight: CGFloat
        if #available(iOS 11.0, *) {
            newHeight = value.cgRectValue.height - view.safeAreaInsets.bottom
        } else {
            newHeight = value.cgRectValue.height
        }
        messageViewBottom.constant = newHeight
        
        if self.viewModel?.groupedByDate.count ?? 0 > 0 {
            let index = IndexPath(row: (self.viewModel?.groupedByDate[self.viewModel?.sectionHeaders.last ?? "Today"]?.count ?? 1) - 1, section: (self.viewModel?.sectionHeaders.count ?? 1 ) - 1)
            self.tblVwMessages.scrollToRow(at: index, at: .bottom, animated: false )
        }
    }
    @objc func keyboardWillHide(notification: Notification) {
        
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            messageViewBottom.constant = 10
        }
    }

    
    @objc func keyboardWillChangeFrames(_ notification: Notification) {
        DispatchQueue.main.async {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                let insets = UIEdgeInsets( top: 0, left: 0, bottom: keyboardHeight, right: 0 )
                
                self.tblVwMessages.contentInset = insets
                self.tblVwMessages.scrollIndicatorInsets = insets
                
                let window = KAPPDELEGATE.window
                let topPadding = window?.safeAreaInsets.top
                let bottomPadding = window?.safeAreaInsets.bottom
                print(topPadding as Any, bottomPadding as Any)
                
                if notification.name == UIResponder.keyboardWillHideNotification {
                    self.messageViewBottom.constant = 15
                } else {
                    self.messageViewBottom.constant = keyboardHeight + 5 - (bottomPadding ?? 0)
                }
                
                let difference = keyboardHeight - self.oldKeyboardHeight
                if difference > 0 {
                    self.tblVwMessages.contentOffset = CGPoint.init(x: 0, y: self.tblVwMessages.contentOffset.y + difference)
                }
                self.oldKeyboardHeight = keyboardHeight
                
                let durationValue = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]
                let curveValue = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey]
                let duration = (durationValue as AnyObject).doubleValue
                let options = UIView.AnimationOptions(rawValue: UInt((curveValue as AnyObject).integerValue << 16))
                UIView.animate(withDuration: duration!, delay: 0, options: options, animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    // MARK: - SetUp UI
    func setUpUI() {
        let leftChatTextNib = UINib(nibName: LeftChatTextCell.identifier, bundle: nil)
        let rightChatTextNib = UINib(nibName: RightChatTextCellCell.identifier, bundle: nil)
        let leftChatImageNib = UINib(nibName: LeftChatImageCell.identifier, bundle: nil)
        let rightChatImageNib = UINib(nibName: RightChatImageCell.identifier, bundle: nil)
        let leftChatTextReplyNib = UINib(nibName: LeftChatTextReplyCell.identifier, bundle: nil)
        let rightChatTextReplyNib = UINib(nibName: RightChatTextReplyCell.identifier, bundle: nil)
        let LeftChatImageReplyNib = UINib(nibName: LeftChatImageReplyCell.identifier, bundle: nil)
        let RightChatImageReplyNib = UINib(nibName: RightChatImageReplyCell.identifier, bundle: nil)
        let LeftChatShareNib = UINib(nibName: LeftChatShareCell.identifier, bundle: nil)
        let RightChatShareNib = UINib(nibName: RightChatShareCell.identifier, bundle: nil)
        let LeftGiftNib = UINib(nibName: LeftGiftCell.identifier, bundle: nil)
        let RightGiftNib = UINib(nibName: RightGiftCell.identifier, bundle: nil)
        
        
        self.tblVwMessages.register(leftChatTextNib, forCellReuseIdentifier: LeftChatTextCell.identifier)
        self.tblVwMessages.register(rightChatTextNib, forCellReuseIdentifier: RightChatTextCellCell.identifier)
        self.tblVwMessages.register(leftChatImageNib, forCellReuseIdentifier: LeftChatImageCell.identifier)
        self.tblVwMessages.register(rightChatImageNib, forCellReuseIdentifier: RightChatImageCell.identifier)
        self.tblVwMessages.register(leftChatTextReplyNib, forCellReuseIdentifier: LeftChatTextReplyCell.identifier)
        self.tblVwMessages.register(rightChatTextReplyNib, forCellReuseIdentifier: RightChatTextReplyCell.identifier)
        self.tblVwMessages.register(LeftChatImageReplyNib, forCellReuseIdentifier: LeftChatImageReplyCell.identifier)
        self.tblVwMessages.register(RightChatImageReplyNib, forCellReuseIdentifier: RightChatImageReplyCell.identifier)
        self.tblVwMessages.register(LeftChatShareNib, forCellReuseIdentifier: LeftChatShareCell.identifier)
        self.tblVwMessages.register(RightChatShareNib, forCellReuseIdentifier: RightChatShareCell.identifier)
        self.tblVwMessages.register(LeftGiftNib, forCellReuseIdentifier: LeftGiftCell.identifier)
        self.tblVwMessages.register(RightGiftNib, forCellReuseIdentifier: RightGiftCell.identifier)
    }
    
    func setupGroupProfileImages(members: [MemberModel]) {
        switch members.count {
        case 1:
            setImageForMember(imgView: self.firstImage, img: members[0].img)
            
            self.secondImage.isHidden = true
            self.thirdImage.isHidden = true
            self.fourthImage.isHidden = true
            self.labelCount.isHidden = true
            break
        case 2:
            setImageForMember(imgView: self.firstImage, img: members[0].img)
            setImageForMember(imgView: self.secondImage, img: members[1].img)

            self.thirdImage.isHidden = true
            self.fourthImage.isHidden = true
            self.labelCount.isHidden = true
            break
        case 3:
            setImageForMember(imgView: self.firstImage, img: members[0].img)
            setImageForMember(imgView: self.secondImage, img: members[1].img)
            setImageForMember(imgView: self.thirdImage, img: members[2].img)

            self.fourthImage.isHidden = true
            self.labelCount.isHidden = true
            break
        case 4:
            setImageForMember(imgView: self.firstImage, img: members[0].img)
            setImageForMember(imgView: self.secondImage, img: members[1].img)
            setImageForMember(imgView: self.thirdImage, img: members[2].img)
            setImageForMember(imgView: self.fourthImage, img: members[3].img)

            self.labelCount.isHidden = true
            break
        default:
            setImageForMember(imgView: self.firstImage, img: members[0].img)
            setImageForMember(imgView: self.secondImage, img: members[1].img)
            setImageForMember(imgView: self.thirdImage, img: members[2].img)
            setImageForMember(imgView: self.fourthImage, img: members[3].img)
            
            self.labelCount.isHidden = false
            self.labelCount.text = "+\(members.count - 4)"

            break
        }
    }

    func setImageForMember(imgView: UIImageView, img: String) {
        imgView.isHidden = false
        img == "dp" ? imgView.image =  UIImage(named: "Avatar") : imgView.sd_setImage(with: URL(string: KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + img), placeholderImage: UIImage(named: "Avatar"), completed:nil)
    }
    
    func loadLocalData() {
        self.viewModel?.fetchAllMessages(chat_dialog_id: viewModel?.chatRoom?.chat_dialog_id ?? "", handler: {
            DispatchQueue.main.async {
                self.tblVwMessages.reloadData()
                if self.viewModel?.groupedByDate.count ?? 0 > 0 {
                    let index = IndexPath(row: (self.viewModel?.groupedByDate[self.viewModel?.sectionHeaders.last ?? "Today"]?.count ?? 1) - 1, section: (self.viewModel?.sectionHeaders.count ?? 1 ) - 1)
                    self.tblVwMessages.scrollToRow(at: index, at: .bottom, animated: false )
                }
            }

            self.viewModel?.observeIfAnyMessageAdded (handler: {
                DispatchQueue.main.async {
                    if self.viewModel?.chatRoom?.message_sent?[UserModel.shared.user.id] == 1 && self.viewModel?.chatRoom?.message_sent?[self.viewModel?.otherUserId ?? ""] == 1 && self.viewModel?.chatRoom?.premium_status?[UserModel.shared.user.id] == 0 && !(self.viewModel?.checkIfGiftKeyValid() ?? false) && !self.blurPopupShown {
                            //If the user is a Freemium Member and no gift key available, Both users messaged and last message is from other user -> Show Blur effect
                        self.blurPopupShown = true
                        self.blurView.isHidden = false
                    }
                    
                    self.tblVwMessages.reloadData()

                    if self.tblVwMessages.contentOffset.y >= (self.tblVwMessages.contentSize.height - self.tblVwMessages.frame.size.height) - 400 {
                        /// you reached the end of the table
                        let index = IndexPath(row: (self.viewModel?.groupedByDate[self.viewModel?.sectionHeaders.last ?? "Today"]?.count ?? 1) - 1, section: (self.viewModel?.sectionHeaders.count ?? 1 ) - 1)

                        self.tblVwMessages.scrollToRow(at: index, at: .bottom, animated: true )
                    }
                }
            })
        })
        
        self.viewModel?.fetchCurrentUser()
    }
    
    // MARK: - Button Actions
    @IBAction func backButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        if viewModel?.isChatUserExist == false{
            if viewModel?.groupedByDate.count == 0{
              //  FirestoreManager.deleteChatOnFirebase(chatRoom: (viewModel?.chatRoom)!)
            }
        }
        callBackForPopViewController()
    }
    @IBAction func removeMessgaeLimitViewAction(_ sender: Any) {
        self.whenMessageLimitFinishNeedToShowUpgradePreminumView.isHidden = true
    }
    func callBackForPopViewController() {
        Database.database().reference().child("Messages").child(viewModel?.chatRoom?.chat_dialog_id ?? "").queryOrdered(byChild: "message_time").removeAllObservers()
//        viewModel = nil

        if viewModel?.isCome == "PROFILE_MATCHED" || self.viewModel?.isCome == "CHAT_NOTIFICATION"{
            viewModel?.proceedForChatPager()
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func openChatUserFullImageView(_ sender: UIButton) {
        self.view.endEditing(true)
        if viewModel?.chatRoom?.dialog_type == 2 {
            let pic = viewModel?.chatRoom?.pic ?? "dp"
            if pic != "dp" {
                self.fullViewImage.removeAll()
                self.fullImages.removeAll()
                let photos = SKPhoto.photoWithImageURL(KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + pic)
                photos.shouldCachePhotoURLImage = false
                fullImages.append(photos)
                let browser = SKPhotoBrowser(photos: fullImages)
                browser.initializePageIndex(0)
                present(browser, animated: true, completion: {})
//                self.fullViewImage.append(LightboxImage(imageURL: URL(string: KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + pic)!, text: ""))
//                self.viewModel?.openPreviewController(images: self.fullViewImage, selectedIndex: 0)
            }
        } else { //One to one
            let pic = viewModel?.chatRoom?.user_pic?[viewModel?.otherUserId ?? ""] ?? "dp"
            if viewModel?.otherUserId != "" && pic != "dp" {
                self.fullViewImage.removeAll()
                self.fullImages.removeAll()
                let photos = SKPhoto.photoWithImageURL(KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + pic)
                photos.shouldCachePhotoURLImage = false
                fullImages.append(photos)
                let browser = SKPhotoBrowser(photos: fullImages)
                browser.initializePageIndex(0)
                present(browser, animated: true, completion: {})
                
//
//                self.fullViewImage.append(LightboxImage(imageURL: URL(string: KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + pic)!, text: ""))
//                self.viewModel?.openPreviewController(images: self.fullViewImage, selectedIndex: 0)
            }
        }
    }
    
    @IBAction func openChatDetailAction(_ sender: Any) {
        self.view.endEditing(true)
        if viewModel?.chatRoom?.dialog_type == 2 {
            GroupDetailViewController.show(from: self, forcePresent: false, isComeFor: "", chatRoom: (viewModel?.chatRoom)!) { success in
            }
        } else { //One to one
            let pic = viewModel?.chatRoom?.user_pic?[viewModel?.otherUserId ?? ""] ?? "dp"
            if viewModel?.otherUserId != "" && pic != "dp" {
                viewModel?.getProfile() { profile in
                    
                    PageFullViewVC.show(from: self, forcePresent: false, forceBackToHome: false, isFrom: "", isComeFor: "home", selectedProfile: profile!, allProfiles: [profile!], selectedIndex: 0) { success in
                        
                    }
//                    FullViewDetailViewController.show(from: self, forcePresent: false, isComeFor: "home", selectedProfile: profile!, allProfiles: [profile!], selectedIndex: 0) { success in
//                    }
                }
            }
        }
    }
    
    @IBAction func moreBtnAction(_ sender: Any) {
        self.view.endEditing(true)
        viewModel?.chatRoom?.dialog_type == 1 ? openMorePopupForOneToOne() : openMorePopupForGroup()
    }
    
    @objc func addAttachmentAction(sender: UIButton) {
        self.view.endEditing(true)
        let status = viewModel?.checkForLimitToSendChatMessage(messageCount: 50)
        if status == 1 {
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
                self.chooseAttachment(type: "Camera")
            }))
            
            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { action in
                self.chooseAttachment(type: "Gallery")
            }))
            
            
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
            self.present(alert, animated: true, completion: nil)
        }
        else if status == 2 {
            //message limit will reach with this sending message
            var message_length = 0
            var member = ""

            if viewModel?.chatRoom?.premium_status?[UserModel.shared.user.id] == 0 && !(viewModel?.checkIfGiftKeyValid() ?? false) {
                //If the user is a Freemium Member and no gift key available
                message_length = viewModel?.chatRoom?.dialog_status?[UserModel.shared.user.id] == 2 ? 150 : 100
                member = "freemium"

            } else {
                //If the user is a premium
                message_length = viewModel?.chatRoom?.dialog_status?[UserModel.shared.user.id] == 2 ? 250 : 150
                member = "premium"
            }
            let sent_message_length = viewModel?.chatRoom?.message_length?[UserModel.shared.user.id] ?? 0
                        
            let alert = UIAlertController(title: "ROKA", message: "You can only send \(message_length) characters as \(member) member and after the sent messages you have only left with \(message_length - sent_message_length). Shared image consumed 50 characters. Please change your message accordingly.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in }))
            
            
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
            self.present(alert, animated: true, completion: nil)
        }
        else if status == 3 {
            //show premium popup
            let otherUserName = UserModel.shared.user.id == viewModel?.chatRoom?.dialog_admin ? viewModel?.chatRoom?.user_name?[viewModel?.otherUserId ?? ""] ?? "" : viewModel?.chatRoom?.user_number?[viewModel?.otherUserId ?? ""] ?? ""
//            GiftKeyPopupController.show(over: self, isCome: "upgradeToPremiumPopup", otherUserName: otherUserName ) { success in
//                self.handlePremiumUpgrade()
//            }
            self.upgradeToPreminumNewView.isHidden = false
            self.upgradeNewPreminumNewStaticLbl.text = "Hi \(UserModel.shared.user.firstName), \(otherUserName) messaging limit has been reached. Please get a Spark gift for \(otherUserName) so that you may both continue your messaging."

        }
//        else if status == 4 || status == 5 {
//            let message = status == 4 ? "You have exhausted your messaging limit for the day, chat again tomorrow." : "You can only message to 5 people today, chat again tomorrow."
//            let alert = UIAlertController(title: "ROKA", message: message, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in }))
//            self.present(alert, animated: true, completion: nil)
//        }
        else if status == 5 {
            let message = "You can only message to 5 people today, chat again tomorrow."
            let alert = UIAlertController(title: "ROKA", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in }))
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            self.present(alert, animated: true, completion: nil)
        }else if status == 4{
            self.whenMessageLimitFinishNeedToShowUpgradePreminumView.isHidden = false
        }
    }
    
    func chooseAttachment(type: String) {
        if type == "Camera" {
            self.viewModel?.checkForCamera { action in
                if action == .cameraSuccess {
                    self.openCameraGallery(type: "Camera")
                } else if action == .permissionError {
                    self.showAlertOfPermissionsNotAvailable()
                } else {
                    //cameraNotFound
                    let alertController: UIAlertController = UIAlertController(title: "Error", message: "Device has no camera.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (_) -> Void in
                    }
                    alertController.addAction(okAction)
                    if let popoverController = alertController.popoverPresentationController {
                        popoverController.sourceView = self.view
                        popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                        popoverController.permittedArrowDirections = []
                    }
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        } else {
            //Gallery
            self.viewModel?.checkForGalleryAction { action in
                if action == .gallerySuccess {
                    self.openCameraGallery(type: "Gallery")
                } else {
                    self.showAlertOfPermissionsNotAvailable()
                }
            }
        }
    }
    
    @objc func longPress(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: tblVwMessages)
            if let indexpath = tblVwMessages.indexPathForRow(at: touchPoint) {
                
                // your code here, get the row for the indexPath or do whatever you want
                let messages = self.viewModel?.groupedByDate[self.viewModel?.sectionHeaders[indexpath.section] ?? "Today"]
                let model = messages?[indexpath.row]
                
                self.replyViewHgt.constant = 50.0
                viewModel?.replyMessageModel = model
                if let name = viewModel?.chatRoom?.user_name?[(model?.sender_id)!] {
                    self.replyName.text = name
                }
                
                self.replyMessage.text = model?.message_type == 4 ? "Profile Shared" : model?.message_type == 2 ? "Image" : model?.message
                if model?.message_type == 2 {
                    self.replyMediaImage.isHidden = false
                    replyMediaImage.sd_setImage(with: URL(string: KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + (model?.attachment_url ?? "")), placeholderImage: UIImage(named: "Avatar"), completed:nil)
                    
                } else { // Hide media image
                    self.replyMediaImage.isHidden = true
                }
            }
        }
    }

    @objc func sendAction(sender: UIButton) {
      //  self.view.endEditing(true)
        if(!(messageTextField.text ?? "").trimmed.isEmpty) {
            
            let status = viewModel?.checkForLimitToSendChatMessage(messageCount: messageTextField.text?.count ?? 0)
            if status == 1 {
                
                if let (hasUrl, _) = viewModel?.urlExists(messageTextField.text ?? "") {
                    sendMessageToServer(message: messageTextField.text!, uploadUrl: "", message_type: hasUrl ? 3 : 1)
                }
            }
            else if status == 2 {
                //message limit will reach with this sending message
                var message_length = 0
                var member = ""

                if viewModel?.chatRoom?.premium_status?[UserModel.shared.user.id] == 0 && !(viewModel?.checkIfGiftKeyValid() ?? false) {
                    //If the user is a Freemium Member and no gift key available
                    message_length = viewModel?.chatRoom?.dialog_status?[UserModel.shared.user.id] == 2 ? 150 : 100
                    member = "freemium"

                } else {
                    //If the user is a premium
                    message_length = viewModel?.chatRoom?.dialog_status?[UserModel.shared.user.id] == 2 ? 250 : 150
                    member = "premium"
                }
                let sent_message_length = viewModel?.chatRoom?.message_length?[UserModel.shared.user.id] ?? 0
                            
                let alert = UIAlertController(title: "ROKA", message: "You can only send \(message_length) characters as \(member) member and after the sent messages you have only left with \(message_length - sent_message_length). Please change your message accordingly.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in }))
                
                if let popoverController = alert.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    popoverController.permittedArrowDirections = []
                }
                self.present(alert, animated: true, completion: nil)
            }
            else if status == 3 {
                //show premium popup
                self.view.endEditing(true)
                let otherUserName = UserModel.shared.user.id == viewModel?.chatRoom?.dialog_admin ? viewModel?.chatRoom?.user_name?[viewModel?.otherUserId ?? ""] ?? "" : viewModel?.chatRoom?.user_number?[viewModel?.otherUserId ?? ""] ?? ""
//                GiftKeyPopupController.show(over: self, isCome: "upgradeToPremiumPopup", otherUserName: otherUserName ) { success in
//                    self.handlePremiumUpgrade()
//                }
                self.upgradeToPreminumNewView.isHidden = false
                self.upgradeNewPreminumNewStaticLbl.text = "Hi \(UserModel.shared.user.firstName), \(otherUserName) messaging limit has been reached. Please get a Spark gift for \(otherUserName) so that you may both continue your messaging."
            }
            else if status == 5 {
                let message = "You can only message to 5 people today, chat again tomorrow."
                let alert = UIAlertController(title: "ROKA", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in }))
                if let popoverController = alert.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    popoverController.permittedArrowDirections = []
                }
                self.present(alert, animated: true, completion: nil)
            }else if status == 4{
                self.whenMessageLimitFinishNeedToShowUpgradePreminumView.isHidden = false
            }
            
            //clearing input field
            messageTextField.text = ""
        }
    }
    
    @IBAction func removeReplyViewAction(_ sender: UIButton) {
        removeReplyAction()
    }
    
    func removeReplyAction() {
        viewModel?.replyMessageModel = nil
        self.replyName.text = ""
        self.replyMessage.text = ""
        replyViewHgt.constant = 0.0
    }
    
    func sendMessageToServer(message: String, uploadUrl: String, message_type: Int) {
        groupDetailView.isHidden = true
        guard let date = viewModel?.readyTheMessageToSend(message: message, uploadUrl: uploadUrl, message_type: message_type) else { return }
        DispatchQueue.main.async {
            self.tblVwMessages.reloadData()
            let index = IndexPath(row: (self.viewModel?.groupedByDate[date]?.count ?? 1) - 1, section: (self.viewModel?.sectionHeaders.count ?? 1) - 1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.tblVwMessages.scrollToRow(at: index, at: .bottom, animated: true )
            }
            self.removeReplyAction()
        }
    }
    
    @IBAction func acceptAction(_ sender: Any) {
        if viewModel?.otherUserId != "" {
            self.viewModel?.processForLikeProfileData(isLiked: 1)
            self.callBackForPopViewController()
        }
    }
    
    @IBAction func rejectAction(_ sender: Any) {
        if viewModel?.otherUserId != "" {
            self.viewModel?.processForLikeProfileData(isLiked: 0)
            self.callBackForPopViewController()
        }
    }
    
    @IBAction func blurViewAction(_ sender: Any) {
        handlePremiumUpgrade()
    }
    
    @IBAction func tapToUnbloackAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Are you sure you want to \(self.blockStatus == 0 ? "block" : "unblock") this user?", message: "", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            // Code to handle "Yes" button action
            if self.viewModel?.otherUserId != "" {
                self.viewModel?.blockUnblockApi(status: self.blockStatus) { [self] res in
                    self.blockStatus = self.blockStatus == 0 ? 1 : 0
                    if let bloackS  = self.blockStatus == 0 ? true : false{
                        self.bloackUserStaicView.isHidden = bloackS
                    }
                    self.removeReplyAction()
                    FirestoreManager.blockUnblockUserOnFirebase(chat_dialog_id: viewModel?.chatRoom?.chat_dialog_id ?? "", param: [UserModel.shared.user.id: self.blockStatus])
                }
            }
        }
        let noAction = UIAlertAction(title: "No", style: .default) { (action) in
            // Code to handle "No" button action
            print("No button tapped")
        }
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func upgradeToPreminumNewAction(_ sender: Any) {
        self.handlePremiumUpgrade()
    }
    
    
    
    func handlePremiumUpgrade() {
        BuyPremiumViewController.show(from: self, forcePresent: false, isComeFor: "Profile") { success in
            self.viewModel?.chatRoom?.premium_status?[UserModel.shared.user.id] = 1
            self.blurView.isHidden = true
            self.blurPopupShown = false
        }
    }
    
    // MARK: - Open Popup
    func openMorePopupForOneToOne() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if self.viewModel?.chatRoom?.dialog_type == 1 && self.viewModel?.chatRoom?.premium_status?[UserModel.shared.user.id] == 1 && self.viewModel?.chatRoom?.premium_status?[viewModel?.otherUserId ?? ""] == 0 && self.viewModel?.chatRoom?.dialog_conversation == 0 && !(self.viewModel?.checkIfGiftKeyValid() ?? false) {
            //For one to one chat only, me - premium, other - fremium, no other gift key valid
            alert.addAction(UIAlertAction(title: "Send a gift card", style: .default, handler: { action in
                let otherUserName = UserModel.shared.user.id == self.viewModel?.chatRoom?.dialog_admin ? self.viewModel?.chatRoom?.user_name?[self.viewModel?.otherUserId ?? ""] ?? "" : self.viewModel?.chatRoom?.user_number?[self.viewModel?.otherUserId ?? ""] ?? ""
                GiftKeyPopupController.show(over: self, isCome: "sendGiftPopup", otherUserName: otherUserName) { success in
                    BuyGiftKeyController.show(from: self, forcePresent: false, chatRoom: (self.viewModel?.chatRoom)!) { status in
                        
                        self.sendMessageToServer(message: "Gift", uploadUrl: "", message_type: 5)
                        
                        let dateWithoutTime = (self.viewModel?.getDateWithoutTime(date: Date()))!
                        let gift_date = Int64(dateWithoutTime.timeIntervalSince1970 * 1000)
                        
                        self.viewModel?.chatRoom?.message_count?[self.viewModel?.otherUserId ?? ""] = 0
                        self.viewModel?.chatRoom?.message_length?[self.viewModel?.otherUserId ?? ""] = 0
                        self.viewModel?.chatRoom?.message_date?[self.viewModel?.otherUserId ?? ""] = gift_date
                        
                        FirestoreManager.updateGiftDateStatus(chatRoom: self.viewModel?.chatRoom, param: [UserModel.shared.user.id: gift_date, (self.viewModel?.otherUserId ?? ""): gift_date])

                        GiftKeyPopupController.show(over: self, isCome: "giftSuccessPopup", otherUserName: otherUserName) { success in
                        }
                    }
                }
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Clear chat history", style: .default, handler: { action in
            self.clearChatPrompt()
        }))
        
        alert.addAction(UIAlertAction(title: "Report", style: .default, handler: { action in
            if self.viewModel?.otherUserId != "" {
                ReportViewController.show(from: self, forcePresent: false, isComeFor: "Detail", id: self.viewModel?.otherUserId ?? "") { success in }
            }
        }))
        
        alert.addAction(UIAlertAction(title: blockStatus == 0 ? "Block" : "Unblock", style: .destructive, handler: { action in
            
            let alert = UIAlertController(title: "Are you sure you want to \(self.blockStatus == 0 ? "block" : "unblock") this user?", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
                if self.viewModel?.otherUserId != "" {
                    self.viewModel?.blockUnblockApi(status: self.blockStatus) { [self] res in
                        self.blockStatus = self.blockStatus == 0 ? 1 : 0
                        if let bloackS  = self.blockStatus == 0 ? true : false{
                            self.bloackUserStaicView.isHidden = bloackS
                        }
                        self.removeReplyAction()
                        FirestoreManager.blockUnblockUserOnFirebase(chat_dialog_id: viewModel?.chatRoom?.chat_dialog_id ?? "", param: [UserModel.shared.user.id: self.blockStatus])
                    }
                }
            }))
            
            alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { action in }))
            
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            self.present(alert, animated: true, completion: nil)
        }))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func openMorePopupForGroup() {
        let isAdmin = viewModel?.chatRoom?.dialog_admin == UserModel.shared.user.id
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Clear chat history", style: .default, handler: { action in
            self.clearChatPrompt()
        }))
        
        alert.addAction(UIAlertAction(title: isAdmin ? "Delete Group" : "Exit Group", style: .destructive, handler: { action in
            
            let alert = UIAlertController(title: "Are you sure you want to \(isAdmin ? "delete" : "exit") this group?", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
                if isAdmin {
                   //Delete This Group
                    FirestoreManager.deleteChatOnFirebase(chatRoom: (self.viewModel?.chatRoom)!)
                    self.callBackForPopViewController()

                } else {
                    //Exit this group
                    FirestoreManager.leaveGroup(group: (self.viewModel?.chatRoom)!, userId: UserModel.shared.user.id)
                    self.callBackForPopViewController()
                }
            }))
            
            alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { action in        }))
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            self.present(alert, animated: true, completion: nil)
        }))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func clearChatPrompt() {
        let alert = UIAlertController(title: "Are you sure you want to clear the chat history?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
            let messagesArr = self.viewModel?.groupedByDate.flatMap { $0.value }
            if let lastItemId = messagesArr?.last?.message_id {
                //Call Api and send last message id here
                self.viewModel?.clearChatApi(params: ["messageId": lastItemId]) { res in
                }
                //Delete from my db
                FMDBDatabase.deleteAllMessagesOfGroup(chat_dialog_id: self.viewModel?.chatRoom?.chat_dialog_id ?? "")
                //Delete from Array
                self.viewModel?.groupedByDate.removeAll()
                self.viewModel?.sectionHeaders.removeAll()
                
                self.tblVwMessages.reloadData()
                
                //Update Clear Chat Time on Firestore,
                FirestoreManager.clearMessagesOfChatRoom(chat_dialog_id: self.viewModel?.chatRoom?.chat_dialog_id ?? "")
                FirestoreManager.emptyLastMessageOnFirebase(chatRoom: (self.viewModel?.chatRoom)!)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { action in }))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertOfPermissionsNotAvailable() {
        let message = UIFunction.getLocalizationString(text: "Camera permission not available")
        let alertController: UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelTitle = UIFunction.getLocalizationString(text: "Cancel")
        let cancelAction = UIAlertAction(title: cancelTitle, style: .destructive) { (_) -> Void in
        }
        let settingsTitle = UIFunction.getLocalizationString(text: "Settings")
        let settingsAction = UIAlertAction(title: settingsTitle, style: .default) { (_) -> Void in
            UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: (self.viewModel?.convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]))!, completionHandler: nil)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate
extension ChatViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        sendButton?.alpha = string.count > 0 ? 1.0 : 0.5
        return true
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel?.sectionHeaders.count ?? 0 // Depends on your date array
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        let headerLabelView = UIView(frame: CGRect(x: (tableView.frame.size.width-100)/2, y: 20, width: 100, height: 30))
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))

        headerLabel.adjustsFontSizeToFitWidth = true
        headerLabel.font = UIFont(name: NSString(format: "SFProDisplay-Medium") as String, size: 14)
        headerLabel.textAlignment = .center

        headerLabel.text = self.viewModel?.sectionHeaders[section]
        headerLabelView.addSubview(headerLabel)

       // headerLabelView.backgroundColor = UIColor(red: 242.0/255.0, green: 247.0/255.0, blue: 246.0/255.0, alpha: 1.0)
        headerLabelView.borderWidth = 1
        headerLabelView.borderColor = .lightGray

        headerLabelView.layer.cornerRadius = 15
        headerView.addSubview(headerLabelView)
        return headerView
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.groupedByDate[self.viewModel?.sectionHeaders[section] ?? "Today"]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let messages = self.viewModel?.groupedByDate[self.viewModel?.sectionHeaders[indexPath.section] ?? "Today"]
        let model = messages?[indexPath.row]

        if model?.message_type == 1  || model?.message_type == 3 { //Text || Link
            if model?.sender_id == UserModel.shared.user.id {
                if let replyId = model?.reply_id, !replyId.isEmpty {
                    if let cell = tableView.dequeueReusableCell(withIdentifier: RightChatTextReplyCell.identifier, for: indexPath) as? RightChatTextReplyCell{
                        cell.replyMessageData = (model, viewModel?.chatRoom)
                        cell.cellTapped = {
                            if let index = self.viewModel?.getScrollToIndexPath(reply_msg_id: model?.reply_msg_id ?? "") {
                                self.tblVwMessages.scrollToRow(at: index, at: .bottom, animated: false)
                            }
                        }
                        return cell
                    }

                } else {
                    if let cell = tableView.dequeueReusableCell(withIdentifier: RightChatTextCellCell.identifier, for: indexPath) as? RightChatTextCellCell{
                        cell.setUpMessageData(messageModel: model, chatRoomModel: viewModel?.chatRoom)
                        return cell
                    }
                }
            } else {
                if let replyId = model?.reply_id, !replyId.isEmpty {
                    if let cell = tableView.dequeueReusableCell(withIdentifier: LeftChatTextReplyCell.identifier, for: indexPath) as? LeftChatTextReplyCell{
                        cell.replyMessageData = (model, viewModel?.chatRoom)
                        cell.cellTapped = {
                            if let index = self.viewModel?.getScrollToIndexPath(reply_msg_id: model?.reply_msg_id ?? "") {
                                self.tblVwMessages.scrollToRow(at: index, at: .bottom, animated: false)
                            }
                        }
                        return cell
                    }

                } else {
                    if let cell = tableView.dequeueReusableCell(withIdentifier: LeftChatTextCell.identifier, for: indexPath) as? LeftChatTextCell{
                        cell.setUpMessageData(messageModel: model, chatRoomModel: viewModel?.chatRoom)

                        return cell
                    }
                }
            }
        } else if model?.message_type == 2 { //Image
            if model?.sender_id == UserModel.shared.user.id {
                if let replyId = model?.reply_id, !replyId.isEmpty {
                    if let cell = tableView.dequeueReusableCell(withIdentifier: RightChatImageReplyCell.identifier, for: indexPath) as? RightChatImageReplyCell{
                        cell.replyMessageData = (model, viewModel?.chatRoom)
                        cell.cellTapped = {
                            if let index = self.viewModel?.getScrollToIndexPath(reply_msg_id: model?.reply_msg_id ?? "") {
                                self.tblVwMessages.scrollToRow(at: index, at: .bottom, animated: false)
                            }
                        }
                        return cell
                    }

                } else {
                    if let cell = tableView.dequeueReusableCell(withIdentifier: RightChatImageCell.identifier, for: indexPath) as? RightChatImageCell{
                        cell.imgViewButton.tag = indexPath.row
                        cell.setUpImageData(messageModel: model, chatRoomModel: viewModel?.chatRoom)

                        cell.callBackForRightImageButton = { rightImage, selectedIndex in
                            let browser = SKPhotoBrowser(photos: rightImage)
                            browser.initializePageIndex(selectedIndex)
                            self.present(browser, animated: true, completion: {})
                          //  self.viewModel?.openPreviewController(images: rightImage, selectedIndex: 0)
                        }
                        return cell
                    }
                }
             } else {
                 if let replyId = model?.reply_id, !replyId.isEmpty {
                     if let cell = tableView.dequeueReusableCell(withIdentifier: LeftChatImageReplyCell.identifier, for: indexPath) as? LeftChatImageReplyCell{
                         cell.replyMessageData = (model, viewModel?.chatRoom)
                         cell.cellTapped = {
                             if let index = self.viewModel?.getScrollToIndexPath(reply_msg_id: model?.reply_msg_id ?? "") {
                                 self.tblVwMessages.scrollToRow(at: index, at: .bottom, animated: false)
                             }
                         }
                         return cell
                     }

                 } else {
                     if let cell = tableView.dequeueReusableCell(withIdentifier: LeftChatImageCell.identifier, for: indexPath) as? LeftChatImageCell{
                         cell.imgViewButton.tag = indexPath.row
                         cell.setUpImageData(messageModel: model, chatRoomModel: viewModel?.chatRoom)

                         cell.callBackForLeftImageButton = { leftImage, selectedIndex in
                         //    self.viewModel?.openPreviewController(images: leftImage, selectedIndex: 0)
                             let browser = SKPhotoBrowser(photos: leftImage)
                             browser.initializePageIndex(selectedIndex)
                             self.present(browser, animated: true, completion: {})
                         }
                         return cell
                     }
                 }
            }
        } else if model?.message_type == 4 { //Share
            if model?.sender_id == UserModel.shared.user.id {
                if let cell = tableView.dequeueReusableCell(withIdentifier: RightChatShareCell.identifier, for: indexPath) as? RightChatShareCell{
                    cell.setUpMessageData(messageModel: model, chatRoomModel: viewModel?.chatRoom)
                    cell.callBackAction = {
                        GroupSharedProfileViewController.show(from: self, isComeFor: "", profilesIds: model?.message ?? "") { success in
                        }
                    }
                    return cell
                }
             } else {
                 if let cell = tableView.dequeueReusableCell(withIdentifier: LeftChatShareCell.identifier, for: indexPath) as? LeftChatShareCell{
                     cell.setUpMessageData(messageModel: model, chatRoomModel: viewModel?.chatRoom)
                     cell.callBackAction = {
                         GroupSharedProfileViewController.show(from: self, isComeFor: "", profilesIds: model?.message ?? "") { success in
                         }
                     }
                     return cell
                 }
            }
        } else if model?.message_type == 5 { //Gift
            if model?.sender_id == UserModel.shared.user.id {
                if let cell = tableView.dequeueReusableCell(withIdentifier: RightGiftCell.identifier, for: indexPath) as? RightGiftCell{
                    cell.setUpMessageData(messageModel: model, chatRoomModel: viewModel?.chatRoom)
                    return cell
                }
             } else {
                 if let cell = tableView.dequeueReusableCell(withIdentifier: LeftGiftCell.identifier, for: indexPath) as? LeftGiftCell{
                     cell.setUpMessageData(messageModel: model, chatRoomModel: viewModel?.chatRoom)
                     return cell
                 }
            }
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func openCameraGallery(type: String) {
        DispatchQueue.main.async { [weak self] in
            let imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = type == "Camera" ? .camera : .photoLibrary
            imagePicker.mediaTypes = ["public.image"]
            self?.present(imagePicker, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        let info = viewModel?.convertFromUIImagePickerControllerInfoKeyDictionary(info)
        if let mediaType = info?["UIImagePickerControllerMediaType"] as? String, mediaType  == "public.image" {
            if let image = (info?[(viewModel?.convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage))!] as? UIImage) {
                sendImageToServer(selectedImage: image)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func sendImageToServer(selectedImage: UIImage) {
        let imageName: String = UIFunction.getRandomImageName()
        let uploadUrlParams = ["contentType": "image/png", "directory": KAPPSTORAGE.userPicDirectoryName, "fileName": imageName]

        viewModel?.uploadURLsApi(uploadUrlParams) { [weak self] (model) in
            let fileName = model?.data?.fileName ?? ""
           
            self?.viewModel?.uploadImage(model?.data?.uploadURL ?? "", image: selectedImage ) { [weak self] _ in
                let params = ["image": fileName]
                self?.viewModel?.verifyImage(params: params) { json in
                    if let isInappropriate = json!["isInappropriate"] as? Int, isInappropriate == 0 {
                        self?.sendMessageToServer(message: "", uploadUrl: fileName, message_type: 2)
                    } else {
                        showMessage(with:"Inappropriate image")
                    }
                }
            }
        }
    }
}
