//
//  NotificationViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 14/10/22.
//

import UIKit

class NotificationViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.notification
        
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.notification
    }

    lazy var viewModel: NotificationViewModel = NotificationViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! NotificationViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.show(from: viewController, forcePresent: forcePresent)
    }

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var barItem = UIBarButtonItem()
    var leftItem = UIBarButtonItem()
    var currentPage = 0
    var isMoreRecordAvailable = false
    
    @IBOutlet weak var topStaticLbl: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        showLeftNavigationLogo()
        
        var params = [String:Any]()
        params["limit"] = "10"
        params["skip"] = 0
        self.executeAPI(params: params)
        
        NotificationCenter.default.post(name: .updateNotificationIcon, object: nil)
    }
    
    func showLeftNavigationLogo() {
        let btn1 = UIButton()
        if GlobalVariables.shared.selectedProfileMode == "MatchMaking" {
            btn1.setImage(UIImage(named: "Ic_Logo_nav"), for: .normal)
            btn1.frame = CGRect(x: 15, y: 0, width: 30, height: 30)
            self.topStaticLbl.backgroundColor = UIColor.loginBlueColor
        }else{
            btn1.setImage(UIImage(named: "IC_logo_purple"), for: .normal)
            btn1.frame = CGRect(x: 15, y: 0, width: 30, height: 30)
            self.topStaticLbl.backgroundColor = UIColor.appTitleBlueColor
        }
        leftItem.customView = btn1
        let space = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItems = [leftItem]
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: NotificationTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NotificationTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func executeAPI(params: [String : Any]) {
        viewModel.processForGetNotifications(parmas: params) { [weak self] data in
            guard let strongSelf = self else { return }
            // if data present then show notificationView
            // otherwise show backgroundView
            guard let data = data, data.data?.count != 0, let rows = data.data?.rows else {
                if strongSelf.currentPage == 0 {
                    strongSelf.isMoreRecordAvailable = false
                    strongSelf.viewModel.notifications.removeAll()
                }
                
                strongSelf.backgroundView.isHidden = false
                strongSelf.notificationView.isHidden = true
                strongSelf.tableView.isHidden = true
                return
            }
            
            if strongSelf.currentPage == 0 {
                strongSelf.isMoreRecordAvailable = false
                strongSelf.viewModel.notifications.removeAll()
            }
            
            if rows.count == 10 {
                strongSelf.isMoreRecordAvailable = true
            } else {
                strongSelf.isMoreRecordAvailable = false
            }
            
            strongSelf.viewModel.notifications.append(contentsOf: rows)
            
            strongSelf.backgroundView.isHidden = true
            strongSelf.notificationView.isHidden = false
            strongSelf.tableView.isHidden = false
            
            DispatchQueue.main.async {
                strongSelf.tableView.reloadData()
            }
        }
    }
    
    func readNotification(id:String, isRead:Int, index:Int){
        var params = [String:Any]()
        params["id"] = id
        params["isRead"] = isRead
        viewModel.processForReadNotificationData(parms: params) { result in
            self.viewModel.notifications[index].isRead = 1
            self.tableView.reloadData()
            NotificationCenter.default.post(name: .updateNotificationIcon, object: nil)
        }
    }
}

extension NotificationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleNotification = viewModel.notifications[indexPath.row]
        
        DispatchQueue.global(qos: .background).async {
            if singleNotification.isRead == 0{
                self.readNotification(id: singleNotification.id ?? "", isRead: 1, index: indexPath.row)
            }
        }
        
        if let notificationType = singleNotification.notificationType {
            switch notificationType {
            case 0:
                viewModel.proceedForNotificationPopupView(title: singleNotification.title ?? "", description: singleNotification.message ?? "")
            case 8:
                viewModel.proceedForVerifyKycScreen()
            
            case 5:
                viewModel.proceedForMatchedProfileScreen(notification: singleNotification)
            
            case 1:
                viewModel.getLikedProfileData(notification: singleNotification)
            
            case 12:
                viewModel.proceedForReferAndEarnScreen()
            
            case 13:
                viewModel.proceedForMySubscriptionScreen()
                
            case 14:
                viewModel.proceedForMySubscriptionScreen()

            default:
                break
            }
        }
    }
}


extension NotificationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.identifier, for: indexPath) as! NotificationTableViewCell
        cell.configure(model: viewModel.notifications[indexPath.row])
        
        let singleNotification = viewModel.notifications[indexPath.row]
        if let notificationType = singleNotification.notificationType {
            if notificationType == 0 || notificationType == 8{
                cell.DescImage.isHidden = true
            } else {
                cell.DescImage.isHidden = false
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.viewModel.notifications.count - 1 &&                     self.isMoreRecordAvailable {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.currentPage = self.viewModel.notifications.count
                var params = [String:Any]()
                params["limit"] = "10"
                params["skip"] = self.currentPage
                self.executeAPI(params: params)
            }
        }
    }
}
