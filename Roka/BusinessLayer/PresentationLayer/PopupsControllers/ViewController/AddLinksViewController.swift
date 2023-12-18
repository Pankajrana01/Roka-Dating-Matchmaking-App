//
//  AddLinksViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 31/10/22.
//

import UIKit

class AddLinksViewController: BaseAlertViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.popups
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.addLinks
    }

    lazy var viewModel: AddLinksViewModel = AddLinksViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(over host: UIViewController,
                    isCome : String,
                    completionHandler: @escaping ((String) -> Void)) {
        let controller = self.getController() as! AddLinksViewController
        controller.show(over: host, isCome: isCome, completionHandler: completionHandler)
    }
    
    func show(over host: UIViewController,
              isCome : String,
              completionHandler: @escaping ((String) -> Void)) {
        viewModel.completionHandler = completionHandler
        viewModel.isCome = isCome
        show(over: host)
    }

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLable.text = self.viewModel.isCome
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.dismiss()
    }
    
    @IBAction func SaveAction(_ sender: UIButton) {
        if titleTextField.text == "" {
            showMessage(with: "Please enter link first")
        } else {
            var params = [String:Any]()
            if self.viewModel.isCome == "Add Twitter Link"{
                if self.titleTextField.text?.isValidUrl(url: self.titleTextField.text ?? "") == false {
                    showMessage(with: StringConstants.invalidLink)
                } else {
                    params[WebConstants.twitter] = titleTextField.text ?? ""
                    params[WebConstants.id] = self.viewModel.user.id
                    self.viewModel.processForUpdateProfileApiData(params: params) { status in
                        self.dismiss()
                    }
                }
            }
            else if self.viewModel.isCome == "Add Instagram Link"{
                if self.titleTextField.text?.isValidUrl(url: self.titleTextField.text ?? "") == false {
                    showMessage(with: StringConstants.invalidLink)
                } else {
                    params[WebConstants.instagram] = titleTextField.text ?? ""
                    params[WebConstants.id] = self.viewModel.user.id
                    self.viewModel.processForUpdateProfileApiData(params: params) { status in
                        self.dismiss()
                    }
                }
                
            }
            else if self.viewModel.isCome == "Add Linkedin Link"{
                if self.titleTextField.text?.isValidUrl(url: self.titleTextField.text ?? "") == false {
                    showMessage(with: StringConstants.invalidLink)
                } else {
                    params[WebConstants.linkdin] = titleTextField.text ?? ""
                    params[WebConstants.id] = self.viewModel.user.id
                    self.viewModel.processForUpdateProfileApiData(params: params) { status in
                        self.dismiss()
                    }
                }
                
            }
            
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss()
    }


}
