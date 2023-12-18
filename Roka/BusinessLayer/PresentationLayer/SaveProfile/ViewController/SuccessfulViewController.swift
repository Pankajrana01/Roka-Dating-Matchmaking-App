//
//  SuccessfulViewController.swift
//  Roka
//
//  Created by ios on 05/09/23.
//

import UIKit

class SuccessfulViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.saveProfile
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.Successful
    }
    
    lazy var viewModel: SuccessfulViewModel = SuccessfulViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    @IBOutlet weak var profileLabel: UILabel!
    var completionHandlerGoToDismiss: (() -> Void)?
    var callbacktopreviousscreen: (() -> ())?
    var status = ""
    var isFrom = ""
    
    class func show(over host: UIViewController,
                    completionHandler: @escaping ((String) -> Void)) {
        let controller = self.getController() as? SuccessfulViewController
        controller?.show(over: host, completionHandler: completionHandler)
    }
    
    func show(over host: UIViewController,
              completionHandler: @escaping ((String) -> Void)) {
        viewModel.completionHandler = completionHandler
        show(over: host, completionHandler: completionHandler)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if status != "" {
            self.profileLabel.text = status
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dismiss(animated: true) {
                self.callbacktopreviousscreen?()
                self.completionHandlerGoToDismiss?()
            }
        }
    }
}

class SuccessfulViewModel: BaseViewModel {
    var isComeFor = ""
    var completionHandler: ((String) -> Void)?
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    
    
  
}
