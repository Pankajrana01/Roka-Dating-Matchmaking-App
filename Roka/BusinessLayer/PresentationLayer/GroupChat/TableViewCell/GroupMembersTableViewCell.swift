//
//  GroupMembersTableViewCell.swift
//  Roka
//
//  Created by Pankaj Rana on 26/12/22.
//

import UIKit

class GroupMembersTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var removeButton: UIButton!
    
    var callBackForRemoveButton: ((_ selectedIndex:Int) ->())?
    
    @IBAction func removeAction(_ sender: UIButton) {
        callBackForRemoveButton?(sender.tag)
    }
}
