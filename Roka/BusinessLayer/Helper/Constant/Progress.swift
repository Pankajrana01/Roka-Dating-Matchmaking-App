//
//  AppDelegate.swift
//  Roka
//
//  Created by Applify  on 19/09/22.
//

import Foundation
import MBProgressHUD

class Progress: NSObject {
    static let instance = Progress()
    var hud = MBProgressHUD()
    var window: UIWindow?
    
    override init() {
        window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
    }
    
    func show() {
        if let window = UIApplication.shared.mainKeyWindow {
            hud = MBProgressHUD.showAdded(to: window, animated: true)
            hud.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            hud.bezelView.color = .black
            hud.mode = .indeterminate
            hud.bezelView.style = .solidColor
            hud.contentColor = .white
        }
    }
    
    func show(with text:String) {
        if let window = UIApplication.shared.mainKeyWindow {
            hud = MBProgressHUD.showAdded(to: window, animated: true)
            hud.label.text = text
            hud.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            hud.bezelView.color = .black
            hud.mode = .indeterminate
            hud.bezelView.style = .solidColor
            hud.contentColor = .white
        }
    }
    
    func hide() {
        if let window = UIApplication.shared.mainKeyWindow {
            MBProgressHUD.hide(for: window, animated: true)
        }
    }
    
    // global functions
    func delay(_ seconds: Double, f: @escaping () -> Void) {
        let delay = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delay) {
            f()
        }
    }
}
