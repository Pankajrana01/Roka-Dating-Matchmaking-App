//
//  SearchViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 14/10/22.
//

import UIKit

class SearchViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.search
        
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.search
    }

    lazy var viewModel: SearchViewModel = SearchViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! SearchViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.show(from: viewController, forcePresent: forcePresent)
    }

    
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var navigationLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var secondLabelBackground: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var labelBackground: UILabel!
    @IBOutlet weak var buttonSetPreference: UIButton!
    
    var barItem = UIBarButtonItem()
    var leftItem = UIBarButtonItem()
    var toggleButton = UIButton()
    private var preferenceData: [[String: Any]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        KAPPSTORAGE.searchTab = false
        self.secondLabelBackground.textColor = UIColor(red: 0.012, green: 0.086, blue: 0.204, alpha: 1)
        self.navigationController?.isNavigationBarHidden = false
        NotificationCenter.default.post(name: .updateNotificationIcon, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        KAPPSTORAGE.searchTab = false
        
        var bounds = UIScreen.main.bounds
        var width = bounds.size.width
        var height = bounds.size.height
        if height >= 700.0 {
            self.imageWidth.constant = 269
            self.imageHeight.constant = 269
        } else {
            self.imageWidth.constant = 200
            self.imageHeight.constant = 200
        }
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(refreshSavedPreferences), name: .refreshSavedPreferences, object: nil)
        setupUI()
        proceedForGetSavedPreferencesData()
    }
    
    @objc func refreshSavedPreferences() {
        proceedForGetSavedPreferencesData()
    }
    
    func proceedForGetSavedPreferencesData() {
        DispatchQueue.main.async { showLoader() }
        viewModel.preferenceIds.removeAll()
        viewModel.getSearchPreferenceData { [weak self] data in
            guard let strongSelf = self else { return }
            // if data present then show tableview
            // otherwise show empty
            guard let data = data, !data.isEmpty else {
                strongSelf.hide(tableView: true)
                return
            }
            strongSelf.hide(tableView: false)
            print(data)
            strongSelf.preferenceData?.removeAll()
            strongSelf.preferenceData = data
            
            strongSelf.tableView.reloadData()
            hideLoader()
        }
    }
    private func setupUI() {
        showLeftNavigationLogo()
        addNavigationLeftButton()
        setupTableView()
    }
    
    private func hide(tableView bool: Bool) {
        tableView.isHidden = bool
        stackView.isHidden = bool
        imageBackground.isHidden = !bool
        labelBackground.isHidden = !bool
        secondLabelBackground.isHidden = !bool
        buttonSetPreference.isHidden = !bool
    }
    
    func showLeftNavigationLogo() {
        let btn1 = UIButton()
//        btn1.setImage(UIImage(named: "Ic_Logo_nav"), for: .normal)
        if GlobalVariables.shared.selectedProfileMode != "MatchMaking"{
            btn1.setImage(UIImage(named: "IC_logo_purple"), for: .normal)
            self.mainView.backgroundColor = UIColor(red: 0.835, green: 0.898, blue: 0.992, alpha: 1)
            self.navigationLabel.backgroundColor = UIColor(hex: "#031634")
            self.buttonSetPreference.setTitle("Set your filters", for: .normal)
            self.tableView.backgroundColor = UIColor(red: 0.835, green: 0.898, blue: 0.992, alpha: 1)
        } else {
            btn1.setImage(UIImage(named: "Ic_Logo_nav"), for: .normal)
            self.mainView.backgroundColor = UIColor(red: 0.871, green: 0.843, blue: 1, alpha: 1)
            self.navigationLabel.backgroundColor = UIColor(hex: "#AD9BFB")
            self.buttonSetPreference.setTitle("Set and save filters for others", for: .normal)
            self.tableView.backgroundColor = UIColor(red: 0.871, green: 0.843, blue: 1, alpha: 1)
        }
        btn1.frame = CGRect(x: 15, y: 0, width: 30, height: 30)
        leftItem.customView = btn1
        let space = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItems = [leftItem]
    }
    
    func addNavigationLeftButton() {
        toggleButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        if GlobalVariables.shared.selectedProfileMode != "MatchMaking"{
            toggleButton.setImage(UIImage(named: "ic_toggle"), for: .normal)
        } else {
            toggleButton.setImage(UIImage(named: "Ic_toggle_matching"), for: .normal)
        }
        toggleButton.addTarget(self, action: #selector(toggleButtonAction(_:)), for: .touchUpInside)
        barItem = UIBarButtonItem(customView: toggleButton)
        self.navigationItem.rightBarButtonItem = barItem
    }
    
    @objc func toggleButtonAction(_ sender: UIButton){
        viewModel.proceedForSwitchModeScreen()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: SearchTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SearchTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    

    @IBAction func setPreferenceButtonAction(_ sender: UIButton) {
        viewModel.proceedForNewSearch()
    }
    
    @IBAction func addMorePressed(_ sender: UIButton) {
        viewModel.proceedForNewSearch()
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let preferenceData = preferenceData else { return 0 }
        return preferenceData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier) as! SearchTableViewCell
        
        if let preferenceData = preferenceData, let id = preferenceData[indexPath.row]["id"] as? String,  let name = preferenceData[indexPath.row]["title"] as? String{
            cell.configure(id: id, index: indexPath.row, name: name)
        }
        
        cell.deleteActionCallBack = { [weak self] tag, id, title in
            guard let strongSelf = self else { return }
            let alert = UIAlertController(title: "", message: "Are you sure you want to delete within \(title)?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                strongSelf.viewModel.deleteSavedPreferences(params: ["id": id]) { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.preferenceData?.remove(at: indexPath.row)
                    strongSelf.tableView.reloadData()
                    if let preferenceData = strongSelf.preferenceData, preferenceData.isEmpty {
                        strongSelf.hide(tableView: true)
                    }
                }
                showSuccessMessage(with: StringConstants.deletedSuccessfully)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = strongSelf.view
                popoverController.sourceRect = CGRect(x: strongSelf.view.bounds.midX, y: strongSelf.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            strongSelf.viewModel.hostViewController.present(alert, animated: true, completion: nil)
        }
        
        cell.editActionCallBack = { [weak self] tag in
            guard let strongSelf = self else { return }
            strongSelf.viewModel.proceedForNewSearch(preferenceId: strongSelf.viewModel.preferenceIds[tag])
        }
        
        cell.allProfilesCallback = { [weak self] tag, id, name in
            guard let strongSelf = self else { return }
            KAPPSTORAGE.searchTabDetail = false
            KAPPSTORAGE.searchTab = false
            strongSelf.viewModel.proceedForSearchDetailsPager(id: id, name: name, isCome: "all")
        }
        
        cell.newProfilesCallback = { [weak self] tag, id, name in
            guard let strongSelf = self else { return }
            KAPPSTORAGE.searchTabDetail = false
            KAPPSTORAGE.searchTab = false
            strongSelf.viewModel.proceedForSearchDetailsPager(id: id, name: name, isCome: "new")
        }
        
        
        cell.selectionStyle = .none
        
        // Fill data to tableview cells item.
        if let preferenceData = preferenceData, let id = preferenceData[indexPath.row]["id"] as? String {
            viewModel.preferenceIds.append(id)
        }
        if let preferenceData = preferenceData, let title = preferenceData[indexPath.row]["title"] as? String {
            cell.labelTitle.text = title.capitalized
        }
        
        if let preferenceData = preferenceData, let dictAll = preferenceData[indexPath.row]["all"] as? [String: Any], let list = dictAll["list"] as? [[String: Any]], let dictNew = preferenceData[indexPath.row]["new"] as? [String: Any] {
            
            if dictAll["count"] as? Int == 0 && dictNew["count"] as? Int == 0 {
                cell.labelNoData.isHidden = false
                cell.noProfileButton.isHidden = false
                cell.stackViewImages.isHidden = true
                cell.buttonAllProfiles.isHidden = true
                cell.buttonNewProfiles.isHidden = true
                cell.labelProfiles.isHidden = true
                
            } else {
                cell.labelNoData.isHidden = true
                cell.noProfileButton.isHidden = true
                cell.stackViewImages.isHidden = false
                cell.buttonAllProfiles.isHidden = false
                cell.buttonNewProfiles.isHidden = false
                cell.labelProfiles.isHidden = false

                if dictAll["count"] as? Int != 0 {
                    cell.labelProfiles.isHidden = false
//                    cell.labelProfiles.text = "\(dictAll["count"] ?? 0) \("Profiles")"
                    viewModel.profileCount = "\(dictAll["count"] ?? 0) \("Profiles")"
                } else {
                    cell.labelProfiles.isHidden = true
                }
                
                if dictAll["count"] as? Int ?? 0 > 4 {
                    cell.labelProfilesCount.isHidden = false
                    cell.labelProfilesCount.text = "+\(dictAll["count"] as! Int - 4)"
                } else {
                    cell.labelProfilesCount.isHidden = true
                }
                
                if dictNew["count"] as? Int != 0 {
                    cell.buttonNewProfiles.setTitle("(\(dictNew["count"] ?? 0) \("New"))", for: .normal)
                    cell.buttonNewProfiles.isHidden = false
                } else {
                    cell.buttonNewProfiles.setTitle("", for: .normal)
                    cell.buttonNewProfiles.isHidden = true
                }
                
                for (index, value)  in list.enumerated() where index <= 3 {
                    if list.count == 1 {
                        cell.firstImage.isHidden = false
                    } else {
                        cell.secondImage.isHidden = true
                        cell.thirdImage.isHidden = true
                        cell.fourthImage.isHidden = true
                    }
                    if list.count == 2 {
                        cell.firstImage.isHidden = false
                        cell.secondImage.isHidden = false
                    } else {
                        cell.thirdImage.isHidden = true
                        cell.fourthImage.isHidden = true
                    }
                    if list.count == 3 {
                        cell.firstImage.isHidden = false
                        cell.secondImage.isHidden = false
                        cell.thirdImage.isHidden = false
                    } else {
                        cell.fourthImage.isHidden = true
                    }
                    if list.count > 3 {
                        cell.firstImage.isHidden = false
                        cell.secondImage.isHidden = false
                        cell.thirdImage.isHidden = false
                        cell.fourthImage.isHidden = false
                    } else {
                    }
                    if let userImageArray = value["userImages"] as? [[String: Any]] {
                        switch index {
                        case 0:
                            cell.firstImage.isHidden = false
                            // first image from the userImages
                            if let userImage = userImageArray[0]["file"] as? String {
                                let imageUrl: String = KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + userImage
                                cell.firstImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "Avatar"), options: .refreshCached)
                            } else {
                                cell.firstImage.image = #imageLiteral(resourceName: "Avatar")
                            }
                        case 1:
                            cell.secondImage.isHidden = false
                            // first image from the userImages
                            if let userImage = userImageArray[0]["file"] as? String {
                                let imageUrl: String = KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + userImage
                                cell.secondImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "Avatar"), options: .refreshCached)
                            } else {
                                cell.secondImage.image = #imageLiteral(resourceName: "Avatar")
                            }
                        case 2:
                            cell.thirdImage.isHidden = false
                            // first image from the userImages
                            if let userImage = userImageArray[0]["file"] as? String {
                                let imageUrl: String = KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + userImage
                                cell.thirdImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "Avatar"), options: .refreshCached)
                            } else {
                                cell.thirdImage.image = #imageLiteral(resourceName: "Avatar")
                            }
                        case 3:
                            cell.fourthImage.isHidden = false
                            // first image from the userImages
                            if let userImage = userImageArray[0]["file"] as? String {
                                let imageUrl: String = KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + userImage
                                cell.fourthImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "Avatar"), options: .refreshCached)
                            } else {
                                cell.fourthImage.image = #imageLiteral(resourceName: "Avatar")
                            }
                        default:
                            break
                        }
                    }
                }
            }
            
        }
        
        return cell
    }
}
