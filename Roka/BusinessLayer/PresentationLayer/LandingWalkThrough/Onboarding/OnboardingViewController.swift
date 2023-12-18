//
//  OnboardingViewController.swift
//  Yummie
//
//  Created by Emmanuel Okwara on 30/01/2021.
//

import UIKit

struct OnboardingSlide {
    let image: UIImage?
}


class OnboardingViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.landingWalkThrough
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.onboarding
    }

    lazy var viewModel: OnboardingViewModel = OnboardingViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = false,
                    isComeFor:String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! OnboardingViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var bigNextButton: UIButton!
    @IBOutlet weak var bigNextButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var buttonsStackView: UIStackView!
    
    var slides: [OnboardingSlide] = []
    
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                nextBtn.setTitle("Finish", for: .normal)
            } else {
                nextBtn.setTitle("Next", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonsStackView.isHidden = true
        bigNextButton.isHidden = false
        
        if viewModel.isComeFor == "MatchMaking" {
            slides = [OnboardingSlide(image: UIImage(named: "MatchSlide1")),
                      OnboardingSlide(image: UIImage(named: "MatchSlide2")),
                      OnboardingSlide(image: UIImage(named: "MatchSlide3")),
                      OnboardingSlide(image: UIImage(named: "MatchSlide4")),
                      OnboardingSlide(image: UIImage(named: "MatchSlide5")),
                      OnboardingSlide(image: UIImage(named: "MatchSlide6"))]
        } else {
            slides = [OnboardingSlide(image: UIImage(named: "Slide1")),
                      OnboardingSlide(image: UIImage(named: "Slide2")),
                      OnboardingSlide(image: UIImage(named: "Slide3")),
                      OnboardingSlide(image: UIImage(named: "Slide4"))]
        }
        pageControl.numberOfPages = slides.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func bigNextButtonClicked(_ sender: UIButton) {
        if currentPage == 0 {
            animateNextButton(width: nextBtn.bounds.width)
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    func animateNextButton(width: CGFloat) {
        buttonsStackView.alpha = 0
        bigNextButtonWidth.constant = width
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.buttonsStackView.transform = .identity
            self.buttonsStackView.alpha = 1
            self.buttonsStackView.isHidden = false
            self.bigNextButton.isHidden = true
        })
    }
    
    func animatePrevoiusButton(width: CGFloat) {
        bigNextButton.isHidden = false
        buttonsStackView.isHidden = true
        self.bigNextButtonWidth.constant = width

        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.bigNextButton.transform = .identity
            self.bigNextButton.alpha = 1
        })
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func skipButtonClicked(_ sender: UIButton) {
        viewModel.proceedToRegisterScreen(registerFor: viewModel.isComeFor)
    }
    
    @IBAction func nextBtnClicked(_ sender: UIButton) {
        if currentPage == slides.count - 1 {
            print("... finished ...")
            viewModel.proceedToRegisterScreen(registerFor: viewModel.isComeFor)
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    @IBAction func previousBtnClicked(_ sender: Any) {
        if currentPage == 1 {
            currentPage -= 1
            animatePrevoiusButton(width: buttonsStackView.bounds.width)
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else {
            currentPage -= 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        if currentPage == 0 {
            animatePrevoiusButton(width: buttonsStackView.bounds.width)
           
        } else if currentPage == 1 {
            animateNextButton(width: nextBtn.bounds.width)
        }
    }
}
