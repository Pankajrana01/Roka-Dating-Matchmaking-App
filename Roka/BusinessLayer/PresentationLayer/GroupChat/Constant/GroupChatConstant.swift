//
//  GroupChatConstant.swift
//  Roka
//
//  Created by Applify  on 29/11/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var groupChat: UIStoryboard {
        return UIStoryboard(name: "GroupChat", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let createGroupChatController  = "CreateGroupChatController"
    static let createGroup                = "CreateGroupViewController"
    static let groupDetail                = "GroupDetailViewController"
    static let addGroupMember             = "AddGroupMemberViewController"
    static let editGroupDetail            = "EditGroupDetailViewController"
    static let groupSharedProfile         = "GroupSharedProfileViewController"
}

extension TableViewNibIdentifier {
    static let createGroupNib              = "CreateGroupTableViewCell"
    static let groupMembersNib             = "GroupMembersTableViewCell"
    static let groupMembersHeaderNib       = "GroupDetailHeaderViewCell"
    static let groupMembersFooterNib       = "GroupDetailFooterViewCell"

}

extension TableViewCellIdentifier {
    static let createGroupCell              = "CreateGroupTableViewCell"
    static let createGroupUsersCell         = "CreateGroupUsersTableViewCell"
    static let groupMembersCell             = "GroupMembersTableViewCell"
    static let groupMembersHeaderCell       = "GroupDetailHeaderViewCell"
    static let groupMembersFooterCell       = "GroupDetailFooterViewCell"
}
