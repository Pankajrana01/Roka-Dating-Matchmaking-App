//
//  NotificationsModel.swift
//  Roka
//
//  Created by  Developer on 27/10/22.
//

import Foundation

class NotificationsModel {
    var status: String
    var description: String
    var isOn: Int
    
    init(status: String, description: String, isOn: Int) {
        self.status = status
        self.description = description
        self.isOn = isOn
    }
}
