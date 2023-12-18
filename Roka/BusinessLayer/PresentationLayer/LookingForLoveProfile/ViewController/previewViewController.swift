//
//  previewViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 28/09/22.
//

import UIKit

class previewViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.lookingForLoveProfile
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.preview
    }

    lazy var viewModel: PreviewViewModel = PreviewViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    selectedImages: [ImageModel],
                    selectedIndex : Int,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! previewViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.selectedImages = selectedImages
        controller.viewModel.copySelectedImages = selectedImages
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
        self.navigationController?.isNavigationBarHidden = true
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.appLightGray,
            NSAttributedString.Key.font : UIFont(name: "SharpSansTRIAL-MediumItalic", size: 14)!]
        imageTitleTextField.attributedPlaceholder = NSAttributedString(string: "Feel free to say a little something...", attributes:attributes)
        
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
        let selectedImgText = viewModel.selectedImages.map({$0.title})
        let copySelectedImagesText = viewModel.copySelectedImages.map({$0.title})

        if selectedImgText.containsSameText(as: copySelectedImagesText) && viewModel.selectedImages.count == viewModel.copySelectedImages.count{
            GlobalVariables.shared.isPreviewScreenBack = "yes"
            self.navigationController?.popViewController(animated: true)
        }
        else if selectedImgText.containsSameText(as: copySelectedImagesText){
            GlobalVariables.shared.isPreviewScreenBack = "yes"
            self.navigationController?.popViewController(animated: true)
        }
        else if viewModel.selectedImages.count == viewModel.copySelectedImages.count {
            GlobalVariables.shared.isPreviewScreenBack = "yes"
            self.navigationController?.popViewController(animated: true)
        }
        else {
            GlobalVariables.shared.isComeFor = "Preview"
            self.navigationController?.popViewController(animated: true)
        }
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

extension Array where Element: Comparable {
    func containsSameText(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}
