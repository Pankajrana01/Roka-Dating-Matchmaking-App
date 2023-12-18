//
//  SelectCountryViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 23/09/22.
//

import UIKit

class SelectCountryViewController: BaseAlertViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.popups
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.selectCounrty
    }

    lazy var viewModel: SelectCountryViewModel = SelectCountryViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(over host: UIViewController,
                    isCurrentCountryCode : String,
                    completionHandler: @escaping ((String) -> Void)) {
        let controller = self.getController() as! SelectCountryViewController
        controller.show(over: host, isCurrentCountryCode: isCurrentCountryCode, completionHandler: completionHandler)
    }
    
    func show(over host: UIViewController,
              isCurrentCountryCode : String,
              completionHandler: @escaping ((String) -> Void)) {
        viewModel.completionHandler = completionHandler
        viewModel.isCurrentCountryCode = isCurrentCountryCode
        show(over: host)
    }
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.tableView = tableView
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonActiob(_ sender: UIButton) {
        viewModel.saveButtonAction()
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss()
    }

}
