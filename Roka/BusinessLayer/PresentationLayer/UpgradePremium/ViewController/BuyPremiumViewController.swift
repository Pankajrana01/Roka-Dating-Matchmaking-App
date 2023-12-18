//
//  BuyPremiumViewController.swift
//  Roka
//
//  Created by  Developer on 21/10/22.
//

import UIKit
import StoreKit
class BuyPremiumViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.buyPremium
        
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.BuyPremium
    }

    lazy var viewModel: BuyPremiumViewModel = BuyPremiumViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! BuyPremiumViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.hidesBottomBarWhenPushed = true
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    @IBOutlet weak var topview: UILabel!
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var congratulationView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buyButton: UIButton!
    private var row = 2
    private var selectedPlan = "12"
    
    var premiumPlanData : [buyPremiumModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: true)
        self.topview.backgroundColor = UIColor.appTitleBlueColor
        addNavigationBackButton()
        self.title = "Upgrade to premium"
        //showNavigationBackButton(title: "  Upgrade to premium")
        self.blackView.isHidden = true
        self.congratulationView.isHidden = true
        self.viewModel.blackView = blackView
        self.viewModel.congratulationView = congratulationView
        setupTableView()
        viewModel.viewDidSetup()
        viewModel.getUserProfileData()
        viewModel.getSubscriptionApiCall { result in
            if result != nil {
                self.viewModel.premiumModels.removeAll()
                for i in 0..<(result?.count ?? 0){
                    self.viewModel.premiumModels.append(PremiumModel(
                        country: result?[i]["country"] as? String ?? "",
                        currency: result?[i]["currency"] as? String ?? "",
                        id: result?[i]["id"] as? String ?? "",
                        planPrice: result?[i]["planPrice"] as? NSNumber ?? 0,
                        planType: result?[i]["planType"] as? Int ?? 0,
                        description: result?[i]["description"] as? String ?? "",
                        mostPopular: result?[i]["mostPopular"] as? String ?? ""))
                }
                
                if self.viewModel.premiumModels.count > 0{
                    self.premiumPlanData.append(buyPremiumModel(day: "1", value: "week", isSelectedIndex: false, planPrice: 49, planDesc: self.viewModel.premiumModels[0].description ?? "", mostPopulat: self.viewModel.premiumModels[0].mostPopular ?? "", currency: self.viewModel.premiumModels[0].currency ?? ""))

                    self.premiumPlanData.append(buyPremiumModel(day: "1", value: "month", isSelectedIndex: false, planPrice: 199, planDesc: self.viewModel.premiumModels[1].description ?? "", mostPopulat: self.viewModel.premiumModels[1].mostPopular ?? "", currency: self.viewModel.premiumModels[1].currency ?? ""))
                    
                    self.premiumPlanData.append(buyPremiumModel(day: "3", value: "months", isSelectedIndex: false, planPrice: 499, planDesc: self.viewModel.premiumModels[2].description ?? "", mostPopulat: self.viewModel.premiumModels[2].mostPopular ?? "", currency: self.viewModel.premiumModels[2].currency ?? ""))
                    
                    self.premiumPlanData.append(buyPremiumModel(day: "6", value: "months", isSelectedIndex: false, planPrice: 899, planDesc: self.viewModel.premiumModels[3].description ?? "", mostPopulat: self.viewModel.premiumModels[3].mostPopular ?? "", currency: self.viewModel.premiumModels[3].currency ?? ""))
                    
                    self.premiumPlanData.append(buyPremiumModel(day: "12", value: "months", isSelectedIndex: false, planPrice: 1499, planDesc: self.viewModel.premiumModels[4].description ?? "", mostPopulat: self.viewModel.premiumModels[4].mostPopular ?? "", currency: self.viewModel.premiumModels[4].currency ?? ""))
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func addNavigationBackButton() {
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn2.setImage(UIImage(named: "ic_back_white"), for: .normal)
        btn2.addTarget(self, action: #selector(backkButtonTapped(_:)), for:.touchUpInside)
        let barButton = UIBarButtonItem(customView: btn2)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func backkButtonTapped(_ sender: UIButton){
        self.viewModel.completionHandler?(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: BuyPremiumTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: BuyPremiumTableViewCell.identifier)
        tableView.register(UINib(nibName: BuyPremiumStaticTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: BuyPremiumStaticTableViewCell.identifier)
        tableView.register(UINib(nibName: "BuyPremiumNewTableViewCell", bundle: nil), forCellReuseIdentifier: "BuyPremiumNewTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
    }
    
    @IBAction func gotITActoin(_ sender: Any) {
        viewModel.proceedForGotItAction()
    }
    
    @IBAction func buyPlanButtonAction(_ sender: UIButton) {
        viewModel.updateKycStatusCall { response in
            if response == "Success" {
                if self.viewModel.selectedIndex != -1{
                    guard let product = self.viewModel.getProductForItem(at: self.viewModel.selectedIndex) else {
                        //viewModel.showSingleAlert(withMessage: "Renewing this item is not possible at the moment.")
                        return
                    }
                    self.viewModel.showAlert(for: product)
                }
            }
        }
    }
}

extension BuyPremiumViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        }
        
        return 1//viewModel.premiumModels.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let labelHeader = UILabel()
        if section == 0 {
            labelHeader.text = "Premium Plan Features"
            labelHeader.textAlignment = .left
            labelHeader.frame = CGRect(x: 24, y: 0, width: tableView.frame.size.width - 24, height: 21)
            
        } else if section == 1 {
            labelHeader.text = "Select your plan"
            labelHeader.textAlignment = .center
            labelHeader.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 21)
        }
        labelHeader.textColor = .appTitleBlueColor
        
        
        labelHeader.font = UIFont(name: "SharpSansTRIAL-Semibold", size: 16.0) //UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(labelHeader)
        view.backgroundColor = .white
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section != 0 {
            return 300.0
        } else{
            return 35.0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cellBuyPremiumStatic = tableView.dequeueReusableCell(withIdentifier: BuyPremiumStaticTableViewCell.identifier) as! BuyPremiumStaticTableViewCell
            cellBuyPremiumStatic.configure(row: indexPath.row)
            return cellBuyPremiumStatic
        }
        else if indexPath.section == 1 {
            if let cellBuyPremium = tableView.dequeueReusableCell(withIdentifier: "BuyPremiumNewTableViewCell") as? BuyPremiumNewTableViewCell {
                
                cellBuyPremium.premiumModelDict = self.premiumPlanData
                cellBuyPremium.collectionView.reloadData()
                cellBuyPremium.callBackSelectedPlan = { [weak self] text,planIndex in
                    self?.buyButton.setTitle(text, for: .normal)
                    self?.viewModel.selectedIndex = planIndex
                  //  self?.viewModel.p
                }
                return cellBuyPremium
            }
        }
        
//       else if indexPath.section == 1 {
//            let cellBuyPremium = tableView.dequeueReusableCell(withIdentifier: BuyPremiumTableViewCell.identifier) as! BuyPremiumTableViewCell
//            if self.viewModel.premiumModels.count != 0 {
//                cellBuyPremium.initPremiumData(premium: (self.viewModel.premiumModels[indexPath.row]))
//
//                cellBuyPremium.configure(selectedRow: row, indexPath: indexPath)
//
//                if self.selectedPlan == "1" {
//                    self.buyButton.setTitle("Buy Monthly Plan", for: .normal)
//                } else if self.selectedPlan == "6" {
//                    self.buyButton.setTitle("Buy half yearly plan", for: .normal)
//                } else if self.selectedPlan == "12" {
//                    self.buyButton.setTitle("Buy yearly plan", for: .normal)
//                }
//            }
//            return cellBuyPremium
//        }
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1  && row != indexPath.row {
            self.row = indexPath.row
          //  self.selectedPlan = self.viewModel.premiumModels[indexPath.row].planType ?? 0
            tableView.reloadData()
        }
    }
}
