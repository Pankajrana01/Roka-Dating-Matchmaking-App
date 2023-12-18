//
//  MatchMakingEditViewController.swift
//  Roka
//
//  Created by  Developer on 21/11/22.
//

import UIKit

class MatchMakingEditViewController: BaseViewController {

    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.matchMakingEdit
        
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.matchMakingEdit
    }

    lazy var viewModel: MatchMakingEditViewModel = MatchMakingEditViewModel(hostViewController: self)

    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    selectedProfile:ProfilesModel,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! MatchMakingEditViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.viewModel.selectedProfile = selectedProfile
        controller.hidesBottomBarWhenPushed = true
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bgColorView: UIView!
    @IBOutlet weak var bgColorLable: UILabel!
    
    var userModel: [ProfilesModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUserInfo()
    }
    
    private func setupUI() {
        //        self.profileImage.layer.cornerRadius = profileImage.frame.height / 2
        //        self.profileImage.layer.masksToBounds = true
        bgColorView.layer.cornerRadius = bgColorView.frame.size.height / 2
        bgColorView.clipsToBounds = true
        //showNavigationCenterTitle(title:" Edit Profile")
        self.title = "Edit Profile"
        bgColorView.isHidden = true
        setupTableView()
    }
    
    func updateUserInfo() {
        let images = viewModel.selectedProfile?.userImages?.filter({($0.file != "" && $0.file != "<null>")})
        if images?.count ?? 0 > 0 {
            let profileImageFirst = images?.first
            profileImage.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + (profileImageFirst?.file ?? ""))), placeholderImage: #imageLiteral(resourceName: "Avatar"), completed: nil)
            bgColorView.isHidden = true
            profileImage.isHidden = false
        }  else {
            bgColorView.isHidden = false
            bgColorView.backgroundColor = UIColor(hex: viewModel.selectedProfile?.placeHolderColour ?? "")
            bgColorLable.text = (viewModel.selectedProfile?.firstName ?? "").prefix(1).capitalized
            profileImage.isHidden = true
        }
        
        labelName.text = viewModel.selectedProfile?.firstName ?? ""
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: MacthMakingEditTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: MacthMakingEditTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    @IBAction func deleteProfileButtonAction(_ sender: UIButton) {
        viewModel.proceedForDeleteProfile(id: viewModel.selectedProfile?.id ?? "")
    }
    
}

extension MatchMakingEditViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MacthMakingEditTableViewCell.identifier, for: indexPath) as! MacthMakingEditTableViewCell
        cell.configure(indexPath: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            viewModel.proceedToMatchMakingBasicInfo()
        } else if indexPath.row == 1 {
            viewModel.proceedForEditPlaceholderImageScreen()
        } else if indexPath.row == 2 {
            viewModel.proceedForEditProfilePreferenceScreen()
        } else {
           // viewModel.proceedForDeleteProfile(id: viewModel.selectedProfile?.id ?? "")
        }
    }
}
