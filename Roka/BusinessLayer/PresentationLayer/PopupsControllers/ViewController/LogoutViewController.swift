//
//  LogoutViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 03/10/22.
//

import UIKit

class LogoutViewController: BaseAlertViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.popups
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.logout
    }

    lazy var viewModel: LogoutViewModel = LogoutViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(over host: UIViewController,
                    completionHandler: @escaping ((String) -> Void)) {
        let controller = self.getController() as! LogoutViewController
        controller.show(over: host, completionHandler: completionHandler)
    }
    
    func show(over host: UIViewController,
              completionHandler: @escaping ((String) -> Void)) {
        viewModel.completionHandler = completionHandler
        show(over: host)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func cancelAction(_ sender: UIButton) {
        self.dismiss()
    }
    
    @IBAction func logoutAction(_ sender: UIButton) {
        viewModel.processForLogoutData()
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss()
    }
  
}
