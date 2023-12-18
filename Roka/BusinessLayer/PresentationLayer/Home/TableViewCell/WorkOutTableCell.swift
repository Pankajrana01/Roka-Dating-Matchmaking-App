//
//  WorkOutTableCell.swift
//  Roka
//
//  Created by ios on 18/09/23.
//

import UIKit
import TagListView

class WorkOutTableCell: UITableViewCell {

    @IBOutlet weak var lowerSepartor: UILabel!
    @IBOutlet weak var middleSeparator: UILabel!
    @IBOutlet weak var workoutSepartorLine: UILabel!
    @IBOutlet weak var smokeSepartorLine: UILabel!
    @IBOutlet weak var bookTagListView: TagListView!
    @IBOutlet weak var sportsTagListView: TagListView!
    @IBOutlet weak var smokeLabel: UILabel!
    @IBOutlet weak var workoutLabel: UILabel!
    @IBOutlet weak var drinkLabel: UILabel!
    @IBOutlet weak var workoutView: UIView!
    @IBOutlet weak var smokeView: UIView!
    @IBOutlet weak var drinkView: UIView!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var lowerView: UIView!
    
    var profile : ProfilesModel! { didSet { profileDidSets() } }
    var sportsArray = [String]()
    var bookArray = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func dataSet() {
        if profile.drinking?.name == "" || profile.drinking?.name == nil {
            self.drinkView.isHidden = true
        } else {
            self.drinkView.isHidden = false
            self.drinkLabel.text = profile.drinking?.name
        }
        if profile.smoking?.name == "" ||  profile.smoking?.name == nil {
            self.smokeView.isHidden = true
        } else {
            self.smokeView.isHidden = false
            self.smokeLabel.text = profile.smoking?.name
        }
        if profile.workout?.name == "" ||  profile.workout?.name == nil {
            self.workoutView.isHidden = true
        } else {
            self.workoutView.isHidden = false
            self.workoutLabel.text = profile.workout?.name
        }
        if (profile.drinking?.name == "" || profile.drinking?.name == nil) && (profile.smoking?.name == "" ||  profile.smoking?.name == nil) && (profile.workout?.name == "" ||  profile.workout?.name == nil) {
            self.upperView.isHidden = true
        } else {
            self.upperView.isHidden = false
        }
        
        if (profile.drinking?.name == "" || profile.drinking?.name == nil) && ((profile.smoking?.name == "" ||  profile.smoking?.name == nil) || (profile.workout?.name == "" ||  profile.workout?.name == nil)) {
            if profile.smoking?.name == "" ||  profile.smoking?.name == nil {
                self.smokeSepartorLine.isHidden = true
                self.workoutSepartorLine.isHidden = true
            } else if profile.workout?.name == "" ||  profile.workout?.name == nil {
                self.workoutSepartorLine.isHidden = true
                self.smokeSepartorLine.isHidden = true
            } else if profile.smoking?.name != "" {
                self.smokeSepartorLine.isHidden = true
            } else if profile.workout?.name != "" {
                self.workoutSepartorLine.isHidden = true
            }
        }
        
        if (profile.drinking?.name == "" || profile.drinking?.name == nil) && profile.smoking?.name != "" && profile.workout?.name != "" {
            if profile.smoking?.name == nil {
                self.smokeSepartorLine.isHidden = true
                self.workoutSepartorLine.isHidden = true
            } else if profile.smoking?.name != nil && profile.workout?.name != nil {
                self.smokeSepartorLine.isHidden = true
                self.workoutSepartorLine.isHidden = false
            }
        }
        
        if ((profile.drinking?.name == "" || profile.drinking?.name == nil) && (profile.smoking?.name == "" ||  profile.smoking?.name == nil) && (profile.workout?.name == "" ||  profile.workout?.name == nil)) {
            if profile.usersSports?.count == 0 || profile.usersSports == nil {
                if profile.usersBooks?.count != 0 || profile.usersBooks != nil {
                    middleSeparator.isHidden = true
                    lowerSepartor.isHidden = true
                }
            } else {
                if profile.usersBooks?.count == 0 || profile.usersBooks == nil {
                    middleSeparator.isHidden = true
                    lowerSepartor.isHidden = true
                } else {
                    middleSeparator.isHidden = true
                    lowerSepartor.isHidden = false
                }
            }
        }
    }
    
    func profileDidSets() {
        self.dataSet()
        sportsArray.removeAll()
        bookArray.removeAll()
        bookTagListView.removeAllTags()
        sportsTagListView.removeAllTags()
        if profile.usersSports?.count == 0 || profile.usersSports?.count == nil {
            self.middleView.isHidden = true
        } else {
            self.middleView.isHidden = false
            for i in 0..<(profile.usersSports?.count ?? 0) {
                sportsArray.append(profile.usersSports?[i].sport?.name ?? "")
            }
            for i in 0..<sportsArray.count {
                sportsTagListView.addTag(sportsArray[i])
            }
            sportsTagListView.textColor = UIColor(hex: "#031634")
            sportsTagListView.tagBackgroundColor = UIColor(hex: "#BCD7FF")
            sportsTagListView.delegate = self
            sportsTagListView.textFont = UIFont(name: "SharpSansTRIAL-Semibold", size: 12.0) ?? UIFont.systemFont(ofSize: 12.0)
        }
        
        if profile.usersBooks?.count == 0 || profile.usersBooks?.count == nil {
            self.lowerView.isHidden = true
        } else {
            self.lowerView.isHidden = false
            for i in 0..<(profile.usersBooks?.count ?? 0) {
                bookArray.append(profile.usersBooks?[i].book?.name ?? "")
            }
            for i in 0..<bookArray.count {
                bookTagListView.addTag(bookArray[i])
            }
            bookTagListView.textColor = UIColor(hex: "#031634")
            bookTagListView.tagBackgroundColor = UIColor(hex: "#BCD7FF")
            bookTagListView.delegate = self
            bookTagListView.textFont = UIFont(name: "SharpSansTRIAL-Semibold", size: 12.0) ?? UIFont.systemFont(ofSize: 12.0)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension WorkOutTableCell : TagListViewDelegate {
    
}
