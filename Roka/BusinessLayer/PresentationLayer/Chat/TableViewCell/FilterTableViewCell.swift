//
//  FilterTableViewCell.swift
//  Roka
//
//  Created by ios on 12/12/22.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgVwTick: UIImageView!
    
    static let identifier = "FilterTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(title: String, isSelected: Bool) {
        self.lblTitle.text = title
        //self.imgVwTick.isHidden = !isSelected
        if isSelected{
            self.imgVwTick.image = UIImage (named: "ic_tick")
        }else{
            self.imgVwTick.image = UIImage (named: "")

        }
    }
    
}
