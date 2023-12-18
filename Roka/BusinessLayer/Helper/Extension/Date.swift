//
//  AppDelegate.swift
//  Roka
//
//  Created by Applify  on 19/09/22.
//

import Foundation
import UIKit

class DateHelper {
    class func convertDateString(dateString : String!, fromFormat sourceFormat : String!, toFormat desFormat : String!) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = sourceFormat
        let date = dateFormatter.date(from: dateString)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = desFormat
        return dateFormatter.string(from: date!)
    }
    
    class func differenceInDays(fromDate:String, toDate:String, endDate:String) -> String{
        let dateFormt = DateFormatter()
        dateFormt.locale = .current
        dateFormt.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormt.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let previousDate = Date().addingTimeInterval(19800)
        let now = dateFormt.date(from: toDate)
        let enddDate = dateFormt.date(from: endDate)
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.weekOfMonth, .day, .hour, .minute]
        formatter.maximumUnitCount = 0
        let string = formatter.string(from: previousDate, to: now!)
        if string?.contains(find: "-") == true {
            let string = formatter.string(from: previousDate, to: enddDate!)
            if string?.contains(find: "-") == true {
                return "" // COMPLETED
            } else {
                return "" //ONGOING
            }
        } else {
            return "\(string?.uppercased() ?? "")"
        }
    }
    
    class func differenceInCountDaysGoals(fromDate:String, toDate:String) -> String{
        let dateFormt = DateFormatter()
        dateFormt.locale = .current
//        dateFormt.dateFormat = DateFormat.BackEndFormat.rawValue
        dateFormt.dateFormat = "dd-MM-yyyy"
        dateFormt.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let previousDate = dateFormt.date(from: fromDate) ?? Date()
        let now = dateFormt.date(from: toDate)
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute]
        formatter.maximumUnitCount = 0
        let string = formatter.string(from: previousDate, to: now!)
        if string?.contains(find: "-") == true {
            return "N.A"
        } else {
            return "\(string?.lowercased() ?? "") to complete"
        }
    }
    
    class func differenceInCountDaysHabits(fromDate:String, toDate:String) -> String{
        let dateFormt = DateFormatter()
        dateFormt.locale = .current
//        dateFormt.dateFormat = DateFormat.BackEndFormat.rawValue
        dateFormt.dateFormat = "yyyy-MM-dd"
        dateFormt.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let previousDate = dateFormt.date(from: fromDate) ?? Date()
        let now = dateFormt.date(from: toDate)
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute]
        formatter.maximumUnitCount = 0
        let string = formatter.string(from: previousDate, to: now!)
        if string?.contains(find: "-") == true {
            return "N.A"
        } else {
            return "\(string?.lowercased() ?? "") to complete"
        }
    }
    
    class func differenceInCountDaysGoal(fromDate:String, toDate:String) -> Int{
        let dateFormt = DateFormatter()
        dateFormt.locale = .current
//        dateFormt.dateFormat = DateFormat.BackEndFormat.rawValue
        dateFormt.dateFormat = "dd-MM-yyyy"
        dateFormt.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let previousDate = dateFormt.date(from: fromDate) ?? Date()
        let now = dateFormt.date(from: toDate)
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.day]
        formatter.maximumUnitCount = 0
        let string = formatter.string(from: previousDate, to: now!)
        if string?.contains(find: "-") == true {
            return -1
        } else {
            let str = ((string?.lowercased().replacingOccurrences(of: " days", with: "")))
            let reqStr = str?.replacingOccurrences(of: "days", with: "")
            let reqStr2 = reqStr?.replacingOccurrences(of: " day", with: "")
            let reqStr3 = reqStr2?.replacingOccurrences(of: "day", with: "")
            return Int(reqStr3 ?? "-1") ?? -1
        }
    }
    
    class func differenceInCountDays(fromDate:String, toDate:String) -> String{
        let dateFormt = DateFormatter()
        dateFormt.locale = .current
//        dateFormt.dateFormat = DateFormat.BackEndFormat.rawValue
        dateFormt.dateFormat = "dd-MM-yyyy"
        dateFormt.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let previousDate = dateFormt.date(from: fromDate) ?? Date()
        let now = dateFormt.date(from: toDate)
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.day]
        formatter.maximumUnitCount = 0
        let string = formatter.string(from: previousDate, to: now!)
        if string?.contains(find: "-") == true {
            return "COMPLETED"
        } else {
            return "\(string?.uppercased() ?? "")"
        }
    }
    
    class func differenceInMinutes(fromTime:Date, toTime:Date) -> Int {

        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [ .hour, .minute]
        formatter.maximumUnitCount = 0
        
        let string = formatter.string(from: fromTime, to: toTime)?.uppercased()
        var isHr = false
        if string!.contains("HOUR") {
            isHr = true
        }
        if string?.contains(find: "-") == true {
            return 0
        } else {
            let time = string?.replacingOccurrences(of: "HOURS", with: "").replacingOccurrences(of: "HOUR", with: "").replacingOccurrences(of: "MINUTES", with: "").replacingOccurrences(of: "MINUTE", with: "").replacingOccurrences(of: " ", with: "").components(separatedBy: ",")
            if let timeList = time {
                if timeList.count > 1 {
                    return ((Int(timeList.first ?? "0") ?? 0) * 60) + (Int(timeList.last ?? "0") ?? 0)
                } else {
                    if isHr == true {
                        return ((Int(timeList.last ?? "0") ?? 0) * 60)
                    } else {
                        return Int(timeList.last ?? "0") ?? 0
                    }
                    
                }
            }
            return 0
        }
    }
}


extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}

func string_date_ToDate(_ date: String?, currentFormat: DateFormat, requiredFormat: DateFormat) -> String {
    if let dateStr = date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = currentFormat.rawValue
        let date = dateFormatter.date(from: dateStr)
        return date?.convertToStringFormat(format: requiredFormat.rawValue) ?? ""
    }
    return ""
}

func getDateFromString(_ date: String?) -> Date {
    if let dateStr = date {
        let dateFormt = DateFormatter()
        dateFormt.locale = .current
        dateFormt.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
      let date = dateFormt.date(from: dateStr)
        return date!
    }
    return Date()
}

enum DateFormat:String{
    case DayMonthYear   = "dd MMM yyyy"
    case ClickdateFrmt  = "yyy-MMM-dd"
    case YearMonthDate  = "yyyy-MM-dd"
    case EEEE_dd_MMMM   = "EEEE, dd MMMM"
    case E_dd_MMM       = "E, dd MMM"
    case hh_mm_a        = "hh:mm a"
    case HH_mm          = "HH:mm"
    case BackEndFormat  = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    case TimeWithAMorPMandMonthDay = "hh:mm a MM-dd-yy"
    case hh_mm_ss        = "HH:mm:ss"
    case yyyy_mm_dd_hh_mm_ss = "yyyy-MM-dd HH:mm:ss"
}


// MARK: - Extensions table view
extension UITableView {
    func reloadData(completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData()})
        {_ in completion() }
    }
    
    func setNoDataMessage(_ message: String,txtColor:UIColor) {
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            messageLabel.text = message
            messageLabel.textColor = txtColor
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.font = UIFont(name: "Roboto-Regular", size: 20)
            messageLabel.sizeToFit()
            self.backgroundView = messageLabel
            self.separatorStyle = .none
        }
    
    func ScrollToBottom() {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10)) {
                let numberOfSections = self.numberOfSections
                let numberOfRows = self.numberOfRows(inSection: 0)
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                    self.scrollToRow(at: indexPath, at: .bottom, animated: false )
                }
            }
        }
}
