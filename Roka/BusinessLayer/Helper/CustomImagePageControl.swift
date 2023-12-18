//
//  CustomImagePageControl.swift
//  Roka
//
//  Created by Pankaj Rana on 28/10/22.
//

import Foundation
import UIKit

class CustomImagePageControl: UIPageControl {
    
    let activeImage:UIImage = UIImage(named: "ic_heart_selected")!
    let inactiveImage:UIImage = UIImage(named: "ic_heart_unselected")!
    
    // active and inactive images
    let imgActive: UIImage = #imageLiteral(resourceName: "ic_heart_selected")
    let imgInactive: UIImage = #imageLiteral(resourceName: "ic_heart_unselected")
    
    
    // adjust these parameters for specific case
    let customActiveYOffset: CGFloat = 5.0
    let customInactiveYOffset: CGFloat = 3.0
    var hasCustomTintColor: Bool = false
    let customActiveDotColor: UIColor = UIColor(white: 0xe62f3e, alpha: 1.0)
    
    override var numberOfPages: Int {
        didSet {
            updateDots()
        }
    }
    
    override var currentPage: Int {
        didSet {
            updateDots()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if #available(iOS 14.0, *) {
            defaultConfigurationForiOS14AndAbove()
        } else {
            pageIndicatorTintColor = .clear
            currentPageIndicatorTintColor = .clear
            clipsToBounds = false
        }
    }
    
    private func defaultConfigurationForiOS14AndAbove() {
        if #available(iOS 14.0, *) {
            for index in 0..<numberOfPages {
                let image = index == currentPage ? activeImage : inactiveImage
                setIndicatorImage(image, forPage: index)
            }
            
            // give the same color as "otherPagesImage" color.
            pageIndicatorTintColor = .gray
            
            // give the same color as "currentPageImage" color.
            currentPageIndicatorTintColor = .red
            /*
             Note: If Tint color set to default, Indicator image is not showing. So, give the same tint color based on your Custome Image.
             */
        }
    }
    
    private func updateDots() {
        if #available(iOS 14.0, *) {
            defaultConfigurationForiOS14AndAbove()
        } else {
            for (index, subview) in subviews.enumerated() {
                let imageView: UIImageView
                if let existingImageview = getImageView(forSubview: subview) {
                    imageView = existingImageview
                } else {
                    imageView = UIImageView(image: inactiveImage)
                    
                    imageView.center = subview.center
                    subview.addSubview(imageView)
                    subview.clipsToBounds = false
                }
                imageView.image = currentPage == index ? activeImage : inactiveImage
            }
        }
    }
    
    private func getImageView(forSubview view: UIView) -> UIImageView? {
        if let imageView = view as? UIImageView {
            return imageView
        } else {
            let view = view.subviews.first { (view) -> Bool in
                return view is UIImageView
            } as? UIImageView
            
            return view
        }
    }
}
