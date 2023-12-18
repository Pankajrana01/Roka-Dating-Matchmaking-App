//
//  GroupDetailViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 26/12/22.
//

import UIKit

class GroupDetailViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.groupChat
        
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.groupDetail
    }

    lazy var viewModel: GroupDetailViewModel = GroupDetailViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    chatRoom: ChatRoomModel,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! GroupDetailViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.viewModel.chatRoom = chatRoom
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var topStaticLabel: UILabel!

    @IBOutlet weak var exitGroupBtn: UIButton!
    @IBOutlet weak var leaveGroupBtn: UIButton!
    @IBOutlet weak var exitStackHeightConst: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
       // showNavigationBackButton(title: "   Group details")
        addNavigationBackButton()
        
        self.navigationController?.isNavigationBarHidden = false
        viewModel.setupMembers()
        viewModel.tableView = tableView

        if UserModel.shared.user.id == self.viewModel.chatRoom?.dialog_admin {
            self.title = "Group details"
            self.exitStackHeightConst.constant = 120
            self.leaveGroupBtn.isHidden = false
        }else{
            self.title = "Group Info"
            self.exitStackHeightConst.constant = 50
            self.leaveGroupBtn.isHidden = true
        }
        self.addNavigationEditButton()
        // Do any additional setup after loading the view.
    }
    
    func addNavigationEditButton() {
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        if GlobalVariables.shared.selectedProfileMode == "MatchMaking" {
            btn2.setImage(UIImage(named: "Edit_New"), for: .normal)
        }else{
            btn2.setImage(UIImage(named: "new_White_Edit"), for: .normal)
        }
        btn2.addTarget(self, action: #selector(editButtonTapped(_:)), for:.touchUpInside)
        let barButton = UIBarButtonItem(customView: btn2)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func editButtonTapped(_ sender: UIButton){
        viewModel.proceedForEditGroupDetail()
    }
    
    func setupExitAndLeaveBtnState(){
        if viewModel.members.count > 0{
            
        }else{
            self.leaveGroupBtn.isHidden = false
            self.exitGroupBtn.isHidden = true
        }
    }
    
    func addNavigationBackButton() {
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        if GlobalVariables.shared.selectedProfileMode == "MatchMaking" {
            btn2.setImage(UIImage(named: "Ic_back_1"), for: .normal)
            self.topStaticLabel.backgroundColor = UIColor.loginBlueColor
        }else{
            self.topStaticLabel.backgroundColor = UIColor.appTitleBlueColor
            btn2.setImage(UIImage(named: "ic_back_white"), for: .normal)
        }
        btn2.addTarget(self, action: #selector(backkButtonTapped(_:)), for:.touchUpInside)
        let barButton = UIBarButtonItem(customView: btn2)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func backkButtonTapped(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func exitGroupAction(_ sender: UIButton) {
        if UserModel.shared.user.id == viewModel.chatRoom?.dialog_admin {
            viewModel.exitButtonActionClick()
        }
    }
    
    @IBAction func leaveGroupAction(_ sender: UIButton) {
        viewModel.leaveAndDeleteActionClicked()
    }
}
