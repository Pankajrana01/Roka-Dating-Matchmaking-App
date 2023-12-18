//
//  SaveProfileViewModel.swift
//  Roka
//
//  Created by  Developer on 11/11/22.
//

import Foundation
import UIKit
class SaveProfileCollectionViewCell : UICollectionViewCell {
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var bgColorView: UIView!
    @IBOutlet weak var bgColorLable: UILabel!
}

class SaveProfileViewModel: BaseViewModel {
    var isCome = ""
    var profileId = ""
    var searchPreferenceId = ""
    var status = 0
    var image = ""
    var name = ""
    var completionHandler: ((String) -> Void)?
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    var collectionView: UICollectionView! { didSet { configureCollectionView() } }
    var selectedIndex = 0
    var selectedShareProfileId = ""
    
    private func configureCollectionView() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = false
        }
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func proceedForAPiCall(_ result:@escaping(String?) -> Void) {
        if GlobalVariables.shared.selectedProfileMode == "MatchMaking" {
            if self.selectedIndex == 0 {
                self.selectedShareProfileId = self.user.id
            }
            var params = [String:Any]()
            params[WebConstants.profileId] = profileId
            params[WebConstants.status] = status
            params[WebConstants.id] = self.selectedShareProfileId
            processForMatchMakingSavedProfileData(params: params) { status in
                result("success")
            }
        } else if GlobalVariables.shared.isUnsavedMatchingProfile == true {
            var params = [String:Any]()
            params[WebConstants.profileId] = profileId
            params[WebConstants.status] = status
            params[WebConstants.id] = self.selectedShareProfileId
            processForMatchMakingSavedProfileData(params: params) { status in
                result("success")
            }
        } else {
            let param = ["searchPreferenceId": searchPreferenceId,
                         "status":status,
                         "profileId":profileId] as? [String:Any] ?? [:]
            
            processForSavedProfileData(parms: param) { status in
                result("success")
            }
        }
    }
   
    func processForMatchMakingSavedProfileData(params: [String: Any], _ result:@escaping(String?) -> Void) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.UserMatchMaking.saveMatchMakingProfile,
                               params: params,
                               headers: headers,
                               method: .post) { response, _ in
            if !self.hasErrorIn(response) {
                _ = response![APIConstants.data] as! [String: Any]
                showSuccessMessage(with: StringConstants.savedProfileSuccess)
                result("success")
            }
            result("success")
            hideLoader()
        }
    }
    
    // MARK: - API Call...
    func processForSavedProfileData(parms:[String:Any], _ result:@escaping(String?) -> Void) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.UserApis.saveProfile,
                               params: parms,
                               headers: headers,
                               method: .post) { response, _ in
                                if !self.hasErrorIn(response) {
                                    if let _ = response![APIConstants.data] as? [String: Any]{
//                                        showSuccessMessage(with: StringConstants.savedProfileSuccess)
                                        
                                        result("success")
                                    }
                                }
                hideLoader()
        }
    }
    
}

extension SaveProfileViewModel :UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GlobalVariables.shared.matchedProfileArr.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SaveProfileCollectionViewCell", for: indexPath) as? SaveProfileCollectionViewCell {
            
            if indexPath.row == 0 {
                cell.userName.text = "You"
                cell.bgColorView.isHidden = true
                if self.user.userImages.count != 0 {
                    for i in 0..<self.user.userImages.count {
                        if self.user.userImages[i].isDp == 1 {
                            let userImage = self.user.userImages[i].file
                            if userImage != "" {
                                let imageUrl: String = KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + userImage
                                
                                cell.userImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "Avatar"), options: .refreshCached)
                                
                            } else {
                                cell.userImage.image = #imageLiteral(resourceName: "Avatar")
                            }
                        }
                    }
                }
            } else {
                let model = GlobalVariables.shared.matchedProfileArr[indexPath.row-1]
                cell.userName.text = (model.firstName ?? "")
                
                let images = model.userImages?.filter({($0.file != "" && $0.file != "<null>")})
                if images?.count ?? 0 > 0 {
                    let profileImageFirst = images?.first
                    cell.userImage.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + (profileImageFirst?.file ?? ""))), placeholderImage: #imageLiteral(resourceName: "Avatar"), completed: nil)
                    cell.bgColorView.isHidden = true
                } else {
                    cell.bgColorView.isHidden = false
                    cell.bgColorView.backgroundColor = UIColor(hex: model.placeHolderColour ?? "")
                    cell.bgColorLable.text = (model.firstName ?? "").prefix(1).capitalized
                }
            }
            
            if self.selectedIndex == indexPath.row {
                cell.circleView.isHidden = false
            } else {
                cell.circleView.isHidden = true
            }
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 80, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        if indexPath.row == 0 {
            self.selectedShareProfileId = self.user.id
        } else {
            let model = GlobalVariables.shared.matchedProfileArr[indexPath.row-1]
            self.selectedShareProfileId = model.id ?? ""
        }
        self.collectionView.reloadData()
    }
}
