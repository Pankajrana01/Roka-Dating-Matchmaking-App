//
//  SubscriptionViewController.swift
//  Roka
//
//  Created by  Developer on 25/10/22.
//

import UIKit

class SubscriptionViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.buyPremium
        
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.mySubscription
    }

    lazy var viewModel: SubscriptionViewModel = SubscriptionViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    class func getController(with isCome: String) -> BaseViewController {
        let controller = self.getController() as! SubscriptionViewController
        controller.viewModel.isComeFor = isCome
        controller.hidesBottomBarWhenPushed = true
        return controller
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! SubscriptionViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.hidesBottomBarWhenPushed = true
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var changePlanButton: UIButton!
    @IBOutlet weak var noSubscriptionFound: UIView!
    @IBOutlet weak var noSubscriptionFoundInnerImg: UIImageView!
    @IBOutlet weak var noSubscriptionFoundInneerStackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    var subscriptionPlan = [SubscriptionsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topLabel.backgroundColor = UIColor.appTitleBlueColor
       // showNavigationBackButton(title: "  My Subscription")
        self.addNavigationBackButtonn()
        self.title = "My Subscription"
        setupTableView()
        self.noSubscriptionFoundInnerImg.isHidden = true
        self.noSubscriptionFoundInneerStackView.isHidden = true
        if viewModel.isComeFor == "COMPLEMENTARY_SUBSCRIPTION_GIVING" || viewModel.isComeFor == "COMPLEMENTARY_SUBSCRIPTION_REVOKING" {
            self.addNavigationBackButton()
        }
    }
    
    func addNavigationBackButtonn() {
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn2.setImage(UIImage(named: "ic_back_white"), for: .normal)
        btn2.addTarget(self, action: #selector(backkButtonTappedd(_:)), for:.touchUpInside)
        let barButton = UIBarButtonItem(customView: btn2)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func backkButtonTappedd(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func addNavigationBackButton() {
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn2.setImage(UIImage(named: "Ic_back_1"), for: .normal)
        btn2.addTarget(self, action: #selector(backkButtonTapped(_:)), for:.touchUpInside)
        let barButton = UIBarButtonItem(customView: btn2)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func backkButtonTapped(_ sender: UIButton){
        viewModel.proceedForHome()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.getSubscriptionApiCall { result in
            self.subscriptionPlan.removeAll()
            if result != nil {
                for i in 0..<(result?.count ?? 0){
                    self.subscriptionPlan.append(SubscriptionsModel(
                        country: result?[i]["country"] as? String ?? "",
                        createdAt: result?[i]["createdAt"] as? String ?? "",
                        customerId: result?[i]["customerId"] as? String ?? "",
                        paymentReciept: result?[i]["paymentReciept"] as? String ?? "",
                        paymentGateway: result?[i]["paymentGateway"] as? Int ?? 0,
                        planExpiryDate: result?[i]["planExpiryDate"] as? String ?? "",
                        planPrice: result?[i]["planPrice"] as? NSNumber ?? 0,
                        planStartDate: result?[i]["planStartDate"] as? String ?? "",
                        planType: result?[i]["planType"] as? String ?? "0",
                        userId: result?[i]["userId"] as? String ?? ""))
                }
                
                if self.subscriptionPlan.count != 0 {
                    self.tableView.reloadData()
                    self.noSubscriptionFound.isHidden = true
                    self.noSubscriptionFoundInnerImg.isHidden = true
                    self.noSubscriptionFoundInneerStackView.isHidden = true
                    self.tableView.isHidden = false
                    self.changePlanButton.isHidden = false
                }else {
                    self.noSubscriptionFound.isHidden = false
                    self.noSubscriptionFoundInnerImg.isHidden = false
                    self.noSubscriptionFoundInneerStackView.isHidden = false
                    self.tableView.isHidden = true
                    self.changePlanButton.isHidden = true
                }
            }
        }
    }
  
    private func setupTableView() {
        tableView.register(UINib(nibName: SubscriptionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SubscriptionTableViewCell.identifier)
        tableView.register(UINib(nibName: BuyPremiumStaticTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: BuyPremiumStaticTableViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    @IBAction func changePlanClicked(_ sender: Any) {
        viewModel.proceedForBuyPremiumScreen()
    }
}

extension SubscriptionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.section {
//            case 0: return 120
//            case 1: return 60
//            default: return 0
//        }
//    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 4
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let labelHeader = UILabel()
        if section == 0 {
            labelHeader.text = ""
        } else if section == 1 {
            labelHeader.text = "Premium plan features"
        }
        labelHeader.textColor = .black
        labelHeader.frame = CGRect(x: 24, y: 0, width: 200, height: 21)
        labelHeader.font = UIFont(name: "SharpSansTRIAL-Semibold", size: 16.0)
        view.addSubview(labelHeader)
        view.backgroundColor = .white
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 30
        }else{
            return 0
        }
    }
    /*
     (
     {
         country = IND;
         createdAt = "2023-11-17T05:36:20.000Z";
         customerId = "<null>";
         paymentGateway = 2;
         paymentReciept = "<null>";
         planExpiryDate = "2024-02-17";
         planPrice = 499;
         planStartDate = "2023-11-17";
         planType = 3;
         userId = "8db769e4-a119-4981-9f39-4b58b700422f";
     },
     {
         country = IND;
         createdAt = "2023-10-27T12:22:51.000Z";
         customerId = "<null>";
         paymentGateway = 1;
         paymentReciept = "<null>";
         planExpiryDate = "2023-11-27";
         planPrice = 811;
         planStartDate = "2023-10-27";
         planType = 1;
         userId = "8db769e4-a119-4981-9f39-4b58b700422f";
     }
     )
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cellNotifications = tableView.dequeueReusableCell(withIdentifier: SubscriptionTableViewCell.identifier) as! SubscriptionTableViewCell
            cellNotifications.selectionStyle = .none
            if self.subscriptionPlan.count != 0{
                
                if self.subscriptionPlan[0].country == "IND"{
                    if self.subscriptionPlan[0].planType == "0" { //For week
                        cellNotifications.labelPerMonth.text = ""
                        cellNotifications.labelMonthPlan.text = "One Week"
                        cellNotifications.labelAmount.text = "₹\(self.subscriptionPlan[0].planPrice ?? 0)"
                    }else if self.subscriptionPlan[0].planType == "1" { // for month
                        cellNotifications.labelMonthPlan.text = "One Month Plan"
                        cellNotifications.labelAmount.text = "₹\(self.subscriptionPlan[0].planPrice ?? 0)/"
                        cellNotifications.labelPerMonth.text = "month"
                    }else if self.subscriptionPlan[0].planType == "3" { // for three month
                        cellNotifications.labelMonthPlan.text = "Three Month Plan"
                        let price = Float(truncating: self.subscriptionPlan[0].planPrice ?? 0) / 3.0
                        let roundedValue = round(price * 100) / 100.0
                        cellNotifications.labelAmount.text = "₹\(String(format: "%.2f", roundedValue))/"
                        cellNotifications.labelPerMonth.text = "month"
                    }else if self.subscriptionPlan[0].planType == "6" { // for 6 month
                        cellNotifications.labelMonthPlan.text = "Half Yearly Plan"
                        cellNotifications.labelPerMonth.text = "month"
                        let price = Float(truncating: self.subscriptionPlan[0].planPrice ?? 0) / 6.0
                        let roundedValue = round(price * 100) / 100.0
                        cellNotifications.labelAmount.text = "₹\(String(format: "%.2f", roundedValue))/"
                    }else if self.subscriptionPlan[0].planType == "12" { // for 12 month
                        cellNotifications.labelMonthPlan.text = "Yearly Plan"
                        cellNotifications.labelPerMonth.text = "month"
                        let price = Float(truncating: self.subscriptionPlan[0].planPrice ?? 0) / 12.0
                        let roundedValue = round(price * 100) / 100.0
                        cellNotifications.labelAmount.text = "₹\(String(format: "%.2f", roundedValue))/"
                    }
                }else if self.subscriptionPlan[0].country == "UK"{
                    if self.subscriptionPlan[0].planType == "0" { //For week
                        cellNotifications.labelMonthPlan.text = "One Week"
                        cellNotifications.labelAmount.text = "£\(self.subscriptionPlan[0].planPrice ?? 0)"
                    }else if self.subscriptionPlan[0].planType == "1" { // for month
                        cellNotifications.labelMonthPlan.text = "One Month Plan"
                        cellNotifications.labelAmount.text = "£\(self.subscriptionPlan[0].planPrice ?? 0)/"
                        cellNotifications.labelPerMonth.text = "month"
                    }else if self.subscriptionPlan[0].planType == "3" { // for three month
                        cellNotifications.labelMonthPlan.text = "Three Month Plan"
                        let price = Float(truncating: self.subscriptionPlan[0].planPrice ?? 0) / 3.0
                        let roundedValue = round(price * 100) / 100.0
                        cellNotifications.labelAmount.text = "£\(String(format: "%.2f", roundedValue))/"
                        cellNotifications.labelPerMonth.text = "month"
                    }else if self.subscriptionPlan[0].planType == "6" { // for 6 month
                        cellNotifications.labelMonthPlan.text = "Half Yearly Plan"
                        cellNotifications.labelPerMonth.text = "month"
                        let price = Float(truncating: self.subscriptionPlan[0].planPrice ?? 0) / 6.0
                        let roundedValue = round(price * 100) / 100.0
                        cellNotifications.labelAmount.text = "£\(String(format: "%.2f", roundedValue))/"
                    }else if self.subscriptionPlan[0].planType == "12" { // for 12 month
                        cellNotifications.labelMonthPlan.text = "Yearly Plan"
                        cellNotifications.labelPerMonth.text = "month"
                        let price = Float(truncating: self.subscriptionPlan[0].planPrice ?? 0) / 12.0
                        let roundedValue = round(price * 100) / 100.0
                        cellNotifications.labelAmount.text = "£\(String(format: "%.2f", roundedValue))/"
                    }
                }else if self.subscriptionPlan[0].country == "US"{
                    if self.subscriptionPlan[0].planType == "0" { //For week
                        cellNotifications.labelMonthPlan.text = "One Week"
                        cellNotifications.labelAmount.text = "$\(self.subscriptionPlan[0].planPrice ?? 0)"
                    }else if self.subscriptionPlan[0].planType == "1" { // for month
                        cellNotifications.labelMonthPlan.text = "One Month Plan"
                        cellNotifications.labelAmount.text = "$\(self.subscriptionPlan[0].planPrice ?? 0)/"
                        cellNotifications.labelPerMonth.text = "month"
                    }else if self.subscriptionPlan[0].planType == "3" { // for three month
                        cellNotifications.labelMonthPlan.text = "Three Month Plan"
                        let price = Float(truncating: self.subscriptionPlan[0].planPrice ?? 0) / 3.0
                        let roundedValue = round(price * 100) / 100.0
                        cellNotifications.labelAmount.text = "$\(String(format: "%.2f", roundedValue))/"
                        cellNotifications.labelPerMonth.text = "month"
                    }else if self.subscriptionPlan[0].planType == "6" { // for 6 month
                        cellNotifications.labelMonthPlan.text = "Half Yearly Plan"
                        cellNotifications.labelPerMonth.text = "month"
                        let price = Float(truncating: self.subscriptionPlan[0].planPrice ?? 0) / 6.0
                        let roundedValue = round(price * 100) / 100.0
                        cellNotifications.labelAmount.text = "$\(String(format: "%.2f", roundedValue))/"
                    }else if self.subscriptionPlan[0].planType == "12" { // for 12 month
                        cellNotifications.labelMonthPlan.text = "Yearly Plan"
                        cellNotifications.labelPerMonth.text = "month"
                        let price = Float(truncating: self.subscriptionPlan[0].planPrice ?? 0) / 12.0
                        let roundedValue = round(price * 100) / 100.0
                        cellNotifications.labelAmount.text = "$\(String(format: "%.2f", roundedValue))/"
                    }
                }
                
//
//                if self.subscriptionPlan[0].country == "IND"{
//                    if self.subscriptionPlan[0].planType == "1" {
//                        cellNotifications.labelMonthPlan.text = "Monthly Plan"
//                        cellNotifications.labelAmount.text = "₹\(self.subscriptionPlan[0].planPrice ?? 0)/"
//
//                    } else if self.subscriptionPlan[0].planType == "6" {
//                        cellNotifications.labelMonthPlan.text = "Half Yearly Plan"
//                        let price = Float(truncating: self.subscriptionPlan[0].planPrice ?? 0) / 6.0
//                        let roundedValue = round(price * 100) / 100.0
//                        cellNotifications.labelAmount.text = "₹\(String(format: "%.2f", roundedValue))/"
//                    } else if self.subscriptionPlan[0].planType == "12" {
//                        cellNotifications.labelMonthPlan.text = "Yearly Plan"
//                        let price = Float(truncating: self.subscriptionPlan[0].planPrice ?? 0) / 12.0
//                        let roundedValue = round(price * 100) / 100.0
//                        cellNotifications.labelAmount.text = "₹\(String(format: "%.2f", roundedValue))/"                    }
//                } else if self.subscriptionPlan[0].country == "UK"{
//                    if self.subscriptionPlan[0].planType == "1" {
//                        cellNotifications.labelMonthPlan.text = "Monthly Plan"
//                        cellNotifications.labelAmount.text = "£\(self.subscriptionPlan[0].planPrice ?? 0)/"
//                    } else if self.subscriptionPlan[0].planType == "6" {
//                        cellNotifications.labelMonthPlan.text = "Half Yearly Plan"
//                        let price = Float(truncating: self.subscriptionPlan[0].planPrice ?? 0) / 6.0
//                        let roundedValue = round(price * 100) / 100.0
//                        cellNotifications.labelAmount.text = "£\(String(format: "%.2f", roundedValue))/"
//                    } else if self.subscriptionPlan[0].planType == "12" {
//                        cellNotifications.labelMonthPlan.text = "Yearly Plan"
//                        let price = Float(truncating: self.subscriptionPlan[0].planPrice ?? 0) / 12.0
//                        let roundedValue = round(price * 100) / 100.0
//                        cellNotifications.labelAmount.text = "£\(String(format: "%.2f", roundedValue))/"                    }
//                }
//                else if self.subscriptionPlan[0].country == "US"{
//                    if self.subscriptionPlan[0].planType == "1" {
//                        cellNotifications.labelMonthPlan.text = "Monthly Plan"
//                        cellNotifications.labelAmount.text = "$\(self.subscriptionPlan[0].planPrice ?? 0)/"
//
//                    } else if self.subscriptionPlan[0].planType == "6" {
//                        cellNotifications.labelMonthPlan.text = "Half Yearly Plan"
//                        let price = Float(truncating: self.subscriptionPlan[0].planPrice ?? 0) / 6.0
//                        let roundedValue = round(price * 100) / 100.0
//                        cellNotifications.labelAmount.text = "$\(String(format: "%.2f", roundedValue))/"
//
//                    } else if self.subscriptionPlan[0].planType == "12" {
//                        cellNotifications.labelMonthPlan.text = "Yearly Plan"
//                        let price = Float(truncating: self.subscriptionPlan[0].planPrice ?? 0) / 12.0
//                        let roundedValue = round(price * 100) / 100.0
//                        cellNotifications.labelAmount.text = "$\(String(format: "%.2f", roundedValue))/"
//                    }
//                }
            }
            return cellNotifications
        }
        if indexPath.section == 1 {
            let cellBuyPremiumStatic = tableView.dequeueReusableCell(withIdentifier: BuyPremiumStaticTableViewCell.identifier) as! BuyPremiumStaticTableViewCell
            cellBuyPremiumStatic.configure(row: indexPath.row)
            return cellBuyPremiumStatic
        }
        return UITableViewCell()
    }
}
