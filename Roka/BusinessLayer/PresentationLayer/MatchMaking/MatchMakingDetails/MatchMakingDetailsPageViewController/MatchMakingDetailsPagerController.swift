//
//  MatchMakingDetailsPagerController.swift
//  Roka
//
//  Created by  Developer on 05/12/22.
//

import UIKit

class MatchMakingDetailsPagerController: DTPagerController {
    
    class func storyboard() -> UIStoryboard {
        return UIStoryboard.matchMakingDetails
    }
    
    class func identifier() -> String {
        return ViewControllerIdentifier.matchMakingDetailsPager
    }
    
    class func getController() -> MatchMakingDetailsPagerController {
        return self.storyboard().instantiateViewController(withIdentifier:
            self.identifier()) as! MatchMakingDetailsPagerController
    }
   
    class func show(from viewController: UIViewController, forcePresent: Bool = false, receivedProfile: ProfilesModel, isComeFor: String) {
        let vc = self.getController()
        vc.hidesBottomBarWhenPushed = true
        vc.isComeFor = isComeFor
        vc.receivedProfile = receivedProfile
        vc.show(from: viewController, forcePresent: forcePresent)
        
    }

    func show(from viewController: UIViewController, forcePresent: Bool = false) {
        viewController.endEditing(true)
        DispatchQueue.main.async {
            if forcePresent {
                viewController.present(self, animated: true, completion: nil)
            } else {
                viewController.navigationController?.pushViewController(self, animated: true)
            }
        }
    }
    
    var receivedProfile: ProfilesModel?
    var profileArray: [ProfilesModel] = []
    var profileCellVMArray: [MatchMakingDetailsCollectionViewCellViewModel] = []
    var isFrom = ""
    var isComeFor = ""
    private let viewController1 = MatchMakingDetailsViewController.getController() as! MatchMakingDetailsViewController
    private let viewController2 = MatchMakingDetailsViewController.getController() as! MatchMakingDetailsViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        perferredScrollIndicatorHeight = 2
        viewController1.friendsId = receivedProfile?.id ?? ""
        viewController1.viewModel.isSuggested = false
        viewController1.viewModel.isComeFor = self.isComeFor
        viewController1.title = "Chosen by me"
        viewController1.getArray = { [weak self] profileArray in
            self?.profileArray.removeAll()
            guard let strongSelf = self else { return }
            strongSelf.isFrom = "Chosen by me"
            strongSelf.profileArray = profileArray
            
        }
        viewController2.friendsId = receivedProfile?.id ?? ""
        viewController2.viewModel.isComeFor = self.isComeFor
        viewController2.viewModel.isSuggested = true
        viewController2.title = "Roka Suggested"
        viewController2.getArray = { [weak self] profileArray in
            guard let strongSelf = self else { return }
            self?.profileArray.removeAll()
            strongSelf.isFrom = "Roka Suggested"
            strongSelf.profileArray = profileArray
        }
        
        viewControllers = [viewController1, viewController2]
        
        scrollIndicator.backgroundColor = UIColor.appPurpleColor.withAlphaComponent(0.5)
        scrollIndicator.layer.cornerRadius = scrollIndicator.frame.height / 2

        setSelectedPageIndex(1, animated: true)

        pageSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.appTitleBlueColor], for: .selected)
        pageSegmentedControl.backgroundColor = .white

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
       
        showNavigationBackButton(title: StringConstants.matchMakingDetails + "\(receivedProfile?.firstName ?? "")")
        
        let searchButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(self.searchNavButtonClicked))
        searchButton.image = UIImage(named: "Ic_search_dark")
        // Here creating emptyButton just to give some space from the right side to rightButton.
        let emptyRightButton = UIBarButtonItem()
        self.navigationItem.rightBarButtonItems = [emptyRightButton, searchButton]
    }
    
    @objc func searchNavButtonClicked() {
            // Search action here
            if self.isFrom == "Chosen by me", profileArray.count == 0 {
                showMessage(with: StringConstants.emptyChoosenByMe)
            } else if self.isFrom == "Roka Suggested", profileArray.count == 0 {
                showMessage(with: StringConstants.emptySuggested)
            } else {
                let cellViewModel = self.isFrom == "Chosen by me" ? self.viewController1.viewModel.profileCellViewModels : self.viewController2.viewModel.profileCellViewModels
                MatchMakingDetailSearchViewController.show(from: self, isComeFor: self.isFrom, profiles: profileArray, profilesCellVMArray: cellViewModel, completionHandler: {_ in })
            }
        }
    
    func showNavigationBackButton(title:String) {
        let customView = UIView(frame: CGRect(x: -30.0, y: 0.0, width: 400.0, height: 44.0))
       
        let profileImage = UIImageView(frame: CGRect(x: -20.0, y: customView.frame.origin.y + 5, width: 35, height: 35))
        let images = receivedProfile?.userImages?.filter({($0.file != "" && $0.file != "<null>")})
        
        if let images = images, !images.isEmpty {
            let image = images[0]
            let urlstring = image.file ?? ""
            let trimmedString = urlstring.replacingOccurrences(of: " ", with: "%20")
            profileImage.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + trimmedString)), placeholderImage: #imageLiteral(resourceName: "Avatar"), completed: nil)
        } else {
            let profileView = UIView(frame: CGRect(x: -20.0, y: customView.frame.origin.y + 5, width: 35, height: 35))
            profileView.layer.cornerRadius = profileView.frame.height/2
            profileView.clipsToBounds = true
            profileView.backgroundColor = UIColor(hex: receivedProfile?.placeHolderColour ?? "")
            let namelabel = UILabel(frame: profileView.bounds)
            namelabel.text = (receivedProfile?.firstName ?? "").prefix(1).capitalized
            namelabel.textColor = UIColor.white
            namelabel.textAlignment = NSTextAlignment.center
            namelabel.font = UIFont(name: "SharpGrotesk-SemiBold25", size: 16.0)
            profileView.addSubview(namelabel)
            
            customView.addSubview(profileView)
        }
       
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFill
        customView.addSubview(profileImage)
        
        let label = UILabel(frame: CGRect(x: 30.0, y: customView.frame.origin.y + 5, width: 200, height: 35.0))
        label.text = title
        label.textColor = UIColor.appBorder
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont(name: "SharpGrotesk-SemiBold25", size: 16.0)
        customView.addSubview(label)
        self.navigationItem.titleView = customView
    }
}



