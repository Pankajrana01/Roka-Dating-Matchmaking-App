//
//  BaseViewController.swift
//  Covid19 tracking
//
//  Created by Aakash on 29/07/21.
//

import SwiftMessages
import UIKit

protocol BaseViewControllerProtocol {
    func getViewModel() -> BaseViewModel
    func refreshUI()
}

extension BaseViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let navigationGR = self.navigationController?.interactivePopGestureRecognizer,
            gestureRecognizer == navigationGR {
            if self.isViewLoaded && self.view.window != nil {
                return false
            }
        }
        return true
    }
}

class BaseViewController: UIViewController {

    func gotoLoginScreen() {
        UserModel.shared.logoutUser()
        KAPPDELEGATE.updateRootController(LoginViewController.getController(),
                                          transitionDirection: .toRight,
                                          embedInNavigationController: true)
    }
    
    let bgImageView = UIImageView()
    
    class func storyboard() -> UIStoryboard {
        fatalError("Child should override")
    }
    
    class func identifier() -> String {
        fatalError("Child should override")
    }
    
    func getViewModel() -> BaseViewModel {
        fatalError("Child should override")
    }
    
    func refreshUI() {
    }
    
    func showNavigationLogo() {
        let btn1 = UIButton()
        btn1.setImage(UIImage(named: "ic_roka_logo"), for: .normal)
        btn1.frame = CGRect(x: 15, y: 0, width: 30, height: 30)
        let item1 = UIBarButtonItem()
        item1.customView = btn1
        let space = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItems = [item1]
    }
    
    func showNavigationLogoforSecretCodeScreen() {
        let btn1 = UIButton()
        btn1.setImage(UIImage(named: "Ic_Logo_nav"), for: .normal)
        btn1.frame = CGRect(x: 15, y: 0, width: 30, height: 30)
        let item1 = UIBarButtonItem()
        item1.customView = btn1
        let space = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItems = [item1]
    }
    
    func showNavigationLogoinCenter() {
        let customView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 44.0))
        let btn1 = UIButton()
        btn1.setImage(UIImage(named: "Ic_Logo_nav"), for: .normal)
        btn1.frame = customView.frame
        customView.addSubview(btn1)
        
        self.navigationItem.titleView = customView
    }
    
    func showNavigationWhiteLogoinCenter() {
        let customView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 44.0))
        let btn1 = UIButton()
        btn1.setImage(UIImage(named: "ic_roka_logo"), for: .normal)
        btn1.frame = customView.frame
        customView.addSubview(btn1)
        
        self.navigationItem.titleView = customView
    }
    
    func showNavigationLogoinCenterWithRigthButton() {
        let customView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 44.0))
        let btn1 = UIButton()
        btn1.setImage(UIImage(named: "Ic_Logo_nav"), for: .normal)
        btn1.frame = customView.frame
        customView.addSubview(btn1)
        self.navigationItem.titleView = customView
    }
    
    func showNavigationBackButton(title:String) {
        let customView = UIView(frame: CGRect(x: -20.0, y: 0.0, width: 300.0, height: 44.0))

        let label = UILabel(frame: customView.frame)
        label.text = title
        label.textColor = UIColor.appBorder
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont(name: "SharpGrotesk-SemiBold25", size: 16.0)
        customView.addSubview(label)
        self.navigationItem.titleView = customView
    }
    
    
    func showNavigationCenterTitle(title:String) {
        let customView = UIView(frame: CGRect(x: 100.0, y: 0.0, width: 300.0, height: 44.0))

        let label = UILabel(frame: customView.frame)
        label.text = title
        label.textColor = UIColor.appBorder
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont(name: "SharpGrotesk-SemiBold25", size: 16.0)
        customView.addSubview(label)
        self.navigationItem.titleView = customView
    }
    
    func isNavigationHidden(isHidden:Bool) {
        self.navigationController?.isNavigationBarHidden = isHidden
    }

    class func getController() -> BaseViewController {
        return self.storyboard().instantiateViewController(withIdentifier:
            self.identifier()) as! BaseViewController
    }
    
    class func show(from viewController: UIViewController, forcePresent: Bool = false) {
        let vc = self.getController()
        vc.show(from: viewController, forcePresent: forcePresent)
    }

    func show(from viewController: UIViewController, forcePresent: Bool = false) {
        DispatchQueue.main.async {
            if forcePresent {
                self.modalPresentationStyle = .fullScreen
                viewController.present(self, animated: true, completion: nil)
            } else {
                viewController.navigationController?.pushViewController(self, animated: true)
            }
        }
    }
    
    func showBack(from viewController: UIViewController, forcePresent: Bool = false) {
        DispatchQueue.main.async {
            if forcePresent {
                viewController.dismiss(animated: true)
            } else {
                viewController.navigationController?.popViewController(animated: true)
            }
        }
    }

    class func showWithoutAnimation(from viewController: UIViewController, forcePresent: Bool = false) {
        let vc = self.getController()
        vc.showWithoutAnimation(from: viewController, forcePresent: forcePresent)
    }

    func showWithoutAnimation(from viewController: UIViewController, forcePresent: Bool = false) {
        DispatchQueue.main.async {
            if forcePresent {
                viewController.present(self, animated: false, completion: nil)
            } else {
                viewController.navigationController?.pushViewController(self, animated: false)
            }
        }
    }

    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint?

    /// In case bottom constraint is connected, i.e. some bottom view needs to be moved up, so the base view controller expects that view to be connected to the bottom safe area with 0 constant. In case there is some padding below that view, so that padding should be returned by the child class.
    var bottomPadding: CGFloat {
        return 0
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getViewModel().viewLoaded()
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("original viewWillDisappear")
    }

    var clearNavigationStackOnAppear: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let  navVC = self.navigationController {
            navVC.interactivePopGestureRecognizer?.delegate = navVC.viewControllers.count == 1 ? self: nil
            navVC.interactivePopGestureRecognizer?.isEnabled = false

        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if clearNavigationStackOnAppear {
            clearNavigationStackOnAppear = false
            self.navigationController?.viewControllers = [self]
        }
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(keyboardWillChangeFrame(_:)),
//                                               name: UIResponder.keyboardWillChangeFrameNotification,
//                                               object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillChangeFrameNotification,
                                                  object: nil)
    }

    @objc
    func keyboardWillChangeFrame(_ notification: Notification) {
        if UIApplication.shared.applicationState == .active {
            let endFrame = ((notification as NSNotification).userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            if endFrame.origin.y >= UIScreen.main.bounds.size.height {
                bottomConstraint?.constant = 0
            } else {
                if hasTopNotch {
                    bottomConstraint?.constant = view.bounds.height - endFrame.origin.y - 34 - bottomPadding
                } else {
                    bottomConstraint?.constant = view.bounds.height - endFrame.origin.y - bottomPadding
                }
            }
            self.view.layoutIfNeeded()
        }
    }
}

