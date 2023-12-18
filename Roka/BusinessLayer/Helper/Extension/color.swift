//
//  AppDelegate.swift
//  Roka
//
//  Created by Applify  on 19/09/22.
//

import Foundation
import UIKit

//struct Color {//###2A383D
//    static let navBarColor                            = UIColor(named: "NavBarColor") ?? UIColor.black
//    static let titleColor = UIColor(hex: "#868B8D")!
//    static let navigationcolor                        = UIColor(hex: "#E7F5F3")!
//    static let headingcolor                           = UIColor(hex: "#3E3E3E")!
//    static let appThemecolor                          = UIColor(hex: "#3E3E3E")!
//    static let textFldTintColor                       = UIColor(hex: "##959595")!
//    static let textFldTextColor                       = UIColor(hex: "##2A383D")!
//}

//extension UIColor {
//
//    var hexString: String {
//        let components = self.cgColor.components
//        let red: CGFloat = components?[0] ?? 0.0
//        let green: CGFloat = components?[1] ?? 0.0
//        let blue: CGFloat = components?[2] ?? 0.0
//        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(red * 255)), lroundf(Float(green * 255)), lroundf(Float(blue * 255)))
//        return hexString
//    }
//
//    public convenience init?(hex: String) {
//        if hex == "" {
//            self.init(red: 0, green: 0, blue: 0, alpha: 0)
//            return
//        }
//        var colorString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
//        colorString = colorString.replacingOccurrences(of: "#", with: "").uppercased()
//        let alpha: CGFloat = 1.0
//        let red: CGFloat = UIColor.colorComponentFrom(colorString: colorString, start: 0, length: 2)
//        let green: CGFloat = UIColor.colorComponentFrom(colorString: colorString, start: 2, length: 2)
//        let blue: CGFloat = UIColor.colorComponentFrom(colorString: colorString, start: 4, length: 2)
//        self.init(red: red, green: green, blue: blue, alpha: alpha)
//        return
//    }
//
//    private static func colorComponentFrom(colorString: String, start: Int, length: Int) -> CGFloat {
//
//        let startIndex = colorString.index(colorString.startIndex, offsetBy: start)
//        let endIndex = colorString.index(startIndex, offsetBy: length)
//        let subString = colorString[startIndex..<endIndex]
//        let fullHexString = length == 2 ? subString : "\(subString)\(subString)"
//        var hexComponent: UInt32 = 0
//        guard Scanner(string: String(fullHexString)).scanHexInt32(&hexComponent) else {
//            return 0
//        }
//        let hexFloat: CGFloat = CGFloat(hexComponent)
//        let floatValue: CGFloat = CGFloat(hexFloat / 255.0)
//        return floatValue
//    }
//}

extension UIColor {
    class func rbg(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        let color = UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
        return color
    }
    
    class func RGBA(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        let color = UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
        return color
    
    }
}

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
    }
}

extension UIColor {
    class var appAlertOpacity: UIColor {
        return UIColor(named: "AppAlertOpacity")!
    }

    class var appBorder: UIColor {
        return UIColor(named: "AppBorder")!
    }

    class var appGray: UIColor {
        return UIColor(named: "AppGray")!
    }

    class var appLightBlack: UIColor {
        return UIColor(named: "AppLightBlack")!
    }

    class var appLightGray: UIColor {
        return UIColor(named: "AppLightGray")!
    }

    class var appPlaceholder: UIColor {
        return UIColor(named: "AppPlaceholder")!
    }

    class var appSeparator: UIColor {
        return UIColor(named: "AppSeparator")!
    }

    class var appTextColor: UIColor {
        return UIColor(named: "AppTextColor")!
    }
    
    class var appTextGreyColor: UIColor {
        return UIColor(named: "AppTextGreyColor")!
    }
    
    class var appYellowColor: UIColor {
        return UIColor(named: "AppYellowColor")!
    }
    
    class var loginBlueColor: UIColor {
        return UIColor(named: "LoginBlueColor")!
    }
    
    class var appTitleBlueColor: UIColor {
        return UIColor(named: "AppTitleBlueColor")!
    }
    
    class var appDescColor: UIColor {
        return UIColor(named: "AppDescColor")!
    }
    
    class var appPurpleColor: UIColor {
        return UIColor(named: "AppPurpleColor")!
    }
    
    class var appBorderColor: UIColor {
        return UIColor(named: "AppBorderColor")!
    }
    
    class var appBrownColor: UIColor {
        return UIColor(named: "AppBrownColor")!
    }
    
    class var appLightBlueColor: UIColor {
        return UIColor(named: "AppLightBlueColor")!
    }
    
    class var appLightOrangeColor: UIColor {
        return UIColor(named: "AppLightOrangeColor")!
    }
    
    class var appSkyLightBlueColor: UIColor {
        return UIColor(named: "AppSkyLightBlueColor")!
    }
    
    class var forYouBorderColor: UIColor {
        return UIColor(named: "ForYouBorderColor")!
    }
    
    class var appLightBorderColor: UIColor {
        return UIColor(named: "AppLightBorderColor")!
    }
    
    
    
}
