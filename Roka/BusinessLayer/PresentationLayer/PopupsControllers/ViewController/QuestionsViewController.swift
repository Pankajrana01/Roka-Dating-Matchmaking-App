//
//  QuestionsViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 18/08/23.
//

import UIKit

class QuestionsViewController: BaseAlertViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.popups
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.question
    }

    lazy var viewModel: QuestionsViewModel = QuestionsViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(over host: UIViewController,
                    isCome:String,
                    isFriend : Bool,
                    completionHandler: @escaping (([NSDictionary]) -> Void)) {
        let controller = self.getController() as? QuestionsViewController
        controller?.viewModel.isComeFor = isCome
        controller?.show(over: host, isCome: isCome, isFriend: isFriend, completionHandler: completionHandler)
    }
    
    func show(over host: UIViewController,
              isCome:String,
              isFriend : Bool,
              completionHandler: @escaping (([NSDictionary]) -> Void)) {
        viewModel.completionHandler = completionHandler
        viewModel.isComeFor = isCome
        viewModel.isFriend = isFriend
        show(over: host)
    }
    
    @IBOutlet weak var firstTextView: UITextView!
    @IBOutlet weak var firstCountLabel: UILabel!
    @IBOutlet weak var secTextView: UITextView!
    @IBOutlet weak var secCountLabel: UILabel!
    var firstMaxLength = 100
    var secMaxLength = 100
    var questionAboutDictionary = [NSDictionary]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstTextView.delegate = self
        secTextView.delegate = self
        firstTextView.text = "Write here…"
        firstTextView.textColor = UIColor.appPlaceholder
        secTextView.text = "Write here…"
        secTextView.textColor = UIColor.appPlaceholder
        
        self.viewModel.processForGetQuestionData(type: "1") { status in
            if let index =  self.viewModel.questionsData.firstIndex(where: {$0.id == self.viewModel.questionsIds[0]}) {
                if self.viewModel.questionsData[index].answer != "" && self.viewModel.questionsData[index].answer != nil {
                    self.firstTextView.textColor = UIColor.appTitleBlueColor
                    self.firstTextView.text = self.viewModel.questionsData[index].answer
                    self.textDidChangeNotification(self.firstTextView)
                } else {
                    self.firstTextView.text = "Write here…"
                    self.firstTextView.textColor = UIColor.appPlaceholder
                }
            }
            
            if let index =  self.viewModel.questionsData.firstIndex(where: {$0.id == self.viewModel.questionsIds[1]}) {
                if self.viewModel.questionsData[index].answer != "" && self.viewModel.questionsData[index].answer != nil {
                    self.secTextView.textColor = UIColor.appTitleBlueColor
                    self.secTextView.text = self.viewModel.questionsData[index].answer
                    self.textDidChangeNotification(self.secTextView)
                } else {
                    self.secTextView.text = "Write here…"
                    self.secTextView.textColor = UIColor.appPlaceholder
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func textDidChangeNotification(_ textView: UITextView) {
//        if textView == firstTextView {
//            firstCountLabel.text = "\(firstMaxLength - textView.text.count)/100"
//        } else {
//            secCountLabel.text = "\(secMaxLength - textView.text.count)/100"
//        }
        if textView == firstTextView {
            firstCountLabel.text = "\(textView.text.count)/100"
            //"\(firstMaxLength - textView.text.count)/100"
        } else {
            secCountLabel.text = "\(textView.text.count)/100"
            //"\(secMaxLength - textView.text.count)/100"
        }
        
    }
    

    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.dismiss()
    }
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        self.questionAboutDictionary.removeAll()
        if firstTextView.text == "Write here…" && secTextView.text == "Write here…" {
            showMessage(with: StringConstants.addAnswers)
        } else {
            if firstTextView.text != "" {
                if firstTextView.text == "Write here…" {
                    let dict = NSMutableDictionary()
                    dict["questionId"] = self.viewModel.questionsData[0].id
                    dict["answer"] = ""
                    self.questionAboutDictionary.append(dict)
                } else {
                    let dict = NSMutableDictionary()
                    dict["questionId"] = self.viewModel.questionsData[0].id
                    dict["answer"] = self.firstTextView.text ?? ""
                    self.questionAboutDictionary.append(dict)
                }
            }
            if secTextView.text != "" {
                if secTextView.text == "Write here…" {
                    let dict = NSMutableDictionary()
                    dict["questionId"] = self.viewModel.questionsData[1].id
                    dict["answer"] = ""
                    self.questionAboutDictionary.append(dict)
                } else {
                    let dict = NSMutableDictionary()
                    dict["questionId"] = self.viewModel.questionsData[1].id
                    dict["answer"] = self.secTextView.text ?? ""
                    self.questionAboutDictionary.append(dict)
                }
            }
            self.viewModel.completionHandler?(self.questionAboutDictionary)
            self.dismiss()
        }
        
    }
}

extension QuestionsViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if firstTextView.textColor == UIColor.appPlaceholder {
            firstTextView.text = nil
            firstTextView.textColor = UIColor.appTitleBlueColor
        } else if secTextView.textColor == UIColor.appPlaceholder {
            secTextView.text = nil
            secTextView.textColor = UIColor.appTitleBlueColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if firstTextView.text.isEmpty {
            firstTextView.text = "Write here…"
            firstTextView.textColor = UIColor.appPlaceholder
        } else if secTextView.text.isEmpty {
            secTextView.text = "Write here…"
            secTextView.textColor = UIColor.appPlaceholder
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView == firstTextView {
            firstCountLabel.text = "\(textView.text.count)/100"
            //"\(firstMaxLength - textView.text.count)/100"
        } else {
            secCountLabel.text = "\(textView.text.count)/100"
            //"\(secMaxLength - textView.text.count)/100"
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == firstTextView {
            return firstTextView.text.count + (text.count - range.length) <= firstMaxLength
        } else {
            return secTextView.text.count + (text.count - range.length) <= secMaxLength
        }
    }
}
