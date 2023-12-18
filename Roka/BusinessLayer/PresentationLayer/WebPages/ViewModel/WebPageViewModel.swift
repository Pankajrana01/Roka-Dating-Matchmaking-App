//
//  WebPageViewModel.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 06/01/21.
//

import Foundation
import UIKit
class WebPageViewModel: BaseViewModel {
    var completionHandler: ((Bool) -> Void)?
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    var titleName = ""
    var iscomeFrom = ""
    var url = ""
}
