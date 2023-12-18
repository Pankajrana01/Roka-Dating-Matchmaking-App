//
//  MatchedViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 06/12/22.
//

import UIKit

class MatchedViewController: BaseAlertViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.popups
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.matched
    }

    lazy var viewModel: MatchedViewModel = MatchedViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(over host: UIViewController,
                    isCome : String,
                    userInfo: [AnyHashable: Any],
                    notificationData :Notifications?,
                    completionHandler: @escaping ((String) -> Void)) {
        let controller = self.getController() as! MatchedViewController
        controller.modalPresentationStyle = .fullScreen
        controller.show(over: host, isCome: isCome, userInfo: userInfo, notificationData: notificationData, completionHandler: completionHandler)
    }
    
    func show(over host: UIViewController,
              isCome : String,
              userInfo: [AnyHashable: Any],
              notificationData :Notifications?,
              completionHandler: @escaping ((String) -> Void)) {
        viewModel.completionHandler = completionHandler
        viewModel.isCome = isCome
        viewModel.userInfo = userInfo
        viewModel.notificationData = notificationData
        show(over: host)
    }

    
    @IBOutlet weak var ownLocationLabel: UILabel!
    @IBOutlet weak var ownUserName: UILabel!
    @IBOutlet weak var matchLocationLabel: UILabel!
    @IBOutlet weak var matchUserName: UILabel!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageOne: UIImageView!
    @IBOutlet weak var imageTwo: UIImageView!
    @IBOutlet weak var heartImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if viewModel.isCome == "NotificationScreen" {
            let matchedUserName = viewModel.notificationData?.userName ?? ""
            self.nameLabel.text = "You’ve matched \(matchedUserName)!"
            
            matchUserName.text = "\(matchedUserName)"
            
            if self.viewModel.user.userImages.count != 0 {
                for i in 0..<self.viewModel.user.userImages.count {
                    if self.viewModel.user.userImages[i].isDp == 1 {
                        let userImage = self.viewModel.user.userImages[i].file
                        if userImage != "" {
                            let imageUrl: String = KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + userImage
                            
                            self.imageOne.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "Avatar"), options: .refreshCached)
                            
                        } else {
                            self.imageOne.image = #imageLiteral(resourceName: "Avatar")
                        }
                    }
                }
            }
            
            if let matchedUserImage = viewModel.notificationData?.userImage as? String{
                let imageUrl: String = KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + matchedUserImage
                
                self.imageTwo.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "Avatar"), options: .refreshCached)
            } else {
                self.imageTwo.image = #imageLiteral(resourceName: "Avatar")
            }
            
        } else {
            if viewModel.userInfo.count != 0 {
                let matchedUserName = viewModel.userInfo["userName"] as? String ?? ""
                self.nameLabel.text = "You and \(matchedUserName) like each other"
                
                matchUserName.text = "\(matchedUserName)"
                
                if self.viewModel.user.userImages.count != 0 {
                    for i in 0..<self.viewModel.user.userImages.count {
                        if self.viewModel.user.userImages[i].isDp == 1 {
                            let userImage = self.viewModel.user.userImages[i].file
                            if userImage != "" {
                                let imageUrl: String = KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + userImage
                                
                                self.imageOne.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "Avatar"), options: .refreshCached)
                                
                            } else {
                                self.imageOne.image = #imageLiteral(resourceName: "Avatar")
                            }
                        }
                    }
                }
                
                if let matchedUserImage = viewModel.userInfo["userImage"] as? String{
                    let imageUrl: String = KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + matchedUserImage
                    
                    self.imageTwo.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "Avatar"), options: .refreshCached)
                } else {
                    self.imageTwo.image = #imageLiteral(resourceName: "Avatar")
                }
            }
        }
        ownUserName.text = "\(KAPPSTORAGE.user?.firstName ?? "")"
        
        let city = KAPPSTORAGE.user?.city == nil ? "" : KAPPSTORAGE.user?.city
        let state = KAPPSTORAGE.user?.state == nil ? "" : KAPPSTORAGE.user?.state
        let country = KAPPSTORAGE.user?.country == nil ? "" : KAPPSTORAGE.user?.country
        if country == "" {
            ownLocationLabel.text = (city == "" || city == "<null>") ?
            state : (state == "" || state == "<null>") ?
            city : "\(city ?? ""), \(state ?? "")"
        } else {
            ownLocationLabel.text = (city == "" || city == "<null>") ?
            country : (country == "" || country == "<null>") ?
            city : "\(city ?? ""), \(country ?? "")"
        }
        
        
        let angleInRadians = CGFloat.pi / 12 // 30 degrees in radians
        firstView.transform = CGAffineTransform(rotationAngle: angleInRadians)
        firstView.center = CGPoint(x: firstView.frame.width / 2, y: firstView.frame.height / 2)
        
        
        let angleInRadian = -(CGFloat.pi / 12) // 30 degrees in radians
        secondView.transform = CGAffineTransform(rotationAngle: angleInRadian)
        secondView.center = CGPoint(x: secondView.frame.width / 2, y: secondView.frame.height / 2)
        
        imageOne.layer.cornerRadius = imageOne.frame.size.height / 2
        imageOne.clipsToBounds = true
        imageOne.borderWidth = 2
        imageOne.borderColor = .white
        imageOne.contentMode = .scaleAspectFill
        
        imageTwo.layer.cornerRadius = imageTwo.frame.size.height / 2
        imageTwo.clipsToBounds = true
        imageTwo.borderWidth = 2
        imageTwo.borderColor = .white
        imageTwo.contentMode = .scaleAspectFill
        self.viewModel.getProfile()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.heartImage.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)

        UIView.animate(withDuration: 1.0,
                       delay: 1.0,
          usingSpringWithDamping: 3.0,
          initialSpringVelocity: 5.0,
                       options: [.autoreverse, .repeat],
          animations: { [weak self] in
            self?.heartImage.transform = .identity
          },
          completion: { _ in
            
        })
    }
    @IBAction func keepSwipingAction(_ sender: Any) {
        self.dismiss()
        self.viewModel.proceedForHome()
    }
    
    @IBAction func messageAction(_ sender: Any) {
        self.viewModel.moveToChatScreen {
            self.dismiss()
        }
    }
}
