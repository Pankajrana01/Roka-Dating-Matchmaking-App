//
//  Extensions.swift
//  JZCalendarWeekView
//
//  Created by Jeff Zhang on 16/4/18.
//  Copyright © 2018 Jeff Zhang. All rights reserved.
//

import UIKit

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}

extension UICollectionView {

    func setContentOffsetWithoutDelegate(_ contentOffset: CGPoint, animated: Bool) {
        let tempDelegate = self.delegate
        self.delegate = nil
        self.setContentOffset(contentOffset, animated: animated)
        self.delegate = tempDelegate
    }
}

// Anchor Constraints from JZiOSFramework
extension UIView {

    func setAnchorConstraintsEqualTo(widthAnchor: CGFloat?=nil, heightAnchor: CGFloat?=nil, centerXAnchor: NSLayoutXAxisAnchor?=nil, centerYAnchor: NSLayoutYAxisAnchor?=nil) {

        self.translatesAutoresizingMaskIntoConstraints = false

        if let width = widthAnchor {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        if let height = heightAnchor {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }

        if let centerX = centerXAnchor {
            self.centerXAnchor.constraint(equalTo: centerX).isActive = true
        }

        if let centerY = centerYAnchor {
            self.centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
    }

    // bottomAnchor & trailingAnchor should be negative
    func setAnchorConstraintsEqualTo(widthAnchor: CGFloat?=nil, heightAnchor: CGFloat?=nil, topAnchor: (NSLayoutYAxisAnchor, CGFloat)?=nil, bottomAnchor: (NSLayoutYAxisAnchor, CGFloat)?=nil, leadingAnchor: (NSLayoutXAxisAnchor, CGFloat)?=nil, trailingAnchor: (NSLayoutXAxisAnchor, CGFloat)?=nil) {

        self.translatesAutoresizingMaskIntoConstraints = false

        if let width = widthAnchor {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        if let height = heightAnchor {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }

        if let topY = topAnchor {
            self.topAnchor.constraint(equalTo: topY.0, constant: topY.1).isActive = true
        }

        if let botY = bottomAnchor {
            self.bottomAnchor.constraint(equalTo: botY.0, constant: botY.1).isActive = true
        }

        if let leadingX = leadingAnchor {
            self.leadingAnchor.constraint(equalTo: leadingX.0, constant: leadingX.1).isActive = true
        }

        if let trailingX = trailingAnchor {
            self.trailingAnchor.constraint(equalTo: trailingX.0, constant: trailingX.1).isActive = true
        }
    }

    func setAnchorCenterVerticallyTo(view: UIView, widthAnchor: CGFloat?=nil, heightAnchor: CGFloat?=nil, leadingAnchor: (NSLayoutXAxisAnchor, CGFloat)?=nil, trailingAnchor: (NSLayoutXAxisAnchor, CGFloat)?=nil) {
        self.translatesAutoresizingMaskIntoConstraints = false

        setAnchorConstraintsEqualTo(widthAnchor: widthAnchor, heightAnchor: heightAnchor, centerYAnchor: view.centerYAnchor)

        if let leadingX = leadingAnchor {
            self.leadingAnchor.constraint(equalTo: leadingX.0, constant: leadingX.1).isActive = true
        }

        if let trailingX = trailingAnchor {
            self.trailingAnchor.constraint(equalTo: trailingX.0, constant: trailingX.1).isActive = true
        }
    }

    func setAnchorCenterHorizontallyTo(view: UIView, widthAnchor: CGFloat?=nil, heightAnchor: CGFloat?=nil, topAnchor: (NSLayoutYAxisAnchor, CGFloat)?=nil, bottomAnchor: (NSLayoutYAxisAnchor, CGFloat)?=nil) {
        self.translatesAutoresizingMaskIntoConstraints = false

        setAnchorConstraintsEqualTo(widthAnchor: widthAnchor, heightAnchor: heightAnchor, centerXAnchor: view.centerXAnchor)

        if let topY = topAnchor {
            self.topAnchor.constraint(equalTo: topY.0, constant: topY.1).isActive = true
        }

        if let botY = bottomAnchor {
            self.bottomAnchor.constraint(equalTo: botY.0, constant: botY.1).isActive = true
        }
    }

    func setAnchorConstraintsFullSizeTo(view: UIView, padding: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: view.topAnchor, constant: padding).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding).isActive = true
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
    }

    func addSubviews(_ views: [UIView]) {
        views.forEach({ self.addSubview($0)})
    }

    var snapshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }

    func setDefaultShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.05
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 4
        self.layer.masksToBounds = false
    }
}

extension UILabel {
    class func getLabelWidth(_ height: CGFloat, font: UIFont, text: String) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: .greatestFiniteMagnitude, height: height))
        label.font = font
        label.numberOfLines = 0
        label.text = text
        label.sizeToFit()
        return label.frame.width
    }
}

extension Date {

    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }

    var isYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }

    var isTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(self)
    }

    static func getCurrentWeekDays(firstDayOfWeek: DayOfWeek?=nil) -> [Date] {
        var calendar = Calendar.current
        calendar.firstWeekday = (firstDayOfWeek ?? .Sunday).rawValue
        let today = calendar.startOfDay(for: Date())
        let dayOfWeek = calendar.component(.weekday, from: today)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
        let days = (weekdays.lowerBound ..< weekdays.upperBound).compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }
        return days
    }

    func add(component: Calendar.Component, value: Int) -> Date {
        return Calendar.current.date(byAdding: component, value: value, to: self)!
    }

//    var startOfDay: Date {
//        return Calendar.current.startOfDay(for: self)
//    }
//
//    var endOfDay: Date {
//        return self.set(hour: 23, minute: 59, second: 59)
//    }

    func getDayOfWeek() -> DayOfWeek {
        let weekDayNum = Calendar.current.component(.weekday, from: self)
        let weekDay = DayOfWeek(rawValue: weekDayNum)!
        return weekDay
    }

    func getTimeIgnoreSecondsFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }

    static func daysBetween(start: Date, end: Date, ignoreHours: Bool) -> Int {
        let startDate = ignoreHours ? start.startOfDay : start
        let endDate = ignoreHours ? end.startOfDay : end
        return Calendar.current.dateComponents([.day], from: startDate, to: endDate).day!
    }

    static let components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second, .weekday]
    private var dateComponents: DateComponents {
        return  Calendar.current.dateComponents(Date.components, from: self)
    }

    var year: Int { return dateComponents.year! }
    var month: Int { return dateComponents.month! }
    var day: Int { return dateComponents.day! }
    var hour: Int { return dateComponents.hour! }
    var minute: Int { return dateComponents.minute! }
    var second: Int { return dateComponents.second! }

    var weekday: Int { return dateComponents.weekday! }

    func set(year: Int?=nil, month: Int?=nil, day: Int?=nil, hour: Int?=nil, minute: Int?=nil, second: Int?=nil, tz: String?=nil) -> Date {
        let timeZone = Calendar.current.timeZone
        let year = year ?? self.year
        let month = month ?? self.month
        let day = day ?? self.day
        let hour = hour ?? self.hour
        let minute = minute ?? self.minute
        let second = second ?? self.second
        let dateComponents = DateComponents(timeZone: timeZone, year: year, month: month, day: day, hour: hour, minute: minute, second: second)
        let date = Calendar.current.date(from: dateComponents)
        return date!
    }


    var startOfWeek: String? {

        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        guard let date = gregorian.date(byAdding: .day, value: 1, to: sunday) else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }

    var endOfWeek: String? {

        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        guard let date = gregorian.date(byAdding: .day, value: 7, to: sunday) else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }

    var startDateOfWeek: Date? {

        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        guard let date = gregorian.date(byAdding: .day, value: 1, to: sunday) else { return nil }
        return date
    }

    var endDateOfWeek: Date? {

        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        guard let date = gregorian.date(byAdding: .day, value: 7, to: sunday) else { return nil }
        return date
    }

    func convertToDateFormate(convertTo: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = convertTo
        let dateString = dateFormatter.string(from: self)
        return  dateFormatter.date(from: dateString) ?? Date()
    }

    func convertToStringFormat(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)

    }

    func getDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: self)
    }


    func getStartDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }

    func getEndDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }

    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }



    func getDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: self)
    }

    func getMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }

    func getYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }

    mutating func addDays(n: Int) {
        let calendar = Calendar.current

        self = calendar.date(byAdding: .day, value: n, to: self)!
    }

    func firstDayOfTheMonth(date: Date) -> Date {
        let calendar = Calendar.current

        return calendar.date(from: calendar.dateComponents([.year,.month], from: date))!
    }

    func getAllDays(isWeekView: Bool) -> [Date] {

        if isWeekView {
            return getAllDaysOfTheCurrentWeek()
        }

        var days = [Date]()

        if weekDay() > 1 {
            let calendar = Calendar.current
            let range = calendar.range(of: .day, in: .month, for: getPreviousMonth()!)!

            days.append(contentsOf: makeList(date: getPreviousMonth()!, fromDate: range.count - (weekDay() - 2)))
        }

        days.append(contentsOf: makeList(date: self, fromDate: 1))

        if days.count % 7 != 0 {
            let separatedDate = separateDate(date: getNextMonth()!)
            let firstDate = DateComponents(year: Int(separatedDate.2), month: Int(separatedDate.1), day: 1)
            let lastDate = DateComponents(year: Int(separatedDate.2), month: Int(separatedDate.1), day: 7 - (days.count % 7))

            let calendar = Calendar.current

            days.append(contentsOf: getDates(from: calendar.date(from: firstDate)!, to: calendar.date(from: lastDate)!))
        }

        return days
    }

    func getAllDaysOfTheCurrentWeek() -> [Date] {
        var calendar = Calendar.autoupdatingCurrent
        calendar.firstWeekday = 1 // Start on Monday (or 1 for Sunday)
        let today = calendar.startOfDay(for: self)
        var week = [Date]()
        if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) {
            for i in 0...6 {
                if let day = calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                    week += [day]
                }
            }
        }
        return week
    }

    func separateDate(date: Date) -> (String, String, String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: date)
        formatter.dateFormat = "MM"
        let month = formatter.string(from: date)
        formatter.dateFormat = "dd"
        let day = formatter.string(from: date)

        return (day, month, year)
    }

    func makeList(date: Date, fromDate: Int) -> [Date] {
        var days = [Date]()

        let calendar = Calendar.current

        let range = calendar.range(of: .day, in: .month, for: date)!

        let separatedDate = separateDate(date: firstDayOfTheMonth(date: date))
        var dateComponent = DateComponents(year: Int(separatedDate.2), month: Int(separatedDate.1), day: fromDate)
        dateComponent.timeZone = TimeZone.current

        var day = calendar.date(from: dateComponent)!

        for _ in fromDate...range.count {
            days.append(day)
            day.addDays(n: 1)
        }

        return days
    }

    func weekDay() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday ?? 1
    }

    func getNextMonth() -> Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: 1, to: self)
    }

    func getPreviousMonth() -> Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: -1, to: self)
    }

    func getDates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate

        while date <= toDate {
            dates.append(date)
            let calendar = Calendar.current

            guard let newDate = calendar.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }

    func isFromSelectedMonth(date: Date) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        let month1 = formatter.string(from: date)
        let month2 = formatter.string(from: self)

        return month1 == month2
    }

    func startOfMonth() -> String {
        if let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self))) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return dateFormatter.string(from: date)
        }
        return ""
    }

    func endOfMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        if let startOfMonth = dateFormatter.date(from: self.startOfMonth()), let date = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth) {
            return dateFormatter.string(from: date)
        }

        return ""
    }

    var stringValue: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: self)
    }

    func getDateFromNow(whenDifferenceInDays days: Int) -> Date? {
        let calendar = Calendar.current

        guard let date = calendar.date(byAdding: .day, value: -(days - 1), to: self) else {
            return nil
        }
        return calendar.startOfDay(for: date)
    }

    func compareDates(date: Date) -> Bool{

        return Calendar.current.isDate(date, equalTo: self, toGranularity: .day)
    }

    func getMinsByAddition(weeks:Int, days:Int, hours:Int, minutes: Int, previousDate: Date) -> Date {
        let monthsToAdd = weeks
        let daysToAdd = days
        let hoursToAdd = hours
        let minutesToAdd = minutes
        let currentDate = previousDate
        var dateComponent = DateComponents()
        dateComponent.month = monthsToAdd
        dateComponent.day = daysToAdd
        dateComponent.hour = hoursToAdd
        dateComponent.minute = minutesToAdd
        guard let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate) else { return Date() }
        return futureDate
//        print(currentDate)
//        print(futureDate!)
    }
 
}

public enum DayOfWeek: Int {
    case Sunday = 1, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
}

extension CGFloat {

    func toDecimal1Value() -> CGFloat {
        return (self * 10).rounded() / 10
    }

}
