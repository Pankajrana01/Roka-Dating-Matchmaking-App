//
//  MatahMakingPlaceholderController.swift
//  Roka
//
//  Created by Pankaj Rana on 21/11/22.
//

import UIKit

class MatchMakingPlaceholderController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.matchMakingBasicInfo
        
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.matchMakingPlaceholderController
    }

    lazy var viewModel: MatchMakingPlaceholderViewModel = MatchMakingPlaceholderViewModel(hostViewController: self)

    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    selectedProfile:ProfilesModel?,
                    profileResponseData: [String:Any],
                    basicDetailsDictionary: [String:Any],
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! MatchMakingPlaceholderController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.viewModel.selectedProfile = selectedProfile
        controller.viewModel.profileResponseData = profileResponseData
        controller.viewModel.basicDetailsDictionary = basicDetailsDictionary
        controller.hidesBottomBarWhenPushed = true
        controller.show(from: viewController, forcePresent: forcePresent)
    }

    @IBOutlet weak var heartStackView: UIStackView!
    @IBOutlet weak var heartStackViewTop: NSLayoutConstraint!
    @IBOutlet weak var uploadImageLabel: UILabel!
    @IBOutlet weak var addImage: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var placeholderImage: UIImageView!
    
    @IBOutlet weak var inappropriateLable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.inappropriateLable.isHidden = true
        viewModel.collectionView = collectionView
        viewModel.backImage = backImage
        viewModel.inappropriateLable = inappropriateLable
      //  viewModel.placeholderImage = placeholderImage
        viewModel.addImage = addImage
        backImage.layer.cornerRadius = 10
        backImage.clipsToBounds = true
        inappropriateLable.layer.cornerRadius = 10
        inappropriateLable.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }
    //EditMatchingProfilePlaceHolder
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        heartStackViewTop.constant = 0
        self.heartStackView.isHidden = true
        
        if viewModel.isComeFor == "EditMatchingProfile" {
            showNavigationBackButton(title: "  Edit profile image")
            nextButton.setTitle("Save changes", for: .normal)
            heartStackView.isHidden = true
            heartStackViewTop.constant = 0
            uploadImageLabel.text = "Edit image"
            
            let images = viewModel.selectedProfile?.userImages?.filter({($0.file != "" && $0.file != "<null>")})
            if images?.count ?? 0 > 0 {
                let profileImageFirst = images?.first
                backImage.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + (profileImageFirst?.file ?? ""))), placeholderImage: #imageLiteral(resourceName: "Avatar"), completed: nil)
               // placeholderImage.isHidden = true
                self.addImage.setImage(UIImage(named: "ic_edit-image"), for: .normal)
                self.addImage.isHidden = false
                self.viewModel.selectedColor = ""
                self.viewModel.selectedIndex = -1
            } else {
               // placeholderImage.isHidden = true
                self.addImage.isHidden = true
                if let index = PlaceholderBGColor.firstIndex(where: {$0 == viewModel.selectedProfile?.placeHolderColour}){
                    print(index)
                    self.viewModel.selectedColor = viewModel.selectedProfile?.placeHolderColour ?? ""
                    self.viewModel.selectedIndex = index
                }
                
            }
            
            self.collectionView.reloadData()
        } else if viewModel.isComeFor == "EditMatchingProfilePlaceHolder" {
            showNavigationBackButton(title: "  Edit Profile Image")
            nextButton.setTitle("Save Changes", for: .normal)
            heartStackView.isHidden = true
            heartStackViewTop.constant = 0
            uploadImageLabel.text = "Edit image"
            
            if let images = viewModel.profileResponseData["userImages"] as? [[String:Any]] {
                if let profileImageFirst = images.first {
                    backImage.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + (profileImageFirst["file"] as? String ?? ""))), placeholderImage: #imageLiteral(resourceName: "Avatar"), completed: nil)
                   // placeholderImage.isHidden = true
                    self.addImage.setImage(UIImage(named: "ic_edit-image"), for: .normal)
                    self.addImage.isHidden = false
                    self.viewModel.selectedColor = ""
                    self.viewModel.selectedIndex = -1
                }
                } else {
                  //  placeholderImage.isHidden = true
                    self.addImage.isHidden = true
                    if let index = PlaceholderBGColor.firstIndex(where: {$0 == viewModel.selectedProfile?.placeHolderColour}){
                        print(index)
                        self.viewModel.selectedColor = viewModel.profileResponseData["placeHolderColour"] as? String ?? ""
                        self.viewModel.selectedIndex = index
                    }
                }
            
            self.collectionView.reloadData()
        } else {
            showNavigationLogoinCenter()
            nextButton.setTitle("Next", for: .normal)
            heartStackView.isHidden = false
            heartStackViewTop.constant = 30
            uploadImageLabel.text = "Upload Image"
        }
        self.viewModel.initializeInputsData()
    }
    
    @IBAction func uploadImageButtonAction(_ sender: UIButton) {
        viewModel.openUploadImagePicker()
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        viewModel.uploadImages()
    }
}
