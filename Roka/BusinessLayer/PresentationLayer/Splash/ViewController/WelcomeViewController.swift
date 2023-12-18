//
//  WelcomeViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 18/07/23.
//

import UIKit
import AVFoundation
class WelcomeViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.splash
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.welcome
    }

    // MARK: - Outlets...
    @IBOutlet weak var playerView: UIView!
    

    // MARK: - Variables...
    lazy var viewModel: WelcomeViewModel = WelcomeViewModel(hostViewController: self)
    var videoPlayer: AVPlayer?
    var playerLayer: AVPlayerLayer?

    // MARK: - Initailize ViewModel...
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: Notification.Name("appEnterForeground"), object: nil)

        
        // foreground event
        NotificationCenter.default.addObserver(self, selector: #selector(reinitializePlayerLayer), name: UIApplication.willEnterForegroundNotification, object: nil)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playFullScreenVideo()
        viewModel.processForGetVersionData()
    }
    
    deinit { NotificationCenter.default.removeObserver(self) }

    @objc private func didBecomeActive() {
    }
    // foreground event
    @objc fileprivate func reinitializePlayerLayer() {
        if let player = videoPlayer {
            playerLayer = AVPlayerLayer(player: player)
            if player.timeControlStatus == .paused {
                player.play()
            } else {
                player.play()
            }
        }
    }
    
    private func playFullScreenVideo() {
        guard let path = Bundle.main.path(forResource: "Roka login screen animation", ofType:"mp4") else {
            debugPrint("Roka login screen animation.mp4 missing")
            return
        }
        videoPlayer = AVPlayer(url: URL(fileURLWithPath: path))
        playerLayer = AVPlayerLayer(player: videoPlayer)
        playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
        playerLayer?.frame = view.bounds
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoPlayer?.currentItem)
        
        playerView.layer.addSublayer(playerLayer!)
        videoPlayer?.play()
      }
    
    @objc func playerDidFinishPlaying(_ notification: NSNotification) {
        videoPlayer?.seek(to: CMTime.zero)
        videoPlayer?.play()
    }
    

    @IBAction func registerButtonAction(_ sender: UIButton) {
        KAPPDELEGATE.initializeNavigationBar()
        viewModel.proceedToModeSelectionScreen()
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        KAPPDELEGATE.initializeNavigationBar()
        viewModel.proceedToLoginScreen()
    }
    
}
