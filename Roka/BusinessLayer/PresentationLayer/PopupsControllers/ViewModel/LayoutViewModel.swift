//
//  LayoutViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 14/11/22.
//

import Foundation
import UIKit

class LayoutViewModel:BaseViewModel {
    var completionHandler: ((LayoutType) -> Void)?
    var isCome = ""
    var isSelected: LayoutType?
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    
}
