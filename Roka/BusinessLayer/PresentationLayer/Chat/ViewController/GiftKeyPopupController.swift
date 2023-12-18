//
//  GiftKeyPopupController.swift
//  Roka
//
//  Created by Applify  on 06/01/23.
//

import UIKit

class GiftKeyPopupController: BaseAlertViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.chat
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.giftkeyPopup
    }

    lazy var viewModel: GiftKeyPopupModel = GiftKeyPopupModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(over host: UIViewController,
                    isCome: String,
                    otherUserName: String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! GiftKeyPopupController
        controller.viewModel.isCome = isCome
        controller.viewModel.otherUserName = otherUserName
        controller.viewModel.completionHandler = completionHandler
        controller.show(over: host)
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var sendGiftPopup: UIView!
    @IBOutlet weak var headerName: UILabel!
    @IBOutlet weak var infoName: UILabel!
    
    @IBOutlet weak var giftSuccessPopup: UIView!
    @IBOutlet weak var giftSuccessBlurView: UIView!
    @IBOutlet weak var successInfoName: UILabel!

    @IBOutlet weak var upgradeToPremiumPopup: UIView!
    
    @IBOutlet weak var staticPremimumInfoLbl: UILabel!

    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        switch viewModel.isCome {
        case "sendGiftPopup":
            setupSendGiftPopup()
            break
        case "giftSuccessPopup":
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(blurViewAction(_:)))
            giftSuccessBlurView.addGestureRecognizer(tapGestureRecognizer)
            setupGiftSuccessPopup()
            break
        case "upgradeToPremiumPopup":
            setupUpgradeToPremiumPopup()
            break
        default:
            break
        }
        if viewModel.otherUserName != "" {
            self.staticPremimumInfoLbl.text = "Hi \(UserModel.shared.user.firstName), \(viewModel.otherUserName) messaging limit has been reached.Please get a Spark gift for her so that you may both continue your messaging."
        }

    }
    
    func setupSendGiftPopup() {
        sendGiftPopup.isHidden = false
        giftSuccessPopup.isHidden = true
        upgradeToPremiumPopup.isHidden = true
        //Right now, NISHA RAWAT can’t chat to you… but that can change with a spark!
        
        //Send a spark to NISHA RAWAT so you can get to   know each other. It could be the start of   something special.
        
        if viewModel.otherUserName != "" {
            headerName.text = "Right now, \(viewModel.otherUserName.uppercased()) can’t chat to you... but that can change with a spark!"
            infoName.text = "Send a spark to \(viewModel.otherUserName.uppercased()) so you can get to know each other. It could be the start of something special."
            
        }
    }
    
    func setupGiftSuccessPopup() {
        sendGiftPopup.isHidden = true
        giftSuccessPopup.isHidden = false
        upgradeToPremiumPopup.isHidden = true

        if viewModel.otherUserName != "" {
            successInfoName.text = "You have gifted card to \(viewModel.otherUserName). Enjoy chat with \(viewModel.otherUserName) for 7 days."
        }
    }
    
    func setupUpgradeToPremiumPopup() {
        sendGiftPopup.isHidden = true
        giftSuccessPopup.isHidden = true
        upgradeToPremiumPopup.isHidden = false
    }
    
    // MARK: - IBActions
    @IBAction func dismissButtonAction(_ sender: UIButton) {
        self.dismiss()
    }
    
    @IBAction func buyAction(_ sender: UIButton) {
        viewModel.completionHandler?(true)
        self.dismiss()
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.dismiss()
    }
    
    @objc func blurViewAction(_ sender: UITapGestureRecognizer) {
        self.dismiss()
    }
}
