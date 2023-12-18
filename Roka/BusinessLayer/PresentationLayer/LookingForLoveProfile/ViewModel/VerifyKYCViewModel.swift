//
//  VerifyKYCViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 22/09/22.
//

import Foundation
import UIKit
import AVFoundation
import Photos
import ASPVideoPlayer
import AVKit

class VerifyKYCViewModel : BaseViewModel {
    weak var videoPlayer: ASPVideoPlayer!
    var completionHandler: ((Bool) -> Void)?
    var isComeFor = ""
    var nextButton: UIButton!
    weak var timeLabel: UILabel!
    weak var previewView: PreviewView!
    weak var recordStackView: UIStackView!
    weak var pauseStopStackView: UIStackView!
    weak var recordInstructionView: UIView!
    weak var record2InstructionView: UIView!
    weak var bottomStackView: UIStackView!
    weak var finishView: UIView!
    weak var blackView: UIView!
    weak var successKycView: UIView!
    weak var playButton: UIButton!
    weak var pauseLabel: UILabel!
    weak var pauseButton: UIButton!
    weak var buttonView: UIView!
    
    var outputFilePathArray = [URL]()
    private var spinner: UIActivityIndicatorView!
    var windowOrientation: UIInterfaceOrientation {
        return self.hostViewController.view.window?.windowScene?.interfaceOrientation ?? .unknown
    }
    var count = 1
    var timer : Timer?
    var resumeTapped = false

    var recordingFileURL: URL?
    var recordingMergeFileURL: URL?
    
    let session = AVCaptureSession()
    var isSessionRunning = false
    private var selectedMovieMode10BitDeviceFormat: AVCaptureDevice.Format?
    private var movieFileOutput: AVCaptureMovieFileOutput?
    private var backgroundRecordingID: UIBackgroundTaskIdentifier?
    private let sessionQueue = DispatchQueue(label: "session queue")
    private var setupResult: SessionSetupResult = .success
    @objc dynamic var videoDeviceInput: AVCaptureDeviceInput!
    
    func proceedForCreateProfileStepFive() {
        if self.isComeFor == "Profile" {
            let viewControllers: [UIViewController] = self.hostViewController.navigationController!.viewControllers
            for aViewController in viewControllers {
                if aViewController is ProfileViewController {
                    self.hostViewController.navigationController!.popToViewController(aViewController, animated: true)
                } else if aViewController is HomeViewController {
                    self.hostViewController.navigationController!.popToViewController(aViewController, animated: true)
                }
            }
        } else if self.isComeFor == "KYC_DECLINE_PUSH" {
            self.proceedForHome()
        } else {
            ProfileCreatedViewController.show(from: self.hostViewController, forcePresent: false, iscomeFrom: "") { success in
            }
        }
    }
    
    func proceedForHome() {
        KAPPDELEGATE.updateRootController(TabBarController.getController(),
                                          transitionDirection: .toLeft,
                                          embedInNavigationController: true)
    }
    func initialPreviewView() {
        // Set up the video preview view.
        previewView.session = session
        //runTimer()
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            // The user has previously granted access to the camera.
            break
            
        case .notDetermined:
            /*
             The user has not yet been presented with the option to grant
             video access. Suspend the session queue to delay session
             setup until the access request has completed.
             
             Note that audio access will be implicitly requested when we
             create an AVCaptureDeviceInput for audio during session setup.
             */
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                if !granted {
                    self.setupResult = .notAuthorized
                }
                self.sessionQueue.resume()
            })
            
        default:
            // The user has previously denied access.
            setupResult = .notAuthorized
        }
        
        sessionQueue.async {
            self.configureSession()
        }
//        DispatchQueue.main.async {
//            self.spinner = UIActivityIndicatorView(style: .large)
//            self.spinner.color = UIColor.yellow
//            self.previewView.addSubview(self.spinner)
//        }
    }
    
    // MARK: - Device Configuration
    private func configureSession() {
        if setupResult != .success {
            return
        }
        
        session.beginConfiguration()
        
        /*
         Do not create an AVCaptureMovieFileOutput when setting up the session because
         Live Photo is not supported when AVCaptureMovieFileOutput is added to the session.
         */
        session.sessionPreset = .photo
        
        // Add video input.
        do {
            var defaultVideoDevice: AVCaptureDevice?
            
            // Choose the back dual camera, if available, otherwise default to a wide angle camera.
            
            if let dualCameraDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .front) {
                defaultVideoDevice = dualCameraDevice
            } else if let dualWideCameraDevice = AVCaptureDevice.default(.builtInDualWideCamera, for: .video, position: .front) {
                // If a rear dual camera is not available, default to the rear dual wide camera.
                defaultVideoDevice = dualWideCameraDevice
                
            } else if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
                // If a rear dual wide camera is not available, default to the rear wide angle camera.
                defaultVideoDevice = backCameraDevice
            
                
            } else if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
                // If the rear wide angle camera isn't available, default to the front wide angle camera.
                defaultVideoDevice = frontCameraDevice
            }
            guard let videoDevice = defaultVideoDevice else {
                print("Default video device is unavailable.")
                setupResult = .configurationFailed
                session.commitConfiguration()
                return
            }
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            
            if session.canAddInput(videoDeviceInput) {
                session.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
                
                DispatchQueue.main.async {
                    /*
                     Dispatch video streaming to the main queue because AVCaptureVideoPreviewLayer is the backing layer for PreviewView.
                     You can manipulate UIView only on the main thread.
                     Note: As an exception to the above rule, it's not necessary to serialize video orientation changes
                     on the AVCaptureVideoPreviewLayer’s connection with other session manipulation.
                     
                     Use the window scene's orientation as the initial video orientation. Subsequent orientation changes are
                     handled by CameraViewController.viewWillTransition(to:with:).
                     */
                    var initialVideoOrientation: AVCaptureVideoOrientation = .portrait
                    if self.windowOrientation != .unknown {
                        if let videoOrientation = AVCaptureVideoOrientation(interfaceOrientation: self.windowOrientation) {
                            initialVideoOrientation = videoOrientation
                        }
                    }
                    
                    self.previewView.videoPreviewLayer.connection?.videoOrientation = initialVideoOrientation
                }
            } else {
                print("Couldn't add video device input to the session.")
                setupResult = .configurationFailed
                session.commitConfiguration()
                return
            }
        } catch {
            print("Couldn't create video device input: \(error)")
            setupResult = .configurationFailed
            session.commitConfiguration()
            return
        }
        
        // Add an audio input device.
        do {
            guard let audioDevice = AVCaptureDevice.default(for: .audio) else { return }
            let audioDeviceInput = try AVCaptureDeviceInput(device: audioDevice)
            
            if session.canAddInput(audioDeviceInput) {
                session.addInput(audioDeviceInput)
            } else {
                print("Could not add audio device input to the session")
            }
        } catch {
            print("Could not create audio device input: \(error)")
        }
        session.commitConfiguration()
    }
    
    func previewWillAppear() {
        sessionQueue.async {
            switch self.setupResult {
            case .success:
                // Only setup observers and start the session if setup succeeded.
                self.addObservers()
                let movieFileOutput = AVCaptureMovieFileOutput()
                if self.session.canAddOutput(movieFileOutput) {
                    self.session.beginConfiguration()
                    self.session.addOutput(movieFileOutput)
                    self.session.sessionPreset = .high
                    self.selectedMovieMode10BitDeviceFormat = self.tenBitVariantOfFormat(activeFormat: self.videoDeviceInput.device.activeFormat)
                    
                    if let connection = movieFileOutput.connection(with: .video) {
                        if connection.isVideoStabilizationSupported {
                            connection.preferredVideoStabilizationMode = .auto
                        }
                    }
                    self.session.commitConfiguration()
                    self.movieFileOutput = movieFileOutput
                }
                self.session.startRunning()
                self.isSessionRunning = self.session.isRunning
                
            case .notAuthorized:
                DispatchQueue.main.async {
                    let changePrivacySetting = "AVCam doesn't have permission to use the camera, please change privacy settings"
                    let message = NSLocalizedString(changePrivacySetting, comment: "Alert message when the user has denied access to the camera")
                    let alertController = UIAlertController(title: "AVCam", message: message, preferredStyle: .alert)
                    
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),
                                                            style: .cancel,
                                                            handler: nil))
                    
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "Alert button to open Settings"),
                                                            style: .`default`,
                                                            handler: { _ in
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                                  options: [:],
                                                  completionHandler: nil)
                    }))
                    
                    if let popoverController = alertController.popoverPresentationController {
                        popoverController.sourceView = self.hostViewController.view
                        popoverController.sourceRect = CGRect(x: self.hostViewController.view.bounds.midX, y: self.hostViewController.view.bounds.midY, width: 0, height: 0)
                        popoverController.permittedArrowDirections = []
                    }
                    
                    self.hostViewController.present(alertController, animated: true, completion: nil)
                }
                
            case .configurationFailed:
                DispatchQueue.main.async {
                    let alertMsg = "Alert message when something goes wrong during capture session configuration"
                    let message = NSLocalizedString("Unable to capture media", comment: alertMsg)
                    let alertController = UIAlertController(title: "AVCam", message: message, preferredStyle: .alert)
                    
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),
                                                            style: .cancel,
                                                            handler: nil))
                    
                    if let popoverController = alertController.popoverPresentationController {
                        popoverController.sourceView = self.hostViewController.view
                        popoverController.sourceRect = CGRect(x: self.hostViewController.view.bounds.midX, y: self.hostViewController.view.bounds.midY, width: 0, height: 0)
                        popoverController.permittedArrowDirections = []
                    }
                    self.hostViewController.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    private let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera, .builtInDualWideCamera],
                                                                               mediaType: .video, position: .unspecified)
    func tenBitVariantOfFormat(activeFormat: AVCaptureDevice.Format) -> AVCaptureDevice.Format? {
        let formats = self.videoDeviceInput.device.formats
        let formatIndex = formats.firstIndex(of: activeFormat)
        
        let activeDimensions = CMVideoFormatDescriptionGetDimensions(activeFormat.formatDescription)
        let activeMaxFrameRate = activeFormat.videoSupportedFrameRateRanges.last?.maxFrameRate
        let activePixelFormat = CMFormatDescriptionGetMediaSubType(activeFormat.formatDescription)
        
        /*
         AVCaptureDeviceFormats are sorted from smallest to largest in resolution and frame rate.
         For each resolution and max frame rate there's a cluster of formats that only differ in pixelFormatType.
         Here, we're looking for an 'x420' variant of the current activeFormat.
         */
        if activePixelFormat != kCVPixelFormatType_420YpCbCr10BiPlanarVideoRange {
            // Current activeFormat is not a 10-bit HDR format, find its 10-bit HDR variant.
            for index in (formatIndex ?? 0) + 1..<formats.count {
                let format = formats[index]
                let dimensions = CMVideoFormatDescriptionGetDimensions(format.formatDescription)
                let maxFrameRate = format.videoSupportedFrameRateRanges.last?.maxFrameRate
                let pixelFormat = CMFormatDescriptionGetMediaSubType(format.formatDescription)
                
                // Don't advance beyond the current format cluster
                if activeMaxFrameRate != maxFrameRate || activeDimensions.width != dimensions.width || activeDimensions.height != dimensions.height {
                    break
                }
                
                if pixelFormat == kCVPixelFormatType_420YpCbCr10BiPlanarVideoRange {
                    return format
                }
            }
        } else {
            return activeFormat
        }
        
        return nil
    }
    func previewWillDisappear() {
        sessionQueue.async {
            if self.setupResult == .success {
                self.session.stopRunning()
                self.isSessionRunning = self.session.isRunning
                self.removeObservers()
                self.timer?.invalidate()
                self.count = 1
                self.timer = nil
            }
        }
    }
    
    // MARK: - KVO and Notifications
    private var keyValueObservations = [NSKeyValueObservation]()
    /// - Tag: ObserveInterruption
    private func addObservers() {
        let keyValueObservation = session.observe(\.isRunning, options: .new) { _, change in
            guard let isSessionRunning = change.newValue else { return }
            
            //DispatchQueue.main.async {
                // Only enable the ability to change camera if the device has more than one camera.
                //                self.recordButton.isEnabled = isSessionRunning && self.movieFileOutput != nil
            //}
        }
        keyValueObservations.append(keyValueObservation)
        
        let systemPressureStateObservation = observe(\.videoDeviceInput.device.systemPressureState, options: .new) { _, change in
            guard let systemPressureState = change.newValue else { return }
            self.setRecommendedFrameRateRangeForPressureState(systemPressureState: systemPressureState)
        }
        keyValueObservations.append(systemPressureStateObservation)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(subjectAreaDidChange),
                                               name: .AVCaptureDeviceSubjectAreaDidChange,
                                               object: videoDeviceInput.device)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(sessionRuntimeError),
                                               name: .AVCaptureSessionRuntimeError,
                                               object: session)
        
        /*
         A session can only run when the app is full screen. It will be interrupted
         in a multi-app layout, introduced in iOS 9, see also the documentation of
         AVCaptureSessionInterruptionReason. Add observers to handle these session
         interruptions and show a preview is paused message. See the documentation
         of AVCaptureSessionWasInterruptedNotification for other interruption reasons.
         */
        
    }
    
    
    /// - Tag: HandleSystemPressure
    private func setRecommendedFrameRateRangeForPressureState(systemPressureState: AVCaptureDevice.SystemPressureState) {
        /*
         The frame rates used here are only for demonstration purposes.
         Your frame rate throttling may be different depending on your app's camera configuration.
         */
        let pressureLevel = systemPressureState.level
        if pressureLevel == .serious || pressureLevel == .critical {
            if self.movieFileOutput == nil || self.movieFileOutput?.isRecording == false {
                do {
                    try self.videoDeviceInput.device.lockForConfiguration()
                    print("WARNING: Reached elevated system pressure level: \(pressureLevel). Throttling frame rate.")
                    self.videoDeviceInput.device.activeVideoMinFrameDuration = CMTime(value: 1, timescale: 20)
                    self.videoDeviceInput.device.activeVideoMaxFrameDuration = CMTime(value: 1, timescale: 15)
                    self.videoDeviceInput.device.unlockForConfiguration()
                } catch {
                    print("Could not lock device for configuration: \(error)")
                }
            }
        } else if pressureLevel == .shutdown {
            print("Session stopped running due to shutdown system pressure level.")
        }
    }
    
    /// - Tag: HandleRuntimeError
    @objc
    func sessionRuntimeError(notification: NSNotification) {
        guard let error = notification.userInfo?[AVCaptureSessionErrorKey] as? AVError else { return }
        
        print("Capture session runtime error: \(error)")
        // If media services were reset, and the last start succeeded, restart the session.
        if error.code == .mediaServicesWereReset {
            sessionQueue.async {
                if self.isSessionRunning {
                    self.session.startRunning()
                    self.isSessionRunning = self.session.isRunning
                } else {
                    //                    DispatchQueue.main.async {
                    //                        self.resumeButton.isHidden = false
                    //                    }
                }
            }
        } else {
            //            resumeButton.isHidden = false
        }
    }
    @objc
    func subjectAreaDidChange(notification: NSNotification) {
        //let devicePoint = CGPoint(x: 0.5, y: 0.5)
        //  focus(with: .continuousAutoFocus, exposureMode: .continuousAutoExposure, at: devicePoint, monitorSubjectAreaChange: false)
    }
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self)
        
        for keyValueObservation in keyValueObservations {
            keyValueObservation.invalidate()
        }
        keyValueObservations.removeAll()
    }
    
    func playVideoButtonTapped() {
        showLoader()
        DispatchQueue.main.async {
            AVMutableComposition().mergeVideo(self.outputFilePathArray) { outputUrl, error in
                hideLoader()
                print(outputUrl as Any)
                if let url = outputUrl {
                    self.recordingMergeFileURL = outputUrl
                    if self.videoPlayer != nil {
                        self.videoPlayer.videoURLs = [url]
                        self.videoPlayer.configuration = ASPVideoPlayer.Configuration(videoGravity: .aspectFit, shouldLoop: false, startPlayingWhenReady: true, controlsInitiallyHidden: false, allowBackgroundPlay: false)
                    }
                }
            }
//            self.videoPlayer.videoURLs = [self.recordingFileURL!]
//            self.videoPlayer.configuration = ASPVideoPlayer.Configuration(videoGravity: .resize, shouldLoop: false, startPlayingWhenReady: true, controlsInitiallyHidden: false, allowBackgroundPlay: false)
        }
    }
    
  
    func pauseButtonTapped() {
        DispatchQueue.main.async {
            guard let movieFileOutput = self.movieFileOutput else {
                return
            }
            if self.resumeTapped == false {
                self.pauseButton.setImage(UIImage(named: "Ic_play"), for: .normal)
                self.pauseLabel.text = "Play"
                self.timer?.invalidate()
                self.timer = nil
                self.resumeTapped = true
                self.sessionQueue.async {
                    if movieFileOutput.isRecording {
                        movieFileOutput.stopRecording()
                    }
                }
            } else {
                self.resumeTapped = false
                self.pauseButton.setImage(UIImage(named: "Ic_pause"), for: .normal)
                self.pauseLabel.text = "Pause"
                self.recordButtonTapped()
            }
        }
    }
    
    func recordButtonTapped(_ result:@escaping(String) -> Void){
        guard let movieFileOutput = self.movieFileOutput else {
                return
            }
            
        guard let videoPreviewLayerOrientation = previewView.videoPreviewLayer.connection?.videoOrientation else { return }
            
            sessionQueue.async {
                if !movieFileOutput.isRecording {
                    self.runTimer()
                    
                    if UIDevice.current.isMultitaskingSupported {
                        self.backgroundRecordingID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
                    }
                    
                    // Update the orientation on the movie file output video connection before recording.
                    let movieFileOutputConnection = movieFileOutput.connection(with: .video)
                    movieFileOutputConnection?.videoOrientation = videoPreviewLayerOrientation
                    
                    let availableVideoCodecTypes = movieFileOutput.availableVideoCodecTypes
                    
                    if availableVideoCodecTypes.contains(.hevc) {
                        movieFileOutput.setOutputSettings([AVVideoCodecKey: AVVideoCodecType.hevc], for: movieFileOutputConnection!)
                    }
                    
                    // Start recording video to a temporary file.
                    let outputFileName = NSUUID().uuidString
                    let outputFilePath = (NSTemporaryDirectory() as NSString).appendingPathComponent((outputFileName as NSString).appendingPathExtension("mov") ?? "")
                   
                    self.outputFilePathArray.append(URL(fileURLWithPath: outputFilePath))
                    movieFileOutput.startRecording(to: URL(fileURLWithPath: outputFilePath), recordingDelegate: self)
                    
                    self.runTimer()
                    result("record_success")
                } else {
                    DispatchQueue.main.async {
                        if self.count < 10{
                            showMessage(with: ValidationError.recordVideoForTenSec)
                        }else{
                            movieFileOutput.stopRecording()
                            self.timer?.invalidate()
                            self.timer = nil
                            self.videoPlayer.videoPlayerControls.pause()
                            self.videoPlayer.videoPlayerControls.stop()
//                            self.session.stopRunning()
//                            self.isSessionRunning = self.session.isRunning
                            result("stop_success")
                        }
                    }
                    
                    //videoPlayer.stopVideo()
                }
            }
    }
    
    func recordButtonTapped() {
        if previewView != nil {
            guard let movieFileOutput = self.movieFileOutput else {
                return
            }
            
            guard let videoPreviewLayerOrientation = previewView.videoPreviewLayer.connection?.videoOrientation else { return }
            
            sessionQueue.async {
                if !movieFileOutput.isRecording {
                    self.runTimer()
                    
                    if UIDevice.current.isMultitaskingSupported {
                        self.backgroundRecordingID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
                    }
                    
                    // Update the orientation on the movie file output video connection before recording.
                    let movieFileOutputConnection = movieFileOutput.connection(with: .video)
                    movieFileOutputConnection?.videoOrientation = videoPreviewLayerOrientation
                    
                    let availableVideoCodecTypes = movieFileOutput.availableVideoCodecTypes
                    
                    if availableVideoCodecTypes.contains(.hevc) {
                        movieFileOutput.setOutputSettings([AVVideoCodecKey: AVVideoCodecType.hevc], for: movieFileOutputConnection!)
                    }
                    
                    // Start recording video to a temporary file.
                    let outputFileName = NSUUID().uuidString
                    let outputFilePath = (NSTemporaryDirectory() as NSString).appendingPathComponent((outputFileName as NSString).appendingPathExtension("mov") ?? "")
                    self.outputFilePathArray.append(URL(fileURLWithPath: outputFilePath))
                    movieFileOutput.startRecording(to: URL(fileURLWithPath: outputFilePath), recordingDelegate: self)
                    self.runTimer()
                    
                } else {
                    movieFileOutput.stopRecording()
                    self.videoPlayer.videoPlayerControls.pause()
                    self.videoPlayer.videoPlayerControls.stop()
                    //videoPlayer.stopVideo()
                }
            }
        }
    }
    
    func runTimer() {
        DispatchQueue.main.async {
            if self.timer == nil {
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self,   selector: #selector(VerifyKYCViewModel.updateCounter), userInfo: nil, repeats: true)
            }
        }
    }

    @objc func updateCounter() {
        DispatchQueue.main.async {
            print(self.count)
            
            if self.count != 0{
                if self.timeLabel != nil {
                    self.timeLabel.text = self.timeFormatted(self.count)
                }
            }
            if self.count < 30 {
                self.count += 1  
            } else {
                showLoader()
                DispatchQueue.main.async {
                    self.timer?.invalidate()
                    self.timer = nil
                    self.count = 1
                    self.recordButtonTapped()
                    if self.pauseStopStackView != nil {
                        self.pauseStopStackView.isHidden = true
                        self.recordStackView.isHidden = true
                        self.bottomStackView.isHidden = false
                        self.finishView.isHidden = false
                        self.recordInstructionView.isHidden = true
                        self.record2InstructionView.isHidden = true
                        self.playButton.isHidden = false
                        self.videoPlayer.isHidden = false
                        self.buttonView.isHidden = true
                        self.timeLabel.isHidden = true
                        self.previewView.isHidden = true
                    }
                    delay(1){
                        hideLoader()
                    }
                }
            }
        }
    }
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func submitRecordButtonTapped(_ result:@escaping(String) -> Void){
        DispatchQueue.main.async {
            showProgressLoader(text: "Processing...")
        }
        
        DispatchQueue.main.async {
            AVMutableComposition().mergeVideo(self.outputFilePathArray) { outputUrl, error in
                print(outputUrl as Any)
                self.recordingMergeFileURL = outputUrl
                
                let folderName = KAPPSTORAGE.userPicDirectoryName
                let videoName: String = UIFunction.getRandomVideoName(videoExtension: "mp4")
                let fileManager = FileManager.default
                do {
                    let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let fileURL = documentDirectory.appendingPathComponent(videoName)
                    
                    do {
                        let imageData = try Data(contentsOf: self.recordingMergeFileURL! as URL)
                        try imageData.write(to: fileURL)
                        
                        print("File size before compression: \(Double(imageData.count / 1048576)) mb")
                        
                        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + UUID().uuidString + ".mp4")
                        self.compressVideo(inputURL: self.recordingMergeFileURL! as URL,
                                      outputURL: compressedURL) { exportSession in
                            guard let session = exportSession else {
                                return
                            }
                            switch session.status {
                            case .unknown:
                                break
                            case .waiting:
                                break
                            case .exporting:
                                break
                            case .completed:
                                guard let compressedData = try? Data(contentsOf: compressedURL) else { return }
                                print("File size after compression: \(Double(compressedData.count / 1048576)) mb")
                                let vid = NSString(format: "%@", videoName as CVarArg) as String
                                let uploadUrlParams = ["directory": folderName, "fileName": vid, "contentType": "video/mp4"]
                                self.uploadURLsApi(uploadUrlParams) { (model) in
                                    let videoFileName = model?.data?.fileName ?? ""
                                    self.uploadVideo(model?.data?.uploadURL ?? "", videoData: compressedData) { status in
                                        if status == "success"{
                                            let dict = NSMutableDictionary()
                                            dict["file"] = videoFileName
                                            dict["type"] = "mp4"
                                            self.registerApiCall(kyc: dict) { status in
                                                if status == "success" {
                                                    result("success")
                                                }
                                            }
                                        } else {
                                            hideLoader()
                                        }
                                    }
                                }
                            case .failed:
                                break
                            case .cancelled:
                                break
                            @unknown default: break
                            }
                        }
                        
                    } catch {
                        print("Unable to load data: \(error)")
                    }
                } catch {}
                
            }
        }
    }
    
    func registerApiCall(kyc:NSDictionary, _ result:@escaping(String) -> Void){
        let params = ["kycVideo": kyc] as [String : Any]
        processForRegisterApiData(params: params) { status in
            if status == "success" {
                result("success")
            }
        }
    }
    
    // MARK: - API Call...
    func processForRegisterApiData(params: [String: Any], _ result:@escaping(String) -> Void) {
       // showLoader()
        ApiManager.makeApiCall(APIUrl.UserApis.registerUser,
                               params: params,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .put) { response, _ in
                                if !self.hasErrorIn(response) {
                                    _ = response![APIConstants.data] as! [String: Any]
                                    result("success")
                                    hideLoader()
                                }
            
                                //showSuccessLoader()
        }
    }
    // MARK: -  Upload Url
    func uploadURLsApi(_ params: [String:Any],_ result:@escaping(UploadUrlResponseModel?) -> Void) {
        ApiManagerWithCodable<UploadUrlResponseModel>.makeApiCall(APIUrl.BasicApis.uploadImage,
                                                                  params: params,
                                                                  headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                                                                  method: .post) { (response, model) in

            if model?.statusCode == 200 {
                result(model)
            } else {
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    func uploadVideo(_ videoURL: String, videoData: Data, _ result:@escaping(String?) -> Void) {
        let url = URL(string: videoURL)
        var request: NSMutableURLRequest? = nil
        if let url = url {
            request = NSMutableURLRequest(url: url)
        }
        
        request?.httpBody = videoData
       // request?.setValue("public-read", forHTTPHeaderField: "x-amz-acl")
        request?.setValue("video/mp4", forHTTPHeaderField: "Content-Type")
        request?.httpMethod = "PUT"
        let session = URLSession.shared
        let task1 = session.uploadTask(with: request! as URLRequest, from: videoData) { _ , response, error in
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
// MARK: - AVCaptureFileOutputRecordingDelegate

extension VerifyKYCViewModel : AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        // Enable the Record button to let the user stop recording.
       
    }
    
    func fileOutput(_ output: AVCaptureFileOutput,
                    didFinishRecordingTo outputFileURL: URL,
                    from connections: [AVCaptureConnection],
                    error: Error?) {
        // Note: Because we use a unique file path for each recording, a new recording won't overwrite a recording mid-save.
        func cleanup() {
            let path = outputFileURL.path
            if FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch {
                    print("Could not remove file at url: \(outputFileURL)")
                }
            }
            
            if let currentBackgroundRecordingID = backgroundRecordingID {
                backgroundRecordingID = UIBackgroundTaskIdentifier.invalid
                
                if currentBackgroundRecordingID != UIBackgroundTaskIdentifier.invalid {
                    UIApplication.shared.endBackgroundTask(currentBackgroundRecordingID)
                }
            }
        }
        
        var success = true
        
        if error != nil {
            print("Movie file finishing error: \(String(describing: error))")
            success = false
        }
        
        if success {
            print(outputFileURL)
            self.recordingFileURL = outputFileURL
            
//            // Check the authorization status.
//            PHPhotoLibrary.requestAuthorization { status in
//                if status == .authorized {
//                    // Save the movie file to the photo library and cleanup.
//                    PHPhotoLibrary.shared().performChanges({
//                        let options = PHAssetResourceCreationOptions()
//                        options.shouldMoveFile = true
//                        let creationRequest = PHAssetCreationRequest.forAsset()
//                        creationRequest.addResource(with: .video, fileURL: outputFileURL, options: options)
//
//                    }, completionHandler: { success, error in
//                        if !success {
//                            print("AVCam couldn't save the movie to your photo library: \(String(describing: error))")
//                        }
//                        cleanup()
//                    }
//                    )
//                } else {
//                    cleanup()
//                }
//            }
        } else {
            cleanup()
        }
        
       
    }
    
    func compressVideo(inputURL: URL,
                           outputURL: URL,
                       handler:@escaping (_ exportSession: AVAssetExportSession?) -> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset,
                                                       presetName: AVAssetExportPresetMediumQuality) else {
            handler(nil)
            
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        exportSession.exportAsynchronously {
            handler(exportSession)
        }
    }
    
}

// MARK: - Session Management
private enum SessionSetupResult {
    case success
    case notAuthorized
    case configurationFailed
}


extension AVCaptureVideoOrientation {
    init?(deviceOrientation: UIDeviceOrientation) {
        switch deviceOrientation {
        case .portrait: self = .portrait
        case .portraitUpsideDown: self = .portraitUpsideDown
        case .landscapeLeft: self = .landscapeRight
        case .landscapeRight: self = .landscapeLeft
        default: return nil
        }
    }
    
    init?(interfaceOrientation: UIInterfaceOrientation) {
        switch interfaceOrientation {
        case .portrait: self = .portrait
        case .portraitUpsideDown: self = .portraitUpsideDown
        case .landscapeLeft: self = .landscapeLeft
        case .landscapeRight: self = .landscapeRight
        default: return nil
        }
    }
}
extension VerifyKYCViewModel: ASPVideoPlayerViewDelegate {
    func startedVideo() {
        print("Started video")
    }

    func stoppedVideo() {
        print("Stopped video")
    }

    func newVideo() {
        print("New Video")
    }

    func readyToPlayVideo() {
        print("Ready to play video")
    }

    func playingVideo(progress: Double) {
//        print("Playing: \(progress)")
    }

    func pausedVideo() {
        print("Paused Video")
    }

    func finishedVideo() {
        print("Finished Video")
    }

    func seekStarted() {
        print("Seek started")
    }

    func seekEnded() {
        print("Seek ended")
    }

    func error(error: Error) {
        print("Error: \(error)")
    }

    func willShowControls() {
        print("will show controls")
    }

    func didShowControls() {
        print("did show controls")
    }

    func willHideControls() {
        print("will hide controls")
    }

    func didHideControls() {
        print("did hide controls")
        
    }
}

