//
//  RecoveryEmailViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 21/09/22.
//

import UIKit

class RecoveryEmailViewController: BaseAlertViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.basicInfo
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.recoveryEmail
    }
    
    lazy var viewModel: RecoveryEmailModel = RecoveryEmailModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(over host: UIViewController,
                    completionHandler: @escaping (() -> Void)) {
        let controller = self.getController() as! RecoveryEmailViewController
        controller.show(over: host, completionHandler: completionHandler)
    }
    
    func show(over host: UIViewController,
              completionHandler: @escaping (() -> Void)) {
        viewModel.completionHandler = completionHandler
        show(over: host)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss()
    }
    @IBAction func gotItButtonAction(_ sender: UIButton) {
        self.dismiss()
    }
    
}
