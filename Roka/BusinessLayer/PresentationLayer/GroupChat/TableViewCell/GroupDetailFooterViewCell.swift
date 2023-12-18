//
//  GroupDetailFooterViewCell.swift
//  Roka
//
//  Created by Pankaj Rana on 26/12/22.
//

import UIKit

class GroupDetailFooterViewCell: UITableViewCell {
    @IBOutlet weak var deleteButton: UILabel!
    @IBOutlet weak var innerView: UIView!

    var callBackForDeleteButtonAction: (() ->())?

    @IBAction func deleteButtonAction(_ sender: UIButton) {
        callBackForDeleteButtonAction?()
    }
}
