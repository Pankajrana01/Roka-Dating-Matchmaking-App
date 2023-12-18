//
//  LandingWalkThroughViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 23/09/22.
//

import UIKit

class LandingWalkThroughViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.landingWalkThrough
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.landingWalkThrough
    }

    lazy var viewModel: LandingWalkThroughViewModel = LandingWalkThroughViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! LandingWalkThroughViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isCome = isComeFor
        controller.show(from: viewController, forcePresent: forcePresent)
    }

    @IBOutlet weak var BottomView: UIView!
    @IBOutlet weak var HomeButtonView: UIView!
    @IBOutlet weak var NotificationButtonView: UIView!
    @IBOutlet weak var SearchButtonView: UIView!
    @IBOutlet weak var ChatButtonView: UIView!
    @IBOutlet weak var ProfileButtonView: UIView!
    
    @IBOutlet weak var tabbarStackView: UIStackView!
    @IBOutlet weak var BottomViewTitle: UILabel!
    @IBOutlet weak var BottomViewDesc: UILabel!
    
    @IBOutlet weak var bottomViewBgImage: UIImageView!
    
    @IBOutlet weak var undoImage: UIImageView!
    @IBOutlet weak var deleteImage: UIImageView!
    @IBOutlet weak var saveImage: UIImageView!
    @IBOutlet weak var shareImage: UIImageView!
    @IBOutlet weak var likeImage: UIImageView!
    
    @IBOutlet weak var likeBottomView: UIView!
    @IBOutlet weak var shareBottomView: UIView!
    @IBOutlet weak var saveBottomView: UIView!
    @IBOutlet weak var deleteBottomView: UIView!
    @IBOutlet weak var undoBottomView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        likeBottomView.isHidden = false
        shareBottomView.isHidden = true
        saveBottomView.isHidden = true
        deleteBottomView.isHidden = true
        undoBottomView.isHidden = true
        
        undoImage.alpha = 0.2
        deleteImage.alpha = 0.2
        saveImage.alpha = 0.2
        shareImage.alpha = 0.2
        likeImage.alpha = 1.0
        // Do any additional setup after loading the view.
    }
    
    @IBAction func undoNextButtonAction(_ sender: Any) {
        //showMessage(with: "Work in progress", theme: .warning)
        if viewModel.isCome == "MatchMaking"{
            viewModel.proceedForCreateMatchMakingProfile()
        } else{
            viewModel.proceedForHome()
        }
    }
    @IBAction func rejectNextButtonAction(_ sender: Any) {
        likeBottomView.isHidden = true
        shareBottomView.isHidden = true
        saveBottomView.isHidden = true
        deleteBottomView.isHidden = true
        undoBottomView.isHidden = false
        
        undoImage.alpha = 1.0
        deleteImage.alpha = 0.2
        saveImage.alpha = 0.2
        shareImage.alpha = 0.2
        likeImage.alpha = 0.2
        
    }
    @IBAction func saveNextButtonAction(_ sender: Any) {
        likeBottomView.isHidden = true
        shareBottomView.isHidden = true
        saveBottomView.isHidden = true
        deleteBottomView.isHidden = false
        undoBottomView.isHidden = true
        
        undoImage.alpha = 0.2
        deleteImage.alpha = 1.0
        saveImage.alpha = 0.2
        shareImage.alpha = 0.2
        likeImage.alpha = 0.2
        
    }
    @IBAction func shareNextButtonAction(_ sender: Any) {
        likeBottomView.isHidden = true
        shareBottomView.isHidden = true
        saveBottomView.isHidden = false
        deleteBottomView.isHidden = true
        undoBottomView.isHidden = true
        
        undoImage.alpha = 0.2
        deleteImage.alpha = 0.2
        saveImage.alpha = 1.0
        shareImage.alpha = 0.2
        likeImage.alpha = 0.2
    }

    @IBAction func likeNextButtonAction(_ sender: Any) {
        likeBottomView.isHidden = true
        shareBottomView.isHidden = false
        saveBottomView.isHidden = true
        deleteBottomView.isHidden = true
        undoBottomView.isHidden = true
        
        undoImage.alpha = 0.2
        deleteImage.alpha = 0.2
        saveImage.alpha = 0.2
        shareImage.alpha = 1.0
        likeImage.alpha = 0.2
        
    }
    
    @IBAction func skipAllButton(_ sender: UIButton) {
        if viewModel.isCome == "MatchMaking"{
            viewModel.proceedForCreateMatchMakingProfile()
        } else{
            viewModel.proceedForHome()
        }
    }
   
}
