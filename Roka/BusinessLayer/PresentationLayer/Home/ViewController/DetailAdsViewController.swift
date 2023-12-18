//
//  DetailAdsViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 09/01/23.
//

import UIKit

class DetailAdsViewController: BaseAlertViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.home
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.detailAdsView
    }

    lazy var viewModel: DetailAdsViewModel = DetailAdsViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(over host: UIViewController,
                    completionHandler: @escaping ((String) -> Void)) {
        let controller = self.getController() as! DetailAdsViewController
        controller.show(over: host, completionHandler: completionHandler)
    }
    
    func show(over host: UIViewController,
              completionHandler: @escaping ((String) -> Void)) {
        viewModel.completionHandler = completionHandler
        show(over: host)
    }
    var bannerView = ISBannerView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        DispatchQueue.main.async {
            self.setupIronSourceSdk()
            self.initBannerAdsView()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        distroyBanner()
    }
    
    @IBAction func crossButtonAction(_ sender: UIButton) {
        self.dismiss()
    }
    

}
// MARK: - ISBannerDelegate Functions

extension DetailAdsViewController : ISBannerDelegate, ISInitializationDelegate, ISImpressionDataDelegate {
    
    func distroyBanner() {
        DispatchQueue.main.async {
           // if self.bannerView != nil {
                IronSource.destroyBanner(self.bannerView)
            //}
        }
    }
    
    func initializationDidComplete() {
        logFunctionName()
    }
    
    func setupIronSourceSdk() {
        ISIntegrationHelper.validateIntegration()
        IronSource.setBannerDelegate(self)
        IronSource.add(self)
        
        //IronSource.initWithAppKey(kAPPKEY, delegate: self)
        // To initialize specific ad units:
        IronSource.initWithAppKey(kAPPKEY, adUnits: [IS_BANNER])
    }
    
    func initBannerAdsView() {
        let BNSize: ISBannerSize = ISBannerSize(description: "RECTANGLE", width:300, height:250)
        IronSource.loadBanner(with: self, size: BNSize)
    }
    
    func logFunctionName(string: String = #function) {
        print("IronSource Swift Demo App: "+string)
    }
    
    func bannerDidLoad(_ bannerView: ISBannerView!) {
        self.bannerView = bannerView
        if #available(iOS 11.0, *) {
            bannerView.frame = CGRect(x: self.view.frame.size.width/2 - bannerView.frame.size.width/2, y:self.view.frame.size.height/2 - (self.bannerView.frame.size.height / 2), width: bannerView.frame.size.width, height: bannerView.frame.size.height - self.view.safeAreaInsets.bottom * 2.5)
        } else {
            bannerView.frame = CGRect(x: self.view.frame.size.width/2 - bannerView.frame.size.width/2, y: self.view.frame.size.height/2 - (self.bannerView.frame.size.height / 2), width: bannerView.frame.size.width, height: bannerView.frame.size.height  * 2.5)
        }
     
      
        self.view.addSubview(bannerView)
        logFunctionName()
    }
    
    func bannerDidFailToLoadWithError(_ error: Error!) {
        logFunctionName(string: #function+String(describing: Error.self))
        
    }
    
    func didClickBanner() {
        logFunctionName()
    }
    
    func bannerWillPresentScreen() {
        logFunctionName()
    }
    
    func bannerDidDismissScreen() {
        logFunctionName()
    }
    
    func bannerWillLeaveApplication() {
        logFunctionName()
    }
    
    // MARK: - ISImpressionData Functions
    func impressionDataDidSucceed(_ impressionData: ISImpressionData!) {
        logFunctionName(string: #function+String(describing: impressionData))

    }
}
