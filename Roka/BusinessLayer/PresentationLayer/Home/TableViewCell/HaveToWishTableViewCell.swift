//
//  HaveToWishTableViewCell.swift
//  Roka
//
//  Created by ios on 18/09/23.
//

import UIKit
import TagListView

class HaveToWishTableViewCell: UITableViewCell {

    @IBOutlet weak var tagListView: TagListView!

    var wishArray = ["A serious relationship", "Kids someday", "Travel", "Marriage", "Romance & trust", "Family bonding"]
    
    var profile : ProfilesModel! { didSet { profileDidSets() } }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    func profileDidSets() {
        wishArray.removeAll()
        for i in 0..<(profile.userWishingToHavePreferences?.count ?? 0) {
            wishArray.append(profile.userWishingToHavePreferences?[i].wishingToHave?.name ?? "")
        }
        
        tagListView.removeAllTags()
        for i in 0..<wishArray.count {
            tagListView.addTag(wishArray[i])
        }
        tagListView.textColor = UIColor(hex: "#031634")
        tagListView.tagBackgroundColor = UIColor(hex: "#FFE6D8")
        tagListView.delegate = self
        tagListView.textFont = UIFont(name: "SharpSansTRIAL-Semibold", size: 12.0) ?? UIFont.systemFont(ofSize: 12.0)
        tagListView.alignment = .left
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension HaveToWishTableViewCell : TagListViewDelegate {
    
}
