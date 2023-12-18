//
//  ShareViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 14/10/22.
//

import UIKit
import Contacts
class ShareViewController: BaseAlertViewController {
    var createGroupPressed: (() -> Void)?

    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.share
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.share
    }

    lazy var viewModel: ShareViewModel = ShareViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(over host: UIViewController,
                    profileArray: [ProfilesModel],
                    completionHandler: @escaping (String) -> Void) {
        let controller = self.getController() as! ShareViewController
//        controller.viewModel.profileArray.removeAll()
        controller.viewModel.completionHandler = completionHandler
        controller.show(over: host, profileArray: profileArray)
    }
    func show(over host: UIViewController, profileArray: [ProfilesModel]) {
        viewModel.profiles = profileArray
        show(over: host)
    }
    
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var thirdImage: UIImageView!
    @IBOutlet weak var fourthImage: UIImageView!
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelShareCount: UILabel!
    
    var callBackToMainScreem: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.txtField = txtField
        viewModel.tableView = tableView
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        askUserForContactsPermission()
        switch viewModel.profiles.count {
        case 1:
            self.firstImage.isHidden = false
            self.secondImage.isHidden = true
            self.thirdImage.isHidden = true
            self.fourthImage.isHidden = true
            self.labelCount.isHidden = true
            break
        case 2:
            self.firstImage.isHidden = false
            self.secondImage.isHidden = false
            self.thirdImage.isHidden = true
            self.fourthImage.isHidden = true
            self.labelCount.isHidden = true
            break
        case 3:
            self.firstImage.isHidden = false
            self.secondImage.isHidden = false
            self.thirdImage.isHidden = false
            self.fourthImage.isHidden = true
            self.labelCount.isHidden = true
            break
        case 4:
            self.firstImage.isHidden = false
            self.secondImage.isHidden = false
            self.thirdImage.isHidden = false
            self.fourthImage.isHidden = false
            self.labelCount.isHidden = true
            break
        default:
            self.firstImage.isHidden = false
            self.secondImage.isHidden = false
            self.thirdImage.isHidden = false
            self.fourthImage.isHidden = false
            self.labelCount.isHidden = false
            break
        }
        setUpProfileImage()
        self.labelShareCount.text = "Share \(viewModel.profiles.count) " + (viewModel.profiles.count > 1 ? "profiles" : "profile")
        self.labelCount.text = "\(viewModel.profiles.count - 4)"
    }
    
    private func setUpProfileImage() {
        for (index, _) in viewModel.profiles.enumerated() {
            let images = viewModel.profiles[index].userImages?.filter({($0.file != "" && $0.file != "<null>" && $0.isDp == 1)})
            if let images = images, !images.isEmpty {
                let image = images[0]
                let urlstring = image.file ?? ""
                let trimmedString = urlstring.replacingOccurrences(of: " ", with: "%20")
                
                switch index {
                case 0:
                    self.firstImage.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + trimmedString)), placeholderImage: #imageLiteral(resourceName: "Avatar"), completed: nil)
                    break
                case 1:
                    self.secondImage.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + trimmedString)), placeholderImage: #imageLiteral(resourceName: "Avatar"), completed: nil)
                    break
                case 2:
                    self.thirdImage.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + trimmedString)), placeholderImage: #imageLiteral(resourceName: "Avatar"), completed: nil)
                    break
                case 3:
                    self.fourthImage.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + trimmedString)), placeholderImage: #imageLiteral(resourceName: "Avatar"), completed: nil)
                    break
                default:
                    break
                }
            }
        }
    }
    
    private func askUserForContactsPermission() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted: Bool, err: Error?) in
            if let err = err {
                print("Failed to request access with error \(err)")
                return
            }
            if granted {
                print("User has granted permission for contacts")

                self.viewModel.contactsVM.fetchContacts { status in
                    if status == "success"{
                        self.viewModel.contactsVM.updateContacts { status in
                            if status == "success"{
                                self.viewModel.processForUpdateUserContactsData { results in }
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("Access denied..")
            }
        }
    }
    
    @IBAction func createGroupAction(_ sender: UIButton) {
        self.dismiss(msg: "CreateGroup")
        self.viewModel.completionHandler?("CreateGroup")
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
        self.dismiss(msg: "")
        self.viewModel.completionHandler?("")
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(msg: "")
       // self.viewModel.completionHandler?("")
    }
    
}
