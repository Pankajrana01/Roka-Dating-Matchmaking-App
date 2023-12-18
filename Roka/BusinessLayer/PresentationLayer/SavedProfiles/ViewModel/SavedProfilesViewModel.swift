//
//  SavedProfilesViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 29/10/22.
//

import Foundation
import UIKit

class SavedProfilesViewModel: BaseViewModel {
    var isComeFor = ""
    var completionHandler: ((Bool) -> Void)?
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    var title = "For you"
    var profileArr: [ProfilesModel] = []
    var current_page = 0
    var isMoreRecordAvailable = false
    weak var nodataView: UIView!
    weak var noDataSubTitleLbl: UILabel!


    weak var collectionView: UICollectionView! { didSet { configureCollectionView() } }

    private func configureCollectionView() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = false
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: CollectionViewNibIdentifier.homeNib, bundle: nil),
                                forCellWithReuseIdentifier: CollectionViewCellIdentifier.homecell)
    }
    
    
    func getSavedProfiles(page:String) {
        var param = [String:Any]()
        
        if self.title == "For you"{
            param = ["limit": 10, "skip": page, "type":0] as [String: Any]
        } else {
            param = ["limit": 10, "skip": page, "type":1] as [String: Any]
        }
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        
        showLoader()

        ApiManagerWithCodable<ProfilesResponseModel>.makeApiCall(APIUrl.UserApis.savedProfiles,
                                                                 params: param,
                                                                 headers: headers,
                                                                 method: .get) { (response, resultModel) in
            hideLoader()
            if let result = resultModel, result.statusCode == 200, result.data.count == 0 {
                if page == "0"{
                    self.isMoreRecordAvailable = false
                    self.profileArr.removeAll()
                }
                self.nodataView.isHidden = false
                self.collectionView.isHidden = true
                if self.title == "For you"{
                    self.noDataSubTitleLbl.text = "See profiles you saved for yourself here."
                }else{
                    self.noDataSubTitleLbl.text = "See profiles you saved for others here."
                }
                
                
            } else if resultModel?.statusCode == 200 {
                if page == "0"{
                    self.isMoreRecordAvailable = false
                    self.profileArr.removeAll()
                }
                
                self.nodataView.isHidden = true
                
                if resultModel?.data.count == 10 {
                    self.isMoreRecordAvailable = true
                } else {
                    self.isMoreRecordAvailable = false
                }
                self.profileArr.append(contentsOf: resultModel?.data ?? [])
            
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            }
            else {
                showMessage(with: response?["message"] as? String ?? "")
                self.collectionView.isHidden = true
            }
        }
    }
    
    func proceedToDetailScreen(profile: ProfilesModel, index:Int) {
        if self.title == "For you"{
//            FullViewDetailViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "SavedPreferences", selectedProfile: profile, allProfiles: profileArr, selectedIndex: index) { success in
//            }
            
            
            
            PageFullViewVC.show(from: self.hostViewController, forcePresent: false, forceBackToHome: false, isFrom: "", isComeFor: "SavedPreferences", selectedProfile: profile, allProfiles: profileArr, selectedIndex: index) { success in
                
            }

        }else {
//            FullViewDetailViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "MatchMakingProfile", selectedProfile: profile, allProfiles: profileArr, selectedIndex: index) { success in
//            }
            
            
            PageFullViewVC.show(from: self.hostViewController, forcePresent: false, forceBackToHome: false, isFrom: "", isComeFor: "MatchMakingProfile", selectedProfile: profile, allProfiles: self.profileArr, selectedIndex: index) { success in
                
            }

        }
    }
    
    
    func proceedForSaveProfile(profileId:String, image:String, status:Int) {
        let controller = SaveProfileViewController.getController() as! SaveProfileViewController
        controller.dismissCompletion = { value  in
            if self.title == "For you" {
                self.current_page = 0
                self.getSavedProfiles(page: "\(self.current_page)")
            } else {
                self.current_page = 0
                self.getSavedProfiles(page: "\(self.current_page)")
            }
        }
        if self.title == "For you" {
            GlobalVariables.shared.isUnsavedMatchingProfile = false
        } else {
            GlobalVariables.shared.isUnsavedMatchingProfile = true
        }
        
        controller.show(over: self.hostViewController, isCome: "SavedPreferences" , profileId: profileId, searchPreferenceId: "", status: status, image: image, name: "") { value  in
            print(value)
        }
       
    }
}

extension SavedProfilesViewModel: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - Collection Delegate & DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return profileArr.count
    }
    
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.homecell, for: indexPath) as! HomeCollectionViewCell
        cell.favButton.isHidden = true
        cell.savedProfileImage.isHidden = false
        cell.profile = self.profileArr[indexPath.row]
        cell.saveButton.tag = indexPath.row
        cell.saveButton.isHidden = false
        
        cell.savedProfileImage.layer.shadowColor = UIColor.lightGray.cgColor
        cell.savedProfileImage.layer.shadowOpacity = 0.5
        cell.savedProfileImage.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        cell.savedProfileImage.layer.shadowRadius = 2
        
        cell.savedProfileImage.layer.shadowPath = UIBezierPath(rect: cell.savedProfileImage.bounds).cgPath
        cell.imageClick = { [weak self] tag in
            guard let strongSelf = self else { return }
            let images = strongSelf.profileArr[indexPath.row].userImages?.filter({($0.file != "" && $0.file != "<null>" && $0.isDp == 1)})
            let profileImageFirst = images?.first
            strongSelf.proceedForSaveProfile(profileId: strongSelf.profileArr[indexPath.row].id ?? "", image: profileImageFirst?.file ?? "", status: 0)
        }
        
        return cell
    }

   @objc func favButtonAction(_ sender: UIButton){
//       var params = [String:Any]()
//       params[WebConstants.profileId] = self.profileArr[sender.tag].id
//       params[WebConstants.isLiked] = self.profileArr[sender.tag].isLiked == 1 ? 0 : 1
//       processForLikeProfileData(params: params)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.hostViewController.view.frame.size.width/2 - 30, height: 210)
    }
  
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.profileArr.count - 1 &&                     self.isMoreRecordAvailable {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.current_page = self.profileArr.count
                self.getSavedProfiles(page: "\(self.current_page)")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.proceedToDetailScreen(profile: self.profileArr[indexPath.row], index: indexPath.row)
    }
}
