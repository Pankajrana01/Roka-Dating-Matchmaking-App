//
//  CongratsViewController.swift
//  Roka
//
//  Created by  Developer on 28/10/22.
//

import UIKit

class CongratsViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.congratulation
        
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.congratulation
    }

    lazy var viewModel: CongratulationViewModel = CongratulationViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! CongratsViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.hidesBottomBarWhenPushed = true
        controller.show(from: viewController, forcePresent: forcePresent)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        showNavigationLogoinCenter()
        addNavigationBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    func addNavigationBackButton() {
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn2.setImage(UIImage(named: "Ic_back_1"), for: .normal)
        btn2.addTarget(self, action: #selector(backkButtonTapped(_:)), for:.touchUpInside)
        let barButton = UIBarButtonItem(customView: btn2)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func backkButtonTapped(_ sender: UIButton){
        viewModel.proceedForHome()
    }
    // MARK: - avail your membership action...
    @IBAction func availYourMembershipClicked(_ sender: UIButton) {
        viewModel.proceedForHome()
    }
}
