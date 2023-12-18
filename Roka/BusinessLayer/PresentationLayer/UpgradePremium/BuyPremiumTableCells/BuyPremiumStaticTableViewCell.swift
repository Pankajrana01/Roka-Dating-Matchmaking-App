//
//  BuyPremiumStaticTableViewCell.swift
//  Roka
//
//  Created by  Developer on 25/10/22.
//

import UIKit

fileprivate struct SubscriptionModel {
    let description: String
}

class BuyPremiumStaticTableViewCell: UITableViewCell {

    @IBOutlet weak var imageTick: UIImageView!
    @IBOutlet weak var label: UILabel!
    
   fileprivate var subscriptionModels = [
        SubscriptionModel(description: "Undo the profiles you liked or disliked by mistake."),
        SubscriptionModel(description: "Unlimited chatting with your matches."),
        SubscriptionModel(description: "Get to know who has liked your profile."),
        SubscriptionModel(description: "Limited ads"),
    ]
    
    static let identifier = "BuyPremiumStaticTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configure(row: Int) {
        label.text = subscriptionModels[row].description
    }
}
