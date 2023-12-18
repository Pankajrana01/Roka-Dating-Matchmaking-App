//
//  LayoutViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 14/11/22.
//

import UIKit

class LayoutViewController: BaseAlertViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.popups
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.layout
    }

    lazy var viewModel: LayoutViewModel = LayoutViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(over host: UIViewController,
                    isCome : String,
                    isSelected:LayoutType,
                    completionHandler: @escaping ((LayoutType) -> Void)) {
        let controller = self.getController() as! LayoutViewController
        controller.show(over: host, isCome: isCome, isSelected: isSelected, completionHandler: completionHandler)
    }
    
    func show(over host: UIViewController,
              isCome : String,
              isSelected: LayoutType,
              completionHandler: @escaping ((LayoutType) -> Void)) {
        viewModel.completionHandler = completionHandler
        viewModel.isCome = isCome
        viewModel.isSelected = isSelected
        show(over: host)
    }

    @IBOutlet weak var gridButton: UIButton!
    @IBOutlet weak var fullButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if viewModel.isSelected?.rawValue == "grid" {
            self.gridButton.setImage(UIImage(named: "Ic_grid_selected"), for: .normal)
        } else if viewModel.isSelected?.rawValue == "list" {
            self.listButton.setImage(UIImage(named: "Ic_list"), for: .normal)
        } else if viewModel.isSelected?.rawValue == "full_view" {
            self.fullButton.setImage(UIImage(named: "Ic_full_view"), for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func gridAction(_ sender: UIButton) {
        if sender.tag == 100{ // grid
            viewModel.completionHandler?(LayoutType.grid)
        } else if sender.tag == 101{ // list
            viewModel.completionHandler?(LayoutType.list)
        } else if sender.tag == 102{ // full view
            viewModel.completionHandler?(LayoutType.full_view)
        }
        self.dismiss()
    }
    
    
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.dismiss()
    }
    
    
}
