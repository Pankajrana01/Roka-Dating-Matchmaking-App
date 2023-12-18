//
//  CalendarViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 22/09/22.
//

import Foundation
import UIKit

class CalendarViewModel:BaseViewModel {
    var completionHandler: ((String, String, Date) -> Void)?
    var selectedDate = ""
    var isCome = ""
    var isFriend = false
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    
    
}
