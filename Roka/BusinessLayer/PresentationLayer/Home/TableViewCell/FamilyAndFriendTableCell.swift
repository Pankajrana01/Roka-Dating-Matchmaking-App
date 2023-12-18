//
//  FamilyAndFriendTableCell.swift
//  Roka
//
//  Created by ios on 18/09/23.
//

import UIKit
import TagListView

class FamilyAndFriendTableCell: UITableViewCell {

    @IBOutlet weak var separtaorView: UIView!
    @IBOutlet weak var familyLabel: UILabel!
    @IBOutlet weak var sepratorLine: UILabel!
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var passionLabel: UILabel!
    @IBOutlet weak var familyFriendLabel: UILabel!

    var profile : ProfilesModel! { didSet { profileDidSets() } }
    var wishArray = [String]()
    var check = false
    var anotherCheck = false

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func profileDidSets() {
        for i in 0..<(profile.userQuestionAnswer?.count ?? 0) {
            if profile.userQuestionAnswer?[i].questionAbout?.question == "My family and friend describe me as." {
                if profile.userQuestionAnswer?[i].answer == "" {
                    familyLabel.isHidden = true
                    familyFriendLabel.isHidden = true
                    check = false
                } else {
                    familyFriendLabel.text = profile.userQuestionAnswer?[i].answer
                    familyLabel.isHidden = false
                    familyFriendLabel.isHidden = false
                    check = true
                    break
                }
            } else {
                familyLabel.isHidden = true
                familyFriendLabel.isHidden = true
                check = false
            }
        }
        if profile.userQuestionAnswer?.count ?? 0 == 0 {
            familyLabel.isHidden = true
            familyFriendLabel.isHidden = true
            check = false
        }
        
        wishArray.removeAll()
        tagListView.removeAllTags()
        if profile.userPassion?.count == 0 || profile.userPassion?.count == nil {
            self.passionLabel.isHidden = true
            self.tagListView.isHidden = true
            anotherCheck = false
        } else {
            anotherCheck = true
            self.passionLabel.isHidden = false
            self.tagListView.isHidden = false
            for i in 0..<(profile.userPassion?.count ?? 0) {
                wishArray.append(profile.userPassion?[i].passion?.name ?? "")
            }
            for i in 0..<wishArray.count {
                tagListView.addTag(wishArray[i])
            }
            tagListView.textColor = UIColor(hex: "#031634")
            tagListView.tagBackgroundColor = UIColor(hex: "#CDC2FD")
            tagListView.delegate = self
            tagListView.textFont = UIFont(name: "SharpSansTRIAL-Semibold", size: 12.0) ?? UIFont.systemFont(ofSize: 12.0)
        }
        
        if check == true && anotherCheck == true {
            sepratorLine.isHidden = false
            separtaorView.isHidden = false
        } else if check == true && anotherCheck == false {
            sepratorLine.isHidden = true
            separtaorView.isHidden = true
        } else if check == false && anotherCheck == true {
            sepratorLine.isHidden = true
            separtaorView.isHidden = true
        } else {
            sepratorLine.isHidden = true
            separtaorView.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension FamilyAndFriendTableCell : TagListViewDelegate {
    
}
