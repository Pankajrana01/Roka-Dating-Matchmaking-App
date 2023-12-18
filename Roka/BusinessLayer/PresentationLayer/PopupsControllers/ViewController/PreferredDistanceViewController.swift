//
//  PreferredDistanceViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 07/12/23.
//

import UIKit

class PreferredDistanceViewController: BaseAlertViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.popups
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.distance
    }

    lazy var viewModel: PreferredDistanceViewModel = PreferredDistanceViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(over host: UIViewController,
                    completionHandler: @escaping ((String) -> Void)) {
        let controller = self.getController() as! PreferredDistanceViewController
        controller.show(over: host, completionHandler: completionHandler)
    }
    
    func show(over host: UIViewController,
              completionHandler: @escaping ((String) -> Void)) {
        viewModel.completionHandler = completionHandler
        show(over: host)
    }

    @IBOutlet weak var rangeSlider2: RangeSeekSlider!
    @IBOutlet weak var rangeSlider2Label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.rangeSlider2 = rangeSlider2
        viewModel.rangeSlider2Label = rangeSlider2Label
        viewModel.rangeSlider2Initialize()
        // Do any additional setup after loading the view.
        
        viewModel.processForGetUserProfileData { userResponseData in
        
        }
    }
    

    @IBAction func cancel(_ sender: Any) {
        self.dismiss()
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        self.viewModel.completionHandler?(self.viewModel.slider2Max)
        self.dismiss()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
