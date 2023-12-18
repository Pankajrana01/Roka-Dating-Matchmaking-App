//
//  NotificationsViewController.swift
//  Roka
//
//  Created by  Developer on 26/10/22.
//

import UIKit

class NotificationsViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.notifications
        
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.notifications
    }

    lazy var viewModel: NotificationsViewModel = NotificationsViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! NotificationsViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.hidesBottomBarWhenPushed = true
        controller.show(from: viewController, forcePresent: forcePresent)
    }

    @IBOutlet weak var topView: UILabel!
    @IBOutlet weak var tableView: UITableView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        if GlobalVariables.shared.selectedProfileMode != "MatchMaking"{
            addNavigationBackButton()
            self.topView.backgroundColor = UIColor.appTitleBlueColor
        } else {
            addNavigatioBlacknBackButton()
            self.topView.backgroundColor = UIColor(hex: "#AD9BFB")
        }
       
        
        self.title = "Notifications"
        //showNavigationBackButton(title: "  Notifications")
        setupTableView()
    }
    
    func addNavigationBackButton() {
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn2.setImage(UIImage(named: "ic_back_white"), for: .normal)
        btn2.addTarget(self, action: #selector(backkButtonTapped(_:)), for:.touchUpInside)
        let barButton = UIBarButtonItem(customView: btn2)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    func addNavigatioBlacknBackButton() {
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn2.setImage(UIImage(named: "Ic_back_1"), for: .normal)
        btn2.addTarget(self, action: #selector(backkButtonTapped(_:)), for:.touchUpInside)
        let barButton = UIBarButtonItem(customView: btn2)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func backkButtonTapped(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getNotificaitons { [weak self] result in
            guard let strongSelf = self else { return }
            guard let result = result else { return }
            for (index, model) in strongSelf.viewModel.modelArray.enumerated() {
                switch (index) {
                case 0:
                    if let matches = result["matches"] as? Int {
                        model.isOn = matches
                    }
                case 1:
                    if let messages = result["messages"] as? Int {
                        model.isOn = messages
                    }
                case 2:
                    if let likes = result["likes"] as? Int {
                        model.isOn = likes
                    }
                case 3:
                    if let subscriptionReminder = result["subscriptionReminder"] as? Int {
                        model.isOn = subscriptionReminder
                    }
                default:
                    break
                }
            
            }
            strongSelf.tableView.reloadData()
        }
    }
    
    // MARK: - Registering the cell...
    private func setupTableView() {
        tableView.register(UINib(nibName: NotificationsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NotificationsTableViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.modelArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellNotifications = tableView.dequeueReusableCell(withIdentifier: NotificationsTableViewCell.identifier) as! NotificationsTableViewCell
        cellNotifications.configure(model: viewModel.modelArray[indexPath.row], indexPath: indexPath)
        cellNotifications.onSwitchClicked = { [weak self] (tag, isOn) in
            guard let strongSelf = self else { return }
            var param: [String: Int] = [:]
            switch tag {
            case 0:
                param = [ "matches": isOn,
                          "messages": strongSelf.viewModel.modelArray[1].isOn,
                          "likes": strongSelf.viewModel.modelArray[2].isOn,
                          "subscriptionReminder": strongSelf.viewModel.modelArray[3].isOn]
            case 1:
                param = ["matches": strongSelf.viewModel.modelArray[0].isOn,
                "messages": isOn,
                         "likes": strongSelf.viewModel.modelArray[2].isOn,
                         "subscriptionReminder": strongSelf.viewModel.modelArray[3].isOn]
            case 2:
                param = ["matches": strongSelf.viewModel.modelArray[0].isOn,
                         "messages": strongSelf.viewModel.modelArray[1].isOn,
                "likes": isOn,
                         "subscriptionReminder": strongSelf.viewModel.modelArray[3].isOn]
            case 3:
                param = ["matches": strongSelf.viewModel.modelArray[0].isOn,
                         "messages": strongSelf.viewModel.modelArray[1].isOn,
                         "likes": strongSelf.viewModel.modelArray[2].isOn,
                "subscriptionReminder": isOn]
            default: break
            }

            strongSelf.viewModel.updateNotifications(params: param) {
                strongSelf.viewModel.modelArray[indexPath.row].isOn = 1 - strongSelf.viewModel.modelArray[indexPath.row].isOn
                strongSelf.tableView.reloadData()
            }
        }
        return cellNotifications
    }    
}
