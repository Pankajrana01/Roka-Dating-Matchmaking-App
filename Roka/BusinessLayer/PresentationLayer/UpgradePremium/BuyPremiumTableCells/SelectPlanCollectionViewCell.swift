//
//  SelectPlanCollectionViewCell.swift
//  Roka
//
//  Created by Pankaj Rana on 25/10/23.
//

import UIKit

class SelectPlanCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tickImage: UIImageView!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var dayValueLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var mostPopularView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
