//
//  HeightViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 10/10/22.
//

import UIKit

class HeightViewController: BaseAlertViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.popups
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.height
    }

    lazy var viewModel: HeightViewModel = HeightViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(over host: UIViewController,
                    isCome:String,
                    isFriend : Bool,
                    completionHandler: @escaping ((String, String, Int) -> Void)) {
        let controller = self.getController() as! HeightViewController
        controller.viewModel.isCome = isCome
        controller.show(over: host, isCome: isCome, isFriend: isFriend, completionHandler: completionHandler)
    }
    
    func show(over host: UIViewController,
              isCome:String,
              isFriend : Bool,
              completionHandler: @escaping ((String, String, Int) -> Void)) {
        viewModel.completionHandler = completionHandler
        viewModel.isCome = isCome
        viewModel.isFriend = isFriend
        show(over: host)
    }

    @IBOutlet weak var privateStackView: UIStackView!
    @IBOutlet weak var privateButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cmLable: UILabel!
    @IBOutlet weak var feetLable: UILabel!
    @IBOutlet weak var feetTickImage: UIImageView!
    @IBOutlet weak var centimetreLable: UILabel!
    @IBOutlet weak var centimetreTickImage: UIImageView!
    @IBOutlet weak var centimetreView: UIView!
    @IBOutlet weak var feetView: UIView!
    @IBOutlet weak var centimetreViewWidth: NSLayoutConstraint!
    @IBOutlet weak var feetViewWidth: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.viewModel.collectionView = self.collectionView

        feetView.layer.borderColor = UIColor.appBrownColor.cgColor
        feetLable.textColor = UIColor.appBrownColor
        feetTickImage.isHidden = false
        feetViewWidth.constant = 85
        
        centimetreView.layer.borderColor = UIColor.appBrownColor.withAlphaComponent(0.5).cgColor
        centimetreLable.textColor = UIColor.appBrownColor.withAlphaComponent(0.5)
        centimetreTickImage.isHidden = true
        centimetreViewWidth.constant = 130
        
        viewModel.isSelected = "feet"
        cmLable.text = "ft"
        self.privateButton.setImage(UIImage(named: "ic_toggle_active_generic"), for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if viewModel.isSelected == "centimetre" {
            viewModel.currentPage = 135
            viewModel.previousCMPage = 135
        } else {
            viewModel.currentPage = 48
            viewModel.previousFTPage = 48
        }
        
        viewModel.processForGetUserProfileData { userResponseData in
            if let heightType = userResponseData?["heightType"] as? String {
                if heightType == "Centimetre" {
                    self.centimetreView.layer.borderColor = UIColor.appBrownColor.cgColor
                    self.centimetreLable.textColor = UIColor.appBrownColor
                    self.centimetreTickImage.isHidden = false
                    self.centimetreViewWidth.constant = 140
                    
                    self.feetView.layer.borderColor = UIColor.appBrownColor.withAlphaComponent(0.5).cgColor
                    self.feetLable.textColor = UIColor.appBrownColor.withAlphaComponent(0.5)
                    self.feetTickImage.isHidden = true
                    self.feetViewWidth.constant = 75
                    
                    self.viewModel.isSelected = "centimetre"
                    self.cmLable.text = "cm"
                } else {
                    self.feetView.layer.borderColor = UIColor.appBrownColor.cgColor
                    self.feetLable.textColor = UIColor.appBrownColor
                    self.feetTickImage.isHidden = false
                    self.feetViewWidth.constant = 85
                    
                    self.centimetreView.layer.borderColor = UIColor.appBrownColor.withAlphaComponent(0.5).cgColor
                    self.centimetreLable.textColor = UIColor.appBrownColor.withAlphaComponent(0.5)
                    self.centimetreTickImage.isHidden = true
                    self.centimetreViewWidth.constant = 130
                    self.viewModel.isSelected = "feet"
                    self.cmLable.text = "ft"
                }
            }
        
            if let isHeightPrivate = userResponseData?["isHeightPrivate"] as? Int {
                if isHeightPrivate == 0 {
                    self.privateButton.setImage(UIImage(named: "ic_toggle_off_generic"), for: .normal)
                    self.viewModel.isPrivate = 0
                } else {
                    self.privateButton.setImage(UIImage(named: "ic_toggle_active_generic"), for: .normal)
                    self.viewModel.isPrivate = 1
                }
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.viewModel.scrollToCurrentPosition()
    }
   
    @IBAction func privateButtonAction(_ sender: UIButton) {
        if self.privateButton.currentImage == UIImage(named: "ic_toggle_active_generic") {
            self.privateButton.setImage(UIImage(named: "ic_toggle_off_generic"), for: .normal)
            self.viewModel.isPrivate = 0
        } else {
            self.privateButton.setImage(UIImage(named: "ic_toggle_active_generic"), for: .normal)
            self.viewModel.isPrivate = 1
        }
    }
    
    @IBAction func saveButtonActiob(_ sender: UIButton) {
        self.dismiss()
        viewModel.saveButtonAction()
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss()
    }
    
    @IBAction func feetAction(_ sender: Any) {
        feetView.layer.borderColor = UIColor.appBrownColor.cgColor
        feetLable.textColor = UIColor.appBrownColor
        feetTickImage.isHidden = false
        feetViewWidth.constant = 85
        
        centimetreView.layer.borderColor = UIColor.appBrownColor.withAlphaComponent(0.5).cgColor
        centimetreLable.textColor = UIColor.appBrownColor.withAlphaComponent(0.5)
        centimetreTickImage.isHidden = true
        centimetreViewWidth.constant = 130
        
        viewModel.isSelected = "feet"
        cmLable.text = "ft"
        DispatchQueue.main.async {
            self.collectionView.reloadData()
           // self.viewModel.currentPage = 48
            if let index = self.viewModel.conversionArr.firstIndex(where: {$0 == self.viewModel.selectedCentimetre}) {
                print(index)
                
                let val = self.viewModel.feetArr[index]
                print(val)
                
                if let index1 = self.viewModel.feetArr.firstIndex(where: {$0 == val}){
                    print(index1)
                    self.viewModel.currentPage = index1
                }
            } else {
                self.viewModel.currentPage = self.viewModel.previousFTPage
            }
            self.viewModel.scrollToCurrentPosition()
        }
    }
    
    @IBAction func centimetreAction(_ sender: Any) {
        centimetreView.layer.borderColor = UIColor.appBrownColor.cgColor
        centimetreLable.textColor = UIColor.appBrownColor
        centimetreTickImage.isHidden = false
        centimetreViewWidth.constant = 140
        
        feetView.layer.borderColor = UIColor.appBrownColor.withAlphaComponent(0.5).cgColor
        feetLable.textColor = UIColor.appBrownColor.withAlphaComponent(0.5)
        feetTickImage.isHidden = true
        feetViewWidth.constant = 75
        
        viewModel.isSelected = "centimetre"
        cmLable.text = "cm"
        DispatchQueue.main.async {
            self.collectionView.reloadData()
           // self.viewModel.currentPage = 135
            
            if let index = self.viewModel.feetArr.firstIndex(where: {$0 == self.viewModel.selectedFeet}) {
                print(index)
                let val = self.viewModel.conversionArr[index]
                print(val)
                
                if let index1 = self.viewModel.centimetreArr.firstIndex(where: {$0 == val}){
                    print(index1)
                    self.viewModel.currentPage = index1
                }
            } else {
                self.viewModel.currentPage = self.viewModel.previousCMPage
            }
            self.viewModel.scrollToCurrentPosition()
        }
    }
    
}

