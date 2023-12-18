//
//  SplashViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 19/09/22.
//

import UIKit
import AVFoundation
class SplashViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.splash
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.splash
    }

    // MARK: - Outlets...
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet weak var playerView: UIView!
    

    // MARK: - Variables...
    private var animationDuration: Double = 1
    lazy var viewModel: SplashViewModel = SplashViewModel(hostViewController: self)
    
    var videoPlayer: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    // MARK: - Initailize ViewModel...
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

       // logoImageView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        logoImageView.alpha = 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: Notification.Name("appEnterForeground"), object: nil)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting audio session category: \(error.localizedDescription)")
        }

        // foreground event
        NotificationCenter.default.addObserver(self, selector: #selector(reinitializePlayerLayer), name: UIApplication.willEnterForegroundNotification, object: nil)

           
        // Do any additional setup after loading the view.
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
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    @objc private func didBecomeActive() {
        // animations were disturbed, now fix views positions without animation
        animationDuration = 0
        performAnimtaion()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playFullScreenVideo()
       // delay(1) { self.performAnimtaion() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear call")
    }
    
    private func playFullScreenVideo() {
        guard let path = Bundle.main.path(forResource: "Welcome_screen_Roka_video", ofType:"mp4") else {
            debugPrint("Welcome_screen_Roka_video.mp4 missing")
            return
        }
        videoPlayer = AVPlayer(url: URL(fileURLWithPath: path))
        playerLayer = AVPlayerLayer(player: videoPlayer)
        playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
        playerLayer?.frame = self.view.frame
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoPlayer?.currentItem)
        
        playerView.layer.addSublayer(playerLayer!)
        videoPlayer?.play()
      }
    
    @objc func playerDidFinishPlaying(_ notification: NSNotification) {
        // Your code here
        self.viewModel.checkCompleteProfileStatus()
    }
    
    private func performAnimtaion() {
        UIView.animate(withDuration: animationDuration) {
            self.logoImageView.transform = .identity
            self.logoImageView.alpha = 1
            
        } completion: { finished in
            if finished {
                self.viewModel.checkCompleteProfileStatus()
            }
        }
    }
   
}
