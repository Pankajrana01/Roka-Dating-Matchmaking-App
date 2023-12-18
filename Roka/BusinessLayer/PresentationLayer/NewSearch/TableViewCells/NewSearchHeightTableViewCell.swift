//
//  NewSearchHeightTableViewCell.swift
//  Roka
//
//  Created by Applify  on 18/11/22.
//

import UIKit

class NewSearchHeightTableViewCell: UITableViewCell {

    @IBOutlet weak var feetBtn: UIButton!
    @IBOutlet weak var cmBtn: UIButton!

    @IBOutlet weak var labelHeight: UILabel!
    @IBOutlet weak var slider: RangeSeekSlider!
    
    var isFeetSelected = true
    static let identifier = "NewSearchHeightTableViewCell"
    var heightCallBack: ((String, String, String) -> ())?
    
    var selectedMinValue = 122
    var selectedMaxValue = 183
    var selectedForSlider = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.slider.delegate = self
    }
    
    func configure(selectedMinValue: CGFloat = 122, selectedMaxValue: CGFloat = 183, heightType: String) {
        self.slider.minValue = 31
        self.slider.maxValue = 244
        self.isFeetSelected = heightType == "Feet"
        
        if heightType == "Feet" {
            let minValue = convertFeetInchesToCM(value: selectedMinValue)
            let maxValue = convertFeetInchesToCM(value: selectedMaxValue)
            self.slider.selectedMinValue = CGFloat(minValue)
            self.slider.selectedMaxValue = CGFloat(maxValue)
            self.selectedMinValue = Int(minValue)
            self.selectedMaxValue = Int(maxValue)
        } else {
            self.slider.selectedMinValue = CGFloat(selectedMinValue)
            self.slider.selectedMaxValue = CGFloat(selectedMaxValue)
            self.selectedMinValue = Int(selectedMinValue)
            self.selectedMaxValue = Int(selectedMaxValue)
        }
        
        changeBtnLayoutOnSelection()
        self.updateSliderLabelInputs()
    }
    
    func changeBtnLayoutOnSelection() {
        
        if GlobalVariables.shared.selectedProfileMode == "MatchMaking" {
            if isFeetSelected {
                //            self.feetBtn.layer.borderColor = UIColor.appYellowColor.cgColor
                self.feetBtn.layer.borderWidth = 0
                //            self.feetBtn.setTitleColor(UIColor.loginBlueColor, for: .normal)
                //            self.feetBtn.setImage(UIImage(named: "ic_tick_gender"), for: .normal)
                self.feetBtn.setImage(UIImage(named: "Matchmaking_toggle_on"), for: .normal)
                
                self.cmBtn.layer.borderColor = UIColor.appLightGray.cgColor
                self.cmBtn.setTitleColor(UIColor.appLightGray, for: .normal)
                self.cmBtn.setImage(nil, for: .normal)
                
            } else {
                self.cmBtn.layer.borderColor = UIColor.appYellowColor.cgColor
                self.cmBtn.setTitleColor(UIColor.appYellowColor, for: .normal)
                self.cmBtn.setImage(UIImage(named: "ic_tick_gender"), for: .normal)
                
                //            self.feetBtn.layer.borderColor = UIColor.appLightGray.cgColor
                self.feetBtn.layer.borderWidth = 0
                //            self.feetBtn.setTitleColor(UIColor.loginBlueColor, for: .normal)
                self.feetBtn.setImage(UIImage(named: "Matchmaking_toggle_off"), for: .normal)
                //            self.feetBtn.setImage(nil, for: .normal)
            }
        } else {
            if isFeetSelected {
                //            self.feetBtn.layer.borderColor = UIColor.appYellowColor.cgColor
                self.feetBtn.layer.borderWidth = 0
                //            self.feetBtn.setTitleColor(UIColor.loginBlueColor, for: .normal)
                //            self.feetBtn.setImage(UIImage(named: "ic_tick_gender"), for: .normal)
                self.feetBtn.setImage(UIImage(named: "im_height_switch"), for: .normal)
                
                self.cmBtn.layer.borderColor = UIColor.appLightGray.cgColor
                self.cmBtn.setTitleColor(UIColor.appLightGray, for: .normal)
                self.cmBtn.setImage(nil, for: .normal)
                
            } else {
                self.cmBtn.layer.borderColor = UIColor.appYellowColor.cgColor
                self.cmBtn.setTitleColor(UIColor.appYellowColor, for: .normal)
                self.cmBtn.setImage(UIImage(named: "ic_tick_gender"), for: .normal)
                
                //            self.feetBtn.layer.borderColor = UIColor.appLightGray.cgColor
                self.feetBtn.layer.borderWidth = 0
                //            self.feetBtn.setTitleColor(UIColor.loginBlueColor, for: .normal)
                self.feetBtn.setImage(UIImage(named: "im_switch_off"), for: .normal)
                //            self.feetBtn.setImage(nil, for: .normal)
            }
        }
    }
    
    func updateSliderLabelInputs() {
        if isFeetSelected {
            let minFeet = convertCmToFeet(value: selectedMinValue)
            let maxFeet = convertCmToFeet(value: selectedMaxValue)
            labelHeight.text = "\(minFeet)ft - \(maxFeet)ft"
            
            let val = minFeet.components(separatedBy: "′")
            let val1 = val[1].components(separatedBy: "“")
            let val2 = val1[0].components(separatedBy: " ")
            let finalMin = val[0] + "." + val2[1]
            
            let val4 = maxFeet.components(separatedBy: "′")
            let val5 = val4[1].components(separatedBy: "“")
            let val6 = val5[0].components(separatedBy: " ")
            let finalMax = val4[0] + "." + val6[1]
            
            heightCallBack?("\(finalMin)", "\(finalMax)","Feet")
//            heightCallBack?("\(selectedMinValue)", "\(selectedMaxValue)","Feet")

        } else {
            labelHeight.text = "\(selectedMinValue)cm -\(selectedMaxValue)cm"
            heightCallBack?("\(selectedMinValue)", "\(selectedMaxValue)","Centimetre")
        }
    }
    
    func newUpdateSliderLabelInputs() {
        if selectedForSlider == 0 {
            let minFeet = convertCmToFeet(value: selectedMinValue)
            let maxFeet = convertCmToFeet(value: selectedMaxValue)
            labelHeight.text = "\(minFeet)ft - \(maxFeet)ft"
            
            let val = minFeet.components(separatedBy: "′")
            let val1 = val[1].components(separatedBy: "“")
            let val2 = val1[0].components(separatedBy: " ")
            let finalMin = val[0] + "." + val2[1]
            
            let val4 = maxFeet.components(separatedBy: "′")
            let val5 = val4[1].components(separatedBy: "“")
            let val6 = val5[0].components(separatedBy: " ")
            let finalMax = val4[0] + "." + val6[1]
            
            heightCallBack?("\(finalMin)", "\(finalMax)","Feet")
//            heightCallBack?("\(selectedMinValue)", "\(selectedMaxValue)","Feet")

        } else {
            labelHeight.text = "\(selectedMinValue)cm -\(selectedMaxValue)cm"
            heightCallBack?("\(selectedMinValue)", "\(selectedMaxValue)","Centimetre")
        }
    }

    func convertCmToFeet(value: Int) -> String {
        let feet = Double(value) * 0.0328084
        let feetShow = Int(floor(feet))
        let feetRest: Double = ((feet * 100).truncatingRemainder(dividingBy: 100) / 100)
        let inches = Int(floor(feetRest * 12))
        return "\(Int(feetShow))′ \(Int(inches))“"
    }
    
    func convertFeetInchesToCM(value: CGFloat) -> CGFloat {
        let int_value = Int(value) // Feet
        let dec_value = (value - CGFloat(int_value)) * 10 // Inches
        let inches = (12 * CGFloat(int_value)) + dec_value
        return round(inches * 2.54) + 2
    }
    
    @IBAction func feetBtnClicked(_ sender: UIButton) {
//        isFeetSelected = true
//        changeBtnLayoutOnSelection()
//        updateSliderLabelInputs()
        if isFeetSelected == true {
            changeBtnLayoutOnSelection()
            updateSliderLabelInputs()
            selectedForSlider = 0
        } else {
            changeBtnLayoutOnSelection()
            updateSliderLabelInputs()
            selectedForSlider = 1
        }
        isFeetSelected = !isFeetSelected
    }
    
    @IBAction func cmBtnClicked(_ sender: UIButton) {
        isFeetSelected = false
        changeBtnLayoutOnSelection()
        updateSliderLabelInputs()
    }
}

extension NewSearchHeightTableViewCell: RangeSeekSliderDelegate {
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        selectedMinValue = Int(slider.selectedMinValue)
        selectedMaxValue = Int(slider.selectedMaxValue)
//         updateSliderLabelInputs()
        newUpdateSliderLabelInputs()
    }
}
