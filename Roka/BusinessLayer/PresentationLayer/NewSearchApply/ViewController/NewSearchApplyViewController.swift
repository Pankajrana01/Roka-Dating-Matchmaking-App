//
//  NewSearchApplyViewController.swift
//  Roka
//
//  Created by  Developer on 04/11/22.
//

import UIKit

class NewSearchApplyViewController: BaseAlertViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.newSearchApply
        
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.newSearchApply
    }

    lazy var viewModel: NewSearchApplyViewModel = NewSearchApplyViewModel(hostViewController: self)

    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! NewSearchApplyViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var titleField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        KAPPSTORAGE.searchTab = false
        titleField.delegate = self
        titleField.text = viewModel.filteredData["title"] as? String
        titleField.leftPadding = 8
        if GlobalVariables.shared.selectedProfileMode != "MatchMaking"{
            self.saveButton.setTitleColor(.white, for: .normal)
            self.saveButton.backgroundColor = UIColor(hex: "#031634")
        } else {
            self.saveButton.setTitleColor(UIColor(hex: "#031634"), for: .normal)
            self.saveButton.setTitle("Apply", for: .normal)
            self.saveButton.backgroundColor = UIColor(hex: "#AD9BFB")
        }
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.dismiss()
    }
    
    @IBAction func cancelClicked(_ sender: UIButton) {
        self.dismiss()
    }
    
    @IBAction func saveClicked(_ sender: UIButton) {
       // viewModel.proceedForPreference()
        guard let title = titleField.text, !title.isEmpty else {
            showMessage(with: StringConstants.savetitleCantEmpty)
            return
        }
        if title == viewModel.filteredData["title"] as? String {
            viewModel.filteredData["title"] = ""
        }
        else {
            viewModel.filteredData["title"] = title
        }
        if let minHeight = viewModel.filteredData["minHeight"] {
            viewModel.filteredData["minHeight"] = "\(minHeight)"
        }
        if let maxHeight = viewModel.filteredData["maxHeight"] {
            viewModel.filteredData["maxHeight"] = "\(maxHeight)"
        }
        
        viewModel.filteredData["userType"] = "\(GlobalVariables.shared.selectedProfileMode != "MatchMaking" ? 1 : 2)"
        
        viewModel.processUserSearchPreferences(params: viewModel.filteredData) { status in
            if status == "success" {
                KAPPSTORAGE.searchTab = true
                KAPPSTORAGE.searchBackCheck = true
                NotificationCenter.default.post(name: .refreshSavedPreferences, object: nil)
                self.dismiss()
                if !self.viewModel.preferenceId.isEmpty {
                    NotificationCenter.default.post(name: .refreshEditSavedPreferences, object: nil)
                }
            }
        }
    }
}

extension NewSearchApplyViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 30
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        return newString.count <= maxLength
    }
}
