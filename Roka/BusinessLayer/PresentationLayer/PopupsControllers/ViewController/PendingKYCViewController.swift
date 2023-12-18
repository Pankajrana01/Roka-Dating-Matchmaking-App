//
//  PendingKYCViewController.swift
//  Roka
//
//  Created by  Developer on 03/01/23.
//

import UIKit

class PendingKYCViewController: BaseAlertViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.popups
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.pendingKYC
    }

    lazy var viewModel: PendingKYCViewModel = PendingKYCViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(over host: UIViewController,
                    completionHandler: @escaping ((String) -> Void)) {
        let controller = self.getController() as! PendingKYCViewController
        controller.show(over: host, completionHandler: completionHandler)
    }
    
    func show(over host: UIViewController,
              completionHandler: @escaping ((String) -> Void)) {
        viewModel.completionHandler = completionHandler
        show(over: host)
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var labelName: UILabel!

    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelName.text = "Hi \(viewModel.storedUser?.firstName ?? "") " + "\(viewModel.storedUser?.lastName ?? "")"
    }
    
    // MARK: - IBActions
    @IBAction func dismissButtonAction(_ sender: UIButton) {
        self.dismiss()
    }
    
    @IBAction func completeYourKYCAction(_ sender: UIButton) {
        self.dismiss()
        viewModel.proceedForVerifyKycScreen()
    }
    
    @IBAction func iWillDoItLaterAction(_ sender: UIButton) {
        self.dismiss()
    }
}
