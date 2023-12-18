//
//  StepThreeViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 28/09/22.
//

import UIKit

class StepThreeViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.lookingForLoveProfile
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.stepThree
    }

    lazy var viewModel: StepThreeViewModel = StepThreeViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    selectedImages: [ImageModel],
                    isComeFor: String,
                    basicDetailsDictionary : [String:Any],
                    preferredDetailsDictionary : [String:Any],
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! StepThreeViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.selectedImages = selectedImages
        controller.viewModel.copySelectedImages = selectedImages
        controller.viewModel.isComeFor = isComeFor
        controller.viewModel.basicDetailsDictionary = basicDetailsDictionary
        controller.viewModel.preferredDetailsDictionary = preferredDetailsDictionary
        controller.hidesBottomBarWhenPushed = true
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
   
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var minimumLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.nextButton = nextButton
        viewModel.collectionView = collectionView
        viewModel.collectionViewHeight = collectionViewHeight
        viewModel.minimumLable = minimumLable
        
        if viewModel.selectedImages.count <= 3 {
            collectionViewHeight.constant = 120
        } else {
            collectionViewHeight.constant = 240
        }
        
        if viewModel.selectedImages.count <= 2 {
            minimumLable.isHidden = false
        } else {
            minimumLable.isHidden = true
        }
        //viewModel.enableDisableNextButton()
        // Do any additional setup after loading the view.
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        showNavigationWhiteLogoinCenter()
        addNavigationBackButton()
        if GlobalVariables.shared.cameraCancel == "" {
            viewModel.initializeInputsData()
        }
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        viewModel.uploadImages()
    }
    
}
