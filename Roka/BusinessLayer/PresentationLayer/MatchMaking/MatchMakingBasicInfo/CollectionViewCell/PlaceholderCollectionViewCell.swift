//
//  PlaceholderCollectionViewCell.swift
//  Roka
//
//  Created by Pankaj Rana on 21/11/22.
//

import UIKit

class PlaceholderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var NameLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        borderView.layer.cornerRadius = borderView.frame.height/2
        borderView.clipsToBounds = true
        
        colorView.layer.cornerRadius = colorView.frame.height/2
        colorView.clipsToBounds = true
    }

    func initColorWithCell(color:String) {
        colorView.backgroundColor = UIColor(hex: color)
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor(hex: color).cgColor
    }
}
