//
//  DetailViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 06/10/22.
//

import UIKit

class DetailViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.home
        
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.detail
    }

    lazy var viewModel: DetailViewModel = DetailViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    selectedProfile: ProfilesModel,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! DetailViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.viewModel.selectedProfile = selectedProfile
        controller.show(from: viewController, forcePresent: forcePresent)
    }

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var imageCaption: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.updateProfileDetail()
    }
    
    func updateProfileDetail() {
        let profile = viewModel.selectedProfile
        let images = profile?.userImages?.filter({($0.file != "" && $0.file != "<null>")})
        if images?.count ?? 0 > 0 {
            let profileImageFirst = images?.first
            backImageView.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + (profileImageFirst?.file ?? ""))), placeholderImage: #imageLiteral(resourceName: "Avatar"), completed: nil)

        } else {
            backImageView.image = #imageLiteral(resourceName: "Avatar")
        }
       
        let captions = profile?.userImages?.filter({($0.title != "" && $0.title != "<null>")})
        if captions?.count ?? 0 > 0 {
            let profileCaptionFirst = captions?.first
            imageCaption.text = profileCaptionFirst?.title
        } else {
            imageCaption.text = ""
        }
        
        let gender = profile?.gender?.prefix(1)

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
        locationLabel.text = (city == "" || city == "<null>") ? country : (country == "" || country == "<null>") ? city : "\(city ?? ""), \(country ?? "")"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
  
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.backButtonTapped(self)
    }
    
    @IBAction func optionButtonTapped(_ sender: UIButton) {
        viewModel.showAlertForReportBlockUser()
    }
    
    @IBAction func shareBUttonAction(_ sender: UIButton) {
        viewModel.proceedForShare()
    }
    
}
