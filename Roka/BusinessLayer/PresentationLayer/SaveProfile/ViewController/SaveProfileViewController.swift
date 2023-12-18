//
//  SaveProfileViewController.swift
//  Roka
//
//  Created by  Developer on 11/11/22.
//

import UIKit
import SDWebImage
class SaveProfileViewController: BaseAlertViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.saveProfile
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.saveProfile
    }

    lazy var viewModel: SaveProfileViewModel = SaveProfileViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(over host: UIViewController,
                    isCome : String,
                    profileId :String,
                    searchPreferenceId :String,
                    status : Int,
                    image:String,
                    name: String,
                    completionHandler: @escaping ((String) -> Void)) {
        let controller = self.getController() as! SaveProfileViewController
        controller.show(over: host, isCome: isCome, profileId:profileId, searchPreferenceId:searchPreferenceId, status:status, image: image, name: name, completionHandler: completionHandler)
    }
    
    func show(over host: UIViewController,
              isCome : String,
              profileId :String,
              searchPreferenceId :String,
              status : Int,
              image:String,
              name: String,
              completionHandler: @escaping ((String) -> Void)) {
        viewModel.completionHandler = completionHandler
        viewModel.isCome = isCome
        viewModel.profileId = profileId
        viewModel.searchPreferenceId = searchPreferenceId
        viewModel.status = status
        viewModel.image = image
        viewModel.name = name
        show(over: host)
    }
    
   
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var containerViewHeigth: NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buttonDismiss: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    var saved = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.collectionView = collectionView
        imageProfile.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + viewModel.image)), placeholderImage: #imageLiteral(resourceName: "Avatar"), completed: nil)
        
        imageProfile.layer.cornerRadius = imageProfile.frame.size.height / 2
        imageProfile.clipsToBounds = true
        self.nameLabel.text = viewModel.name
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if GlobalVariables.shared.selectedProfileMode != "MatchMaking"{
            self.saveButton.backgroundColor = UIColor.appTitleBlueColor
        } else {
            self.saveButton.backgroundColor = UIColor(hex: "#AD9BFB")
        }
        if GlobalVariables.shared.selectedProfileMode == "MatchMaking" {
            collectionView.isHidden = false
            collectionViewHeight.constant = 0
            containerViewHeigth.constant = 450
//            titleLable.text = "Save this profile for"
            if viewModel.status == 0 {
                titleLable.text = "Do you want to unsave this profile?"
                saveButton.setTitle("Unsave", for: .normal)
            } else {
                saveButton.setTitle("Save", for: .normal)
                titleLable.text = "Do you want to save this profile for later?"
            }
        } else if GlobalVariables.shared.isUnsavedMatchingProfile == true {
            collectionView.isHidden = true
            collectionViewHeight.constant = 0
            containerViewHeigth.constant = 410 //350
          
            if viewModel.status == 0 {
                titleLable.text = "Do you want to unsave this profile?"
                saveButton.setTitle("Unsave", for: .normal)
            } else {
                saveButton.setTitle("Save", for: .normal)
                titleLable.text = "Do you want to save this profile for later?"
            }
        } else {
            collectionView.isHidden = true
            collectionViewHeight.constant = 0
            containerViewHeigth.constant = 410 //350
          
            if viewModel.status == 0 {
                titleLable.text = "Do you want to unsave this profile?"
                saveButton.setTitle("Unsave", for: .normal)
            } else {
                saveButton.setTitle("Save", for: .normal)
                titleLable.text = "Do you want to save this profile for later?"
            }
        }
    }
    @IBAction func dismissAction(_ sender: UIButton) {
        print("dismissAction")
        self.dismiss()
    }
    
    @IBAction func cancelClicked(_ sender: UIButton) {
        self.dismiss()
    }
    
    @IBAction func saveClicked(_ sender: UIButton) {
        self.viewModel.proceedForAPiCall { status in
            self.saved = true
            self.dismiss()
            self.viewModel.completionHandler?("success")
        }
    }
}
