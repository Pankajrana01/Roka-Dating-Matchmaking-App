//
//  NewSearchAgeTableViewCell.swift
//  Roka
//
//  Created by  Developer on 04/11/22.
//

import UIKit

class NewSearchAgeTableViewCell: UITableViewCell {

    @IBOutlet weak var labelAge: UILabel!
    @IBOutlet weak var slider: RangeSeekSlider!
    
    static let identifier = "NewSearchAgeTableViewCell"
    var ageCallBack: ((Int, Int) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.slider.delegate = self
    }
    
    func configure(selectedMinValue: CGFloat = 18, selectedMaxValue: CGFloat = 99) {
        slider.minValue = 18
        slider.maxValue = 99
        slider.selectedMinValue = selectedMinValue
        slider.selectedMaxValue = selectedMaxValue
        //slider.reloadInputViews()
        // update the label
//        labelAge.text = "\(Int(slider.selectedMinValue)) Years - \(Int(slider.selectedMaxValue)) Years"
        labelAge.text = "\(Int(slider.selectedMinValue)) - \(Int(slider.selectedMaxValue)) "
     //   ageCallBack!(slider.selectedMinValue, slider.selectedMaxValue)
    }
}

extension NewSearchAgeTableViewCell: RangeSeekSliderDelegate {
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
//        labelAge.text = "\(Int(minValue)) Years - \(Int(maxValue)) Years"
        labelAge.text = "\(Int(minValue)) - \(Int(maxValue)) "
        ageCallBack!(Int(slider.selectedMinValue), Int(slider.selectedMaxValue))
    }
}
