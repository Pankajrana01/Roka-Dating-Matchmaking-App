//
//  CalendarViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 22/09/22.
//

import UIKit

class CalendarViewController: BaseAlertViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.popups
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.calendar
    }

    lazy var viewModel: CalendarViewModel = CalendarViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(over host: UIViewController,
                    selectedDate: String,
                    isCome:String,
                    isFriend : Bool,
                    completionHandler: @escaping ((String, String, Date) -> Void)) {
        let controller = self.getController() as! CalendarViewController
        controller.viewModel.isCome = isCome
        controller.show(over: host, selectedDate: selectedDate, isCome: isCome, isFriend: isFriend, completionHandler: completionHandler)
    }
    
    func show(over host: UIViewController,
              selectedDate: String,
              isCome:String,
              isFriend : Bool,
              completionHandler: @escaping ((String, String, Date) -> Void)) {
        viewModel.completionHandler = completionHandler
        viewModel.selectedDate = selectedDate
        viewModel.isCome = isCome
        viewModel.isFriend = isFriend
        show(over: host)
    }
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var privateStackView: UIStackView!
    @IBOutlet weak var privateButton: UIButton!
    @IBOutlet weak var privateLine: UIImageView!
    
    var strDate = ""
    var strDate2 = ""
    var strDate3 = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        //datePicker.maximumDate = Date()
        if self.viewModel.selectedDate != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            if let strDa = dateFormatter.date(from: self.viewModel.selectedDate) {
                print(strDa as Any)
                strDate3 = strDa
                datePicker.date = strDa
            }
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "dd MMM, yyyy"
            let strDate = dateFormatter2.string(from: datePicker.date)
            
            dateFormatter2.dateFormat = "yyyy/MM/dd"
            let strDate2 = dateFormatter2.string(from: datePicker.date)
            self.strDate = strDate
            self.strDate2 = strDate2
            
            
        } else {
            datePicker.date = Calendar.current.date(byAdding: .year, value: -18, to: Date())!
            datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM, yyyy"
            let strDate = dateFormatter.string(from: datePicker.date)
        
            dateFormatter.dateFormat = "yyyy/MM/dd"
            let strDate2 = dateFormatter.string(from: datePicker.date)
            self.strDate = strDate
            self.strDate2 = strDate2
            self.strDate3 = datePicker.date
        }
        self.privateButton.setImage(UIImage(named: "Ic_toggle_offPrivate"), for: .normal)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if viewModel.isCome == "MoreDetail" {
            privateStackView.isHidden = true
            privateLine.isHidden = true
        } else {
            privateStackView.isHidden = true
            privateLine.isHidden = true
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss()
    }
    
    @IBAction func saveButton(_ sender: Any) {
        viewModel.completionHandler!(strDate, strDate2, strDate3)
        self.dismiss()
    }
    
    @IBAction func privateButtonAction(_ sender: UIButton) {
        if self.privateButton.currentImage == UIImage(named: "Ic_toggle_onPrivate") {
            self.privateButton.setImage(UIImage(named: "Ic_toggle_offPrivate"), for: .normal)
        } else{
            self.privateButton.setImage(UIImage(named: "Ic_toggle_onPrivate"), for: .normal)
        }
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        let strDate = dateFormatter.string(from: datePicker.date)
    
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let strDate2 = dateFormatter.string(from: datePicker.date)
        self.strDate = strDate
        self.strDate2 = strDate2
        self.strDate3 = datePicker.date
        //viewModel.completionHandler!(strDate, strDate2, datePicker.date)
    }
}
