//
//  MatchMakingProfileCreatedController.swift
//  Roka
//
//  Created by Pankaj Rana on 21/11/22.
//

import UIKit

class MatchMakingProfileCreatedController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.matchMakingProfileCreated
        
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.matchMakingProfileCreatedController
    }

    lazy var viewModel: MatchMakingProfileCreatedViewModel = MatchMakingProfileCreatedViewModel(hostViewController: self)

    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    iscomeFrom : String,
                    profileUser: User,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! MatchMakingProfileCreatedController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.iscomeFrom = iscomeFrom
        controller.viewModel.profileUser = profileUser
        controller.hidesBottomBarWhenPushed = true
        controller.show(from: viewController, forcePresent: forcePresent)
    }

    @IBOutlet weak var profileCreatedLable: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var locationLable: UILabel!
    @IBOutlet weak var bgColorView: UIView!
    @IBOutlet weak var bgColorNameLable: UILabel!
    @IBOutlet weak var heightButton: UIButton!
    @IBOutlet weak var ethencityButton: UIButton!
    @IBOutlet weak var religionButton: UIButton!
    @IBOutlet weak var educationButton: UIButton!
    @IBOutlet weak var editButtonTrailing: NSLayoutConstraint!
    @IBOutlet weak var editButtonTop: NSLayoutConstraint!
    
    var gender = [String:Any]()
    var genderName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showNavigationLogoinCenter()
        viewModel.nextButton = nextButton
        self.updateUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.viewModel.processForGetUserData()
        
        self.viewModel.callBackforUpdateUserInfo = { response in

            if response["height"] as? String != nil {
                self.heightButton.setTitleColor(UIColor.appYellowColor, for: .normal)
                self.heightButton.setImage(UIImage(named: "ic_height"), for: .normal)
                self.heightButton.layer.borderColor = UIColor.appYellowColor.cgColor
            }
            
            if response["Ethnicity"] as? [String:Any] != nil {
                self.ethencityButton.setTitleColor(UIColor.appYellowColor, for: .normal)
                self.ethencityButton.setImage(UIImage(named: "Ic_ethencity-selected"), for: .normal)
                self.ethencityButton.layer.borderColor = UIColor.appYellowColor.cgColor
            }
            
            if response["Religion"] as? [String:Any] != nil {
                self.religionButton.setTitleColor(UIColor.appYellowColor, for: .normal)
                self.religionButton.setImage(UIImage(named: "Ic_religion-selected"), for: .normal)
                self.religionButton.layer.borderColor = UIColor.appYellowColor.cgColor
            }
            
            if response["Education"] as? [String:Any] != nil {
                self.educationButton.setTitleColor(UIColor.appYellowColor, for: .normal)
                self.educationButton.setImage(UIImage(named: "ic_education-selected"), for: .normal)
                self.educationButton.layer.borderColor = UIColor.appYellowColor.cgColor
            }
        }
    }
    
    func refreshStackUI() {
        self.heightButton.setTitleColor(UIColor.appTextGreyColor, for: .normal)
        self.heightButton.setImage(UIImage(named: "Ic_height-1"), for: .normal)
        self.heightButton.layer.borderColor = UIColor.appTextGreyColor.cgColor
        
        self.ethencityButton.setTitleColor(UIColor.appTextGreyColor, for: .normal)
        self.ethencityButton.setImage(UIImage(named: "Ic_ethencity-1"), for: .normal)
        self.ethencityButton.layer.borderColor = UIColor.appTextGreyColor.cgColor
        
        self.religionButton.setTitleColor(UIColor.appTextGreyColor, for: .normal)
        self.religionButton.setImage(UIImage(named: "ic_religion-1"), for: .normal)
        self.religionButton.layer.borderColor = UIColor.appTextGreyColor.cgColor
        
        self.educationButton.setTitleColor(UIColor.appTextGreyColor, for: .normal)
        self.educationButton.setImage(UIImage(named: "ic_education"), for: .normal)
        self.educationButton.layer.borderColor = UIColor.appYellowColor.cgColor
    }
    
    func updateUserInfo() {
       // let age = calculateAge(birthday: viewModel.profileUser.dob)
        GlobalVariables.shared.selectedFriendProfileId = viewModel.profileUser.id
        GlobalVariables.shared.selectedFriendProfileDOB = viewModel.profileUser.dob 
       // nameLable.text = "\(viewModel.profileUser.firstName), " + "\(age)" + (self.viewModel.profileUser.gender.prefix(1))
        
        nameLable.text = "\(viewModel.profileUser.firstName), " + (self.viewModel.profileUser.gender.prefix(1))
        
        self.profileCreatedLable.text = "\((viewModel.profileUser.firstName ))'s " + "profile has been created"
        
        locationLable.text = "\(viewModel.profileUser.city), " + "\(viewModel.profileUser.country)"
        
        if self.viewModel.profileUser.userImages.count != 0 {
            self.editButtonTrailing.constant = 15
            self.editButtonTop.constant = -15
            let userImage = self.viewModel.profileUser.userImages[0].file
            bgColorView.isHidden = true
            self.profileImage.isHidden = false
            if userImage != "" {
                let imageUrl: String = KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + userImage
                
                self.profileImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "Avatar"), options: .refreshCached)
                titleLable.text = self.viewModel.profileUser.userImages[0].title
            }
        } else {
            self.editButtonTrailing.constant = -10
            self.editButtonTop.constant = 0
            bgColorView.isHidden = false
            self.profileImage.isHidden = true
            bgColorView.backgroundColor = UIColor(hex: self.viewModel.profileUser.placeHolderColour)
            bgColorNameLable.text = (viewModel.profileUser.firstName).prefix(1).capitalized

        }
//        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
//        profileImage.clipsToBounds = true
        bgColorView.layer.cornerRadius = bgColorView.frame.size.height / 2
        bgColorView.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFill
    }
    
    @IBAction func addMoreDetailAction(_ sender: UIButton) {
        viewModel.proceedForEditProfilePreferenceScreen()
    }
    
    @IBAction func editButtonAction(_ sender: UIButton) {
        if viewModel.selectedProfileData.count != 0 {
            viewModel.proceedForEditPlaceholderImageScreen()
        }
    }
    @IBAction func nextButtonAction(_ sender: UIButton) {
        GlobalVariables.shared.selectedImages.removeAll()
        GlobalVariables.shared.isComeFor = ""
        GlobalVariables.shared.cameraCancel = ""
        viewModel.popBackToController()
    }
    @IBAction func heightButtonAction(_ sender: Any) {
        viewModel.proceedForSelectHeight { success in
            self.heightButton.setTitleColor(UIColor.appYellowColor, for: .normal)
            self.heightButton.setImage(UIImage(named: "ic_height"), for: .normal)
            self.heightButton.layer.borderColor = UIColor.appYellowColor.cgColor
        }
    }
    @IBAction func ethencityButtonAction(_ sender: Any) {
        viewModel.proceedForSelectEthencity{ success in
            self.ethencityButton.setTitleColor(UIColor.appYellowColor, for: .normal)
            self.ethencityButton.setImage(UIImage(named: "Ic_ethencity-selected"), for: .normal)
            self.ethencityButton.layer.borderColor = UIColor.appYellowColor.cgColor
        }
    }
    @IBAction func religionButtonAction(_ sender: Any) {
        viewModel.proceedForSelectReligion{ success in
            self.religionButton.setTitleColor(UIColor.appYellowColor, for: .normal)
            self.religionButton.setImage(UIImage(named: "Ic_religion-selected"), for: .normal)
            self.religionButton.layer.borderColor = UIColor.appYellowColor.cgColor
        }
    }
    
    @IBAction func educationButtonAction(_ sender: UIButton) {
        viewModel.proceedForSelectEducation{ success in
            self.educationButton.setTitleColor(UIColor.appYellowColor, for: .normal)
            self.educationButton.setImage(UIImage(named: "ic_education-selected"), for: .normal)
            self.educationButton.layer.borderColor = UIColor.appYellowColor.cgColor
        }
    }
    
}
