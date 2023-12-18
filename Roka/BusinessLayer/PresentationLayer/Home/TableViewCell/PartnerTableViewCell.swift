//
//  PartnerTableViewCell.swift
//  Roka
//
//  Created by ios on 18/09/23.
//

import UIKit

class PartnerTableViewCell: UITableViewCell {

    @IBOutlet weak var separationView: UIView!
    @IBOutlet weak var separatorLine: UILabel!
    @IBOutlet weak var workLeftLine: UILabel!
    @IBOutlet weak var workUpperLine: UILabel!
    @IBOutlet weak var educationUpperLine: UILabel!
    @IBOutlet weak var partnertextLabel: UILabel!
    @IBOutlet weak var partnerLabel: UILabel!
    @IBOutlet weak var educationLabel: UILabel!
    @IBOutlet weak var workLabel: UILabel!
    @IBOutlet weak var educationView: UIView!
    @IBOutlet weak var workIndustryView: UIView!
    
    var profile : ProfilesModel! { didSet { profileDidSets() } }
    var check = false
    var anotherCheck = false
    var workCheck = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func profileDidSets() {
        for i in 0..<(profile.userQuestionAnswer?.count ?? 0) {
            if profile.userQuestionAnswer?[i].questionAbout?.question == "What do i look for in my partner?" {
                if profile.userQuestionAnswer?[i].answer == "" {
                    partnerLabel.isHidden = true
                    partnertextLabel.isHidden = true
                    check = false
                } else {
                    partnerLabel.text = profile.userQuestionAnswer?[i].answer
                    partnerLabel.isHidden = false
                    partnertextLabel.isHidden = false
                    check = true
                    break
                }
            } else {
                check = false
                partnerLabel.isHidden = true
                partnertextLabel.isHidden = true
            }
        }
        if profile.userQuestionAnswer?.count ?? 0 == 0 || profile.userQuestionAnswer == nil {
            check = false
            partnerLabel.isHidden = true
            partnertextLabel.isHidden = true
        }
        
        if profile.Education?.name == "" || profile.Education?.name == nil {
            self.educationView.isHidden = true
            anotherCheck = false
        } else {
            anotherCheck = true
            self.educationView.isHidden = false
            self.educationLabel.text = profile.Education?.name
        }
        if profile.WorkIndustry?.name == "" || profile.WorkIndustry?.name == nil {
            self.workIndustryView.isHidden = true
            workCheck = false
        } else {
            workCheck = true
            self.workIndustryView.isHidden = false
            self.workLabel.text = profile.WorkIndustry?.name
        }
        
        if check == true && (anotherCheck == true || workCheck == true) {
            self.separatorLine.isHidden = false
            self.separationView.isHidden = false
        } else {
            self.separatorLine.isHidden = true
            self.separationView.isHidden = true
        }
        if anotherCheck == true && workCheck == true {
            workLeftLine.isHidden = false
        } else {
            workLeftLine.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
