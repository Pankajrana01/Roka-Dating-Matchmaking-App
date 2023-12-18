//
//  HomeWalkThroughViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 04/10/22.
//

import Foundation
import UIKit

class HomeWalkThroughViewModel: BaseViewModel {
    var toggleView: UIView!
    var BottomView: UIView!
    var isComeFor = ""
    var HomeButtonView: UIView!
    var NotificationButtonView: UIView!
    var SearchButtonView: UIView!
    var ChatButtonView: UIView!
    var ProfileButtonView: UIView!
    
    var BottomViewTitle: UILabel!
    var BottomViewDesc: UILabel!
    var bottomViewBgImage: UIImageView!
    
    var notiCircle: UIImageView!
    var notiImage: UIImageView!
    var searchCircle: UIImageView!
    var searchImage: UIImageView!
    var chatCircle: UIImageView!
    var chatImage: UIImageView!
    var homeCircle: UIImageView!
    var homeImage: UIImageView!
    var profileCircle: UIImageView!
    var profileImage: UIImageView!
    
    var completionHandler: ((Bool) -> Void)?
    var collectionView: UICollectionView! { didSet { configureCollectionView() } }
    
    var categories: [HomeCategory] = {
        var categories = [HomeCategory]()
        categories.append(HomeCategory(name: "Shreya , 21F", image: UIImage(named: "img_home1")!, location: "Cancer / Delhi, India", isFav: true))
        categories.append(HomeCategory(name: "Fang , 24F", image: UIImage(named: "img_home2")!, location: "Virgo / LA, USA", isFav: false))
        categories.append(HomeCategory(name: "Xavier, 23F", image: UIImage(named: "img_home3")!, location: "Leo / CT, South Africa", isFav: false))
        categories.append(HomeCategory(name: "Fatima, 21F", image: UIImage(named: "img_home4")!, location: "Leo / Dubai, UAE", isFav: false))
        categories.append(HomeCategory(name: "Shreya , 21F", image: UIImage(named: "img_home5")!, location: "Cancer / Delhi, India", isFav: false))
        categories.append(HomeCategory(name: "Shreya , 21F", image: UIImage(named: "img_home6")!, location: "Cancer / Delhi, India", isFav: false))
        return categories
    }()
    
    private func configureCollectionView() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = false
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: CollectionViewNibIdentifier.homeNib, bundle: nil),
                                forCellWithReuseIdentifier: CollectionViewCellIdentifier.homecell)
    }
    
    
    func showToggleView() {
        self.toggleView.isHidden = false
        self.BottomView.isHidden = true
        
        self.HomeButtonView.isHidden = true
        self.NotificationButtonView.isHidden = true
        self.SearchButtonView.isHidden = true
        self.ChatButtonView.isHidden = true
        self.ProfileButtonView.isHidden = true
    }
    
    func showHomeView() {
        self.BottomView.alpha = 0.0
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.BottomView.alpha = 1.0
            self.toggleView.isHidden = true
            self.BottomView.isHidden = false
            
            self.HomeButtonView.isHidden = false
            self.NotificationButtonView.isHidden = false
            self.SearchButtonView.isHidden = false
            self.ChatButtonView.isHidden = false
            self.ProfileButtonView.isHidden = false
            
            self.homeImage.image = UIImage(named: "Ic_home_selected")
            self.homeCircle.image = UIImage(named: "ic_circle_bg")
            self.notiImage.image = UIImage(named: "")
            self.notiCircle.image = UIImage(named: "")
            self.searchImage.image = UIImage(named: "")
            self.searchCircle.image = UIImage(named: "")
            self.chatImage.image = UIImage(named: "")
            self.chatCircle.image = UIImage(named: "")
            self.profileImage.image = UIImage(named: "")
            self.profileCircle.image = UIImage(named: "")
            
            self.BottomViewTitle.text = StringConstants.homeTitle
            self.BottomViewDesc.text = StringConstants.homeDesc
            self.bottomViewBgImage.image = UIImage(named: "home_arrow")
        })
    }
    
    func showNotificationView() {
        self.BottomView.alpha = 0.0
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.BottomView.alpha = 1.0
            self.toggleView.isHidden = true
            self.BottomView.isHidden = false
            
            self.HomeButtonView.isHidden = false
            self.NotificationButtonView.isHidden = false
            self.SearchButtonView.isHidden = false
            self.ChatButtonView.isHidden = false
            self.ProfileButtonView.isHidden = false
            
            self.homeImage.image = UIImage(named: "")
            self.homeCircle.image = UIImage(named: "")
            self.notiImage.image = UIImage(named: "ic_notifications_selected")
            self.notiCircle.image = UIImage(named: "ic_circle_bg")
            self.searchImage.image = UIImage(named: "")
            self.searchCircle.image = UIImage(named: "")
            self.chatImage.image = UIImage(named: "")
            self.chatCircle.image = UIImage(named: "")
            self.profileImage.image = UIImage(named: "")
            self.profileCircle.image = UIImage(named: "")
            
            self.BottomViewTitle.text = StringConstants.notiTitle
            self.BottomViewDesc.text = StringConstants.notiDesc
            self.bottomViewBgImage.image = UIImage(named: "notifications_arrow")
        })
    }
    
    func showSearchView() {
        self.BottomView.alpha = 0.0
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.BottomView.alpha = 1.0
            self.toggleView.isHidden = true
            self.BottomView.isHidden = false
            
            self.HomeButtonView.isHidden = false
            self.NotificationButtonView.isHidden = false
            self.SearchButtonView.isHidden = false
            self.ChatButtonView.isHidden = false
            self.ProfileButtonView.isHidden = false
            
            self.homeImage.image = UIImage(named: "")
            self.homeCircle.image = UIImage(named: "")
            self.notiImage.image = UIImage(named: "")
            self.notiCircle.image = UIImage(named: "")
            self.searchImage.image = UIImage(named: "Ic_search_selected")
            self.searchCircle.image = UIImage(named: "ic_circle_bg")
            self.chatImage.image = UIImage(named: "")
            self.chatCircle.image = UIImage(named: "")
            self.profileImage.image = UIImage(named: "")
            self.profileCircle.image = UIImage(named: "")
            
            self.BottomViewTitle.text = StringConstants.searchTitle
            self.BottomViewDesc.text = StringConstants.searchDesc
            self.bottomViewBgImage.image = UIImage(named: "search_arrow")
        })
    }
    
    func showChatView() {
        self.BottomView.alpha = 0.0
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.BottomView.alpha = 1.0
            self.toggleView.isHidden = true
            self.BottomView.isHidden = false
            
            self.HomeButtonView.isHidden = false
            self.NotificationButtonView.isHidden = false
            self.SearchButtonView.isHidden = false
            self.ChatButtonView.isHidden = false
            self.ProfileButtonView.isHidden = false
            
            self.homeImage.image = UIImage(named: "")
            self.homeCircle.image = UIImage(named: "")
            self.searchImage.image = UIImage(named: "")
            self.searchCircle.image = UIImage(named: "")
            self.notiImage.image = UIImage(named: "")
            self.notiImage.image = UIImage(named: "")
            self.chatImage.image = UIImage(named: "ic_chat_selected")
            self.chatCircle.image = UIImage(named: "ic_circle_bg")
            self.profileImage.image = UIImage(named: "")
            self.profileCircle.image = UIImage(named: "")
            
            self.BottomViewTitle.text = StringConstants.chatTitle
            self.BottomViewDesc.text = StringConstants.chatDesc
            self.bottomViewBgImage.image = UIImage(named: "chat_arrow")
        })
    }
    
    func showProfileView() {
        self.BottomView.alpha = 0.0
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.BottomView.alpha = 1.0
            self.toggleView.isHidden = true
            self.BottomView.isHidden = false
            
            self.HomeButtonView.isHidden = false
            self.NotificationButtonView.isHidden = false
            self.SearchButtonView.isHidden = false
            self.ChatButtonView.isHidden = false
            self.ProfileButtonView.isHidden = false
            
            self.homeImage.image = UIImage(named: "")
            self.homeCircle.image = UIImage(named: "")
            self.searchImage.image = UIImage(named: "")
            self.searchCircle.image = UIImage(named: "")
            self.chatImage.image = UIImage(named: "")
            self.chatCircle.image = UIImage(named: "")
            self.notiCircle.image = UIImage(named: "")
            self.notiImage.image = UIImage(named: "")
            self.profileImage.image = UIImage(named: "img_profile_tab")
            self.profileCircle.image = UIImage(named: "ic_circle_bg")
            
            self.BottomViewTitle.text = StringConstants.profileTitle
            self.BottomViewDesc.text = StringConstants.profileDesc
            self.bottomViewBgImage.image = UIImage(named: "profile_arrow")
        })
    }
    
    func proceedToLandingWalkthrough() {
        KAPPSTORAGE.isWalkthroughShown = "Yes"
        LandingWalkThroughViewController.show(from: self.hostViewController, forcePresent: false , isComeFor: self.isComeFor) { success in
        }
    }
    
    
    func proceedForHome() {
        KAPPSTORAGE.isWalkthroughShown = "Yes"
        KAPPDELEGATE.updateRootController(TabBarController.getController(),
                                          transitionDirection: .fade,
                                          embedInNavigationController: true)
    }
    func proceedForLogout() {
        let controller = LogoutViewController.getController() as! LogoutViewController
        controller.dismissCompletion = { value  in }
        controller.show(over: self.hostViewController) { value  in
        }
    }
    
    func proceedForCreateMatchMakingProfile() {
        KAPPSTORAGE.isWalkthroughShown = "Yes"
        KAPPDELEGATE.updateRootController(MatchingTabBar.getController(),
                                          transitionDirection: .fade,
                                          embedInNavigationController: true)
    }
}



extension HomeWalkThroughViewModel : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - Collection Delegate & DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.homecell, for: indexPath) as! HomeCollectionViewCell
        cell.saveButton.isHidden = true
//        cell.category = self.categories[indexPath.row]
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.hostViewController.view.frame.size.width/2 - 30, height: 240)
    }
}
