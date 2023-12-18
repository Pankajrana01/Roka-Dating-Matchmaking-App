//
//  InterestTableViewCell.swift
//  Roka
//
//  Created by Pankaj Rana on 18/10/22.
//

import UIKit
import TagListView
class InterestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var separatorLabel: UILabel!
    @IBOutlet weak var zodiacUpperLine: UILabel!
    @IBOutlet weak var zodiacleftLine: UILabel!
    @IBOutlet weak var religionUpperLine: UILabel!
    @IBOutlet weak var religionleftLine: UILabel!
    @IBOutlet weak var ethnicityUpperLine: UILabel!
    @IBOutlet weak var heightleftLine: UILabel!
    @IBOutlet weak var relationleftLine: UILabel!
    @IBOutlet weak var zodiacSeparatorLline: UILabel!
    @IBOutlet weak var religionSeparatorline: UILabel!
    @IBOutlet weak var lowerView: UIView!
    @IBOutlet weak var zodiacLabel: UILabel!
    @IBOutlet weak var zodiacView: UIView!
    @IBOutlet weak var religionLabel: UILabel!
    @IBOutlet weak var religionView: UIView!
    @IBOutlet weak var ethnicityLabel: UILabel!
    @IBOutlet weak var ethnicityView: UIView!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var relationLabel: UILabel!
    @IBOutlet weak var relationView: UIView!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var tagView: TagListView!
    
    var profile : ProfilesModel! { didSet { profileDidSets() } }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func profileDidSets() {
        if profile.gender == "NA" {
            self.genderLabel.text = ""
            self.genderLabel.text = profile.Gender?.name
        } else {
            self.genderLabel.text = profile.gender
        }
        
        if profile.Relationship?.name == "" || profile.Relationship?.name == nil {
            self.relationView.isHidden = true
        } else {
            self.relationView.isHidden = false
            self.relationLabel.text = profile.Relationship?.name
        }
        var a = Double(profile.height ?? "5.5") ?? 5.5
        let height = convertFeetInchesToCM(value: CGFloat(a))
        self.heightLabel.text = "\(height) cm"
        if profile.Ethnicity?.name == "" || profile.Ethnicity?.name == nil {
            self.ethnicityView.isHidden = true
        } else {
            self.ethnicityView.isHidden = false
            self.ethnicityLabel.text = profile.Ethnicity?.name
        }
        if profile.Religion?.name == "" || profile.Religion?.name == nil {
            self.religionView.isHidden = true
        } else {
            self.religionView.isHidden = false
            self.religionLabel.text = profile.Religion?.name
        }
        if profile.zodiac?.name == "" || profile.zodiac?.name == nil {
            self.zodiacView.isHidden = true
        } else {
            self.zodiacView.isHidden = false
            self.zodiacLabel.text = profile.zodiac?.name
        }
        if (profile.Ethnicity?.name == "" || profile.Ethnicity?.name == nil) && (profile.Religion?.name == "" || profile.Religion?.name == nil) && (profile.zodiac?.name == "" || profile.zodiac?.name == nil) {
            self.lowerView.isHidden = true
            self.separatorLabel.isHidden = true
        } else {
            self.separatorLabel.isHidden = false
            self.lowerView.isHidden = false
        }
        if (profile.Ethnicity?.name == "" || profile.Ethnicity?.name == nil) && ((profile.Religion?.name == "" || profile.Religion?.name == nil) || (profile.zodiac?.name == "" || profile.zodiac?.name == nil)) {
            if profile.Religion?.name == "" || profile.Religion?.name == nil {
                self.religionSeparatorline.isHidden = true
            } else if profile.zodiac?.name == "" || profile.zodiac?.name == nil {
                self.religionSeparatorline.isHidden = true
                self.zodiacSeparatorLline.isHidden = true
            } else if profile.Religion?.name != "" && profile.zodiac?.name != "" {
                self.religionSeparatorline.isHidden = true
                self.zodiacSeparatorLline.isHidden = false
            } else if profile.Religion?.name != "" {
                self.religionSeparatorline.isHidden = true
            } else if profile.zodiac?.name != "" {
                self.zodiacSeparatorLline.isHidden = true
            }
        }
        
        
        
        if (profile.Ethnicity?.name == "" || profile.Ethnicity?.name == nil) && profile.Religion?.name != "" || profile.zodiac?.name != "" {
            if profile.Religion?.name != "" && profile.zodiac?.name != "" {
                if profile.Religion?.name == nil && profile.zodiac?.name == nil {
                    self.religionSeparatorline.isHidden = true
                    self.zodiacSeparatorLline.isHidden = true
                } else if profile.Religion?.name == nil && profile.zodiac?.name != "" {
                    self.religionSeparatorline.isHidden = true
                    self.zodiacSeparatorLline.isHidden = true
                } else if profile.zodiac?.name == nil && profile.Religion?.name != "" {
                    self.religionSeparatorline.isHidden = true
                    self.zodiacSeparatorLline.isHidden = true
                } else {
                    self.religionSeparatorline.isHidden = true
                    self.zodiacSeparatorLline.isHidden = false
                }
            } else if profile.Religion?.name != "" && (profile.zodiac?.name == "" || profile.zodiac?.name == nil) {
                self.religionSeparatorline.isHidden = true
                self.zodiacSeparatorLline.isHidden = true
            } else {
                self.religionSeparatorline.isHidden = true
                self.zodiacSeparatorLline.isHidden = true
            }
        }
        if (profile.Ethnicity?.name != "" && profile.Religion?.name != "" && profile.zodiac?.name != "") {
            if profile.Ethnicity?.name != nil && profile.Religion?.name != nil && profile.zodiac?.name != nil {
                self.religionSeparatorline.isHidden = false
                self.zodiacSeparatorLline.isHidden = false
            }
        }
        
        if (profile.Ethnicity?.name != "" && profile.Religion?.name != "" && profile.zodiac?.name != "") {
            if profile.Ethnicity?.name != nil && profile.Religion?.name != nil && profile.zodiac?.name == nil {
                self.religionSeparatorline.isHidden = false
                self.zodiacSeparatorLline.isHidden = true
            }
        }
        
        if profile.height == "" || profile.height == nil {
            self.heightView.isHidden = true
        } else {
            self.heightView.isHidden = false
        }
    }
    
    func convertFeetInchesToCM(value: CGFloat) -> CGFloat {
        let int_value = Int(value) // Feet
        let dec_value = (value - CGFloat(int_value)) * 10 // Inches
        let inches = (12 * CGFloat(int_value)) + dec_value
        return round(inches * 2.54) + 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
