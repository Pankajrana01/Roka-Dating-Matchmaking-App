//
//  MatchMakingProfileTabViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 25/11/22.
//

import UIKit

class MatchMakingProfileTabViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.matchMakingProfileTab
        
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.matchMakingProfileTab
    }

    lazy var viewModel: MatchMakingProfileTabViewModel = MatchMakingProfileTabViewModel(hostViewController: self)

    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! MatchMakingProfileTabViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    var barItem = UIBarButtonItem()
    var leftItem = UIBarButtonItem()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        showLeftNavigationLogo()
        // Do any additional setup after loading the view.
    }
    
    func showLeftNavigationLogo() {
        let btn1 = UIButton()
        btn1.setImage(UIImage(named: "Ic_Logo_nav"), for: .normal)
        btn1.frame = CGRect(x: 15, y: 0, width: 30, height: 30)
        leftItem.customView = btn1
        let space = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItems = [leftItem]
    }
}
