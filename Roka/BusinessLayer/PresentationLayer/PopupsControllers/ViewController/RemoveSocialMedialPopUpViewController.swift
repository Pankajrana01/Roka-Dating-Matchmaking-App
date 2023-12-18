//
//  RemoveSocialMedialPopUpViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 04/01/23.
//

import UIKit

class RemoveSocialMedialPopUpViewController: BaseAlertViewController {
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.popups
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.removeSocialMedia
    }

    lazy var viewModel: RemoveSocialMedialPopUpViewModel = RemoveSocialMedialPopUpViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func getController(with title: String) -> BaseViewController {
        let controller = self.getController() as! RemoveSocialMedialPopUpViewController
        controller.viewModel.titleName = title
        controller.hidesBottomBarWhenPushed = true
        return controller
    }
    class func show(over host: UIViewController,
                    completionHandler: @escaping ((String) -> Void)) {
        let controller = self.getController() as! RemoveSocialMedialPopUpViewController
        controller.show(over: host, completionHandler: completionHandler)
    }
    
    func show(over host: UIViewController,
              completionHandler: @escaping ((String) -> Void)) {
        viewModel.completionHandler = completionHandler
        show(over: host)
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        label.text = "Are you sure you want to remove your \(viewModel.titleName) account?"
    }
    

    @IBAction func noAction(_ sender: UIButton) {
        self.dismiss()
    }
    
    @IBAction func yesAction(_ sender: UIButton) {
        self.dismiss()
        dismissCompletion?("yes")
    }
}
