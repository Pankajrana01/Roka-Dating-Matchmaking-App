//
//  MatahMakingPlaceholderViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 21/11/22.
//

import Foundation
import UIKit
import AVKit
import PhotosUI

class MatchMakingPlaceholderViewModel: BaseViewModel {
    var isComeFor = ""
    var completionHandler: ((Bool) -> Void)?
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    var selectedProfile: ProfilesModel?
    var profileUser = UserModel.shared.user
    var profileResponseData = [String:Any]()
    var selectedIndex = 0
    var selectedColor = PlaceholderBGColor[0]
    var basicDetailsDictionary = [String:Any]()
   
    weak var inappropriateLable: UILabel!
    weak var backImage: UIImageView!
    weak var placeholderImage: UIImageView!
    weak var addImage: UIButton!
    
    let imagePicker = UIImagePickerController()
    var picker: PHPickerViewController!
    var configuration = PHPickerConfiguration()
    var galleryList = [GalleryModel]()
    var dispatchGroup = DispatchGroup()
    var uploadImageStringArray = [String]()
    var uploadImagesDic = [NSDictionary]()
    
    func configurePHPickerView() {
        configuration.selectionLimit = 1
        configuration.filter = .images
    }
    
    func initializeInputsData() {
        configurePHPickerView()
        picker = PHPickerViewController(configuration: self.configuration)
        picker.delegate = self
        self.inappropriateLable.isHidden = true
        self.backImage.alpha = 1.0
        self.galleryList.removeAll()
        self.galleryList.append(contentsOf: GlobalVariables.shared.selectedGalleryImages)
        
        if GlobalVariables.shared.selectedGalleryImages.count != 0 {
            //self.placeholderImage.isHidden = true
            self.backImage.image = self.galleryList[0].image
            self.addImage.setImage(UIImage(named: "ic_edit-image"), for: .normal)
            self.selectedIndex = -1
            self.selectedColor = ""
            self.collectionView.reloadData()
        } else {
            if self.isComeFor == "EditMatchingProfilePlaceHolder"  {
            }
            else if self.isComeFor != "EditMatchingProfile"  {
                //self.placeholderImage.isHidden = false
                self.backImage.image = UIImage(named: "ic_upload_image")
                self.addImage.setImage(UIImage(named: ""), for: .normal)
            }
        }
    }
    
    weak var collectionView: UICollectionView! { didSet { configureCollectionView() } }

    private func configureCollectionView() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = false
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: CollectionViewNibIdentifier.placeholderNib, bundle: nil),
                                forCellWithReuseIdentifier: CollectionViewCellIdentifier.placeholderCell)
        configurePHPickerView()
        picker = PHPickerViewController(configuration: self.configuration)
        picker.delegate = self
    }
    
    func openUploadImagePicker() {
        self.configurePHPickerView()
        self.allowCameraPermission()
        self.picker = PHPickerViewController(configuration: self.configuration)
        self.picker.delegate = self
    }
    
    func allowCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            print("Denied, request permission from settings")
            presentCameraSettings()
        case .restricted:
            print("Restricted, device owner must approve")
        case .authorized:
            print("Authorized, proceed")
            showAlertForCameraGallery()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    DispatchQueue.main.async {
                        self.showAlertForCameraGallery()
                    }
                    print("Permission granted, proceed")
                } else {
                    print("Permission denied")
                }
            }
        @unknown default:
            break
        }
    }

    func presentCameraSettings() {
        let alertController = UIAlertController(title: "Error",
                                      message: "Camera access is denied",
                                      preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        alertController.addAction(UIAlertAction(title: "Settings", style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                    // Handle
                })
            }
        })
        self.hostViewController.present(alertController, animated: true)
    }
    
    func showAlertForCameraGallery() {
        let alert = UIAlertController(title: "", message: "Do you want to add photo from camera or gallery?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.choosePhoto(isCamera: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { action in
            //self.choosePhoto(isCamera: false)
            self.hostViewController.present(self.picker, animated: true)
        }))
        
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.hostViewController.view
            popoverController.sourceRect = CGRect(x: self.hostViewController.view.bounds.midX, y: self.hostViewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.hostViewController.present(alert, animated: true, completion: nil)
    }
    
    func proceedForCreatedProfileCreatedScreen() {
        MatchMakingProfileCreatedController.show(from: self.hostViewController, forcePresent: false, iscomeFrom: "", profileUser: self.profileUser) { success in
        }
    }
    
    func proceedForCreatePreviewScreen() {
        GlobalVariables.shared.cameraCancel = ""
        GalleryPreviewViewController.show(from: self.hostViewController, forcePresent: false, selectedImages: self.galleryList, selectedIndex: 0) { success in
            
        }
        
    }
}
// MARK: - Collection Delegate & DataSource
extension MatchMakingPlaceholderViewModel: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PlaceholderBGColor.count
    }
    
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.placeholderCell, for: indexPath) as! PlaceholderCollectionViewCell
        cell.initColorWithCell(color: PlaceholderBGColor[indexPath.row])
       
        if self.isComeFor == "EditMatchingProfile" {
            cell.NameLable.text = (self.selectedProfile?.firstName ?? "").prefix(1).capitalized
        } else if self.isComeFor == "EditMatchingProfilePlaceHolder" {
            cell.NameLable.text = (self.profileResponseData["firstName"] as? String ?? "").prefix(1).capitalized
        } else {
            cell.NameLable.text = (self.basicDetailsDictionary[WebConstants.firstName] as? String ?? "").prefix(1).capitalized
        }
        if selectedIndex == indexPath.row {
            cell.borderView.layer.borderWidth = 1
            cell.borderView.layer.borderColor = UIColor(hex: PlaceholderBGColor[indexPath.row]).cgColor
        } else {
            cell.borderView.layer.borderWidth = 0
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 90, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.selectedColor = PlaceholderBGColor[indexPath.row]
        self.galleryList.removeAll()
        GlobalVariables.shared.selectedGalleryImages.removeAll()
       // self.placeholderImage.isHidden = false
        self.backImage.image = UIImage(named: "ic_upload_image")
        self.addImage.setImage(UIImage(named: ""), for: .normal)
        self.initializeInputsData()
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       
    }
}


extension MatchMakingPlaceholderViewModel: PHPickerViewControllerDelegate {
    
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
       
        picker.dismiss(animated: true, completion: nil)

        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.galleryList.removeAll()
            self.galleryList.append(GalleryModel(file: "", id: "", isDp: 0, isInappropriate: 0, isTitleInappropriate: 0, title: "", type: "", image: image))
            self.proceedForCreatePreviewScreen()
           // self.placeholderImage.isHidden = true
        } else {
            return
        }
    }
    
    override func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if results.count != 0{
            let imageItems = results
                .map { $0.itemProvider }
                .filter { $0.canLoadObject(ofClass: UIImage.self) } // filter for possible UIImages
            
            let dispatchGroup = DispatchGroup()
            var images = [UIImage]()
            var titles = [String]()
            
            for imageItem in imageItems {
                dispatchGroup.enter() // signal IN
                
                imageItem.loadObject(ofClass: UIImage.self) { image, error in
                    if let image = image as? UIImage {
                        images.append(image)
                        titles.append(" ")
                    }
                    print(error as Any)
                    dispatchGroup.leave() // signal OUT
                }
            }
            // This is called at the end; after all signals are matched (IN/OUT)
            dispatchGroup.notify(queue: .main) {
                print(images)
                self.galleryList.removeAll()
                for i in 0..<images.count{
                    //self.placeholderImage.isHidden = true
                    self.galleryList.append(GalleryModel(file: "", id: "", isDp: 0, isInappropriate: 0, isTitleInappropriate: 0, title: "", type: "", image: images[i]))
                }
                self.proceedForCreatePreviewScreen()
                
            }
        }
    }
    
//    private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
//        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
//    }
//    // Helper function inserted by Swift 4.2 migrator.
//    private func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
//        return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
//    }
//    // Helper function inserted by Swift 4.2 migrator.
//    private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
//        return input.rawValue
//    }

    
}

extension MatchMakingPlaceholderViewModel {

    func uploadImages() {
        if self.galleryList.count != 0{
            if self.galleryList[0].image == UIImage(named: "ic_upload_image"){
                self.galleryList.remove(at: 0)
            }
            
            DispatchQueue.main.async {
                showProgressLoader(text: "Processing...")
            }
            
            for i in 0..<self.galleryList.count{
                if self.galleryList[i].file == "" {
                    dispatchGroup.enter()
                    var imageFileName = ""
                    let folderName = KAPPSTORAGE.userPicDirectoryName
                    
                    let imageName: String = UIFunction.getRandomImageName()
                    let fileManager = FileManager.default
                    do {
                        let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                        let fileURL = documentDirectory.appendingPathComponent(imageName)
                        
                        if let imageData = self.galleryList[i].image?.jpegData(compressionQuality: 0.0) {
                            try imageData.write(to: fileURL)
                        }
                        
                        let userImage = NSString(format: "%@", imageName as CVarArg) as String
                        self.uploadImageStringArray.append(userImage)
                    } catch {}
                    
                    let uploadUrlParams = ["directory": folderName, "fileName": self.uploadImageStringArray[0], "contentType": "image"]
                    
                    
                    self.uploadURLsApi(uploadUrlParams) { (model) in
                        imageFileName = model?.data?.fileName ?? ""
                        self.uploadImage(model?.data?.uploadURL ?? "", image: self.galleryList[i].image!) { _ in
                            let dict = NSMutableDictionary()
                            dict["file"] = imageFileName
                            dict["type"] = "jpg"
                            dict["title"] = self.galleryList[i].title
                            dict["sequence"] = i+1
                            //dict["isDp"] = self.galleryList[i].isDp
                            self.uploadImagesDic.append(dict)
                            self.dispatchGroup.leave()
                        }
                    }
                    
                } else {
                    dispatchGroup.enter()
                    let dict = NSMutableDictionary()
                    dict["file"] = self.galleryList[i].file
                    dict["type"] = "jpg"
                    dict["title"] = self.galleryList[i].title
                    dict["sequence"] = i+1
                    // dict["isDp"] = self.galleryList[i].isDp
                    self.uploadImagesDic.append(dict)
                    self.dispatchGroup.leave()
                }
                
            }
            
            dispatchGroup.notify(queue: .main) {
                print(self.uploadImagesDic)
                if self.isComeFor == "EditMatchingProfile" {
                    self.processForUpdateFriendProfileGallery(images: self.uploadImagesDic, id: self.selectedProfile?.id ?? "")
                } else if self.isComeFor == "EditMatchingProfilePlaceHolder" {
                    self.processForUpdateFriendProfileGallery(images: self.uploadImagesDic, id: self.profileResponseData["id"] as? String ?? "")
                } else {
                    self.updateGalleryApiCall(images: self.uploadImagesDic)
                }
            }
        } else {
            DispatchQueue.main.async {
                showProgressLoader(text: "Processing...")
            }
            if self.isComeFor == "EditMatchingProfile" {
                self.processForUpdateFriendProfileGallery(images: [], id: self.selectedProfile?.id ?? "")
            } else if self.isComeFor == "EditMatchingProfilePlaceHolder" {
                self.processForUpdateFriendProfileGallery(images: [], id: self.profileResponseData["id"] as? String ?? "")
            } else {
                self.updateGalleryApiCall(images: [])
               
            }
        }
    }
    
    func updateGalleryApiCall(images:[NSDictionary]){
        processForCreateFriendProfile(images: images)
    }
    
    // MARK: - API Call...
    func processForCreateFriendProfile(images:[NSDictionary]){
        self.basicDetailsDictionary["registrationStep"] = 2
        self.basicDetailsDictionary["notificationEnabled"] = "0"
        self.basicDetailsDictionary["userType"] = 2
        self.basicDetailsDictionary["email"] = ""
        self.basicDetailsDictionary["placeHolderColour"] = self.selectedColor
        self.basicDetailsDictionary["preferredGendersPriority"] = 0
        self.basicDetailsDictionary["preferredDistance"] = 0
        self.basicDetailsDictionary["images"] = images
    
        print(self.basicDetailsDictionary)
        processForCreateFriendProfileApiData(params: self.basicDetailsDictionary)
    }
    
    // MARK: - API Call...
    func processForCreateFriendProfileApiData(params: [String: Any]) {
       // showLoader()
        
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.UserMatchMaking.createFriendsProfile,
                               params: params,
                               headers: headers,
                               method: .put) { response, _ in
            self.uploadImagesDic.removeAll()
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [String: Any]
                                    self.profileUser.updateWith(responseData)
                                    
                                    var isInappropriate = 0
                                    if self.user.userImages.filter({$0.isInappropriate == 1}).count > 0 || self.user.userImages.filter({$0.isTitleInappropriate == 1}).count > 0 {
                                        isInappropriate = 1
                                    }
                                    
                                    self.uploadImagesDic.removeAll()
                                    GlobalVariables.shared.selectedGalleryImages.removeAll()
                                    self.galleryList.removeAll()

                                    if isInappropriate == 0 {
                                        showSuccessLoader()
                                        self.inappropriateLable.isHidden = true
                                        self.proceedForCreatedProfileCreatedScreen()
                                    } else {
                                        hideLoader()
                                        self.inappropriateLable.isHidden = false
                                      //  self.placeholderImage.isHidden = true
                                        self.backImage.alpha = 0.5
                                    }
                                }
                hideLoader()
        }
    }
    
    
    // MARK: - API Call...
    func processForUpdateFriendProfileGallery(images:[NSDictionary], id :String){
        if id != "" {
            var params = [String:Any]()
            params["id"] = id
            params["placeHolderColour"] = self.selectedColor
            params["images"] = images
            
            print(params)
            processForUpdateFriendProfileApiData(params: params)
        }
    }
    
    // MARK: - API Call...
    func processForUpdateFriendProfileApiData(params: [String: Any]) {
       // showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.UserMatchMaking.updateMatchMakingGallery,
                               params: params,
                               headers: headers,
                               method: .put) { response, _ in
            self.uploadImagesDic.removeAll()
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [String: Any]
                                    self.profileUser.updateWith(responseData)
                                    
                                    var isInappropriate = 0
                                    if self.user.userImages.filter({$0.isInappropriate == 1}).count > 0 || self.user.userImages.filter({$0.isTitleInappropriate == 1}).count > 0 {
                                        isInappropriate = 1
                                    }
                                    
                                    self.uploadImagesDic.removeAll()
                                    GlobalVariables.shared.selectedGalleryImages.removeAll()
                                    self.galleryList.removeAll()

                                    if isInappropriate == 0 {
                                        showSuccessLoader()
                                        self.inappropriateLable.isHidden = true
                                        self.popBackToController()
                                    } else {
                                        hideLoader()
                                        self.inappropriateLable.isHidden = false
                                        self.backImage.alpha = 0.5

                                    }
                                }
                hideLoader()
        }
    }
    
    func popBackToController() {
        for controller in self.hostViewController.navigationController!.viewControllers as Array {
            if controller.isKind(of: MatchMakingViewController.self) {
                UserModel.shared.refreshUser()
                user.userImages.removeAll()
                self.hostViewController.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    // MARK: -  Upload Url
    func uploadURLsApi(_ params: [String:Any],_ result:@escaping(UploadUrlResponseModel?) -> Void) {
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManagerWithCodable<UploadUrlResponseModel>.makeApiCall(APIUrl.BasicApis.uploadImage,
                                                                  params: params,
                                                                  headers: headers,
                                                                  method: .post) { (response, model) in
//            DispatchQueue.main.async {
//                hideLoader()
//            }
            if model?.statusCode == 200 {
                result(model)
            } else {
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    func uploadImage(_ imgURL: String, image: UIImage, _ result:@escaping(String?) -> Void) {
//        DispatchQueue.main.async {
//            showLoader()
//        }
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {
            return
        }
        let url = URL(string: imgURL)
        var request: NSMutableURLRequest? = nil
        if let url = url {
            request = NSMutableURLRequest(url: url)
        }
        request?.httpBody = imageData
      //  request?.setValue("public-read", forHTTPHeaderField: "x-amz-acl")
        request?.setValue("image/png", forHTTPHeaderField: "Content-Type")
        request?.httpMethod = "PUT"
        let session = URLSession.shared
        let task1 = session.uploadTask(with: request! as URLRequest, from: imageData) { _ , response, error in
//            DispatchQueue.main.async {
//                hideLoader()
//            }
            if error == nil {
                result("success")
            }
        }
        task1.resume()
    }
}
