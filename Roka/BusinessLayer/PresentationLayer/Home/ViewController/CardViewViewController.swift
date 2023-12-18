//
//  CardViewViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 17/10/23.
//

import UIKit
import Koloda

class CardViewViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.home
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.cardView
    }

    lazy var viewModel: CardViewViewModel = CardViewViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isFrom: String,
                    isComeFor:String,
                    selectedProfile: ProfilesModel,
                    allProfiles: [ProfilesModel],
                    selectedIndex : Int,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! CardViewViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isFrom = isFrom
        controller.viewModel.isComeFor = isComeFor
        controller.viewModel.allProfiles = allProfiles
        controller.viewModel.copyAllProfiles = allProfiles
        controller.viewModel.selectedIndex = selectedIndex
        controller.viewModel.previousSelectedIndex = selectedIndex
        controller.viewModel.selectedProfile = selectedProfile
        controller.hidesBottomBarWhenPushed = true
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var shareButtonView: UIButton!
    @IBOutlet weak var undoButtonView: UIButton!
    @IBOutlet weak var likeButtonView: UIButton!
    @IBOutlet weak var crossButtonView: UIButton!
    @IBOutlet weak var saveButtonView: UIButton!
    @IBOutlet weak var nextButtonView: UIButton!
    @IBOutlet weak var prevoiusButtonView: UIButton!
    @IBOutlet weak var sideMenuStack: UIStackView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cardButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        initViews()
        // Do any additional setup after loading the view.
        
        if GlobalVariables.shared.selectedProfileMode != "MatchMaking"{
            self.navigationView.backgroundColor = UIColor(hex: "#031634")
            self.nameLabel.textColor = .white
            self.backButton.setImage(UIImage(named: "ic_back_white"), for: .normal)
            self.cardButton.setImage(UIImage(named: "ic_list_white"), for: .normal)
        } else {
            self.navigationView.backgroundColor = UIColor(hex: "#AD9BFB")
            self.nameLabel.textColor = UIColor(hex: "#031634")
            self.backButton.setImage(UIImage(named: "Ic_back_1"), for: .normal)
            self.cardButton.setImage(UIImage(named: "ic_list_black"), for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func initViews() {
        viewModel.nameLabel = nameLabel
        viewModel.shareButtonView = shareButtonView
        viewModel.undoButtonView = undoButtonView
        viewModel.likeButtonView = likeButtonView
        viewModel.crossButtonView = crossButtonView
        viewModel.saveButtonView = saveButtonView
        viewModel.nextButtonView = nextButtonView
        viewModel.prevoiusButtonView = prevoiusButtonView
        viewModel.sideMenuStack = sideMenuStack
        viewModel.kolodaView = kolodaView
    }
    
    func addNavigationBackButton() {
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn2.setImage(UIImage(named: "ic_back_white"), for: .normal)
        btn2.addTarget(self, action: #selector(backkButtonTapped(_:)), for:.touchUpInside)
        let barButton = UIBarButtonItem(customView: btn2)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func backkButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        viewModel.popBackToController()
    }
    
    @IBAction func DetailViewAction(_ sender: Any) {
        if UserModel.shared.user.id == viewModel.selectedProfile.id{
            self.navigationController?.popViewController(animated: true)
        }else{
            viewModel.proceedToDetailScreen(profile: viewModel.selectedProfile)
        }
    }
    
    @IBAction func undoButtonAction(_ sender: UIButton) {
        viewModel.proceedForUndoButtonAction()
    }
    @IBAction func crossButtonAction(_ sender: UIButton) {
        viewModel.proceedForCrossAction()
    }
    @IBAction func shareBUttonAction(_ sender: UIButton) {
        viewModel.callBackForSelectShareButton()
    }
    @IBAction func likeUnlikeButtonAction(_ sender: UIButton) {
        if likeButtonView.currentImage == UIImage(named: "Im_whiteLike") {
            self.likeButtonView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)

            UIView.animate(withDuration: 0.5,
              delay: 0,
              usingSpringWithDamping: 0.2,
              initialSpringVelocity: 4.0,
              options: .allowUserInteraction,
              animations: { [weak self] in
                self?.likeButtonView.transform = .identity
              },
              completion: { _ in
                self.viewModel.proceedForLikeAction()
            })


        } else {
            self.viewModel.callBackForSelectChatButton()
        }
    }
    
    @IBAction func savedButtonAction(_ sender: UIButton) {
        viewModel.callBackForSelectSaveButton()
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        viewModel.callBackForSelectNextButton()
    }
    
    @IBAction func previousButtonAction(_ sender: UIButton) {
        viewModel.callBackForSelectPreviousButton()
    }
    
}
