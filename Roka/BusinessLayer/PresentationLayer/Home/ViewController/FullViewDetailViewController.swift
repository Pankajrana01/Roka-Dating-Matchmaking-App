//
//  FullViewDetailViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 18/10/22.
//

import UIKit

class FullViewDetailViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.home
        
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.fullDetail
    }

    lazy var viewModel: FullViewDetailViewModel = FullViewDetailViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func getController(with isCome: String,
                             forceBackToHome:Bool,
                             selectedProfile: ProfilesModel,
                             allProfiles: [ProfilesModel],
                             selectedIndex : Int) -> BaseViewController {
        let controller = self.getController() as! FullViewDetailViewController
        controller.viewModel.isComeFor = isCome
        controller.viewModel.forceBackToHome = forceBackToHome
        controller.viewModel.allProfiles = allProfiles
        controller.viewModel.selectedIndex = selectedIndex
        controller.viewModel.previousSelectedIndex = selectedIndex
        controller.viewModel.selectedProfile = selectedProfile
        controller.hidesBottomBarWhenPushed = true
        return controller
    }
    
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    selectedProfile: ProfilesModel,
                    allProfiles: [ProfilesModel],
                    selectedIndex : Int,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! FullViewDetailViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.viewModel.allProfiles = allProfiles
        controller.viewModel.selectedIndex = selectedIndex
        controller.viewModel.previousSelectedIndex = selectedIndex
        controller.viewModel.selectedProfile = selectedProfile
        controller.hidesBottomBarWhenPushed = true
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    var controllerIndex = 0
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var moreButton: UIButton!
    
    @IBOutlet weak var sideMenuStack: UIStackView!
    
    @IBOutlet weak var shareButtonView: UIView!
    @IBOutlet weak var undoButtonView: UIView!
    @IBOutlet weak var likeButtonView: UIView!
    @IBOutlet weak var crossButtonView: UIView!
    @IBOutlet weak var saveButtonView: UIView!
    @IBOutlet weak var nextButtonView: UIView!
    @IBOutlet weak var prevoiusButtonView: UIView!
    
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var saveImage: UIImageView!
   
    
    var profile: ProfilesModel! { didSet { profileDidSet() } }
    func profileDidSet() {
        if viewModel.user.isSubscriptionPlanActive == 0 {
            self.undoButtonView.isHidden = true
        } else {
            if viewModel.previousSelectedIndex != viewModel.index {
                self.undoButtonView.isHidden = false
            } else {
                self.undoButtonView.isHidden = true
            }
        }
        // update like and chat button state ...
        if let liked = profile.isLiked {
            if liked == 1 {
                self.likeImage.image = UIImage(named: "Ic_chat")
            } else {
                self.likeImage.image = UIImage(named: "Im_whiteLike")
            }
        }
        // update save button state ...
        if let liked = profile.isSaved {
            if liked == 1 {
                self.saveImage.image = UIImage(named: "Im_Saved_tick")
            } else {
                self.saveImage.image = UIImage(named: "Ic_save 1")
            }
        }
        if viewModel.isComeFor == "Profile" {
            self.sideMenuStack.isHidden = true
            self.saveButtonView.isHidden = true
            self.prevoiusButtonView.isHidden = true
            self.nextButtonView.isHidden = true
        } else if viewModel.isComeFor == "SavedPreferences" {
            self.sideMenuStack.isHidden = false
            self.saveButtonView.isHidden = false
            self.likeButtonView.isHidden = true
            self.crossButtonView.isHidden = true
            self.undoButtonView.isHidden = true
            let lastElement = self.viewModel.allProfiles.count - 1
            print(lastElement)
            
            if viewModel.index == lastElement {
                self.nextButtonView.isHidden = true
            } else {
                self.nextButtonView.isHidden = false
            }

            if viewModel.index == 0 {
                self.prevoiusButtonView.isHidden = true
            } else {
                self.prevoiusButtonView.isHidden = false
            }
            
        } else if viewModel.isComeFor == "MatchMakingProfile" {
            self.sideMenuStack.isHidden = false
            self.undoButtonView.isHidden = true
            self.likeButtonView.isHidden = true
            self.crossButtonView.isHidden = true

            let lastElement = self.viewModel.allProfiles.count - 1
            print(lastElement)
            
            if viewModel.index == lastElement {
                self.nextButtonView.isHidden = true
            } else {
                self.nextButtonView.isHidden = false
            }

            if viewModel.index == 0 {
                self.prevoiusButtonView.isHidden = true
            } else {
                self.prevoiusButtonView.isHidden = false
            }
            
        } else if viewModel.isComeFor == "BrowseAndSkip" {
            self.sideMenuStack.isHidden = false
            self.undoButtonView.isHidden = true
            self.likeButtonView.isHidden = true
            self.crossButtonView.isHidden = true
            self.saveButtonView.isHidden = true
            
            let lastElement = self.viewModel.allProfiles.count - 1
            print(lastElement)
            
            if viewModel.index == lastElement {
                self.nextButtonView.isHidden = true
            } else {
                self.nextButtonView.isHidden = false
            }

            if viewModel.index == 0 {
                self.prevoiusButtonView.isHidden = true
            } else {
                self.prevoiusButtonView.isHidden = false
            }
        } else {
            self.sideMenuStack.isHidden = false
            self.saveButtonView.isHidden = true //false
            self.prevoiusButtonView.isHidden = true
            self.nextButtonView.isHidden = true
            
            if viewModel.isFrom == "Likes" || viewModel.isFrom == "Aligned" {
                self.undoButtonView.isHidden = true
            } else {
                if viewModel.index == 0 {
                    self.undoButtonView.isHidden = true
                } else {
                    self.undoButtonView.isHidden = false
                }
            }
        }
        
    }
    @IBOutlet weak var bottomArrowButton: UIButton!
    @IBOutlet weak var downArrowImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.controllerIndex = controllerIndex
        viewModel.tableView = tableView
        self.nameLabel.text = "\(viewModel.allProfiles[viewModel.selectedIndex].firstName ?? "")"
        
//        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
//        swipeGesture.direction = .left
//        tableView.addGestureRecognizer(swipeGesture)
//
//        let swipeGesturess = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
//        swipeGesturess.direction = .right
//        tableView.addGestureRecognizer(swipeGesturess)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.state == .recognized {
            viewModel.rightSwipe()
        }
    }
    
    @objc func handleSwipes(_ gesture: UISwipeGestureRecognizer) {
        if gesture.state == .recognized {
            viewModel.leftSwipe()
            }
        }
    
    func animateDownArrow() {
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [.autoreverse, .repeat], animations: {
            self.downArrowImage.frame.origin.y -= 30
        }, completion:{ _ in
            self.downArrowImage.transform = .identity
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.setHidesBackButton(true, animated: true)
        viewModel.tableView = tableView
       // animateDownArrow()
        
        if viewModel.isComeFor == "Profile" || viewModel.isComeFor == "SavedPreferences" {
            self.moreButton.isHidden = true
        } else if viewModel.isComeFor == "MatchMakingProfile" {
            self.moreButton.isHidden = false
        }
        
        viewModel.index = viewModel.selectedIndex
        updateProfileData()
    }
    
    func updateProfileData() {
        if self.viewModel.allProfiles.indices.contains(self.viewModel.selectedIndex) {
            self.profile = self.viewModel.allProfiles[viewModel.selectedIndex]
        } else {
            self.viewModel.popBackToController()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func downArrowButtonAction(_ sender: UIButton) {
        let indexPath = IndexPath(item: 0, section: 0)
        viewModel.scrollToBottom(indexPath: indexPath)
    }

    @IBAction func backButtonAction(_ sender: UIButton) {
        if viewModel.forceBackToHome{
            viewModel.proceedForHome()
        } else {
            self.backButtonTapped(self)
        }
    }
    
    @IBAction func optionButtonTapped(_ sender: UIButton) {
        viewModel.showAlertForReportBlockUser()
    }
    
    @IBAction func undoButtonAction(_ sender: UIButton) {
        //viewModel.callBackForSelectUndoButton?(viewModel.selectedIndex, viewModel.previousSelectedIndex)
        viewModel.proceedForSelectUndoButton(selectedIndex: viewModel.selectedIndex, previousIndex: viewModel.previousSelectedIndex)
    }
    @IBAction func crossButtonAction(_ sender: UIButton) {
      //  viewModel.callBackForSelectCrossButton?(viewModel.selectedIndex)
        viewModel.proceedForSelectCrossButton(selectedIndex: viewModel.selectedIndex)
    }
    @IBAction func shareBUttonAction(_ sender: UIButton) {
        viewModel.proceedForShare(selectedIndex: viewModel.selectedIndex)
    }
    @IBAction func likeUnlikeButtonAction(_ sender: UIButton) {
        if likeImage.image == UIImage(named: "Im_whiteLike") {
            self.likeImage.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)

            UIView.animate(withDuration: 0.5,
              delay: 0,
              usingSpringWithDamping: 0.2,
              initialSpringVelocity: 4.0,
              options: .allowUserInteraction,
              animations: { [weak self] in
                self?.likeImage.transform = .identity
              },
              completion: { _ in
                self.viewModel.proceedForSelectLikeButton(selectedIndex:self.viewModel.selectedIndex)
            })

            
        } else {
            self.viewModel.proceedForSelectChatButton(selectedIndex:self.viewModel.selectedIndex)
        }
    }
    
    @IBAction func savedButtonAction(_ sender: UIButton) {
       // viewModel.proceedForSelectSaveButton(selectedIndex:self.viewModel.selectedIndex)
        viewModel.proceedForSelectSaveButton(selectedIndex: self.viewModel.selectedIndex) { result in
            self.updateProfileData()
        }
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        viewModel.proceedForNextProfile(selectedIndex:self.viewModel.selectedIndex)
    }
    
    @IBAction func previousButtonAction(_ sender: UIButton) {
        viewModel.proceedForPreviousProfile(selectedIndex:self.viewModel.selectedIndex)
    }
}
