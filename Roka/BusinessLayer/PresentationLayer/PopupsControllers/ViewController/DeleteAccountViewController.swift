//
//  DeleteAccountViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 22/11/22.
//

import UIKit

class DeleteAccountViewController: BaseAlertViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.popups
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.deleteAccount
    }

    lazy var viewModel: DeleteAccountViewModel = DeleteAccountViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(over host: UIViewController,
                    isComeFrom : String,
                    friendId : String,
                    completionHandler: @escaping ((String) -> Void)) {
        let controller = self.getController() as! DeleteAccountViewController
        controller.show(over: host, isComeFrom: isComeFrom, friendId: friendId, completionHandler: completionHandler)
    }
    
    func show(over host: UIViewController,
              isComeFrom : String,
              friendId : String,
              completionHandler: @escaping ((String) -> Void)) {
        viewModel.completionHandler = completionHandler
        viewModel.isComeFrom = isComeFrom
        viewModel.friendId = friendId
        show(over: host)
    }

    @IBOutlet weak var containerViewheight: NSLayoutConstraint!
    @IBOutlet weak var deleteAccountLbl: UILabel!
    @IBOutlet weak var Areyousurelable: UILabel!
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var confirmTextField: SearchTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.confirmTextField = confirmTextField
        
        if viewModel.isComeFrom == "EditFriendProfile" {
            deleteAccountLbl.text = "Delete profile"
            containerViewheight.constant = 380 - 60
            confirmView.isHidden = true
            Areyousurelable.text = "Do you want to delete this profile?"
        } else {
            deleteAccountLbl.text = "Delete account"
            containerViewheight.constant = 450
            confirmView.isHidden = false
            Areyousurelable.text = "Are you sure you want to delete your account? Please type CONFIRM to delete account."
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func cancelAction(_ sender: UIButton) {
        self.dismiss()
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        if viewModel.isComeFrom == "EditFriendProfile" && viewModel.friendId != "" {
            viewModel.processForDeleteFriendProfile(id: viewModel.friendId) { result in
                if result == "yes" {
                    self.dismiss(msg: "yes")
                } else {
                    self.dismiss(msg: "no")
                }
            }
        } else {
            viewModel.processForDeleteUserData { result in
            }
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss()
    }
  
}
