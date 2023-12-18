//
//  ImageTableViewCell.swift
//  Roka
//
//  Created by Pankaj Rana on 18/10/22.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var verifiedImage: UIImageView!
    @IBOutlet weak var likeUnlikeButton: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView! { didSet { configureCollectionView() } }
    
    @IBOutlet weak var bottomArrowButton: UIButton!
    @IBOutlet weak var downArrowImage: UIImageView!
    
    @IBOutlet weak var sideMenuStack: UIStackView!
    
    @IBOutlet weak var shareButtonView: UIView!
    @IBOutlet weak var undoButtonView: UIView!
    @IBOutlet weak var likeButtonView: UIView!
    @IBOutlet weak var crossButtonView: UIView!
    @IBOutlet weak var saveButtonView: UIView!
    @IBOutlet weak var nextButtonView: UIView!
    @IBOutlet weak var prevoiusButtonView: UIView!
    
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var saveImage: UIImageView!
    
    // NEW
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var imageCaption: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var kingImage: UIImageView!
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.insetsLayoutMarginsFromSafeArea = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(UINib(nibName: CollectionViewNibIdentifier.imageCell, bundle: nil), forCellWithReuseIdentifier: CollectionViewCellIdentifier.imageCell)
        
        
    }
    var allProfiles: [ProfilesModel] = []
    var cellIndex = 0
    var index = 0
    var displayIndex = 0
    var previousIndex = 0
    var profile : ProfilesModel! { didSet { profileDidSets() } }
    var userImages = [ProfilesImages]()
    var isComeFor = ""
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    
    func profileDidSet() {
        sideMenuStack.isHidden = true
        
       // userImages = profile?.userImages?.filter({($0.file != "" && $0.file != "<null>")})
        
        self.userImages.removeAll()
        if let images: [ProfilesImages] = profile?.userImages?.filter({($0.file != "" && $0.file != "<null>")}) {
            for i in 0..<(profile?.userImages?.count ?? 0) {
                if let imgarr = profile?.userImages?[i] as? ProfilesImages{
                    if imgarr.isDp == 1{
                        self.userImages.insert(imgarr, at: 0)
                    } else {
                        self.userImages.insert(imgarr, at: i)
                    }
                }
            }
        }
//        // update undo button state ...
//        if storedUser?.isSubscriptionPlanActive == 0 {
//            self.undoButtonView.isHidden = true
//        } else {
//            if previousIndex != index{
//                self.undoButtonView.isHidden = false
//            } else {
//                self.undoButtonView.isHidden = true
//            }
//        }
//
//        // update like and chat button state ...
//        if let liked = profile.isLiked {
//            if liked == 1 {
//                likeImage.image = UIImage(named: "Ic_chat")
//            } else {
//                likeImage.image = UIImage(named: "Ic_like")
//            }
//        }
//
//        // update save button state ...
//        if let liked = profile.isSaved {
//            if liked == 1 {
//                saveImage.image = UIImage(named: "Ic_tick_1")
//            } else {
//                saveImage.image = UIImage(named: "Ic_save 1")
//            }
//        }
//
//        if isComeFor == "Profile"{
//            sideMenuStack.isHidden = true
//            self.saveButtonView.isHidden = true
//            self.prevoiusButtonView.isHidden = true
//            self.nextButtonView.isHidden = true
//        } else if isComeFor == "SavedPreferences" {
//            sideMenuStack.isHidden = false
//            self.saveButtonView.isHidden = false
//            self.prevoiusButtonView.isHidden = true
//            self.nextButtonView.isHidden = true
//        } else if isComeFor == "MatchMakingProfile" {
//            sideMenuStack.isHidden = false
//            self.undoButtonView.isHidden = true
//            self.likeButtonView.isHidden = true
//            self.crossButtonView.isHidden = true
//
//            let last_element = self.allProfiles.count - 1
//            print(last_element)
//
//            if index == last_element {
//                self.nextButtonView.isHidden = true
//            } else {
//                self.nextButtonView.isHidden = false
//            }
//
//            if index == 0 {
//                self.prevoiusButtonView.isHidden = true
//            } else {
//                self.prevoiusButtonView.isHidden = false
//            }
//
//        } else {
//            sideMenuStack.isHidden = false
//            self.saveButtonView.isHidden = true
//            self.prevoiusButtonView.isHidden = true
//            self.nextButtonView.isHidden = true
//
//        }
        
        GlobalVariables.shared.isProfileDisplayedCount += 1
        print(" +++++++++++++ >>>>>>>>>>", GlobalVariables.shared.isProfileDisplayedCount)
        if GlobalVariables.shared.isProfileDisplayedCount > user.advertismentShowCount {
            callBackForOpenDetailAdsView?(index)
            GlobalVariables.shared.isProfileDisplayedCount = 0
        }
        
    }
    
    var callBackForSelectCrossButton: ((_ selectedIndex:Int) ->())?
    var callBackForSelectUndoButton: ((_ selectedIndex:Int, _ prevoiusIndex:Int) ->())?
    var callBackForSelectShareButton: ((_ selectedIndex:Int) ->())?
    var callBackForSelectLikeButton: ((_ selectedIndex:Int) ->())?
    var callBackForSelectChatButton: ((_ selectedIndex:Int) ->())?
    var callBackForSelectSaveButton: ((_ selectedIndex:Int) ->())?
    var callBackForDownArrowButton: ((_ selectedIndex:Int) ->())?
    var callBackForSelectNextButton: ((_ selectedIndex:Int) ->())?
    var callBackForSelectPreviousButton: ((_ selectedIndex:Int) ->())?
    var callBackForOpenDetailAdsView: ((_ selectedIndex:Int) ->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //animateDownArrow()
    }

    func animateDownArrow() {
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [.autoreverse, .repeat], animations: {
            self.downArrowImage.frame.origin.y -= 30
        }, completion:{ _ in
            self.downArrowImage.transform = .identity
        })
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func downArrowButtonAction(_ sender: UIButton) {
        callBackForDownArrowButton?(index)
    }
    @IBAction func undoButtonAction(_ sender: UIButton) {
        callBackForSelectUndoButton?(index, previousIndex)
    }
    @IBAction func crossButtonAction(_ sender: UIButton) {
        callBackForSelectCrossButton?(index)
    }
    @IBAction func shareBUttonAction(_ sender: UIButton) {
        callBackForSelectShareButton?(index)
    }
    @IBAction func likeUnlikeButtonAction(_ sender: UIButton) {
        if likeImage.image == UIImage(named: "Im_whiteLike") {
            self.likeImage.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)

            UIView.animate(withDuration: 0.5,
              delay: 0,
              usingSpringWithDamping: 0.2,
              initialSpringVelocity: 4.0,
              options: .allowUserInteraction,
              animations: { [weak self] in
                self?.likeImage.transform = .identity
              },
              completion: { _ in
                self.callBackForSelectLikeButton?(self.index)
            })

            
        } else {
            self.callBackForSelectChatButton?(self.index)
        }
    }
    
    @IBAction func savedButtonAction(_ sender: UIButton) {
        callBackForSelectSaveButton?(index)
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        callBackForSelectNextButton?(index)
    }
    
    @IBAction func previousButtonAction(_ sender: UIButton) {
        callBackForSelectPreviousButton?(index)
    }
    
    func profileDidSets() {
        backImageView.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + (profile.userImages?[0].file ?? ""))), placeholderImage: #imageLiteral(resourceName: "Avatar"), options: .refreshCached, completed: nil)
        
        imageCaption.text = profile.userImages?[0].title
        let gender = profile?.Gender?.name?.prefix(1)
        userNameLabel.text = profile?.firstName
        if profile?.dob != nil && profile?.dob != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dobDate = dateFormatter.date(from: profile?.dob ?? "") ?? Date()
            let now = Date()
            let calendar = Calendar.current
            let ageComponents = calendar.dateComponents([.year], from: dobDate, to: now)
            let age = ageComponents.year!
            print(age)
            let userAge = profile?.userAge ?? 0
            userNameLabel.text = (profile?.firstName ?? "") + ", \(userAge)" + "\(gender ?? "")"
        }
        
        let city = profile?.city == nil ? "" : profile?.city
        let country = profile?.country == nil ? "" : profile?.country
        let state = profile?.state == nil ? "" : profile?.state
        if country == "" {
            locationLabel.text = (city == "" || city == "<null>") ? state : (state == "" || state == "<null>") ? city : "\(city ?? ""), \(state ?? "")"
        } else{
            locationLabel.text = (city == "" || city == "<null>") ? country : (country == "" || country == "<null>") ? city : "\(city ?? ""), \(country ?? "")"
        }
        
        if let distance = profile.distance {
            let strDistance = "\(distance)"
            let fullArr = strDistance.components(separatedBy: ".")
            if storedUser?.countryCode == "+91"{
                if fullArr.count > 0{
                    if Int(fullArr[0]) ?? 0 > 500 {
//                        descLabel.text = ">500 Km"
                    } else {
//                        descLabel.text = "\(fullArr[0]) Km"
                    }
                } else {
//                    descLabel.text = ""
                }
               // let roundedValue = round(distance * 100) / 100.0
              //  descLabel.text = "\(String(format: "%.0f", distance)) Km"
               // descLabel.text = "\(distance) Km"
            } else {
                if fullArr.count > 0{
                    if Int(fullArr[0]) ?? 0 > 500 {
//                        descLabel.text = ">500 Miles"
                    } else {
//                        descLabel.text = "\(fullArr[0]) Miles"
                    }
                } else {
//                    descLabel.text = ""
                }
                //let roundedValue = round(distance * 100) / 100.0
               // descLabel.text = "\(String(format: "%.0f", distance)) Miles"
                //descLabel.text = "\(distance) Miles"
            }
        } else {
            if storedUser?.countryCode == "+91"{
//                descLabel.text = ""
            }else {
//                descLabel.text = ""
            }
        }
        
        if profile.isSubscriptionPlanActive == 1{
            kingImage.isHidden = false
        } else {
            kingImage.isHidden = true
        }
        
        if profile.isKycApproved == 0 {
            descLabel.isHidden = true
            verifiedImage.isHidden = true
            self.bottomConstraint.constant = 7
        } else {
            descLabel.isHidden = false
            verifiedImage.isHidden = false
            self.bottomConstraint.constant = 22
        }
    }
}

extension ImageTableViewCell :UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.imageCell, for: indexPath) as? ImageCollectionViewCell {
            cell.profile = self.profile
            cell.userImage = self.userImages[indexPath.row]
            
            let screenRect = UIScreen.main.bounds
            let screenHeight = screenRect.size.height
            if screenHeight >= 812{
                cell.descBottomConstraints.constant = 30
            }else {
                cell.descBottomConstraints.constant = 15
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenRect = UIScreen.main.bounds
        let screenHeight = screenRect.size.height
        let screenWidth = screenRect.size.width
        
        return  CGSize(width: screenWidth, height: screenHeight)

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
