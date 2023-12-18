//
//  BroadCastPushViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 28/11/22.
//

import UIKit

class BroadCastPushViewController: BaseAlertViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.popups
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.broadcast
    }

    lazy var viewModel: BroadCastPushViewModel = BroadCastPushViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(over host: UIViewController, userInfo: [AnyHashable: Any], isCome: String, title: String, desc: String,
                    completionHandler: @escaping ((String) -> Void)) {
        let controller = self.getController() as! BroadCastPushViewController
        controller.show(over: host, userInfo: userInfo, isCome: isCome, title: title, desc: desc, completionHandler: completionHandler)
    }
    
    func show(over host: UIViewController, userInfo: [AnyHashable: Any], isCome: String, title: String, desc: String,
              completionHandler: @escaping ((String) -> Void)) {
        viewModel.completionHandler = completionHandler
        viewModel.userInfo = userInfo
        viewModel.isCome = isCome
        viewModel.title = title
        viewModel.desc = desc
        show(over: host)
    }

    @IBOutlet weak var descLable: UILabel!
    @IBOutlet weak var titleLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel.isCome == "NotificationViewController" {
            titleLable.text = viewModel.title
            descLable.text = viewModel.desc
        } else {
            if viewModel.userInfo.count != 0 {
                titleLable.text = viewModel.userInfo["title"] as? String ?? "Title"
                descLable.text = viewModel.userInfo["message"] as? String ?? "Broadcast"
            }
        }
        
        // Do any additional setup after loading the view.
    }
   
    @IBAction func okButtonAction(_ sender: UIButton) {
        self.dismiss()
    }
    
}
