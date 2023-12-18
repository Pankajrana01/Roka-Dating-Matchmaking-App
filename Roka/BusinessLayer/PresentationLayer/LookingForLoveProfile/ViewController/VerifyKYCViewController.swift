//
//  VerifyKYCViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 22/09/22.
//

import UIKit
import AVFoundation
import Photos
import ASPVideoPlayer
class VerifyKYCViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.lookingForLoveProfile
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.verifyKYC
    }

    lazy var viewModel: VerifyKYCViewModel = VerifyKYCViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor: String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! VerifyKYCViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.hidesBottomBarWhenPushed = true
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    @IBOutlet weak var videoPlayer: ASPVideoPlayer!
    @IBOutlet weak var previewView: PreviewView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var recordStackView: UIStackView!
    @IBOutlet weak var pauseStopStackView: UIStackView!
    @IBOutlet weak var recordInstructionView: UIView!
    @IBOutlet weak var record2InstructionView: UIView!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var finishView: UIView!
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var successKycView: UIView!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var pauseLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var buttonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
       // showNavigationBackButton(title: StringConstants.verifyKYC)
        initViews()
        //videoPlayer.delegate = viewModel.self
        // Do any additional setup after loading the view.
    }
    func initViews() {
        viewModel.previewView = previewView
        viewModel.timeLabel = timeLabel
        viewModel.videoPlayer = videoPlayer
        viewModel.recordStackView = recordStackView
        viewModel.pauseStopStackView = pauseStopStackView
        viewModel.recordInstructionView = recordInstructionView
        viewModel.record2InstructionView = record2InstructionView
        viewModel.bottomStackView = bottomStackView
        viewModel.finishView = finishView
        viewModel.successKycView = successKycView
        viewModel.playButton = playButton
        viewModel.pauseButton = pauseButton
        viewModel.pauseLabel = pauseLabel
        viewModel.buttonView = buttonView
        
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.addNavigationBackButton()
            self.title = "Verify video"
            self.initViews()
            self.startupView()
            self.viewModel.initialPreviewView()
            self.viewModel.previewWillAppear()
        }
    
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: .appBecomeInactive, object: nil)
        
    }
    
    func addNavigationBackButton() {
        let btn2 = UIButton()
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn2.setImage(UIImage(named: "ic_back_white"), for: .normal)
        btn2.addTarget(self, action: #selector(backkButtonTapped(_:)), for:.touchUpInside)
        let barButton = UIBarButtonItem(customView: btn2)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func backkButtonTapped(_ sender: UIButton){
       self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.previewWillDisappear()
        super.viewWillDisappear(animated)
        
    }
    
    @objc func appMovedToBackground() {
        print("App moved to background!")
        DispatchQueue.main.async {
            self.timeLabel.text = "00:00"
            self.viewModel.count = 1
            self.viewModel.timer?.invalidate()
            self.viewModel.timer = nil
            self.viewModel.videoPlayer.videoPlayerControls.pause()
            self.viewModel.videoPlayer.videoPlayerControls.stop()
            self.viewModel.outputFilePathArray.removeAll()
            self.initViews()
            self.startupView()
            self.viewModel.initialPreviewView()
        }
    }
    
    
    func startupView() {
        self.timeLabel.isHidden = true
        self.pauseStopStackView.isHidden = true
        self.recordStackView.isHidden = false
        self.bottomStackView.isHidden = true
        self.finishView.isHidden = true
        self.recordInstructionView.isHidden = false
        self.record2InstructionView.isHidden = true
        self.blackView.isHidden = true
        self.successKycView.isHidden = true
        self.blackView.alpha = 0
        self.successKycView.alpha = 0
        self.playButton.isHidden = true
        self.videoPlayer.isHidden = true
        self.buttonView.isHidden = false
        self.previewView.isHidden = false
        self.timeLabel.text = "00:00"
        viewModel.count = 1
        viewModel.timer?.invalidate()
        viewModel.timer = nil
        
    }
    
    @IBAction func recordButtonAction(_ sender: UIButton) {
        viewModel.recordButtonTapped { status in
            if status == "record_success" {
                DispatchQueue.main.async {
                    self.pauseStopStackView.isHidden = false
                    self.recordStackView.isHidden = true
                    self.bottomStackView.isHidden = true
                    self.finishView.isHidden = true
                    self.timeLabel.isHidden = false
                    self.recordInstructionView.isHidden = true
                    self.record2InstructionView.isHidden = false
                    self.playButton.isHidden = true
                    self.videoPlayer.isHidden = true
                    self.buttonView.isHidden = false
                }
            }
        }
    }
    
    @IBAction func pauseButtonAction(_ sender: UIButton) {
        viewModel.pauseButtonTapped()
    }
    
    @IBAction func playButtonAction(_ sender: UIButton) {
        self.pauseStopStackView.isHidden = true
        self.recordStackView.isHidden = true
        self.bottomStackView.isHidden = false
        self.finishView.isHidden = false
        self.timeLabel.isHidden = true
        self.recordInstructionView.isHidden = true
        self.record2InstructionView.isHidden = true
        self.playButton.isHidden = true
        self.videoPlayer.isHidden = false
        self.buttonView.isHidden = true
        self.previewView.isHidden = true
        viewModel.playVideoButtonTapped()
        //viewModel.mergeMultipleVideos()
    }
    @IBAction func stopButtonAction(_ sender: UIButton) {
        viewModel.recordButtonTapped { status in
            if status == "stop_success" {
                DispatchQueue.main.async {
                    showLoader()
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
                    hideLoader()
                }
            }
        }
    }
    
    @IBAction func recordAgain(_ sender: UIButton) {
        showLoader()
        DispatchQueue.main.async {
            self.viewModel.videoPlayer.videoPlayerControls.pause()
            self.viewModel.videoPlayer.videoPlayerControls.stop()
            self.viewModel.outputFilePathArray.removeAll()
            self.initViews()
            self.startupView()
            self.viewModel.initialPreviewView()
            delay(1){
                hideLoader()
            }
        }
    
//        DispatchQueue.global(qos: .background).async { [self] in
//            viewModel.session.startRunning()
//            viewModel.isSessionRunning = viewModel.session.isRunning
//        }
    }
    
    @IBAction func submitAction(_ sender: Any) {
        if viewModel.videoPlayer != nil {
            viewModel.videoPlayer.videoPlayerControls.pause()
            viewModel.videoPlayer.videoPlayerControls.stop()
            viewModel.submitRecordButtonTapped { status in
                if status == "success" {
                    UIView.animate(withDuration: 1) {
                        self.blackView.isHidden = false
                        self.successKycView.isHidden = false
                        self.successKycView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                        self.successKycView.center = self.view.center
                        
                        self.blackView.transform = .identity
                        self.successKycView.transform = .identity
                        self.blackView.alpha = 0.5
                        self.successKycView.alpha = 1
                        self.navigationController?.navigationBar.isUserInteractionEnabled = false
                        
                    } completion: { _ in
                        delay(2){
                            self.navigationController?.navigationBar.isUserInteractionEnabled = true
                            self.viewModel.proceedForCreateProfileStepFive()
                        }
                    }
                }
            }
        }
    }
    
}


