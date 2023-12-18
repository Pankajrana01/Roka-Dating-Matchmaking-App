//
//  ChatConstant.swift
//  Roka
//
//  Created by Pankaj Rana on 14/10/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var chat: UIStoryboard {
        return UIStoryboard(name: "Chat", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let chatPager                = "ChatPagerController"
    static let inbox                    = "InboxController"
    static let other                    = "InviteController"
    static let chat                     = "ChatViewController"
    static let giftkeyPopup             = "GiftKeyPopupController"
    static let BuyGiftKey               = "BuyGiftKeyController"

    
}

