//
//  ExampleOverlayView.swift
//  KolodaView
//
//  Created by Eugene Andreyev on 6/21/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import Koloda

private let overlayRightImageName = ""//"yesOverlayImage"
private let overlayLeftImageName = ""//"noOverlayImage"

class ExampleOverlayView: OverlayView {
    
    @IBOutlet weak var dislikeView: UIView!
    @IBOutlet weak var likeView: UIView!
    @IBOutlet lazy var overlayImageView: UIImageView! = {
        [unowned self] in
        
        var imageView = UIImageView(frame: self.bounds)
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        self.addSubview(imageView)
        
        return imageView
        }()

    override var overlayState: SwipeResultDirection? {
        didSet {
            if KAPPSTORAGE.isShownLikeDislike {
                dislikeView.isHidden = true
                likeView.isHidden = true
            }
            switch overlayState {
            case .left? :
                overlayImageView.image = UIImage(named: overlayLeftImageName)
                KAPPSTORAGE.isShownLikeDislike = true
                
                if KAPPSTORAGE.isShownLikeDislike {
                    dislikeView.isHidden = true
                    likeView.isHidden = true
                } else {
                    dislikeView.isHidden = false
                    likeView.isHidden = true
                }
            case .right? :
                
                overlayImageView.image = UIImage(named: overlayRightImageName)
                KAPPSTORAGE.isShownLikeDislike = true
                
                if KAPPSTORAGE.isShownLikeDislike {
                    dislikeView.isHidden = true
                    likeView.isHidden = true
                } else {
                    dislikeView.isHidden = true
                    likeView.isHidden = false
                }
            default:
                overlayImageView.image = nil
                dislikeView.isHidden = true 
                likeView.isHidden = true
            }
        }
    }

}
