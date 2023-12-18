//
//  EditGroupDetailViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 26/12/22.
//

import UIKit

class EditGroupDetailViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.groupChat
        
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.editGroupDetail
    }

    lazy var viewModel: EditGroupDetailViewModel = EditGroupDetailViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }

    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    chatRoom: ChatRoomModel,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! EditGroupDetailViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.viewModel.chatRoom = chatRoom
        controller.show(from: viewController, forcePresent: forcePresent)
    }

    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var topStaticLabel: UILabel!    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var placeholderImage: UIImageView!
    @IBOutlet weak var editGroupNameTextField: UnderlinedTextField!
    var fileName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let pic = viewModel.chatRoom?.pic ?? "dp"
        if pic != "dp" {
            self.groupImage.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + pic)), placeholderImage: #imageLiteral(resourceName: "Ic_image"), completed: nil)
            placeholderImage.isHidden = true
        }else{
            outerView.layer.borderColor = UIColor.lightGray.cgColor
            outerView.layer.borderWidth = 0.5
            outerView.layer.cornerRadius = outerView.layer.frame.size.width/2
        }
        editGroupNameTextField.text = viewModel.chatRoom?.name
        fileName = viewModel.chatRoom?.pic ?? "dp"
        
        addNavigationBackButton()
        self.title = "Edit Group"

    }
    override func viewDidLayoutSubviews() {
        
    }
    func addNavigationBackButton() {
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        if GlobalVariables.shared.selectedProfileMode == "MatchMaking" {
            btn2.setImage(UIImage(named: "Ic_back_1"), for: .normal)
            self.topStaticLabel.backgroundColor = UIColor.loginBlueColor
        }else{
            btn2.setImage(UIImage(named: "ic_back_white"), for: .normal)
            self.topStaticLabel.backgroundColor = UIColor.appTitleBlueColor
        }
        btn2.addTarget(self, action: #selector(backkButtonTapped(_:)), for:.touchUpInside)
        let barButton = UIBarButtonItem(customView: btn2)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func backkButtonTapped(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editGroupImageButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.chooseAttachment(type: "Camera")
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { action in
            self.chooseAttachment(type: "Gallery")
        }))
        
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func chooseAttachment(type: String) {
        if type == "Camera" {
            self.viewModel.checkForCamera { action in
                if action == .cameraSuccess {
                    self.openCameraGallery(type: "Camera")
                } else if action == .permissionError {
                    self.showAlertOfPermissionsNotAvailable()
                } else {
                    //cameraNotFound
                    DispatchQueue.main.async { [weak self] in
                        let alertController: UIAlertController = UIAlertController(title: "Error", message: "Device has no camera.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default) { (_) -> Void in
                        }
                        alertController.addAction(okAction)
                        self?.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        } else {
            //Gallery
            self.viewModel.checkForGalleryAction { action in
                if action == .gallerySuccess {
                    self.openCameraGallery(type: "Gallery")
                } else {
                    self.showAlertOfPermissionsNotAvailable()
                }
            }
        }
    }
    
    func showAlertOfPermissionsNotAvailable() {
        DispatchQueue.main.async { [weak self] in
            let message = UIFunction.getLocalizationString(text: "Camera permission not available")
            let alertController: UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let cancelTitle = UIFunction.getLocalizationString(text: "Cancel")
            let cancelAction = UIAlertAction(title: cancelTitle, style: .destructive) { (_) -> Void in
            }
            let settingsTitle = UIFunction.getLocalizationString(text: "Settings")
            let settingsAction = UIAlertAction(title: settingsTitle, style: .default) { (_) -> Void in
                UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: (self?.viewModel.convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]))!, completionHandler: nil)
            }
            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func saveChangesAction(_ sender: UIButton) {
        if editGroupNameTextField.text ?? "" == "" {
            showMessage(with: ValidationError.groupName)
        } else {
            FirestoreManager.updateGroupInfo(groupPic: nil, name: editGroupNameTextField.text , groupId: viewModel.chatRoom?.chat_dialog_id ?? "")
            viewModel.completionHandler?(true)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func addDotAroundView() {
        // Calculate the radius for the dot
        let dotRadius: CGFloat = 10.0
        
        // Create a circular layer
        let dotLayer = CALayer()
        dotLayer.bounds = CGRect(x: 0, y: 0, width: dotRadius * 2, height: dotRadius * 2)
        dotLayer.cornerRadius = dotRadius
        dotLayer.backgroundColor = UIColor.red.cgColor // Set the dot color
        
        // Position the dot around the view
        let xOffset: CGFloat = outerView.frame.width / 2 - dotRadius
        let yOffset: CGFloat = outerView.frame.height / 2 - dotRadius
        dotLayer.position = CGPoint(x: outerView.frame.origin.x + xOffset, y: outerView.frame.origin.y + yOffset)
        
        // Add the dot layer as a sublayer to the view
        outerView.layer.addSublayer(dotLayer)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension EditGroupDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func openCameraGallery(type: String) {
        DispatchQueue.main.async { [weak self] in
            let imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = type == "Camera" ? .camera : .photoLibrary
            imagePicker.mediaTypes = ["public.image"]
            self?.present(imagePicker, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        let info = viewModel.convertFromUIImagePickerControllerInfoKeyDictionary(info)
        if let mediaType = info["UIImagePickerControllerMediaType"] as? String, mediaType  == "public.image" {
            if let image = (info[viewModel.convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage) {
                sendImageToServer(selectedImage: image)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func sendImageToServer(selectedImage: UIImage) {
        let imageName: String = UIFunction.getRandomImageName()
        let uploadUrlParams = ["contentType": "image/png", "directory": KAPPSTORAGE.userPicDirectoryName, "fileName": imageName]

        viewModel.uploadURLsApi(uploadUrlParams) { [weak self] (model) in
            let fileName = model?.data?.fileName ?? ""
           
            self?.viewModel.uploadImage(model?.data?.uploadURL ?? "", image: selectedImage ) { [weak self] _ in
                let params = ["image": fileName]
                self?.viewModel.verifyImage(params: params) { json in
                    if let isInappropriate = json!["isInappropriate"] as? Int, isInappropriate == 0 {
                        self?.fileName = fileName
                        self?.groupImage.sd_setImage(with: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + (self?.fileName ?? ""))), placeholderImage: #imageLiteral(resourceName: "Ic_image"), completed: nil)
                        self?.placeholderImage.isHidden = true
                        
                        FirestoreManager.updateGroupInfo(groupPic: fileName, name: nil, groupId: self?.viewModel.chatRoom?.chat_dialog_id ?? "")
                        self?.viewModel.completionHandler?(true)
                    } else {
                        showMessage(with:"Inappropriate image")
                    }
                }
            }
        }
    }
}
