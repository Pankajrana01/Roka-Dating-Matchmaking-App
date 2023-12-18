//
//  StepFiveViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 23/09/22.
//

import UIKit
import SDWebImage

class StepFiveViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.lookingForLoveProfile
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.stepFive
    }

    lazy var viewModel: StepFiveViewModel = StepFiveViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    iscomeFrom : String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! StepFiveViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.iscomeFrom = iscomeFrom
        controller.hidesBottomBarWhenPushed = true
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var locationLable: UILabel!
    
    @IBOutlet weak var heightButton: UIButton!
    @IBOutlet weak var ethencityButton: UIButton!
    @IBOutlet weak var religionButton: UIButton!
    @IBOutlet weak var educationButton: UIButton!
    
    var gender = [String:Any]()
    var genderName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        showNavigationWhiteLogoinCenter()
        viewModel.nextButton = nextButton
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel.processForGetUserData()
        
        if viewModel.iscomeFrom == "Skip"{
            self.navigationItem.setHidesBackButton(true, animated: true)
        } else {
            self.navigationItem.setHidesBackButton(true, animated: true)

        }
        
        self.viewModel.callBackforUpdateUserInfo = { response in
            if let gender = response["Gender"] as? [String:Any] {
                self.gender = gender
                self.updateUserInfo()
            }
            
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
        let age = calculateAge(birthday: viewModel.storedUser?.dob ?? "")
        
        if let name = self.gender["name"] as? String {
            self.genderName = name
        }
        nameLable.text = "\(viewModel.storedUser?.firstName ?? "") " + "\(viewModel.storedUser?.lastName ?? ""), " + "\(age)" + (self.genderName.prefix(1))
        
        locationLable.text = "\(viewModel.storedUser?.city ?? ""), " + "\(viewModel.storedUser?.country ?? "")"
        
        guard let userImage = self.viewModel.storedUser?.userImages[0].file else { return }
        
        if userImage != "" {
            let imageUrl: String = KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + userImage
            
            self.profileImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "Avatar"), options: .refreshCached)
            titleLable.text = self.viewModel.storedUser?.userImages[0].title ?? ""

        } else {
            guard let userImage = self.viewModel.storedUser?.userImages[1].file else { return }
            let imageUrl: String = KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + userImage
            
            self.profileImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "Avatar"), options: .refreshCached)
            titleLable.text = self.viewModel.storedUser?.userImages[1].title ?? ""
        }
        
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFill
        
        
        
    }
    
    @IBAction func addMoreDetailAction(_ sender: UIButton) {
        viewModel.proceedForAddMoreDetails()
    }
    @IBAction func nextButtonAction(_ sender: UIButton) {
        GlobalVariables.shared.selectedImages.removeAll()
        GlobalVariables.shared.isComeFor = ""
        GlobalVariables.shared.cameraCancel = ""
        viewModel.proceedForTabbar()
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
