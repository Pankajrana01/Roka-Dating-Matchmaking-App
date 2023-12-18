//
//  GalleryPreviewViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 01/11/22.
//

import UIKit

class GalleryPreviewViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.gallery
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.galleryPreview
    }

    lazy var viewModel: GalleryPreviewViewModel = GalleryPreviewViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    selectedImages: [GalleryModel],
                    selectedIndex : Int,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! GalleryPreviewViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.selectedImages = selectedImages
        controller.viewModel.selectedIndex = selectedIndex
        controller.hidesBottomBarWhenPushed = true
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var imageScrollView: ImageScrollView!
    @IBOutlet weak var imageTitleTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        imageTitleTextField.delegate = viewModel
        viewModel.previewImage = previewImage
        viewModel.nextButton = nextButton
        viewModel.imageTitleTextField = imageTitleTextField
        viewModel.collectionView = collectionView
        viewModel.imageScrollView = imageScrollView
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if GlobalVariables.shared.selectedProfileMode != "MatchMaking" {
            KAPPDELEGATE.initializeDatingNavigationBar()
        } else {
            KAPPDELEGATE.initializeMatchMakingNavigationBar()
        }
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.viewModel.scrollToCurrentPosition()
    }
    
    @IBAction func backButton(_ sender: Any) {
        //viewModel.proceedForBackCreateProfileStepThree()
        let alert = UIAlertController(title: "By going back all the changes will be discarded.", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
            self.backButtonAction()
        }))
        
        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { action in        }))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(alert, animated: true, completion: nil)
        
       
    }
    
    func backButtonAction() {
        //self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure you want to delete this image?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
            self.viewModel.deleteButtonTapped()
        }))
        
        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { action in        }))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(alert, animated: true, completion: nil)
        
        //showMessage(with: "Work in progress", theme: .info)
    }
    

    @IBAction func nextButtonAction(_ sender: Any) {
        viewModel.proceedForCreateProfileStepThree()
    }
}
