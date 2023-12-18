//
//  PersonalityTableCell.swift
//  Roka
//
//  Created by ios on 18/09/23.
//

import UIKit
import TagListView

class PersonalityTableCell: UITableViewCell {

    @IBOutlet weak var lowerSeparator: UILabel!
    @IBOutlet weak var middleSeparator: UILabel!
    @IBOutlet weak var personlitySeparatorLine: UILabel!
    @IBOutlet weak var kidSeparatorLine: UILabel!
    @IBOutlet weak var moviesTagListView: TagListView!
    @IBOutlet weak var musicTagListView: TagListView!
    @IBOutlet weak var personalityLabel: UILabel!
    @IBOutlet weak var kidsLabel: UILabel!
    @IBOutlet weak var sexualLabel: UILabel!
    @IBOutlet weak var sexualView: UIView!
    @IBOutlet weak var kidsView: UIView!
    @IBOutlet weak var personalityView: UIView!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var lowerView: UIView!

    var profile : ProfilesModel! { didSet { profileDidSets() } }
    var moviesArray = [String]()
    var musicArray = [String]()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func dataSet() {
        if profile.sexualOrientation?.name == "" || profile.sexualOrientation?.name == nil {
            self.sexualView.isHidden = true
        } else {
            self.sexualView.isHidden = false
            self.sexualLabel.text = profile.sexualOrientation?.name
        }
        if profile.kid?.name == "" ||  profile.kid?.name == nil {
            self.kidsView.isHidden = true
        } else {
            self.kidsView.isHidden = false
            self.kidsLabel.text = profile.kid?.name
        }
        if profile.personality?.name == "" ||  profile.personality?.name == nil {
            self.personalityView.isHidden = true
        } else {
            self.personalityView.isHidden = false
            self.personalityLabel.text = profile.personality?.name
        }
        if (profile.sexualOrientation?.name == "" || profile.sexualOrientation?.name == nil) && (profile.kid?.name == "" ||  profile.kid?.name == nil) && (profile.personality?.name == "" ||  profile.personality?.name == nil) {
            self.upperView.isHidden = true
        } else {
            self.upperView.isHidden = false
        }
        if (profile.sexualOrientation?.name == "" || profile.sexualOrientation?.name == nil) && ((profile.kid?.name == "" ||  profile.kid?.name == nil) || (profile.personality?.name == "" ||  profile.personality?.name == nil)) {
            if profile.kid?.name == "" ||  profile.kid?.name == nil {
                self.kidSeparatorLine.isHidden = true
            } else if profile.personality?.name == "" ||  profile.personality?.name == nil {
                self.kidSeparatorLine.isHidden = true
                self.personlitySeparatorLine.isHidden = true
            } else if profile.kid?.name != "" && profile.personality?.name != "" {
                self.kidSeparatorLine.isHidden = true
                self.personlitySeparatorLine.isHidden = false
            } else if profile.kid?.name != "" {
                self.kidSeparatorLine.isHidden = true
            } else if profile.personality?.name != "" {
                self.personlitySeparatorLine.isHidden = true
            }
        }
        if (profile.sexualOrientation?.name == "" || profile.sexualOrientation?.name == nil) && profile.kid?.name != "" && profile.personality?.name != "" {
            self.kidSeparatorLine.isHidden = true
            self.personlitySeparatorLine.isHidden = false
        }
        
        if ((profile.sexualOrientation?.name == "" || profile.sexualOrientation?.name == nil) && (profile.kid?.name == "" ||  profile.kid?.name == nil) && (profile.personality?.name == "" ||  profile.personality?.name == nil)) {
            if profile.userMovies?.count == 0 || profile.userMovies == nil {
                if profile.userMusic?.count != 0 || profile.userMusic != nil {
                    middleSeparator.isHidden = true
                    lowerSeparator.isHidden = true
                }
            } else {
                if profile.userMusic?.count == 0 || profile.userMusic == nil {
                    middleSeparator.isHidden = true
                    lowerSeparator.isHidden = true
                } else {
                    middleSeparator.isHidden = true
                    lowerSeparator.isHidden = false
                }
            }
        }
    }
    
    func profileDidSets() {
        self.dataSet()
        musicArray.removeAll()
        moviesArray.removeAll()
        musicTagListView.removeAllTags()
        moviesTagListView.removeAllTags()
        if profile.userMusic?.count == 0 || profile.userMusic?.count == nil {
            self.lowerView.isHidden = true
        } else {
            self.lowerView.isHidden = false
            for i in 0..<(profile.userMusic?.count ?? 0) {
                musicArray.append(profile.userMusic?[i].music?.name ?? "")
            }
            for i in 0..<musicArray.count {
                musicTagListView.addTag(musicArray[i])
            }
            musicTagListView.textColor = UIColor(hex: "#031634")
            musicTagListView.tagBackgroundColor = UIColor(hex: "#FFE6D8")
            musicTagListView.delegate = self
            musicTagListView.textFont = UIFont(name: "SharpSansTRIAL-Semibold", size: 12.0) ?? UIFont.systemFont(ofSize: 12.0)
        }
        
        if profile.userMovies?.count == 0 || profile.userMovies?.count == nil {
            self.middleView.isHidden = true
        } else {
            self.middleView.isHidden = false
            for i in 0..<(profile.userMovies?.count ?? 0) {
                moviesArray.append(profile.userMovies?[i].movie?.name ?? "")
            }
            for i in 0..<moviesArray.count {
                moviesTagListView.addTag(moviesArray[i])
            }
            moviesTagListView.textColor = UIColor(hex: "#031634")
            moviesTagListView.tagBackgroundColor = UIColor(hex: "#FFE6D8")
            moviesTagListView.delegate = self
            moviesTagListView.textFont = UIFont(name: "SharpSansTRIAL-Semibold", size: 12.0) ?? UIFont.systemFont(ofSize: 12.0)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension PersonalityTableCell : TagListViewDelegate {
    
}
