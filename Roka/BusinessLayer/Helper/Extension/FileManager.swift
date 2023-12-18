//
//  FileManager.swift
//  KarGoCustomer
//
//  Created by Applify on 05/10/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

extension FileManager {
    static func clearTmpDirectory() {
        do {
            let manager = FileManager.default
            let tmpDirURL = manager.temporaryDirectory
            let tmpDirectory = try manager.contentsOfDirectory(atPath: tmpDirURL.path)
            try tmpDirectory.forEach { file in
                let fileUrl = tmpDirURL.appendingPathComponent(file)
                try manager.removeItem(atPath: fileUrl.path)
            }
        } catch {
           //catch the error somehow
        }
    }
}
