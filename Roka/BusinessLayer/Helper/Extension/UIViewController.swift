//
//  UIViewController.swift
//  KarGoCustomer
//
//  Created by Applify on 22/07/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func endEditing(_ force: Bool) {
        self.view.endEditing(force)
    }
    
    func showAlert(with title: String? = nil,
                   message: String,
                   style: UIAlertController.Style = .alert,
                   options: String...,
        completion: @escaping (Int) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        for (index, option) in options.enumerated() {
            alert.addAction(UIAlertAction(title: option, style: .default, handler: { action in
                completion(index)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
        }))
        
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backButtonTapped(_ sender: Any?) {
        if let navVC = self.navigationController,
           navVC.viewControllers.count > 1 {
            navVC.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

}


public extension UIViewController {
    var pagerController: DTPagerController? {
        get {
            var viewController = parent

            while viewController != nil {
                if let containerViewController = viewController as? DTPagerController {
                    return containerViewController
                }
                viewController = viewController?.parent
            }

            return nil
        }
    }
}

