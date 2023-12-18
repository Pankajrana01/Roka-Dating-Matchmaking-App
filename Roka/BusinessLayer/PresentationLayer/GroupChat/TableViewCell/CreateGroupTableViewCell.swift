//
//  CreateGroupTableViewCell.swift
//  Roka
//
//  Created by Pankaj Rana on 22/12/22.
//

import UIKit
import TagListView

class CreateGroupTableViewCell: UITableViewCell {

    @IBOutlet weak var suggestTopConstant: NSLayoutConstraint!
    @IBOutlet weak var searchHeightConst: NSLayoutConstraint!
    @IBOutlet weak var groupNameTextField: UnderlinedTextField!
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var groupNameHeightConstant: NSLayoutConstraint!

    var callBackForSearchTextField: ((_ selectedIndex:Int, _ newText:String) ->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        searchTextField.delegate = self
        // Initialization code
    }
}

extension CreateGroupTableViewCell: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == searchTextField {
            let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
            callBackForSearchTextField?(textField.tag, newString)
        }
        return true
    }
    
    
}
