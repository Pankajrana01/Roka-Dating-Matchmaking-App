//
//  BuyPremiumNewTableViewCell.swift
//  Roka
//
//  Created by Pankaj Rana on 25/10/23.
//

import UIKit

struct buyPremiumModel {
    let day: String?
    let value: String?
    var isSelectedIndex: Bool?
    let planPrice: NSNumber?
    let planDesc: String?
    let mostPopulat: String?
    let currency: String?

    
    init(day: String, value: String, isSelectedIndex: Bool, planPrice: NSNumber, planDesc: String,mostPopulat:String,currency :String) {
        self.day = day
        self.value = value
        self.isSelectedIndex = isSelectedIndex
        self.planDesc = planDesc
        self.planPrice = planPrice
        self.mostPopulat = mostPopulat
        self.currency = currency
    }
}

class BuyPremiumNewTableViewCell: UITableViewCell {

    var premiumModelDict = [buyPremiumModel]()
    @IBOutlet weak var collectionView: UICollectionView!
    var callBackSelectedPlan: ((_ plan: String,_ planIndex :Int) -> ())?
    var isSelect = -1
    var premiumPlan : [buyPremiumModel] = []
//    {
//        var premiumPlan = [buyPremiumModel]()
// //       premiumPlan.append(buyPremiumModel(day: "1", value: "day", isSelectedIndex: false, planPrice: 99, planDesc: "Get exclusive \n benefits for 24 hours"))
//
//        premiumPlan.append(buyPremiumModel(day: "1", value: "week", isSelectedIndex: false, planPrice: 49, planDesc: "Try the best for \n a week", mostPopulat: "0"))
//
//        premiumPlan.append(buyPremiumModel(day: "1", value: "month", isSelectedIndex: false, planPrice: 199, planDesc: "One month of \n exclusive benefits", mostPopulat: "0"))
//
//        premiumPlan.append(buyPremiumModel(day: "3", value: "months", isSelectedIndex: false, planPrice: 499, planDesc: "Rs. 166.33/ \n month", mostPopulat: "0"))
//
//        premiumPlan.append(buyPremiumModel(day: "6", value: "months", isSelectedIndex: false, planPrice: 899, planDesc: "Rs. 149.83/ \n month", mostPopulat: "0"))
//
//        premiumPlan.append(buyPremiumModel(day: "12", value: "months", isSelectedIndex: false, planPrice: 1499, planDesc: "Rs. 124.91/ \n month", mostPopulat: "0"))
//
//        return premiumPlan
//    }()
    
    func configureCollectionView() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = false
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView.register(UINib(nibName:"SelectPlanCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "SelectPlanCollectionViewCell")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension BuyPremiumNewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - Collection Delegate & DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // return premiumPlan.count
        return premiumModelDict.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectPlanCollectionViewCell", for: indexPath) as? SelectPlanCollectionViewCell {
            
            let dict = self.premiumModelDict[indexPath.item]
            
            cell.numberLabel.text = dict.day ?? ""
            cell.dayValueLabel.text = dict.value ?? ""
            cell.desc.text = dict.planDesc ?? ""
            
            if dict.currency == "INR"{
                cell.price.text = "₹\(dict.planPrice ?? 0)"
            }else if dict.currency == "UK"{
                cell.price.text = "£\(dict.planPrice ?? 0)"
            }else if dict.currency == "US"{
                cell.price.text = "$\(dict.planPrice ?? 0)"
            }

            
//            cell.numberLabel.text = premiumModelDict[indexPath.row].day
//            cell.dayValueLabel.text = premiumModelDict[indexPath.row].value
//            cell.price.text = "\(premiumModelDict[indexPath.row].planPrice ?? 0)"
//            cell.desc.text = premiumModelDict.description

            
//            cell.numberLabel.text = premiumPlan[indexPath.row].day
//            cell.dayValueLabel.text = premiumPlan[indexPath.row].value
//            cell.price.text = "Rs. " + "\(premiumPlan[indexPath.row].planPrice ?? 0)"
//            cell.desc.text = premiumPlan[indexPath.row].planDesc
            
            if isSelect == indexPath.item {
                cell.tickImage.isHidden = false
                cell.mainView.backgroundColor = UIColor.appTitleBlueColor
                cell.price.textColor = .white
                cell.desc.textColor = .white
                let str = "\(dict.day ?? "")" + " \(dict.value ?? "")"
              //  self.callBackSelectedPlan?("Buy \(str) plan")
                self.callBackSelectedPlan?("Buy \(str) plan", isSelect)
            } else {
                cell.tickImage.isHidden = true
                cell.mainView.backgroundColor = UIColor.appLightBlueColor
                cell.price.textColor = .appTitleBlueColor
                cell.desc.textColor = .appTitleBlueColor
            }
            
            if (dict.mostPopulat ?? "0") == "1"{
                cell.mostPopularView.isHidden = false
            }else{
                cell.mostPopularView.isHidden = true
            }
            
//            if indexPath.row == 4 {
//                cell.mostPopularView.isHidden = false
//            } else{
//                cell.mostPopularView.isHidden = true
//            }
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return CGSize.init(width: 180, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        /// vertical spacing
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        premiumPlan.filter {$0.isSelectedIndex == true}.map {$0.isSelectedIndex = false}
//        var currentItem = premiumPlan[indexPath.row]
//        currentItem.isSelectedIndex = true
        isSelect = indexPath.item
        self.collectionView.reloadData()
    }
    
}
