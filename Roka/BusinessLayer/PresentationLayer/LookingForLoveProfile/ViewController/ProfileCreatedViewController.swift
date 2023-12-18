//
//  ProfileCreatedViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 07/08/23.
//

import UIKit

class ProfileCreatedViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.lookingForLoveProfile
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.profileCreated
    }

    lazy var viewModel: ProfileCreatedViewModel = ProfileCreatedViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    iscomeFrom : String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! ProfileCreatedViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.iscomeFrom = iscomeFrom
        controller.hidesBottomBarWhenPushed = true
        controller.show(from: viewController, forcePresent: forcePresent)
    }

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var lableCount: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var maxLength = 100
    var questionAboutDictionary = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showNavigationWhiteLogoinCenter()
        textView.delegate = self
        textView.text = "Write here…"
        textView.textColor = UIColor.appPlaceholder
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showLoader()
        viewModel.processForGetUserData { result in
            self.viewModel.processForGetUserProfileData { result in
                hideLoader()
            }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.viewModel.processForGetUserData()
        self.viewModel.processForGetQuestionData(type: "1")
        
        if viewModel.iscomeFrom == "Skip" {
            self.navigationItem.setHidesBackButton(true, animated: true)
        } else {
            self.navigationItem.setHidesBackButton(true, animated: true)

        }
        
        self.viewModel.callBackforUpdateUserInfo = { response in
            self.updateUserInfo()
        }
    }
    
    func updateUserInfo() {
        guard let userImage = self.viewModel.storedUser?.userImages[0].file else { return }
        
        if userImage != "" {
            let imageUrl: String = KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + userImage
            
            self.userImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "Avatar"), options: .refreshCached)

        } else {
            guard let userImage = self.viewModel.storedUser?.userImages[1].file else { return }
            let imageUrl: String = KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + userImage
            
            self.userImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "Avatar"), options: .refreshCached)
        }
   
    }

    @IBAction func viewPublicView(_ sender: UIButton) {
        if viewModel.profileArr.count != 0 {
            viewModel.proceedToDetailScreen(profile: viewModel.profileArr[0], index: 0)
        }
    }
    
    @IBAction func addMoreDetailButton(_ sender: UIButton) {
        submitAboutMeQuestionAnswers()
        viewModel.proceedForAddMoreDetails()
    }

    @IBAction func nextButton(_ sender: UIButton) {
        GlobalVariables.shared.selectedImages.removeAll()
        GlobalVariables.shared.isComeFor = ""
        GlobalVariables.shared.cameraCancel = ""
        submitAboutMeQuestionAnswers()
        viewModel.proceedForTabbar()
    }
    
    func submitAboutMeQuestionAnswers() {
        if self.textView.text != "Write here…" {
            let dict = NSMutableDictionary()
            dict["questionId"] = self.viewModel.questionsData[0].id
            dict["answer"] = self.textView.text ?? ""
            self.questionAboutDictionary.append(dict)
            
            var params = [String:Any]()
            params[WebConstants.id] = self.viewModel.user.id
            params[WebConstants.questionAbout] = self.questionAboutDictionary
            
            DispatchQueue.global(qos: .background).async {
                self.viewModel.processForUpdateProfileApiData(params: params, titleName: "") { success in
                    print("profile update with questions...")
                }
            }
        }
    }
}

extension ProfileCreatedViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        lableCount.text = "\(textView.text.count)/100"
        //"\(maxLength - textView.text.count)/100"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= maxLength
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.appPlaceholder {
            textView.text = nil
            textView.textColor = UIColor.appTitleBlueColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write here…"
            textView.textColor = UIColor.appPlaceholder
        }
    }
}

