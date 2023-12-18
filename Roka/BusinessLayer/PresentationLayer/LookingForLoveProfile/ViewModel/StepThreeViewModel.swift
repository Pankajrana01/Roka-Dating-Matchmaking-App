//
//  StepThreeViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 28/09/22.
//

import Foundation
import UIKit
import AVKit
import PhotosUI

class StepThreeViewModel : BaseViewModel {
    var completionHandler: ((Bool) -> Void)?
    var nextButton: UIButton!
    var selectedImages = [ImageModel]()
    var configuration = PHPickerConfiguration()
    var picker : PHPickerViewController!
    var isComeFor = ""
    var copySelectedImages = [ImageModel]()
    var uploadImageStringArray = [String]()
    var uploadImagesDic = [NSDictionary]()
    var preferredDetailsDictionary = [String:Any]()
    var basicDetailsDictionary = [String:Any]()
    var storedUser = KUSERMODEL.user
    let user = UserModel.shared.user
    weak var collectionViewHeight: NSLayoutConstraint!
    weak var minimumLable: UILabel!
    func configurePHPickerView() {
        if self.selectedImages.count != 0{
            if self.selectedImages[0].image == UIImage(named: "AddPhoto"){
                configuration.selectionLimit = 6 - self.selectedImages.count + 1 // Selection limit. Set to 0 for unlimited.
            } else {
                configuration.selectionLimit = 6 - self.selectedImages.count // Selection limit. Set to 0 for unlimited.
            }
        } else {
            configuration.selectionLimit = 6 - self.selectedImages.count //
        }
        
        configuration.filter = .images
    }
    var dispatchGroup = DispatchGroup()

    var collectionView: UICollectionView! { didSet { configureCollectionView() } }
    private func configureCollectionView() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = false
        }
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(UINib(nibName: CollectionViewNibIdentifier.uploadImageNib, bundle: nil),
                                forCellWithReuseIdentifier: CollectionViewCellIdentifier.uploadImagecell)
    }
    
    func initializeInputsData() {
        self.selectedImages.removeAll()
        uploadImagesDic.removeAll()
      //  self.selectedImages.insert(ImageModel(imageName: "", image: UIImage(named: "AddPhoto"), title: ""), at: 0)
        self.selectedImages.append(ImageModel(imageName: "", image: UIImage(named: "AddPhoto"), title: ""))
        configurePHPickerView()
        picker = PHPickerViewController(configuration: self.configuration)
        picker.delegate = self
        
        if GlobalVariables.shared.isComeFor == "Preview" || GlobalVariables.shared.isPreviewScreenBack == "yes" {
            self.selectedImages.removeAll()
            
            //self.selectedImages.insert(ImageModel(imageName: "", image: UIImage(named: "AddPhoto"), title: ""), at: 0)
            
            self.selectedImages.append(contentsOf:  GlobalVariables.shared.selectedImages)
            
            if GlobalVariables.shared.selectedImages.count != 6 {
                self.selectedImages.append(ImageModel(imageName: "", image: UIImage(named: "AddPhoto"), title: ""))
            }
        }
    
        self.collectionView.reloadData()
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
        if let index = self.selectedImages.firstIndex(where: { $0.image == UIImage(named: "AddPhoto") }) {
            print(index)
            self.selectedImages.remove(at: index)
            GlobalVariables.shared.cameraCancel = ""
            previewViewController.show(from: self.hostViewController, forcePresent: false, selectedImages: self.selectedImages, selectedIndex: index) { success in
            }
        } else {
            GlobalVariables.shared.cameraCancel = ""
            previewViewController.show(from: self.hostViewController, forcePresent: false, selectedImages: self.selectedImages, selectedIndex: 0) { success in
            }
        }
        
        //        if self.selectedImages[0].image == UIImage(named: "AddPhoto"){
        //            self.selectedImages.remove(at: 0)
        //        }
    }
    
    func proceedForEditPreviewScreen(tag:Int) {
        if let index = self.selectedImages.firstIndex(where: { $0.image == UIImage(named: "AddPhoto") }) {
            print(index)
            self.selectedImages.remove(at: index)
        }
        
//        if self.selectedImages[tag].image == UIImage(named: "AddPhoto") {
//            self.selectedImages.remove(at: tag)
//        }
        
        if self.selectedImages.count == 6 {
            previewViewController.show(from: self.hostViewController, forcePresent: false, selectedImages: self.selectedImages, selectedIndex: tag) { success in
            }
        } else {
            previewViewController.show(from: self.hostViewController, forcePresent: false, selectedImages: self.selectedImages, selectedIndex: tag) { success in
            }
        }
    }
    
    func proceedForCreateProfileStepFour() {
        if self.selectedImages.count == 7 {
            StepFourViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "") { success in
            }
        } else {
            StepFourViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "") { success in
            }
        }
    }
    
    func enableDisableNextButton() {
        if self.selectedImages.count < 2 {
            self.nextButton.alpha = 0.5
            self.nextButton.isUserInteractionEnabled = false
        } else {
            self.nextButton.alpha = 1.0
            self.nextButton.isUserInteractionEnabled = true
        }
    }
}

// MARK: - Collection Delegate & DataSource

extension StepThreeViewModel : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.enableDisableNextButton()
        if selectedImages.count <= 3 {
            collectionViewHeight.constant = 120
        } else {
            collectionViewHeight.constant = 240
        }
        
        if selectedImages.count <= 2 {
            minimumLable.isHidden = false
        } else {
            minimumLable.isHidden = true
        }
        
        if self.selectedImages.count == 7 {
            return self.selectedImages.count - 1
        } else {
            return self.selectedImages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.uploadImagecell, for: indexPath) as! UploadImagesCollectionViewCell
        cell.backImage.layer.cornerRadius = 10
        cell.backImage.clipsToBounds = true
        cell.inappLabel.layer.cornerRadius = 10
        cell.inappLabel.clipsToBounds = true
        cell.inappLabel.isHidden = true

        
        if self.selectedImages.count == 7 {
            cell.backImage.image = self.selectedImages[indexPath.row + 1].image
            cell.backImage.isHidden = false
            
            cell.backImage.alpha = self.selectedImages[indexPath.row + 1].isInappropriate == 1 ? 0.5 : 1
            
            cell.inappLabel.isHidden = self.selectedImages[indexPath.row+1].isInappropriate == 1 ? false : true
            
            cell.centerImage.isHidden = true
//            cell.addButton.isHidden = false
//            cell.addButton.setImage(UIImage(named: ""), for: .normal)
//            cell.addButton.tag = indexPath.row
            
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: self.selectedImages[indexPath.row + 1].title)
            
//            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: (self.selectedImages[indexPath.row + 1].isTitleInappropriate ?? 0) == 1 ? 1 : 0, range: NSRange(location: 0, length: attributeString.length))
            
            attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: (self.selectedImages[indexPath.row + 1].isTitleInappropriate ?? 0) == 1 ? UIColor.appYellowColor : UIColor.appBorder, range: NSRange(location: 0, length: attributeString.length))
            
            cell.descLabel.attributedText = attributeString
            
        } else {
            if indexPath.row == 0 {
                cell.backImage.image = self.selectedImages[indexPath.row].image
                cell.backImage.isHidden = false
                cell.centerImage.isHidden = true
//                cell.addButton.isHidden = false
//                cell.addButton.setImage(UIImage(named: ""), for: .normal)
                cell.descLabel.text = ""
              //  cell.addButton.tag = indexPath.row
                cell.inappLabel.isHidden = true
            }else{
                cell.backImage.image = self.selectedImages[indexPath.row].image
                cell.backImage.isHidden = false
                cell.backImage.alpha = self.selectedImages[indexPath.row].isInappropriate == 1 ? 0.5 : 1
                cell.inappLabel.isHidden = self.selectedImages[indexPath.row].isInappropriate == 1 ? false : true
                cell.centerImage.isHidden = true
//                cell.addButton.isHidden = false
//                cell.addButton.setImage(UIImage(named: ""), for: .normal)
//                cell.addButton.tag = indexPath.row
            }
        }
        
//        cell.addButton.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        
        var title = ""
        if GlobalVariables.shared.isComeFor == "Preview" {
            if self.selectedImages.count == 7 {
                title = self.selectedImages[indexPath.row + 1].title
            } else{
                title = self.selectedImages[indexPath.row].title
            }
        } else {
            title = self.selectedImages[indexPath.row].title
        }
        
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: title)
       
//        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: (self.selectedImages[indexPath.row].isTitleInappropriate ?? 0) == 1 ? 1 : 0, range: NSRange(location: 0, length: attributeString.length))
        
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: (self.selectedImages[indexPath.row].isTitleInappropriate ?? 0) == 1 ? UIColor.appYellowColor : UIColor.appBorder, range: NSRange(location: 0, length: attributeString.length))

        cell.descLabel.attributedText = attributeString
        
        return cell
    }

    @objc func addButtonTapped(_ sender:UIButton) {
        if sender.currentImage == UIImage(named: "") {
                if self.selectedImages.count >= 7 {
                    showMessage(with: ValidationError.maxuploadImages)
                } else {
                    self.configurePHPickerView()
                    self.allowCameraPermission()
                    self.picker = PHPickerViewController(configuration: self.configuration)
                    self.picker.delegate = self
                }
        } else {
            self.proceedForEditPreviewScreen(tag: sender.tag)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.hostViewController.view.frame.size.width/3 - 10, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.selectedImages[indexPath.row].image == UIImage(named: "AddPhoto") {
            self.configurePHPickerView()
            self.allowCameraPermission()
            self.picker = PHPickerViewController(configuration: self.configuration)
            self.picker.delegate = self
        } else {
            self.proceedForEditPreviewScreen(tag: indexPath.row)
        }

    }
}


extension StepThreeViewModel : PHPickerViewControllerDelegate {
    
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.selectedImages.append(ImageModel(imageName: "", image: image, title: ""))
            self.proceedForCreatePreviewScreen()
        } else {
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
                for img in images {
                    self.selectedImages.append(ImageModel(imageName: "", image: img, title: ""))
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

extension StepThreeViewModel {

    func uploadImages() {
        if self.selectedImages.count < 3 {
            showMessage(with: ValidationError.minuploadImages)
        }
        else {
//            if self.selectedImages[0].image == UIImage(named: "AddPhoto"){
//                self.selectedImages.remove(at: 0)
//            }
            
            if let index = self.selectedImages.firstIndex(where: { $0.image == UIImage(named: "AddPhoto") }) {
                print(index)
                self.selectedImages.remove(at: index)
            }
            
            for i in 0..<self.selectedImages.count {
                self.uploadImageStringArray.removeAll()
                dispatchGroup.enter()
                var imageFileName = ""
                let folderName = KAPPSTORAGE.userPicDirectoryName
                
                let imageName: String = UIFunction.generateRandomStringWithLength(length: 12) + ".png"  //UIFunction.getRandomImageName()
                let fileManager = FileManager.default
                do {
                    let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let fileURL = documentDirectory.appendingPathComponent(imageName)
                    
                    if let imageData = self.selectedImages[i].image?.jpegData(compressionQuality: 0.2) {
                        try imageData.write(to: fileURL)
                    }
                    
                    let userImage = NSString(format: "%@", imageName as CVarArg) as String
                    self.uploadImageStringArray.append(userImage)
                } catch {}
                
                print(self.uploadImageStringArray)
                
                let uploadUrlParams = ["directory": folderName, "fileName": self.uploadImageStringArray[0], "contentType": "image/"]
                
                if self.selectedImages.count > 1 {
                    self.uploadURLsApi(uploadUrlParams) { (model) in
                        imageFileName = model?.data?.fileName ?? ""
                        self.uploadImage(model?.data?.uploadURL ?? "", image: self.selectedImages[i].image ?? UIImage() ) { _ in
                            let dict = NSMutableDictionary()
                            if i == 0 {
                                dict["file"] = imageFileName
                                dict["type"] = "jpg"
                                dict["title"] = self.selectedImages[i].title
                                dict["sequence"] = i+1
                                dict["isDp"] = 1
                                self.selectedImages[i].imageName = imageFileName
                                self.uploadImagesDic.append(dict)
                            } else {
                                dict["file"] = imageFileName
                                dict["type"] = "jpg"
                                dict["title"] = self.selectedImages[i].title
                                dict["sequence"] = i+1
                                dict["isDp"] = 0
                                self.selectedImages[i].imageName = imageFileName
                                self.uploadImagesDic.append(dict)
                            }
                           
                            self.dispatchGroup.leave()
                        }
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                print(self.uploadImagesDic)
                self.registerApiCall(images: self.uploadImagesDic)
            }
        }
    
    }
    
    func registerApiCall(images:[NSDictionary]){
        let kycDic = ["file": "",
                      "type": ""]
        
        let params = ["firstName": "\(storedUser.firstName)",
                      "lastName": "\(storedUser.lastName)",
                      "genderId": "\(storedUser.genderId)",
                      "gender": "\(storedUser.gender)",
                      "dob": "\(storedUser.dob)",
                      "registrationStep": 2,
                      "notificationEnabled": "0",
                      "userType": 1,
                      "latitude": "\(storedUser.latitude)",
                      "longitude": "\(storedUser.longitude)",
                      "city": "\(storedUser.city)",
                      "state": "\(storedUser.state)",
                      "country" : "\(storedUser.country)",
                      //"preferredGendersPriority": 0,
                      //"preferredGenders": storedUser.preferredGenders as Any,
                      "preferredMaxAge": storedUser.preferredMaxAge,
                      "preferredMinAge": storedUser.preferredMinAge,
                      "preferredLatitude": "\(storedUser.preferredLatitude)",
                      "preferredLongitude": "\(storedUser.preferredLongitude)",
                      "preferredCity": "\(storedUser.preferredCity)",
                      "preferredState": "\(storedUser.preferredState)",
                      "preferredCountry": "\(storedUser.preferredCountry)",
                      "preferredDistance": storedUser.preferredDistance,
                      "isLocationSetDefault": storedUser.isLocationSetDefault,
                      "images": images,
                      "kycVideo": kycDic] as [String : Any]
                      //"preferredWishingToHave": storedUser.preferredWishingToHave,
                     // "relationshipId":storedUser.relationshipId
                       
        
        processForRegisterApiData(params: params)
    }
    
    // MARK: - API Call...
    func processForRegisterApiData(params: [String: Any]) {
        // showLoader()
        
        ApiManager.makeApiCall(APIUrl.UserApis.registerUser,
                               params: params,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .put) { response, _ in
            self.uploadImagesDic.removeAll()
            if !self.hasErrorIn(response) {
                if let responseData = response![APIConstants.data] as? [String: Any] {
                    var isInappropriate = 0
                    
                    if let rawUserImages = responseData[WebConstants.userImages] as? [[String: Any]] {
                        self.user.updateProfiles(rawUserImages)
                        if self.user.userImages.filter({$0.isInappropriate == 1}).count > 0 || self.user.userImages.filter({$0.isTitleInappropriate == 1}).count > 0 {
                            isInappropriate = 1
                        }
                        
                        if isInappropriate == 0 {
                            showSuccessLoader()
                            self.user.updateWith(responseData)
                            UserModel.shared.storedUser = self.user
                            UserModel.shared.setUserLoggedIn(true)
                            self.proceedForCreateProfileStepFour()
                            
                        } else {
                            hideLoader()
                            for item in self.user.userImages {
                                if let index = self.selectedImages.firstIndex(where: {$0.imageName == item.file}) {
                                    self.selectedImages[index].isInappropriate = item.isInappropriate
                                    self.selectedImages[index].isTitleInappropriate = item.isTitleInappropriate
                                    
                                }
                            }
                            GlobalVariables.shared.selectedImages = self.selectedImages
                            //self.selectedImages.insert(ImageModel(imageName: "", image: UIImage(named: "AddPhoto"), title: ""), at: 0)
                            if self.selectedImages.count != 6 {
                                self.selectedImages.append(ImageModel(imageName: "", image: UIImage(named: "AddPhoto"), title: ""))
                            }
                            self.collectionView.reloadData()
                        }
                    }
                } else {
                    hideLoader()
                    if self.selectedImages.count != 6 {
                        self.selectedImages.append(ImageModel(imageName: "", image: UIImage(named: "AddPhoto"), title: ""))
                    }
                   // self.selectedImages.insert(ImageModel(imageName: "", image: UIImage(named: "AddPhoto"), title: ""), at: 0)
                }
            } else {
                hideLoader()
                if self.selectedImages.count != 6 {
                    self.selectedImages.append(ImageModel(imageName: "", image: UIImage(named: "AddPhoto"), title: ""))
                }
            }
        }
    }
    
    // MARK: -  Upload Url
    func uploadURLsApi(_ params: [String:Any],_ result:@escaping(UploadUrlResponseModel?) -> Void) {
        DispatchQueue.main.async {
            showProgressLoader(text: "Processing...")
        }
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

struct ImageModel {
    var imageName: String = ""
    var image: UIImage?
    var title: String = ""
    var isInappropriate: Int? = 0
    var isTitleInappropriate: Int? = 0
}
