//
//  ReferAndEarnViewController.swift
//  Roka
//
//  Created by  Developer on 28/10/22.
//

import UIKit

class ReferAndEarnViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.referAndEarn
        
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.referAndEarn
    }
    
    lazy var viewModel: ReferAndEarnViewModel = ReferAndEarnViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! ReferAndEarnViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.hidesBottomBarWhenPushed = true
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var lableOne: UILabel!
    @IBOutlet weak var copyStackView: UIStackView!
    @IBOutlet weak var labelReferalCode: UILabel!
    @IBOutlet weak var labelRatings: UILabel!
    @IBOutlet weak var lableTwo: UILabel!
    
    var referralUserCount: Int?
    var totalRefarralLimit: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topLabel.backgroundColor = UIColor.appTitleBlueColor
    }
    
    func addNavigationBackButtonn() {
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
    // Refer friends to get free premium membership for Roka!
        
      //You are 5 referral away to get one month of free premium membership for Roka.
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addNavigationBackButtonn()
        self.title = "Refer & Earn"
       // showNavigationBackButton(title: "  Refer & Earn")
        viewModel.getReferAndEarnData { [weak self] result in
            
            guard let strongSelf = self else { return }
            guard let result = result else { return }
            
            if let totalRefarralLimit = result["totalRefarralLimit"] as? Int, let referralUserCount = result["referralUserCount"] as? Int {
                strongSelf.labelRatings.text = "\(referralUserCount)/\(totalRefarralLimit)"
                strongSelf.referralUserCount = referralUserCount
                strongSelf.totalRefarralLimit = totalRefarralLimit

                if strongSelf.totalRefarralLimit == 0 {
                    strongSelf.lableOne.text = "Refer your friends to get free membership"
                    strongSelf.lableTwo.text = "Refer your friends to get free membership"
                    strongSelf.copyStackView.isHidden = true
                } else {
                    strongSelf.lableOne.text = "Refer 2 friends to get one month premium membership."
                    strongSelf.lableTwo.text = "You are one referral away to get one month of free premium membership for Roka."
                    strongSelf.copyStackView.isHidden = false
                }
            }
            if let referralCode = result["referralCode"] as? String {
                strongSelf.labelReferalCode.text = "\(referralCode)".uppercased()
            }
        }
    }
    
    @IBAction func successfulReferalClicked(_ sender: UIButton) {
        if self.totalRefarralLimit == self.referralUserCount{
            viewModel.proceedForCongratulationScreen()
        }
    }
    
    @IBAction func copyClicked(_ sender: UIButton) {
        // action here
        UIPasteboard.general.string = labelReferalCode.text
        print(UIPasteboard.general.string ?? "")
        showSuccessMessage(with: "Copied")
    }
    
    
    @IBAction func shareAppWithYourFreindsClikced(_ sender: UIButton) {
        // action here
        let text = "Your friend wants you to join Roka! \n https://www.apple.com/in/app-store/"     // text to share
        
        // set up activity view controller
        let activityViewController = UIActivityViewController(activityItems: [UIImage(named: "Ic_Logo_nav") as Any, text], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
}
