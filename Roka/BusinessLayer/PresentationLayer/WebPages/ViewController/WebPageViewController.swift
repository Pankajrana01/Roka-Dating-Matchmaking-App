//
//  WebPageViewController.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 06/01/21.
//

import UIKit
import WebKit
class WebPageViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.webPages
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.webPage
    }
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false, title: String, url:String, iscomeFrom:String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! WebPageViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.titleName = title
        controller.hidesBottomBarWhenPushed = true
        controller.viewModel.iscomeFrom = iscomeFrom
        controller.viewModel.url = url
        controller.show(from: viewController, forcePresent: forcePresent)
    }

    lazy var viewModel: WebPageViewModel = WebPageViewModel(hostViewController: self)

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet private weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        if GlobalVariables.shared.selectedProfileMode != "MatchMaking"{
            self.topView.backgroundColor = UIColor.appTitleBlueColor
            backBtn.setImage(UIImage(named: "ic_back_white"), for: .normal)
            titleLable.textColor = UIColor.white
        } else {
            self.topView.backgroundColor = UIColor(hex: "#AD9BFB")
            backBtn.setImage(UIImage(named: "Ic_back_1"), for: .normal)
            titleLable.textColor = UIColor.appTitleBlueColor
        }

        DispatchQueue.main.async {
            self.titleLable.text = "\(self.viewModel.titleName)"
            self.webView.navigationDelegate = self
            if self.viewModel.url != ""{
                let url = URL(string: self.viewModel.url)
                self.webView.load(URLRequest(url: url!))
                self.webView.allowsBackForwardNavigationGestures = true
            }
        }
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
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    @objc func backkButtonTapped(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Webview delegate ..
extension WebPageViewController: WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideLoader()
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showLoader()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideLoader()
 }

}
