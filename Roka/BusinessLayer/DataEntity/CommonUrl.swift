//
//  CommonUrl.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 15/01/21.
//

import Foundation
import UIKit

class CommonUrl {
    var name: String!
    var url: String!
    
    init(name: String, url: String) {
        self.name   = name
        self.url    = url
    }
}

struct UploadUrlResponseModel: Codable {
    var message: String?
    var statusCode: Int?
    var data: UploadUrlResponseDeatil?
}
struct UploadUrlResponseDeatil: Codable {
    var key: String?
    var fileName: String?
    var thumbnail: String?
    var uploadURL: String?
}
