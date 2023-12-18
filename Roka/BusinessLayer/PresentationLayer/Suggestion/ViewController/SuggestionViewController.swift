//
//  SuggestionViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 30/10/22.
//

import UIKit

class SuggestionViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.suggestion
        
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.suggestion
    }

    lazy var viewModel: SuggestionViewModel = SuggestionViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! SuggestionViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.hidesBottomBarWhenPushed = true
        controller.show(from: viewController, forcePresent: forcePresent)
    }


    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var NameTextField: UnderlinedTextField!
    @IBOutlet weak var suggestionTextView: UITextView!
    @IBOutlet weak var textViewHC: NSLayoutConstraint!
    
//    let suggestionTextViewMaxHeight: CGFloat = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if GlobalVariables.shared.selectedProfileMode != "MatchMaking"{
            addNavigationBackButtonn()
            self.topLabel.backgroundColor = UIColor.appTitleBlueColor
        } else {
            addNavigatioBlacknBackButton()
            self.topLabel.backgroundColor = UIColor(hex: "#AD9BFB")
        }
     //   self.title = "Have any suggestions?"
        //showNavigationBackButton(title: "  Have any suggestions")
        suggestionTextView.text = "   Write here..."
        suggestionTextView.textColor = UIColor.appPlaceholder
        suggestionTextView.delegate = self
//        self.suggestionTextView.textContainer.maximumNumberOfLines = 4
//        self.suggestionTextView.textContainer.lineBreakMode = .byTruncatingTail
        self.suggestionTextView.isScrollEnabled = true
        
        let customView = UIView(frame: CGRect(x: 0, y: 0.0, width: 300, height: 50))
        let label = UILabel(frame: customView.frame)
        label.text = "Have any suggestions?"
        if GlobalVariables.shared.selectedProfileMode != "MatchMaking"{
            label.textColor = .white
        }else{
            label.textColor = .black
        }
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "SharpGrotesk-SemiBold25", size: 17.0)
        customView.addSubview(label)
        self.navigationItem.titleView = customView
    }
    
    func addNavigationBackButtonn() {
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn2.setImage(UIImage(named: "ic_back_white"), for: .normal)
        btn2.addTarget(self, action: #selector(backkButtonTapped(_:)), for:.touchUpInside)
        let barButton = UIBarButtonItem(customView: btn2)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    func addNavigatioBlacknBackButton() {
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn2.setImage(UIImage(named: "Ic_back_1"), for: .normal)
        btn2.addTarget(self, action: #selector(backkButtonTapped(_:)), for:.touchUpInside)
        let barButton = UIBarButtonItem(customView: btn2)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func backkButtonTapped(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        viewModel.checkValidation(nameTextField: NameTextField, suggestionTextView: suggestionTextView)
    }
}

extension SuggestionViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.appPlaceholder {
            textView.text = nil
            textView.textColor = UIColor.appBorder
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write here..."
            textView.textColor = UIColor.appPlaceholder
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if self.suggestionTextView.contentSize.height > 100 {
//            textViewHC.constant = 100
        } else {
//            textViewHC.constant = self.suggestionTextView.contentSize.height
        }
    }
}
