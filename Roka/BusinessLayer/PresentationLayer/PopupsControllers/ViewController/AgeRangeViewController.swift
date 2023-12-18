//
//  AgeRangeViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 11/10/22.
//

import UIKit

class AgeRangeViewController: BaseAlertViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.popups
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.ageRange
    }

    lazy var viewModel: AgeRangeViewModel = AgeRangeViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(over host: UIViewController,
                    isCome:String,
                    isFriend : Bool,
                    completionHandler: @escaping ((Int, Int, Int) -> Void)) {
        let controller = self.getController() as! AgeRangeViewController
        controller.viewModel.isCome = isCome
        controller.show(over: host, isCome: isCome, isFriend: isFriend, completionHandler: completionHandler)
    }
    
    func show(over host: UIViewController,
              isCome:String,
              isFriend : Bool,
              completionHandler: @escaping ((Int, Int, Int) -> Void)) {
        viewModel.completionHandler = completionHandler
        viewModel.isCome = isCome
        viewModel.isFriend = isFriend
        show(over: host)
    }

    @IBOutlet weak var rangeSlider1: RangeSeekSlider!
    @IBOutlet weak var rangeSlider1Label: UILabel!
    @IBOutlet weak var rangeSlider2: RangeSeekSlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.rangeSlider1 = rangeSlider1
        viewModel.rangeSlider2 = rangeSlider2
        viewModel.rangeSlider1Label = rangeSlider1Label
        viewModel.rangeSlider1Initialize()
        viewModel.rangeSlider2Initialize()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.processForGetUserPreferenceProfileData()

    }
    
    @IBAction func saveButtonActiob(_ sender: UIButton) {
        viewModel.saveButtonAction()
        self.dismiss()
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss()
    }

}
