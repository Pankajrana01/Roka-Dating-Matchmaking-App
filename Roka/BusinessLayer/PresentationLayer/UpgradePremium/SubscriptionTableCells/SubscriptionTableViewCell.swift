//
//  SubscriptionTableViewCell.swift
//  Roka
//
//  Created by  Developer on 25/10/22.
//

import UIKit

class SubscriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var imageSubscription: UIImageView!
    @IBOutlet weak var labelMonthPlan: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelPerMonth: UILabel!
    
    static let identifier = "SubscriptionTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

}
