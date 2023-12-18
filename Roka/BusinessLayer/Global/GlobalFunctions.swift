//
//  GlobalFunctions.swift
//  Covid19 tracking
//
//  Created by Aakash on 29/07/21.
//

import SwiftMessages
import SVProgressHUD
import UIKit
/// Shows default loader over the current screen

protocol ComponentShimmers {
    var animationDuration: Double { get }
    func hideViews()
    func showViews()
    func setShimmer()
    func removeShimmer()
}

func showLoader() {
    SVProgressHUD.show()
}

func showProgressLoader(text:String) {
    SVProgressHUD.show(withStatus: text)
}

func showSuccessLoader() {
    SVProgressHUD.showSuccess(withStatus: "Success")
    SVProgressHUD.dismiss(withDelay: 0.5)
}

/// Hides the loader
func hideLoader() {
    SVProgressHUD.dismiss()
}
// global functions
func delay(_ seconds: Double, f: @escaping () -> Void) {
    let delay = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: delay) {
        f()
    }
}

// MARK: - Top bar
func showWorkInProgress() {
    showMessage(with: "Work in progress", theme: .warning)
}

func showMessage(with title: String, theme: Theme = .error) {
    SwiftMessages.show {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(theme)
        view.configureContent(title: title , body: title, iconImage: Icon.info.image)
        view.button?.isHidden = true
        view.bodyLabel?.font = UIFont(name: "sfdisplay_regular", size: 15)
        view.titleLabel?.isHidden = true
        view.iconLabel?.isHidden = true
        return view
    }
}
func showSuccessMessage(with title: String, theme: Theme = .success) {
    SwiftMessages.show {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(theme)
        view.configureContent(title: title , body: title, iconImage: Icon.info.image)
        view.button?.isHidden = true
        view.bodyLabel?.font = UIFont(name: "sfdisplay_regular", size: 15)
        view.titleLabel?.isHidden = true
        view.iconLabel?.isHidden = true
        return view
    }
}

func calculateAge(birthday: String) -> Int {
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "yyyy/MM/dd"
    let birthdayDate = dateFormater.date(from: birthday)
    let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
    let now = Date()
    let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
    let age = calcAge.year
    return age!
}


/// A global function to check if the device has a top notch or not.
var hasTopNotch: Bool {
    if #available(iOS 11.0, tvOS 11.0, *) {
        return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
    }
    return false
}

func convertDateFormatString(dateTimeRequired:String, previousFormat:String, reqiuredFormat:String) -> String {
    let previousFormatter = DateFormatter()
    previousFormatter.dateFormat = previousFormat
    previousFormatter.timeZone = TimeZone(identifier: "UTC")

    let previousDate = previousFormatter.date(from: dateTimeRequired) ?? Date()
    let requiredFormatter = DateFormatter()
    requiredFormatter.dateFormat = reqiuredFormat
    requiredFormatter.timeZone = TimeZone(identifier: "UTC")

    return (requiredFormatter.string(from: previousDate))
}

class ScaledHeightImageView: UIImageView {

    override var intrinsicContentSize: CGSize {
        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width
            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio
            return CGSize(width: myViewWidth, height: scaledHeight)
        }
        return CGSize(width: -1.0, height: -1.0)
    }

}
