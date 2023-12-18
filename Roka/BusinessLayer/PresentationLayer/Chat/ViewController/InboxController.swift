//
//  InboxController.swift
//  Roka
//
//  Created by Applify  on 21/11/22.
//

import UIKit


class InboxController: BaseViewController {
    
    // MARK: - Variable
    @IBOutlet weak var inboxTableView: UITableView!
    @IBOutlet weak var viewNoData: UIView!

    // MARK: - ViewLifeCycle
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.chat
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.inbox
    }

    lazy var viewModel: InboxViewModel = InboxViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! InboxController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.hidesBottomBarWhenPushed = true
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        inboxTableView.register(UINib(nibName: InboxCell.identifier, bundle: nil), forCellReuseIdentifier: InboxCell.identifier)
        inboxTableView.delegate = self
        inboxTableView.dataSource = self
        self.viewNoData.isHidden = self.viewModel.chatRooms.count != 0

        viewModel.fetchAllChats {
            self.viewNoData.isHidden = self.viewModel.chatRooms.count != 0
            self.inboxTableView.reloadData()
            self.refreshChatIcon(chatRooms: self.viewModel.chatRooms)
        }
        viewModel.observeIfChatRoomAdded {
            self.viewNoData.isHidden = self.viewModel.chatRooms.count != 0
            self.inboxTableView.reloadData()
            self.refreshChatIcon(chatRooms: self.viewModel.chatRooms)
        }
        viewModel.observeIfChatRoomChanged {
            self.viewNoData.isHidden = self.viewModel.chatRooms.count != 0
            self.inboxTableView.reloadData()
            self.refreshChatIcon(chatRooms: self.viewModel.chatRooms)
        }
        viewModel.observeIfChatRoomRemoved {
            self.viewNoData.isHidden = self.viewModel.chatRooms.count != 0
            self.inboxTableView.reloadData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updatePremiumStatusForAllDialogs), name: .premiumPlan, object: nil)
        
        // This need to add to add someextra spcae to botton in table view
        self.inboxTableView.contentInset = UIEdgeInsets(top: 0, left: 0,bottom: CGFloat(20),right: 0)
    }
    
    @objc func updatePremiumStatusForAllDialogs() {
        viewModel.chatRooms.forEach { model in
            var chatModel = model
            chatModel.premium_status?[UserModel.shared.user.id] = 1
            FirestoreManager.upgradePremiumStatusOnFirebase(chatRoom: model)
        }
    }
    
    func refreshChatIcon(chatRooms:[ChatRoomModel]) {
        var chatDataDict = [String: Int]()
        for model in chatRooms{
            let unreadCount = model.unread_count?[UserModel.shared.user.id] ?? 0
            if unreadCount > 0 {
                chatDataDict["unreadCount"] = unreadCount
                break
            } else {
                chatDataDict["unreadCount"] = 0
            }
        }
        NotificationCenter.default.post(name: .updateChatIcon, object: nil, userInfo: chatDataDict)
    }
    
    func applyFiters() {
        guard let filterVC = self.storyboard?.instantiateViewController(withIdentifier: FilterViewController.identifier) as? FilterViewController else { return }
        filterVC.selection = viewModel.dataFilterStatus
        filterVC.modalPresentationStyle = .overFullScreen
        filterVC.filterApply = { filter in
            self.viewModel.dataFilterStatus = filter
            self.viewModel.applyFilters(handler: {
                self.viewNoData.isHidden = self.viewModel.dataFilterStatus == "All" ? self.viewModel.chatRooms.count != 0 : self.viewModel.filteredChatRooms.count != 0
                self.inboxTableView.reloadData()
            })
        }
        self.present(filterVC, animated: true)
    }
    

    func searchAction(text:String) {
        self.viewModel.searchAction(text: text) {
            self.viewNoData.isHidden = self.viewModel.searchedText.count > 0 ? self.viewModel.searchListArray.count != 0 : self.viewModel.dataFilterStatus == "All" ? self.viewModel.chatRooms.count != 0 : self.viewModel.filteredChatRooms.count != 0
            self.inboxTableView.reloadData()
        }
    }
}

// MARK: -  UITableViewDelegate & UITableViewDataSource
extension InboxController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.searchedText.count > 0 ? self.viewModel.searchListArray.count : viewModel.dataFilterStatus == "All" ? viewModel.chatRooms.count : viewModel.filteredChatRooms.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: InboxCell.identifier, for: indexPath) as? InboxCell{
            let model = self.viewModel.searchedText.count > 0 ? self.viewModel.searchListArray[indexPath.row] : viewModel.dataFilterStatus == "All" ? viewModel.chatRooms[indexPath.row] : viewModel.filteredChatRooms[indexPath.row]
            cell.setUpInbox(model: model)
            return cell
        }
        return UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.viewModel.searchedText.count > 0 ? self.viewModel.searchListArray[indexPath.row] : viewModel.dataFilterStatus == "All" ? viewModel.chatRooms[indexPath.row] : viewModel.filteredChatRooms[indexPath.row]
        ChatViewController.show(from: self, forcePresent: false, chatRoom: model)
    }
}
