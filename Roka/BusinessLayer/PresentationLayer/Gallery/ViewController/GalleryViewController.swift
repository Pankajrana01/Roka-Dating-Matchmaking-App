//
//  GalleryViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 01/11/22.
//

import UIKit

class GalleryViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.gallery
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.gallery
    }

    lazy var viewModel: GalleryViewModel = GalleryViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! GalleryViewController
        controller.viewModel.completionHandler = completionHandler
        controller.hidesBottomBarWhenPushed = true
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var uploadSixImagesLabel:UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.collectionView = collectionView
      //  showNavigationBackButton(title: "  Gallery")
        self.addNavigationBackButtonn()
        self.title = "My photos"
        self.viewModel.processForGetUserGalleryData { respose in
        }
        // Do any additional setup after loading the view.
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

    @IBAction func nextButton(_ sender: UIButton) {
        viewModel.uploadImages()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.viewModel.initializeInputsData()
    }
}
