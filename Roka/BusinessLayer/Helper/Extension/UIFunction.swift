//
//  AppDelegate.swift
//  Roka
//
//  Created by Applify  on 19/09/22.
//

import Foundation
import UIKit
import CoreTelephony

class UIFunction: NSObject {
    // MARK: Button
    class func createButton(frame: CGRect, bckgroundColor: UIColor?, image: UIImage?, title: NSString?, font: UIFont?, titleColor: UIColor?) -> UIButton {
        let button: UIButton = UIButton.init(type: .roundedRect)
        button.backgroundColor = bckgroundColor
        button.frame = frame
        button.isExclusiveTouch = true
        button.setTitle(title! as String, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.setBackgroundImage(image, for: .normal)
        button.titleLabel?.font = font
        return button
    }
    // MARK: Label
    class func createLable(frame: CGRect, bckgroundColor: UIColor?, title: NSString?, font: UIFont?, titleColor: UIColor?) -> UILabel {
        let label: UILabel = UILabel.init(frame: frame)
        label.backgroundColor = bckgroundColor
        label.text = title as String?
        label.textColor = titleColor
        label.font = font
        return label
    }
    // MARK: UIImageView
    class func createUIImageView(frame: CGRect, bckgroundColor: UIColor?, image: UIImage?) -> UIImageView {
        let imageView: UIImageView = UIImageView.init(frame: frame)
        imageView.image = image
        imageView.backgroundColor = bckgroundColor
        return imageView
    }
    // MARK: Create Header
    class func createHeader(frame: CGRect, bckgroundColor: UIColor?) -> UIView {
        let headerView: UIView = UIView.init(frame: frame)
        headerView.backgroundColor = bckgroundColor
        headerView.layer.masksToBounds = false
        headerView.layer.shadowColor = UIColor.gray.cgColor
        headerView.layer.shadowOffset = CGSize(width: CGFloat(1.0), height: CGFloat(1.0))
        headerView.layer.shadowOpacity = 1.0
        headerView.layer.shadowRadius = 2.0
        return headerView
    }
    // MARK: Create UIView
    class func createUIViews(frame: CGRect, bckgroundColor: UIColor?) -> UIView {
        let backGroundView: UIView = UIView.init(frame: frame)
        backGroundView.backgroundColor = bckgroundColor
        return backGroundView
    }
    // MARK: Create TextField
    class func createTextField(frame: CGRect, font: UIFont?, placeholder: NSString?) -> UITextField {
        let textField : UITextField = UITextField.init(frame: frame)
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 12.0)
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.contentVerticalAlignment = .center
        textField.contentHorizontalAlignment = .center
        textField.isSecureTextEntry = false
        textField.placeholder = placeholder as String?
        textField.clearButtonMode = .whileEditing
        textField.textColor = UIColor.black
        textField.leftViewMode = .always
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.backgroundColor = UIColor.clear
        return textField
    }
    // MARK: Create UIAlertView
    class func createActivityIndicatorView(frame: CGRect, bckgroundColor: UIColor?) -> UIActivityIndicatorView {
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(frame: frame)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = bckgroundColor
        return activityIndicator
    }
    // MARK: Detect Country Code
    class func autoDetectCountryCode() -> String {
        let network_Info = CTTelephonyNetworkInfo()
        let carrier = network_Info.serviceSubscriberCellularProviders?.first?.value
        let isdCode = carrier?.isoCountryCode?.uppercased()
        if isdCode == nil {
            return ""
        } else {
            return isdCode!
        }
    }
    class func getAllCountriesDataWithDialCodes() -> NSMutableArray {
        var countryArray = NSMutableArray()
        if let path = Bundle.main.path(forResource: "countries", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                countryArray = (jsonResult as? NSArray)?.mutableCopy() as? NSMutableArray ?? []
                return countryArray
            } catch let error {
                UIFunction.AGLogs(log: "parse error: " as AnyObject)
                UIFunction.AGLogs(log: error.localizedDescription as AnyObject)
            }
        } else {
            UIFunction.AGLogs(log: "Invalid filename/path." as AnyObject)
        }
        return countryArray
    }
    
    class func getCountryInfoWithDialCode(dialCode: String) -> NSDictionary {
        let arrayAllCountries = self.getAllCountriesDataWithDialCodes()
        let predicate = NSPredicate(format: "code == %@", dialCode)
        let searchDataSource = arrayAllCountries.filter { predicate.evaluate(with: $0) }
        if searchDataSource.count > 0 {
            return searchDataSource[0] as? NSDictionary ?? [:]
        } else {
            let dictionary : NSDictionary = ["name": "United States", "dial_code": "+1", "code": "US"]
            return dictionary
        }
    }
    
    class func stringContainsEmoji (string: NSString) -> Bool {
        var returnValue: Bool = false
        string.enumerateSubstrings(in: NSMakeRange(0, (string as NSString).length), options: NSString.EnumerationOptions.byComposedCharacterSequences) { (substring, _ , enclosingRange, stop) -> (Void) in
            let objCString:NSString = NSString(string:substring!)
            let hss: unichar = objCString.character(at: 0)
            if 0xd800 <= hss && hss <= 0xdbff {
                if objCString.length > 1 {
                    let ls1: unichar = objCString.character(at: 1)
                    let step1: Int = Int((hss - 0xd800) * 0x400)
                    let step2: Int = Int(ls1 - 0xdc00)
                    let uc: Int = Int(step1 + step2 + 0x10000)
                    if 0x1d000 <= uc && uc <= 0x1f77f {
                        returnValue = true
                    }
                }
            } else if objCString.length > 1 {
                let ls2: unichar = objCString.character(at: 1)
                if ls2 == 0x20e3 {
                    returnValue = true
                }
            } else {
                if 0x2100 <= hss && hss <= 0x27ff {
                    returnValue = true
                } else if 0x2b05 <= hss && hss <= 0x2b07 {
                    returnValue = true
                } else if 0x2934 <= hss && hss <= 0x2935 {
                    returnValue = true
                } else if 0x3297 <= hss && hss <= 0x3299 {
                    returnValue = true
                } else if hss == 0xa9 || hss == 0xae || hss == 0x303d || hss == 0x3030 || hss == 0x2b55 || hss == 0x2b1c || hss == 0x2b1b || hss == 0x2b50 {
                    returnValue = true
                }
            }
        }
        return returnValue
    }
    
    class func addSpacingInSring(stringValue: NSString) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: stringValue as String)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: (1.0), range: NSRange(location: 0, length: stringValue.length - 1))
        return attributedString
    }
    
    class func removeAllNULLValuesFromDictionary (dictionary: NSMutableDictionary) -> NSMutableDictionary {
        let allKeysArray: NSArray = dictionary.allKeys as NSArray
        for index in 0 ..< allKeysArray.count {
            let key: NSString = allKeysArray.object(at: index) as? NSString ?? ""
            
            if (dictionary.object(forKey: key) is NSArray) || (dictionary.object(forKey: key) is NSMutableArray) {
                let tempArray: NSMutableArray = NSMutableArray()
                let selectedKeyArray: NSMutableArray = dictionary.object(forKey: key) as? NSMutableArray ?? []
                for innerCount in 0 ..< selectedKeyArray.count {
                    var innerDictionary: NSMutableDictionary = NSMutableDictionary()
                    innerDictionary = selectedKeyArray.object(at: innerCount) as? NSMutableDictionary ?? [:]
                    let allKeysArrayOfInnerDictionary: NSArray = innerDictionary.allKeys as NSArray
                    for loop in 0 ..< allKeysArrayOfInnerDictionary.count {
                        guard let innerKey : NSString = allKeysArrayOfInnerDictionary.object(at: loop) as? NSString else { return [:] }
                        if allKeysArrayOfInnerDictionary.object(at: loop) is NSNull {
                            innerDictionary.setValue("", forKey: innerKey as String)
                        }
                    }
                    tempArray.add(innerDictionary)
                }
                dictionary.setObject(tempArray, forKey: key)
            } else if (dictionary.object(forKey: key) is NSDictionary) || (dictionary.object(forKey: key) is NSMutableDictionary) {
                var json: NSMutableDictionary = NSMutableDictionary()
                json = dictionary.object(forKey: key) as? NSMutableDictionary ?? [:]
                let allKeysArrayOfJSONDictionary: NSArray = json.allKeys as NSArray
                for loop in 0 ..< allKeysArrayOfJSONDictionary.count {
                    let innerKey: NSString = allKeysArrayOfJSONDictionary.object(at: loop) as? NSString ?? ""
                    if json.object(forKey: innerKey) is NSNull {
                        json.setValue("", forKey: innerKey as String)
                    }
                }
                dictionary.setObject(json, forKey: key)
            } else if dictionary.object(forKey: key) is NSNull {
                dictionary.setValue("", forKey: key as String)
            }
        }
        return dictionary
    }
    
    class func convertArrayToJSON (jsonObject: AnyObject) -> NSString {
        if let theJSONData = try? JSONSerialization.data(withJSONObject: jsonObject, options: []) {
            let theJSONText = String(data: theJSONData, encoding: .ascii)
            return theJSONText! as NSString
        }
        return ""
    }
    
    class func removeAllAudioFilesFromDocumentDirectory() {
        let fileManager: FileManager = FileManager.default
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths: NSArray = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) as NSArray
        guard let documentsDirectory = paths.object(at: 0) as? NSString else { return }
        guard let contents: NSArray =  try? fileManager.contentsOfDirectory(atPath: documentsDirectory as String) as NSArray else { return }
        let enumerator: NSEnumerator = contents.objectEnumerator()
        while let element = enumerator.nextObject() as? String {
            let fileName = element as NSString
            if fileName.pathExtension == "m4a" {
                let pathOfFile = documentsDirectory.appendingPathComponent(fileName as String)
                try? fileManager.removeItem(atPath: pathOfFile)
            }
        }
    }
    
    class func getCurrentUTCTime() -> NSString {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let returnDateInstring = dateFormatter.string(from: date as Date)
        return returnDateInstring as NSString
    }
    
    class func getCurrentMillis() -> NSString {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")!
        let strDate = dateFormatter.string(from: Date())
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        let date = dateFormatter.date(from: strDate)
        let myString2 = String(Int64((date?.timeIntervalSince1970)! * 1000))
        return myString2 as NSString
    }
    
    class func getDateFromUTC(strDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let dateFromString = dateFormatter.date(from: strDate)
        if dateFromString == nil
        {
            return Date()
        }
        return dateFromString!
    }
    
    class func dateFromMilliSeconds(dateMilliSeconds: Double) -> NSString {
        let date = NSDate(timeIntervalSince1970: TimeInterval(dateMilliSeconds / 1000.0))
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, hh:mm a"
        formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        let dateString = formatter.string(from: date as Date)
        return dateString as NSString
    }
    
    class func OnlyDateFromMilliSeconds(dateMilliSeconds: Double, type: NSInteger) -> NSString {
        if type == 0 {
            let date = NSDate(timeIntervalSince1970: TimeInterval(dateMilliSeconds / 1000.0))
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM yyyy"
            formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
            let dateString = formatter.string(from: date as Date)
            return dateString as NSString
        } else {
            let date = NSDate(timeIntervalSince1970: TimeInterval(dateMilliSeconds / 1000.0))
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
            let dateString = formatter.string(from: date as Date)
            return dateString as NSString
        }
    }
    
    class func downloadFileFromServer(audioUrl: NSString, completionHandler: @escaping (NSString) -> Void) {
        let url = NSURL(string: audioUrl as String)
        let todayDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY_MM_dd_hh_mm_ss"
        let audioName: String = "\(dateFormatter.string(from: todayDate)).m4a"
        let paths: [Any] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory: String? = (paths[0] as? String)
        let pathOfAudio: String = URL(fileURLWithPath: documentsDirectory!).appendingPathComponent(audioName).absoluteString
        let finalPath = NSURL(string: pathOfAudio as String)
        do {
            let data = try Data(contentsOf: url! as URL)
            try data.write(to: finalPath! as URL)
            completionHandler (audioName as NSString)
        } catch {
            completionHandler ("" as NSString)
        }
    }
    
    class func getDocumentsDirectory(fileName: NSString) -> NSString {
        let paths: [Any] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory: String? = (paths[0] as? String)
        let pathOfAudio = documentsDirectory?.appending("/").appending(fileName as String)
        return pathOfAudio! as NSString
    }
    
    class func getCurrentUTCTimeForGuessMessage() -> NSString {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier:"UTC")
        let returnDateInstring = dateFormatter.string(from: date as Date)
        return returnDateInstring as NSString
    }
    
    class func getRandomImageName() -> String {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        dateFormatter.dateFormat = "YYYY_MM_dd_hh_mm_ss.SSS"
        let stringFromDate = dateFormatter.string(from: date as Date)
        let imageName = stringFromDate + ".jpeg"
        return imageName
    }
    
    class func generateRandomStringWithLength(length: Int) -> String {
        let randomString: NSMutableString = NSMutableString(capacity: length)
        let letters: NSMutableString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var i: Int = 0

        while i < length {
            let randomIndex: Int = Int(arc4random_uniform(UInt32(letters.length)))
            randomString.append("\(Character( UnicodeScalar( letters.character(at: randomIndex))!))")
            i += 1
        }
        return String(randomString)
    }
    
    class func getRandomVideoName(videoExtension: String) -> String {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        dateFormatter.dateFormat = "YYYY_MM_dd_hh_mm_ss.SSS"
        let stringFromDate = dateFormatter.string(from: date as Date)
        let imageName = stringFromDate.appending(".\(videoExtension)")
        return imageName
    }
    
    class func generateRandomNumberFromUpperLimit(upperLimit: NSInteger) -> NSInteger {
        let offset = 0
        let mini = UInt32(offset)
        let maxi = UInt32(upperLimit   + offset)
        let randomNumber = Int(mini + arc4random_uniform(maxi - mini)) - offset
        return randomNumber
    }
    
    // MARK: - Get value from dictionary - Get Methods
    class func getObjectForKey(_ key: String!, dictResponse: NSDictionary!) -> AnyObject! {
        if key != nil {
            if let dict = dictResponse {
                if let value = dict.value(forKey: key) as AnyObject? {
                    if let _:NSNull = value as? NSNull {
                        return "" as AnyObject
                    } else {
                        if let valueString = value as? String {
                            if valueString == "<null>" {
                                return "" as AnyObject
                            }
                        }
                        return value
                    }
                } else {return "" as AnyObject}
            } else {return "" as AnyObject}
        } else {return "" as AnyObject}
    }
    
    class func getObjectForKeyNumber(_ key: String?, dictResponse: NSDictionary?) -> NSNumber? {
        if key != nil {
            if let dict = dictResponse {
                if let value: AnyObject = dict.value(forKey: key ?? "") as AnyObject? {
                    if let _:NSNull = value as? NSNull {
                        return 0
                    } else {
                        if let valueString = value as? String {
                            if valueString == "<null>"{
                                return 0
                            }
                        }
                        return (value as? NSNumber)
                    }
                } else {return 0}
            } else {return 0}
        } else {return 0}
    }
    
    class func getObjectForKeyInt(_ key: String!, dictResponse: NSDictionary!) -> Int! {
        if key != nil {
            if let dict = dictResponse {
                if let value: AnyObject = dict.value(forKey: key) as AnyObject? {
                    if let _:NSNull = value as? NSNull {
                        return 0
                    } else {
                        if let valueString = value as? String {
                            if valueString == "<null>" {
                                return 0
                            }
                        }
                        return Int(String(describing: value as AnyObject))
                    }
                } else {return 0}
            } else {return 0}
        } else {return 0}
    }
    
    class func getAgeFromDate(strDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        let date = dateFormatter.date(from: strDate)
        if (date as AnyObject).isKind(of: NSDate.self) {
            return ""
        }
        let dayHourMinuteSecond: Set<Calendar.Component> = [.year]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date!, to: Date())
        let years = "\(difference.year ?? 0)"
        return years
    }
    
    class func trimNextLineWithSpace(text: String) -> String {
        return text.replacingOccurrences(of: "\n", with: " ")
    }
    
    class func getAllStatesOfCountry(country: String) -> NSArray {
        if let path = Bundle.main.path(forResource: "states", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                guard let countriesArray = (jsonResult as? NSDictionary)?.value(forKey: "Countries") as? NSArray else { return [] }
                let resultPredicate = NSPredicate(format: "CountryName == %@", country)
                let selectedCountryArray = countriesArray.filtered(using: resultPredicate)
                if selectedCountryArray.count > 0 {
                    guard let selectedCountryDict = selectedCountryArray[0] as? NSDictionary else {return []}
                    guard let statesArray = (selectedCountryDict.value(forKey: "States") as? NSArray)?.value(forKey: "StateName") as? NSArray else { return [] }
                    return statesArray
                }
            } catch let error {
                UIFunction.AGLogs(log: "parse error:" as AnyObject)
                UIFunction.AGLogs(log: error.localizedDescription as AnyObject)
            }
        } else {
            UIFunction.AGLogs(log: "Invalid filename/path." as AnyObject)
        }
        return NSArray()
    }
    
    class func getAllCitiesOfState(state: String, country: String) -> NSArray {
        if let path = Bundle.main.path(forResource: "states", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                guard let countriesArray = (jsonResult as? NSDictionary)?.value(forKey: "Countries") as? NSArray else { return [] }
                let resultPredicate = NSPredicate(format: "CountryName == %@", country)
                let selectedCountryArray = countriesArray.filtered(using: resultPredicate)
                if selectedCountryArray.count > 0 {
                    guard let selectedCountryDict = selectedCountryArray[0] as? NSDictionary else { return []}
                    guard let statesArray = (selectedCountryDict.value(forKey: "States") as? NSArray) else { return [] }
                    let resultPredicate = NSPredicate(format: "StateName == %@", state)
                    let selectedStateArray = statesArray.filtered(using: resultPredicate)
                    if selectedStateArray.count > 0 {
                        guard let selectedStateDict = selectedStateArray[0] as? NSDictionary else {return []}
                        guard let citiesArray : NSMutableArray = (selectedStateDict.value(forKey: "Cities") as? NSArray)?.mutableCopy() as? NSMutableArray else {return []}
                        if citiesArray.count == 0 {
                            citiesArray.add(state)
                        }
                        return citiesArray
                    }
                }
            } catch let error {
                UIFunction.AGLogs(log: "parse error:" as AnyObject)
                UIFunction.AGLogs(log: error.localizedDescription as AnyObject)
            }
        } else {
            UIFunction.AGLogs(log: "Invalid filename/path." as AnyObject)
        }
        return NSArray()
    }

    class func compareTime(_ timeArray: Array<Substring>) -> String {

        let currentTime = Date().convertToDateFormate(convertTo: "hh:mm a")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"

        let nextTime = timeArray.first { timeStr in
            let time = dateFormatter.date(from: String(timeStr)) ?? Date()
            return currentTime < time
        }

        return String(nextTime ?? "")
    }
}
// MARK: - UUID
extension UIFunction {
    class func AGLogs(log: AnyObject) {
        //        if (isDebugingMode == "1")
        //        {
        //            print(log)
        //        }
    }
}
// MARK: - Localization File
extension UIFunction {
    class func getLocalizationString(text: String) -> String {
        let text = NSLocalizedString(text, comment: "")
        return text
    }
}
// MARK: - Chat
extension UIFunction {
    class func getKeyboardAnimationOptions(notification: Notification) -> (height: CGFloat?, duration: Double?, curve: UIView.AnimationOptions) {
        let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        let animationCurveRawNSN = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = (animationCurveRawNSN?.uintValue) ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        let keyboardFrameBegin = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height
        return (height: keyboardFrameBegin, duration: duration, curve: animationCurve)
    }
}
