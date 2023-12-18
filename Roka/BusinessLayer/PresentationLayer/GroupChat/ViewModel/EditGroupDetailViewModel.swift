//
//  EditGroupDetailViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 26/12/22.
//

import Foundation
import UIKit
import Photos

class EditGroupDetailViewModel: BaseViewModel {
    var isComeFor = ""
    var completionHandler: ((Bool) -> Void)?
    var chatRoom: ChatRoomModel?
    
    func checkForCamera(handler: @escaping ((MediaAction) -> Void)) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(3)) {
                let status  = AVCaptureDevice.authorizationStatus(for: .video)
                if status == .authorized {
                    handler(.cameraSuccess)
                    
                } else if status == .notDetermined {
                    AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (status) in
                        if status == true {
                            handler(.cameraSuccess)
                        } else {
                            handler(.permissionError)
                        }
                    })
                } else if status == .restricted || status == .denied {
                    handler(.permissionError)
                }
            }
        } else {
            handler(.cameraNotFound)
        }
    }
    
    func checkForGalleryAction(handler: @escaping ((MediaAction) -> Void)) {
        let status = PHPhotoLibrary.authorizationStatus()
        if(status == .notDetermined) {
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                    handler(.gallerySuccess)
                } else {
                    handler(.permissionError)
                }
            })
        } else if (status == .authorized) {
            handler(.gallerySuccess)
        } else if (status == .restricted || status == .denied) {
            handler(.permissionError)
        }
    }
    
    func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
    }
    
    func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
    
    // MARK: -  Upload Url
    func uploadURLsApi(_ params: [String:Any],_ result:@escaping(UploadUrlResponseModel?) -> Void) {
        showLoader()
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
                DispatchQueue.main.async {
                    hideLoader()
                    showMessage(with: response?["message"] as? String ?? "")
                }
            }
        }
    }
    
    func verifyImage(params: [String: Any],_ result:@escaping([String: Any]?) -> Void) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.LandingApis.imageModulation,
                               params: params,
                               headers: headers,
                               method: .post) { response, _ in
            if !self.hasErrorIn(response) {
                let responseData = response![APIConstants.data] as! [String: Any]
                result(responseData)
            }
            hideLoader()
        }
    }
    
    func uploadImage(_ imgURL: String, image: UIImage, _ result:@escaping(String?) -> Void) {
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
            DispatchQueue.main.async {
                Progress.instance.hide()
                hideLoader()
                
            }
            error == nil ? result("success") : result("failure")
        }
        task1.resume()
    }
}
