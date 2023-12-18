//
//  GroupDetailHeaderViewCell.swift
//  Roka
//
//  Created by Pankaj Rana on 26/12/22.
//

import UIKit

class GroupDetailHeaderViewCell: UITableViewCell {

    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var addMemberButton: UIButton!
    @IBOutlet weak var totalMemberCountLbl: UILabel!
    
    var callBackForSelectAddMemberButton: ((_ selectedIndex:Int) ->())?
    
    @IBAction func addMemberAction(_ sender: UIButton) {
        callBackForSelectAddMemberButton?(sender.tag)
    }
}
