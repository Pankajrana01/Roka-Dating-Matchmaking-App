//
//  GroupSharedProfileViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 28/12/22.
//

import Foundation
import UIKit
import SDWebImage

class GroupSharedProfileViewModel: BaseViewModel {
    var isComeFor = ""
    var completionHandler: ((Bool) -> Void)?
    var profilesIds: String = ""
    var profileArr: [ProfilesModel] = []
    
    weak var gridCollectionView: UICollectionView! { didSet { configureGridCollectionView() } }
    private func configureGridCollectionView() {
        gridCollectionView.dataSource = self
        gridCollectionView.delegate = self
        
        gridCollectionView.register(UINib(nibName: CollectionViewNibIdentifier.gridNib, bundle: nil),
                                    forCellWithReuseIdentifier: CollectionViewCellIdentifier.gridCell)
        
//        if let pinterestlayout = gridCollectionView?.collectionViewLayout as? PinterestLayout {
//            pinterestlayout.delegate = self
//        }
    }
    
    func getAllSharedProfiles(_ result:@escaping([String: Any]?) -> Void) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        let params: [String: String] = ["userIds": profilesIds]
        
        ApiManagerWithCodable<ProfilesResponseModel>.makeApiCall(APIUrl.UserApis.getUsersDetailedListingByIds,
                                                                 params: params,
                                                                 headers: headers,
                                                                 method: .get) { (response, resultModel) in
            hideLoader()

            if resultModel?.statusCode == 200 {
                self.profileArr.removeAll()
                self.profileArr.append(contentsOf: resultModel?.data ?? [])
                self.gridCollectionView.reloadData()
            } else {
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
}

extension GroupSharedProfileViewModel: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Collection Delegate & DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.gridCell,
                                                              for: indexPath) as? GridCollectionViewCell {
            
            if self.profileArr.count != 0 {
                imageCell.profile = self.profileArr[indexPath.row] }

            
            if self.profileArr[indexPath.row].isSaved == 1{
                imageCell.saveButton.setImage(UIImage(named: "ic_tick_icon"), for: .normal)
            } else {
                imageCell.saveButton.setImage(UIImage(named: "GroupShare_New_Img"), for: .normal)
            }
            
            imageCell.configure(index: indexPath.row)
            imageCell.imageClick = { [weak self] tag in
                guard let strongSelf = self else { return }
                if strongSelf.profileArr[indexPath.row].isSaved == 0{
                    
                    let images = strongSelf.profileArr[indexPath.row].userImages?.filter({($0.file != "" && $0.file != "<null>")})
                    let profileImageFirst = images?.first

                    if strongSelf.profileArr[indexPath.row].isSaved == 0{
                        strongSelf.proceedForSaveProfile(profileId: strongSelf.profileArr[indexPath.row].id ?? "", image: profileImageFirst?.file ?? "", status: 1)
                    } else {
                        strongSelf.proceedForSaveProfile(profileId: strongSelf.profileArr[indexPath.row].id ?? "", image: profileImageFirst?.file ?? "", status: 0)
                    }
                    
                }
            }
            
            return imageCell
        }
        return UICollectionViewCell()
    }
    
    func proceedForSaveProfile(profileId:String, image:String, status:Int) {
        let controller = SaveProfileViewController.getController() as! SaveProfileViewController
        controller.dismissCompletion = { value  in
            self.getAllSharedProfiles { success in }
        }
        controller.show(over: self.hostViewController, isCome: "SavedPreferences" , profileId: profileId, searchPreferenceId: "", status: status, image: image, name: "") { value  in
            print(value)
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let profile = profileArr[indexPath.row]
//        FullViewDetailViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "home", selectedProfile: profile, allProfiles: [profile], selectedIndex: 0) { success in
//        }
        
        PageFullViewVC.show(from: self.hostViewController, forcePresent: false, forceBackToHome: false, isFrom: "", isComeFor: "home", selectedProfile: profile, allProfiles: [profile], selectedIndex: 0) { success in
            
        }
    }
}

extension GroupSharedProfileViewModel: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        //        return CGSize(width: itemSize, height: 220)
        //
        return CGSize.init(width: collectionView.frame.size.width/2 - 20, height: 210)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        // return .init(top: 5, left: 10, bottom: 10, right: 10)
        UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

//extension GroupSharedProfileViewModel: PinterestLayoutDelegate {
//    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
//        if indexPath.row == 0{
//            return 230.0
//        } else {
//            return 230.0
//        }
//    }
//}

struct SharedProfileModel {
    let imageName: String?
    let name: String?
}
