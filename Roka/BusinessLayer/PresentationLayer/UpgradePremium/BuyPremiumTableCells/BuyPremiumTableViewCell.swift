//
//  BuyPremiumTableViewCell.swift
//  Roka
//
//  Created by  Developer on 21/10/22.
//

import UIKit



class BuyPremiumTableViewCell: UITableViewCell {

    // MARK: - IB Outlets
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var labelMonthsPlan: UILabel!
    @IBOutlet weak var imageViewBoughtPlan: UIImageView!
    @IBOutlet weak var labelPopular: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelPerMonth: UILabel!
    @IBOutlet weak var labelMoreMonths: UILabel!
    @IBOutlet weak var monthsPlan: UIImageView!
    
    @IBOutlet weak var planInnerView: UIView!
    // MARK: - Varibles
    static let identifier = "BuyPremiumTableViewCell"
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func initPremiumData(premium:PremiumModel){
        /*
        if premium.planType == "1" {
            labelMonthsPlan.text = "Monthly plan"
        } else if premium.planType == "6" {
            labelMonthsPlan.text = "Half yearly plan"
        } else if premium.planType == "12" {
            labelMonthsPlan.text = "Yearly plan"
        }
        
        if premium.country == "IND"{
            if premium.planType == "1" {
                labelAmount.text = "₹\(premium.planPrice ?? 0.0)/"
                labelMoreMonths.text = "One-time payment"
            } else if premium.planType == "6" {
                let price = Float(truncating: premium.planPrice ?? 0) / 6.0
                let roundedValue = round(price * 100) / 100.0
                labelAmount.text = "₹\(String(format: "%.2f", roundedValue))/"
                labelMoreMonths.text = "₹\(Float(truncating: premium.planPrice ?? 0)) one-time payment"
            } else if premium.planType == "12" {
                let price = Float(truncating: premium.planPrice ?? 0) / 12.0
                let roundedValue = round(price * 100) / 100.0
                labelAmount.text = "₹\(String(format: "%.2f", roundedValue))/"
                labelMoreMonths.text = "₹\(Float(truncating: premium.planPrice ?? 0)) one-time payment"
            }
        } else if premium.country == "UK"{
            if premium.planType == "1" {
                labelAmount.text = "£\(premium.planPrice ?? 0)/"
                labelMoreMonths.text = "One-time payment"
            } else if premium.planType == "6" {
                let price = Float(truncating: premium.planPrice ?? 0) / 6.0
                let roundedValue = round(price * 100) / 100.0
                labelAmount.text = "£\(String(format: "%.2f", roundedValue))/"
                labelMoreMonths.text = "£\(Float(truncating: premium.planPrice ?? 0)) one-time payment"
            } else if premium.planType == "12" {
                let price = Float(truncating: premium.planPrice ?? 0) / 12.0
                let roundedValue = round(price * 100) / 100.0
                labelAmount.text = "£\(String(format: "%.2f", roundedValue))/"
                labelMoreMonths.text = "£\(Float(truncating: premium.planPrice ?? 0)) one-time payment"
            }
        }
        else if premium.country == "US"{
            if premium.planType == "1" {
                labelAmount.text = "$\(premium.planPrice ?? 0)/"
                labelMoreMonths.text = "One-time payment"
            } else if premium.planType == "6" {
                let price = Float(truncating: premium.planPrice ?? 0) / 6.0
                let roundedValue = round(price * 100) / 100.0
                labelAmount.text = "$\(String(format: "%.2f", roundedValue))/"
                labelMoreMonths.text = "$\(Float(truncating: premium.planPrice ?? 0)) one-time payment"
            } else if premium.planType == "12" {
                let price = Float(truncating: premium.planPrice ?? 0) / 12.0
                let roundedValue = round(price * 100) / 100.0
                labelAmount.text = "$\(String(format: "%.2f", roundedValue))/"
                labelMoreMonths.text = "$\(Float(truncating: premium.planPrice ?? 0)) one-time payment"
            }
        }
         */
    }
    
    func configure(selectedRow: Int, indexPath: IndexPath) {
        if selectedRow == indexPath.row {
            labelMonthsPlan.textColor = .white
            viewBackground.layer.borderColor = UIColor.loginBlueColor.cgColor
            monthsPlan.image = UIImage(named: "img_bg_color")
            imageViewBoughtPlan.isHidden = false
            self.planInnerView.backgroundColor = UIColor.loginBlueColor
        } else {
            imageViewBoughtPlan.isHidden = true
            labelMonthsPlan.textColor = UIColor(displayP3Red: 16/255, green: 16/255, blue: 16/255, alpha: 1)
            monthsPlan.image = UIImage(named: "img_bg_clear")
            viewBackground.layer.borderColor = UIColor(red:229/255, green:229/255, blue:229/255, alpha: 1).cgColor
            self.planInnerView.backgroundColor = UIColor(red:229/255, green:229/255, blue:229/255, alpha: 1)
        }
        viewBackground.layer.borderWidth = 1
        selectionStyle = .none
    }
}
