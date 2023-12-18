//
//  BuyGiftKeyController.swift
//  Roka
//
//  Created by Applify  on 06/01/23.
//

import UIKit

class BuyGiftKeyController: BaseViewController {

    // MARK: - Variables
    lazy var viewModel: BuyGiftKeyViewModel = BuyGiftKeyViewModel(hostViewController: self)

    // MARK: - ViewLifeCycle
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.chat
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.BuyGiftKey
    }
    
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    chatRoom: ChatRoomModel,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! BuyGiftKeyController
        controller.hidesBottomBarWhenPushed = true
        controller.viewModel.chatRoom = chatRoom
        controller.viewModel.completionHandler = completionHandler
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //showNavigationBackButton(title: "   Confirm payment")
        self.title = "Confirm payment"
        self.addNavigationBackButton()
        viewModel.fetchAllProducts()
    }

    @IBAction func proceedToPayAction(_ sender: UIButton) {
        if viewModel.canPurchase() {
            viewModel.purchase {
                self.viewModel.completionHandler?(true)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func addNavigationBackButton() {
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn2.setImage(UIImage(named: "ic_back_white"), for: .normal)
        btn2.addTarget(self, action: #selector(backkButtonTapped(_:)), for:.touchUpInside)
        let barButton = UIBarButtonItem(customView: btn2)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func backkButtonTapped(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}
