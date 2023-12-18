//
//  InviteController.swift
//  Roka
//
//  Created by Applify  on 21/11/22.
//

import UIKit

class InviteController: BaseViewController {
    
    // MARK: - Variable
    @IBOutlet weak var otherTableView: UITableView!
    @IBOutlet weak var viewNoData: UIView!

    // MARK: - ViewLifeCycle
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.chat
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.other
    }

    lazy var viewModel: ChatInviteViewModel = ChatInviteViewModel(hostViewController: self)

    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! InviteController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.hidesBottomBarWhenPushed = true
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    override func viewDidLoad() {
        otherTableView.register(UINib(nibName: ChatInviteCell.identifier, bundle: nil), forCellReuseIdentifier: ChatInviteCell.identifier)
        otherTableView.delegate = self
        otherTableView.dataSource = self
        
        self.viewNoData.isHidden = self.viewModel.chatRooms.count != 0

        viewModel.fetchAllChats {
            self.viewNoData.isHidden = self.viewModel.chatRooms.count != 0
            self.otherTableView.reloadData()
        }
        viewModel.observeIfChatRoomAdded {
            self.viewNoData.isHidden = self.viewModel.chatRooms.count != 0
            self.otherTableView.reloadData()
        }
        viewModel.observeIfChatRoomChanged {
            self.viewNoData.isHidden = self.viewModel.chatRooms.count != 0
            self.otherTableView.reloadData()
        }
        viewModel.observeIfChatRoomRemoved {
            self.viewNoData.isHidden = self.viewModel.chatRooms.count != 0
            self.otherTableView.reloadData()
        }
        
        // This need to add to add someextra spcae to botton in table view
        self.otherTableView.contentInset = UIEdgeInsets(top: 0, left: 0,bottom: CGFloat(20),right: 0)

    }
    
    func searchAction(text:String) {
        self.viewModel.searchAction(text: text) {
            self.viewNoData.isHidden = self.viewModel.searchedText.count > 0 ? self.viewModel.searchListArray.count != 0 : self.viewModel.chatRooms.count != 0
            self.otherTableView.reloadData()
        }
    }
}

extension InviteController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.searchedText.count > 0 ? self.viewModel.searchListArray.count : viewModel.chatRooms.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ChatInviteCell.identifier, for: indexPath) as? ChatInviteCell{
            let model = self.viewModel.searchedText.count > 0 ? self.viewModel.searchListArray[indexPath.row] : viewModel.chatRooms[indexPath.row]
            cell.chatInviteData = model
            cell.acceptPressed = { userId in
                self.viewModel.processForLikeProfileData(id: userId, isLiked: 1, model: model)
            }
            cell.rejectPressed = { userId in
                self.viewModel.processForLikeProfileData(id: userId, isLiked: 0, model: model)
            }
            cell.acceptBtn.tintColor = UIColor.black
            return cell
        }
        return UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.viewModel.searchedText.count > 0 ? self.viewModel.searchListArray[indexPath.row] : viewModel.chatRooms[indexPath.row]
        NotificationCenter.default.post(name: .updateChatIcon, object: nil)
        ChatViewController.show(from: self, forcePresent: false, chatRoom: model)
    }
}
