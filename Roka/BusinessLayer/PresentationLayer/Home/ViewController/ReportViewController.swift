//
//  ReportViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 14/10/22.
//

import UIKit
import Contacts

class ReportViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.home
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.report
    }

    lazy var viewModel: ReportViewModel = ReportViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    id: String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! ReportViewController
        controller.hidesBottomBarWhenPushed = true
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.viewModel.id = id
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reportTextField: UnderlinedTextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.tableView = tableView
        viewModel.reportTextField = reportTextField
        viewModel.reportButton = reportButton
        self.reportTextField.delegate = self
        self.navigationController?.isNavigationBarHidden = true
       // showNavigationBackButton(title: "  Report Profile")
        viewModel.processForGetReportData()
        //viewModel.enableDisableNextButton()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func reportButtonAction(_ sender: UIButton) {
        viewModel.reportPofileButtonAction()
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
       // self.dismiss(animated: true)
    }
    

}

extension ReportViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 100
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        return newString.count <= maxLength
    }
}
