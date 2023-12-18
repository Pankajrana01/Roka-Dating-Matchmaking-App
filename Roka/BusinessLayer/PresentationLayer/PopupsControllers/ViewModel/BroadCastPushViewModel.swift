//
//  BroadCastPushViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 28/11/22.
//

import Foundation
import UIKit

class BroadCastPushViewModel: BaseViewModel {
    var completionHandler: ((String) -> Void)?
    var userInfo = [AnyHashable: Any]()
    var isCome = ""
    var title = ""
    var desc = ""
    
}
