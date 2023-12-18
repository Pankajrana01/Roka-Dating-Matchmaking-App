//
//  GalleryConstant.swift
//  Roka
//
//  Created by Pankaj Rana on 01/11/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    class var gallery: UIStoryboard {
        return UIStoryboard(name: "Gallery", bundle: nil)
    }
}

extension ViewControllerIdentifier {
    static let gallery                     = "GalleryViewController"

}

extension CollectionViewNibIdentifier {
    static let galleryImageNib           = "GalleryImagesCollectionViewCell"
}
extension CollectionViewCellIdentifier {
    static let galleryImagecell           = "GalleryImagesCollectionViewCell"
}
