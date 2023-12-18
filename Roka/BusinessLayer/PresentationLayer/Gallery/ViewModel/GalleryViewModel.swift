//
//  GalleryViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 01/11/22.
//

import Foundation
import UIKit
import AVKit
import PhotosUI

class GalleryViewModel: BaseViewModel {
    var isComeFor = ""
    var completionHandler: ((Bool) -> Void)?
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    
    var galleryList:[GalleryModel] = [GalleryModel(file: "", id: "", isDp: 0, isInappropriate: 0, isTitleInappropriate: 0, title: "", type: "", image: UIImage(named: "Ellipse")!)]
    
    var duplicateGalleryList = [GalleryModel]()
    
    var uploadImageStringArray = [String]()
    var uploadImagesDic = [NSDictionary]()
    var dispatchGroup = DispatchGroup()
    var configuration = PHPickerConfiguration()
    var picker : PHPickerViewController!

    func configurePHPickerView() {
        if self.galleryList.count != 0{
            if self.galleryList[0].image == UIImage(named: "Ellipse"){
                configuration.selectionLimit = 6 - self.galleryList.count + 1 // Selection limit. Set to 0 for unlimited.
            } else {
                configuration.selectionLimit = 6 - self.galleryList.count // Selection limit. Set to 0 for unlimited.
            }
        } else {
            configuration.selectionLimit = 6 - self.galleryList.count //
        }
        
        configuration.filter = .images
    }
    
    
    
    var collectionView: UICollectionView! { didSet { configureCollectionView() } }
    private func configureCollectionView() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = false
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: CollectionViewNibIdentifier.galleryImageNib, bundle: nil),
                                forCellWithReuseIdentifier: CollectionViewCellIdentifier.galleryImagecell)
        
        configurePHPickerView()
        picker = PHPickerViewController(configuration: self.configuration)
        picker.delegate = self
    }
    
    func initializeInputsData() {
        configurePHPickerView()
        picker = PHPickerViewController(configuration: self.configuration)
        picker.delegate = self
        
        self.galleryList.removeAll()
        self.galleryList.insert(GalleryModel(file: "", id: "", isDp: 0, isInappropriate: 0, isTitleInappropriate: 0, title: "", type: "", image: UIImage(named: "Ellipse")!), at: 0)
        self.galleryList.append(contentsOf: GlobalVariables.shared.selectedGalleryImages)
        
        self.collectionView.reloadData()
    }
    
    // MARK: - API Call...
    func processForGetUserGalleryData(_ result:@escaping([String: Any]?) -> Void) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.UserApis.gallery,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .get) { response, _ in
            if !self.hasErrorIn(response) {
                DispatchQueue.main.async {
                    let userResponseData = response![APIConstants.data] as! [String: Any]
                    result(userResponseData)
                    self.galleryList.removeAll()
                    if let rows = userResponseData["rows"] as? [[String:Any]]{
                        for i in 0..<rows.count {
                            self.galleryList.append(GalleryModel(
                                file: rows[i]["file"] as? String ?? "",
                                id: rows[i]["id"] as? String ?? "",
                                isDp: rows[i]["isDp"] as? Int ?? 0,
                                isInappropriate: rows[i]["isInappropriate"] as? Int ?? 0,
                                isTitleInappropriate: rows[i]["isTitleInappropriate"] as? Int ?? 0,
                                title: rows[i]["title"] as? String ?? "",
                                type: rows[i]["type"] as? String ?? "",
                                image: UIImage(named: "Ellipse")!))
                        }
                    
                        GlobalVariables.shared.selectedGalleryImages = self.galleryList
                        if self.galleryList.count <= 6 {
                            self.galleryList.insert(GalleryModel(file: "", id: "", isDp: 0, isInappropriate: 0, isTitleInappropriate: 0, title: "", type: "", image: UIImage(named: "Ellipse")!), at: 0)
                            for (index, item) in self.galleryList.enumerated() {
                                if item.isDp == 1{
                                    self.galleryList.remove(at: index)
                                    self.galleryList.insert(item, at: 1)
                                    break
                                }
                            }
                        }else{
                            for (index, item) in self.galleryList.enumerated() {
                                if item.isDp == 1{
                                    self.galleryList.remove(at: index)
                                    self.galleryList.insert(item, at: 0)
                                    break
                                }
                            }
                        }
                        
                        self.configurePHPickerView()
                        self.picker = PHPickerViewController(configuration: self.configuration)
                        self.picker.delegate = self
                        self.collectionView.reloadData()
                    }
                    hideLoader()
                }
            }
        }
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
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.hostViewController.view
            popoverController.sourceRect = CGRect(x: self.hostViewController.view.bounds.midX, y: self.hostViewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.hostViewController.present(alertController, animated: true)
    }
    
    func showAlertForCameraGallery() {
        let alert = UIAlertController(title: "", message: "Do you want to add photo from camera or gallery?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.choosePhoto(isCamera: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { action in
            self.choosePhoto(isCamera: false)
           // self.hostViewController.present(self.picker, animated: true)
        }))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.hostViewController.view
            popoverController.sourceRect = CGRect(x: self.hostViewController.view.bounds.midX, y: self.hostViewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.hostViewController.present(alert, animated: true, completion: nil)
    }
    
    
    func proceedForCreatePreviewScreen() {
        if self.galleryList[0].image == UIImage(named: "Ellipse"){
            self.galleryList.remove(at: 0)
        }
        
        GlobalVariables.shared.cameraCancel = ""
        GalleryPreviewViewController.show(from: self.hostViewController, forcePresent: false, selectedImages: self.galleryList, selectedIndex: 0) { success in
        }
        
    }
    
    func proceedForEditPreviewScreen(tag:Int) {
        if self.galleryList[0].image == UIImage(named: "Ellipse"){
            self.galleryList.remove(at: 0)
        }
        print(self.galleryList)
        
        if self.galleryList.count == 6 {
            GalleryPreviewViewController.show(from: self.hostViewController, forcePresent: false, selectedImages: self.galleryList, selectedIndex: tag) { success in
            }
        }else {
            GalleryPreviewViewController.show(from: self.hostViewController, forcePresent: false, selectedImages: self.galleryList, selectedIndex: tag-1) { success in
            }
        }
    
       
    }
    
}
extension GalleryViewModel : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.galleryList.count == 7 {
            return self.galleryList.count - 1
        } else {
            return self.galleryList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.galleryImagecell, for: indexPath) as! GalleryImagesCollectionViewCell
        
        cell.backImage.layer.cornerRadius = 5 //cell.backImage.frame.height/2
        cell.backImage.clipsToBounds = true
        cell.inappLabel.layer.cornerRadius = cell.inappLabel.frame.height/2
        cell.inappLabel.clipsToBounds = true
        
        cell.inappLabel.isHidden = true
        
        if self.galleryList.count == 7 {
            if self.galleryList[indexPath.row+1].file != "" {
                cell.backImage.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + (self.galleryList[indexPath.row + 1].file ?? ""))), placeholderImage: #imageLiteral(resourceName: "Avatar"), completed: nil)
            }  else {
                cell.backImage.image = self.galleryList[indexPath.row+1].image
            }
            
            cell.backImage.alpha = (self.galleryList[indexPath.row+1].isInappropriate ?? 0) == 1 ? 0.5 : 1
            cell.inappLabel.isHidden = (self.galleryList[indexPath.row+1].isInappropriate ?? 0) == 1 ? false : true
           
            if self.galleryList[indexPath.row+1].isDp == 1 {
                cell.dpView.isHidden = false
                cell.setAsDPButton.isHidden = true
                cell.setDpView.isHidden = true
                cell.bottomDPView.layer.borderColor = UIColor.white.cgColor
            } else {
                cell.dpView.isHidden = true
                cell.setAsDPButton.isHidden = false
                cell.setDpView.isHidden = false
                cell.bottomDPView.layer.borderColor = UIColor.appGray.cgColor
            }
            
            cell.setAsDPButton.tag = indexPath.row + 1
            cell.bottomDPView.isHidden = false
         //   cell.addButton.setImage(UIImage(named: "ic_edit-1"), for: .normal)
//            cell.centerImage.isHidden = true
            cell.bottomDPView.isHidden = false
            cell.addButton.tag = indexPath.row + 1
            cell.addButton.isHidden = false
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: self.galleryList[indexPath.row + 1].title ?? "")
            attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: (self.galleryList[indexPath.row + 1].isTitleInappropriate ?? 0) == 1 ? UIColor.appYellowColor : UIColor.appBorder, range: NSRange(location: 0, length: attributeString.length))
            cell.descLabel.attributedText = attributeString
            cell.backImage.contentMode = .scaleAspectFill
            
        } else {
            
            // This is used to add space b/w 0 and 1st index
            if indexPath.row == 0{
                cell.viewBottomConstant.constant = 25
            }else{
                cell.viewBottomConstant.constant = 5
            }
            
            if indexPath.row == 0 {
                cell.inappLabel.isHidden = true
                cell.backImage.image = UIImage(named: "garally_selectImage")//self.galleryList[0].image
                cell.bottomDPView.isHidden = true
//                cell.centerImage.isHidden = false
                cell.setAsDPButton.tag = indexPath.row
            //    cell.addButton.setImage(UIImage(named: "Ic_add_image"), for: .normal)
                cell.backImage.contentMode = .scaleToFill
                cell.addButton.isHidden = true
            } else {
                cell.addButton.isHidden = false
                cell.backImage.contentMode = .scaleAspectFill
                if self.galleryList.count != 0 {
                    if self.galleryList[indexPath.row].file != "" {
                        cell.backImage.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + (self.galleryList[indexPath.row].file ?? ""))), placeholderImage: #imageLiteral(resourceName: "Avatar"), completed: nil)
                    }  else {
                        cell.backImage.image = self.galleryList[indexPath.row].image
                    }
                }
                cell.backImage.alpha = (self.galleryList[indexPath.row].isInappropriate ?? 0) == 1 ? 0.5 : 1
                cell.inappLabel.isHidden = (self.galleryList[indexPath.row].isInappropriate ?? 0) == 1 ? false : true
                
                cell.bottomDPView.isHidden = false
             //   cell.addButton.setImage(UIImage(named: "ic_edit-1"), for: .normal)
                
                if self.galleryList[indexPath.row].isDp == 1{
                    cell.dpView.isHidden = false
                    cell.setAsDPButton.isHidden = true
                    cell.setDpView.isHidden = true
                    cell.bottomDPView.layer.borderColor = UIColor.white.cgColor
                } else {
                    cell.dpView.isHidden = true
                    cell.setAsDPButton.isHidden = false
                    cell.setDpView.isHidden = false
                    cell.bottomDPView.layer.borderColor = UIColor.appGray.cgColor
                }
                cell.bottomDPView.isHidden = false
//                cell.centerImage.isHidden = true
                cell.setAsDPButton.tag = indexPath.row
            }
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: self.galleryList[indexPath.row].title ?? "")
           // attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: (self.galleryList[indexPath.row].isTitleInappropriate ?? 0) == 1 ? 1 : 0, range: NSRange(location: 0, length: attributeString.length))
            
            attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: (self.galleryList[indexPath.row].isTitleInappropriate ?? 0) == 1 ? UIColor.appYellowColor : UIColor.appBorder, range: NSRange(location: 0, length: attributeString.length))
            
            cell.descLabel.attributedText = attributeString
        }
       
        cell.addButton.tag = indexPath.row
        cell.addButton.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        
        cell.setAsDPButton.addTarget(self, action: #selector(setDPButtonTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func addButtonTapped(_ sender:UIButton) {
//        if sender.currentImage == UIImage(named: "Ic_add_image"){
//            if sender.tag == 0{
//                if self.galleryList.count >= 7{
//                    showMessage(with: ValidationError.maxuploadImages)
//                } else {
//                    self.configurePHPickerView()
//                    self.allowCameraPermission()
//                    self.picker = PHPickerViewController(configuration: self.configuration)
//                    self.picker.delegate = self
//                }
//            }
//        } else {
//           self.proceedForEditPreviewScreen(tag: sender.tag)
//        }
        print("sendee tag--->",sender.tag)
        let alert = UIAlertController(title: "Are you sure you want to delete this image?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
          //  self.viewModel.deleteButtonTapped()
            self.galleryList.remove(at: sender.tag)
            self.collectionView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { action in        }))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.hostViewController.view
            popoverController.sourceRect = CGRect(x: self.hostViewController.view.bounds.midX, y: self.hostViewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        hostViewController.present(alert, animated: true, completion: nil)

    }

    @objc func setDPButtonTapped(_ sender:UIButton) {
        for i in 0..<self.galleryList.count {
            if sender.tag == i {
                self.galleryList[i].isDp = 1
            } else {
                self.galleryList[i].isDp = 0
            }
        }
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.galleryList.count == 7 {
            return CGSize.init(width: self.hostViewController.view.frame.size.width - 24, height: 350)
        }else{
            if indexPath.row == 0 {
                return CGSize.init(width: self.hostViewController.view.frame.size.width - 24, height: 162)
            } else {
                return CGSize.init(width: self.hostViewController.view.frame.size.width - 24, height: 350)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.galleryList.count == 7 { } else {
            if indexPath.row == 0{
                if self.galleryList.count >= 7 {
                    showMessage(with: ValidationError.maxuploadImages)
                } else {
                    self.configurePHPickerView()
                    self.allowCameraPermission()
                    self.picker = PHPickerViewController(configuration: self.configuration)
                    self.picker.delegate = self
                }
            } else { }
        }
    }
}

extension GalleryViewModel : PHPickerViewControllerDelegate {
    
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            self.galleryList.append(GalleryModel(file: "", id: "", isDp: 0, isInappropriate: 0, isTitleInappropriate: 0, title: "", type: "", image: image))
            self.proceedForCreatePreviewScreen()
        }else {
            return
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        GlobalVariables.shared.cameraCancel = "yes"
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
                for i in 0..<images.count{
                    self.galleryList.append(GalleryModel(file: "", id: "", isDp: 0, isInappropriate: 0, isTitleInappropriate: 0, title: "", type: "", image: images[i]))
                }
                self.proceedForCreatePreviewScreen()
            }
        }
    }
    
    private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    // Helper function inserted by Swift 4.2 migrator.
    private func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
    }
    // Helper function inserted by Swift 4.2 migrator.
    private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }

    
}

extension GalleryViewModel {

    func uploadImages() {
        if self.galleryList.count < 3 {
            showMessage(with: ValidationError.minuploadImages)
        }
        else {
            if self.galleryList[0].image == UIImage(named: "Ellipse"){
                self.galleryList.remove(at: 0)
            }
            
            DispatchQueue.main.async {
                showProgressLoader(text: "Processing...")
            }
            
            self.duplicateGalleryList.removeAll()
            
            for i in 0..<self.galleryList.count {
                if self.galleryList[i].isDp == 1 {
                    self.duplicateGalleryList.insert(self.galleryList[i], at: 0)
                } else {
                    self.duplicateGalleryList.append(self.galleryList[i])
                }
            }
            for i in 0..<self.duplicateGalleryList.count {
                self.uploadImageStringArray.removeAll()
                if self.duplicateGalleryList[i].file == "" {
                    dispatchGroup.enter()
                    var imageFileName = ""
                    let folderName = KAPPSTORAGE.userPicDirectoryName
                    
                    let imageName: String = UIFunction.generateRandomStringWithLength(length: 12) + ".png" //UIFunction.getRandomImageName()
                    let fileManager = FileManager.default
                    do {
                        let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                        let fileURL = documentDirectory.appendingPathComponent(imageName)
                        
                        if let imageData = self.duplicateGalleryList[i].image?.jpegData(compressionQuality: 0.0) {
                            try imageData.write(to: fileURL)
                        }
                        
                        let userImage = NSString(format: "%@", imageName as CVarArg) as String
                        self.uploadImageStringArray.append(userImage)
                    } catch { }
                    
                    let uploadUrlParams = ["directory": folderName, "fileName": self.uploadImageStringArray[0], "contentType": "image"]
                    
                    if self.duplicateGalleryList.count > 1 {
                        self.uploadURLsApi(uploadUrlParams) { (model) in
                            imageFileName = model?.data?.fileName ?? ""
                            self.uploadImage(model?.data?.uploadURL ?? "", image: self.duplicateGalleryList[i].image!) { _ in
                                
                                let dict = NSMutableDictionary()
                                dict["file"] = imageFileName
                                dict["type"] = "jpg"
                                dict["title"] = self.duplicateGalleryList[i].title
                                dict["sequence"] = i+1
                                dict["isDp"] = self.duplicateGalleryList[i].isDp
                                self.uploadImagesDic.append(dict)
                                self.dispatchGroup.leave()
                            }
                        }
                    }
                    
                } else {
                    dispatchGroup.enter()
                    let dict = NSMutableDictionary()
                    dict["file"] = self.duplicateGalleryList[i].file
                    dict["type"] = "jpg"
                    dict["title"] = self.duplicateGalleryList[i].title
                    dict["sequence"] = i+1
                    dict["isDp"] = self.duplicateGalleryList[i].isDp
                    self.uploadImagesDic.append(dict)
                    self.dispatchGroup.leave()
                }
            }
            dispatchGroup.notify(queue: .main) {
                print(self.uploadImagesDic)
                self.updateGalleryApiCall(images: self.uploadImagesDic)
            }
        }
    }
    
    func updateGalleryApiCall(images:[NSDictionary]){
        let params = ["images": images] as [String : Any]
        processForUpdateGalleryApiData(params: params)
    }
    
    // MARK: - API Call...
    func processForUpdateGalleryApiData(params: [String: Any]) {
       // showLoader()
        ApiManager.makeApiCall(APIUrl.UserApis.updateGallery,
                               params: params,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .put) { response, _ in

                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [String: Any]
                                    self.user.updateWith(responseData)
                                    UserModel.shared.setUserLoggedIn(true)
                                    UserModel.shared.storedUser = self.user
                                    
                                    var isInappropriate = 0
                                    if self.user.userImages.filter({$0.isInappropriate == 1}).count > 0 || self.user.userImages.filter({$0.isTitleInappropriate == 1}).count > 0 {
                                        isInappropriate = 1
                                    }
                                    
                                    self.uploadImagesDic.removeAll()
                                    GlobalVariables.shared.selectedGalleryImages.removeAll()
                                    self.galleryList.removeAll()

                                    if isInappropriate == 0 {
                                        showSuccessLoader()
                                        delay(1){
                                            showSuccessMessage(with: "Gallery updated successfully")
                                            self.hostViewController.navigationController?.popViewController(animated: true)
                                        }
                                    } else {
                                        hideLoader()
                                        for item in self.user.userImages {
                                            self.galleryList.append(GalleryModel(file: item.file, id: item.id, isDp: item.isDp, isInappropriate: item.isInappropriate, isTitleInappropriate: item.isTitleInappropriate, title: item.title, type: item.type, image: UIImage(named: "Ellipse")!))
                                        }
                                        GlobalVariables.shared.selectedGalleryImages = self.galleryList
                                        self.galleryList.insert(GalleryModel(file: "", id: "", isDp: 0, isInappropriate: 0, isTitleInappropriate: 0, title: "", type: "", image: UIImage(named: "Ellipse")!), at: 0)
                                        self.collectionView.reloadData()
                                    }
                                }
            hideLoader()

        }
    }
    
    // MARK: -  Upload Url
    func uploadURLsApi(_ params: [String:Any],_ result:@escaping(UploadUrlResponseModel?) -> Void) {
        
        ApiManagerWithCodable<UploadUrlResponseModel>.makeApiCall(APIUrl.BasicApis.uploadImage,
                                                                  params: params,
                                                                  headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
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
