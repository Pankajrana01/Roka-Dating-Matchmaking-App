//
//  SearchDetailsViewModel.swift
//  Roka
//
//  Created by  Developer on 10/11/22.
//

import Foundation
import UIKit
import SDWebImage
class SearchDetailsViewModel: BaseViewModel {
    var isComeFor = ""
    var isCome = ""
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    var layout = LayoutType.list
    var title = ""
    var profileArr: [ProfilesModel] = []
    var current_page = 0
    var completionHandler: ((Bool) -> Void)?
    var isMoreRecordAvailable = false
    var searchPreferenceId = ""
    weak var nodataView: UIView!
    weak var collectionView: UICollectionView! { didSet { configureCollectionView() } }
    var name = ""
    var vc: SearchDetailsViewController?
   
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName:CollectionViewNibIdentifier.listNib, bundle: nil),
                                forCellWithReuseIdentifier: CollectionViewCellIdentifier.listCell)
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = false
            layout.scrollDirection = .vertical
        }
    }
    
    weak var fullCollectionView: UICollectionView! { didSet { configureFullCollectionView() } }
    private func configureFullCollectionView() {
        fullCollectionView.dataSource = self
        fullCollectionView.delegate = self
        
        fullCollectionView.register(UINib(nibName:CollectionViewNibIdentifier.fullNib, bundle: nil),
                                    forCellWithReuseIdentifier: CollectionViewCellIdentifier.fullCell)
        // Scroll one cell at at a time.
        fullCollectionView.isPagingEnabled = true
        if let layout = fullCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = false
            layout.scrollDirection = .horizontal
        }
    }
    
    weak var gridCollectionView: UICollectionView! { didSet { configureGridCollectionView() } }
    private func configureGridCollectionView() {
        gridCollectionView.dataSource = self
        gridCollectionView.delegate = self
        
        gridCollectionView.register(UINib(nibName: CollectionViewNibIdentifier.FilterGridNib, bundle: nil),
                                    forCellWithReuseIdentifier: CollectionViewCellIdentifier.FilterGridCell)
        
//        if let pinterestlayout = gridCollectionView?.collectionViewLayout as? PinterestLayout {
//            pinterestlayout.delegate = self
//        }
        //
        if let layout = gridCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = false
            layout.scrollDirection = .vertical
        }
    }
    
    func proceedForSaveProfile(profileId:String, image:String, status:Int) {
        let controller = SaveProfileViewController.getController() as! SaveProfileViewController
        controller.dismissCompletion = { value  in
            if controller.saved == true {
                if self.title == "Chosen by me" {
                    self.getRokaSuggestedProfiles { url in
                        self.getProfiles(url: url ?? "", page: "\(self.current_page)", id: self.searchPreferenceId)
                    }
                } else {
                    let popup = UIStoryboard(name: "SaveProfile", bundle: nil)
                    if let popupvc = popup.instantiateViewController(withIdentifier: "SuccessfulViewController") as? SuccessfulViewController {
                        popupvc.completionHandlerGoToDismiss = { [weak self] in
                        }
                        popupvc.callbacktopreviousscreen = {
                            self.getRokaSuggestedProfiles { url in //"\(self?.current_page)"
                                self.getProfiles(url: url ?? "", page: "0", id: self.searchPreferenceId)
                            }
                        }
                        popupvc.modalPresentationStyle = .overCurrentContext
                        self.hostViewController.present(popupvc, animated: true)
                    }
                }
            } else {
                self.getRokaSuggestedProfiles { url in
                    self.getProfiles(url: url ?? "", page: "\(self.current_page)", id: self.searchPreferenceId)
                }
            }
        }
        controller.show(over: self.hostViewController, isCome: "SavedPreferences" , profileId: profileId, searchPreferenceId: searchPreferenceId, status: status, image: image, name: name) { value  in
            print(value)
        }
    }
}

extension SearchDetailsViewModel {
    func proceedToDetailScreen(profile: ProfilesModel, index:Int) {
        PageFullViewVC.show(from: self.hostViewController, forcePresent: false, forceBackToHome: false, isFrom: "", isComeFor: "SavedPreferences", selectedProfile: profile, allProfiles: profileArr, selectedIndex: index) { success in

        }
    }
    
    func getRokaSuggestedProfiles(_ result:@escaping(String?) -> Void) {
        let url = self.title == "Chosen by me" ? APIUrl.UserSearchPreferences.chosenByMe : self.title == "Roka Suggested" ? APIUrl.UserSearchPreferences.allProfilesBySearchPreferences : APIUrl.UserSearchPreferences.chosenByMe
        result(url)
    }
    
    func getProfiles(url:String, page:String, id:String) {
        DispatchQueue.main.async {
            showLoader()
        }
        var param = [String:Any]()
        
        if self.title == "Chosen by me" {
            param = ["searchPreferenceId": id] as [String: Any]
        } else {
            if self.isCome == "all" {
                param = ["limit": 20, "skip": page , "searchPreferenceId": id, "listType": 0] as [String: Any]
            } else {
                param = ["limit": 20, "skip": page , "searchPreferenceId": id, "listType": 1] as [String: Any]
            }
        }
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        
        ApiManagerWithCodable<ProfilesResponseModel>.makeApiCall(url, params: param,
                                                                 headers: headers,
                                                                 method: .get) { (response, resultModel) in
            hideLoader()
            if KAPPSTORAGE.searchTab == true {
            } else {
                KAPPSTORAGE.searchTab = false
                if let result = resultModel, result.statusCode == 200, result.data.count == 0 {
                    if page == "0"{
                        self.isMoreRecordAvailable = false
                        self.profileArr.removeAll()
                    }
                    if self.layout == .grid {
                        self.nodataView.isHidden = false
                        self.gridCollectionView.isHidden = true
                    } else if self.layout == .list {
                        self.nodataView.isHidden = false
                        self.collectionView.isHidden = true
                    } else {
                        self.nodataView.isHidden = false
                        self.fullCollectionView.isHidden = true
                    }
                    
                    var profileDataDict = [String: Int]()
                    profileDataDict["profileCount"] = 0
                    NotificationCenter.default.post(name: .refreshProfileCount, object: nil, userInfo: profileDataDict)
                    
                    DispatchQueue.main.async {
                        self.gridCollectionView.reloadData()
                        self.collectionView.reloadData()
                        self.fullCollectionView.reloadData()
                    }
                    
                } else if resultModel?.statusCode == 200 {
                    if page == "0"{
                        self.isMoreRecordAvailable = false
                        self.profileArr.removeAll()
                    }
                    self.nodataView.isHidden = true
                    
                    if resultModel?.data.count == 20 {
                        self.isMoreRecordAvailable = true
                    } else {
                        self.isMoreRecordAvailable = false
                    }
                    self.profileArr.append(contentsOf: resultModel?.data ?? [])
                
                    var profileDataDict = [String: Int]()
                    profileDataDict["profileCount"] = self.profileArr.count
                    NotificationCenter.default.post(name: .refreshProfileCount, object: nil, userInfo: profileDataDict)
                    
                    DispatchQueue.main.async {
                        if self.gridCollectionView != nil { self.gridCollectionView.reloadData()
                            
                        }
                        if self.collectionView != nil { self.collectionView.reloadData()
                            
                        }
                        if self.fullCollectionView != nil { self.fullCollectionView.reloadData()
                            
                        }
                        if self.layout == .grid {
                            self.gridCollectionView.isHidden = false
                            self.collectionView.isHidden = true
                            self.fullCollectionView.isHidden = true
                        } else if self.layout == .list {
                            self.collectionView.isHidden = false
                            self.fullCollectionView.isHidden = true
                            self.gridCollectionView.isHidden = true
                        } else {
                            self.fullCollectionView.isHidden = false
                            self.gridCollectionView.isHidden = true
                            self.collectionView.isHidden = true
                        }
                    }
                    
                } else {
                    showMessage(with: response?["message"] as? String ?? "")
    //                self.collectionView.isHidden = true
                }
            }
        }
    }
}
extension SearchDetailsViewModel: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Collection Delegate & DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == gridCollectionView {
            if let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.FilterGridCell,
                                                                  for: indexPath) as? FilterGridCollectionViewCell {
                
                if self.profileArr.count != 0 { imageCell.profile = self.profileArr[indexPath.row] }
                
                if self.title == "Chosen by me" {
                    imageCell.saveButton.setImage(UIImage(named: "im_saved_sea"), for: .normal)
                } else {
                    imageCell.saveButton.setImage(UIImage(named: "Filter_Grid_Save_Img_New"), for: .normal)
                }
                
                imageCell.configure(index: indexPath.row)
                
                imageCell.imageClick = { [weak self] tag in
                    guard let strongSelf = self else { return }
                    let images = strongSelf.profileArr[indexPath.row].userImages?.filter({($0.file != "" && $0.file != "<null>" && $0.isDp == 1)})
                    let profileImageFirst = images?.first
                    
                  //  if strongSelf.profileArr[indexPath.row].isSaved == 0 {
                    if strongSelf.title != "Chosen by me" {
                        self?.name = imageCell.nameLable.text ?? ""
                        strongSelf.proceedForSaveProfile(profileId: strongSelf.profileArr[indexPath.row].id ?? "", image: profileImageFirst?.file ?? "", status: 1)
                    } else {
                        self?.name = imageCell.nameLable.text ?? ""
                        strongSelf.proceedForSaveProfile(profileId: strongSelf.profileArr[indexPath.row].id ?? "", image: profileImageFirst?.file ?? "", status: 0)
                    }
                    
                }
                
                return imageCell
            }
        } else if collectionView == fullCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.fullCell, for: indexPath) as? FullViewCollectionViewCell {
                cell.configure(index: indexPath.row)
                
                cell.imageClick = { [weak self] tag in
                    guard let strongSelf = self else { return }
                    let images = strongSelf.profileArr[indexPath.row].userImages?.filter({($0.file != "" && $0.file != "<null>" && $0.isDp == 1)})
                    let profileImageFirst = images?.first

                    //if strongSelf.profileArr[indexPath.row].isSaved == 0{
                    if strongSelf.title != "Chosen by me" {
                        self?.name = cell.labelName.text ?? ""
                        strongSelf.proceedForSaveProfile(profileId: strongSelf.profileArr[indexPath.row].id ?? "", image: profileImageFirst?.file ?? "", status: 1)
                    } else {
                        self?.name = cell.labelName.text ?? ""
                        strongSelf.proceedForSaveProfile(profileId: strongSelf.profileArr[indexPath.row].id ?? "", image: profileImageFirst?.file ?? "", status: 0)
                    }
                }
                if self.profileArr.count != 0 { cell.profile = self.profileArr[indexPath.row] }
                
                if self.title == "Chosen by me" {
                    cell.buttonImageSave.setImage(UIImage(named: "im_saved_sea"), for: .normal)
                } else {
                    cell.buttonImageSave.setImage(UIImage(named: "Ic_save 1"), for: .normal)
                }
                
//                cell.imageHeightConstraints.constant = collectionView.frame.size.height - 150
                
                return cell
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.listCell, for: indexPath) as? SearchCollectionViewCell {
                cell.configure(index: indexPath.row)
                cell.imageClick = { [weak self] tag in
                    guard let strongSelf = self else { return }
                    let images = strongSelf.profileArr[indexPath.row].userImages?.filter({($0.file != "" && $0.file != "<null>" && $0.isDp == 1)})
                    let profileImageFirst = images?.first

                   // if strongSelf.profileArr[indexPath.row].isSaved == 0{
                    if strongSelf.title != "Chosen by me" {
                        self?.name = cell.labelName.text ?? ""
                        strongSelf.proceedForSaveProfile(profileId: strongSelf.profileArr[indexPath.row].id ?? "", image: profileImageFirst?.file ?? "", status: 1)
                    } else {
                        self?.name = cell.labelName.text ?? ""
                        strongSelf.proceedForSaveProfile(profileId: strongSelf.profileArr[indexPath.row].id ?? "", image: profileImageFirst?.file ?? "", status: 0)
                    }
                }
                if self.profileArr.count != 0 { cell.profile = self.profileArr[indexPath.row] }
                
                if self.title == "Chosen by me"{
                    cell.buttonImageSave.setImage(UIImage(named: "im_saved_sea"), for: .normal)
                } else {
                    cell.buttonImageSave.setImage(UIImage(named: "Ic_save 1"), for: .normal)
                }
                cell.overLayImg.isHidden = false
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //if collectionView == gridCollectionView {
            if indexPath.row == self.profileArr.count - 1 &&                     self.isMoreRecordAvailable {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.getRokaSuggestedProfiles { url in
                        self.current_page = self.profileArr.count
                        self.getProfiles(url: url ?? "", page: "\(self.current_page)", id: self.searchPreferenceId)
                    }
                }
            }
        //}
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        proceedToDetailScreen(profile: self.profileArr[indexPath.row], index: indexPath.row)
    }
}

extension SearchDetailsViewModel: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if layout == .grid{
//            var height = gridCollectionView.frame.width / 2 - 20 + 50
//            return CGSize(width: gridCollectionView.frame.width / 2 - 20, height: height)
            let screenRect = UIScreen.main.bounds
            let screenHeight = screenRect.size.height
            if screenHeight >= 812 {
                return CGSize.init(width: self.hostViewController.view.frame.size.width/2 - 20, height: 210)
            } else {
                return CGSize.init(width: self.hostViewController.view.frame.size.width/2 - 20, height: 210)
            }
            
            
        } else if layout == .list{
            return CGSize(width: collectionView.frame.size.width - 20, height: 320)
        } else {
            return CGSize(width: collectionView.frame.size.width - 20, height: collectionView.frame.size.height - 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        }
}

extension SearchDetailsViewModel: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 230.0
        } else {
            return 230.0
        }
    }
}
