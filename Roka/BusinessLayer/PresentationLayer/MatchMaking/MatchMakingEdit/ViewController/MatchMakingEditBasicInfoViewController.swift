//
//  MatchMakingEditBasicInfoViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 28/07/23.
//

import UIKit

class MatchMakingEditBasicInfoViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.matchMakingEdit
        
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.matchMakingBasicInfoEdit
    }

    lazy var viewModel: MatchMakingEditBasicInfoViewModel = MatchMakingEditBasicInfoViewModel(hostViewController: self)

    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    selectedProfile:ProfilesModel,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! MatchMakingEditBasicInfoViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.viewModel.selectedProfile = selectedProfile
        controller.hidesBottomBarWhenPushed = true
        controller.show(from: viewController, forcePresent: forcePresent)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
