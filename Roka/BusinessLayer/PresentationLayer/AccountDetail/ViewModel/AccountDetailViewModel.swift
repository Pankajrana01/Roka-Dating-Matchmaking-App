//
//  AccountDetailViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 29/10/22.
//

import Foundation
import UIKit
import Swifter
import SafariServices
import WebKit

class AccountDetailViewModel: BaseViewModel {
    var isComeFor = ""
    var completionHandler: ((Bool) -> Void)?
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    
    var profileArr: [ProfilesModel] = []
    var userResponse = [String:Any]()
    var linkedInLink = ""
    var instagramLink = ""
    var twiiterLink = ""

    var webView = WKWebView()
    
    weak var tableView: UITableView! { didSet { configureTableView() } }
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: AccountDetailsFirstTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AccountDetailsFirstTableViewCell.identifier)
        tableView.register(UINib(nibName: AccountDetailsSecondTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AccountDetailsSecondTableViewCell.identifier)
        tableView.register(UINib(nibName: AccountDetailsThirdTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AccountDetailsThirdTableViewCell.identifier)
    }
    
    
    // MARK: - API Call...
    func processForGetUserData(_ result:@escaping(String) -> Void) {
       // showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManagerWithCodable<SingleProfilesResponseModel>.makeApiCall(APIUrl.UserApis.getUserProfileDetail,
                                                                       params: [:],
                                                                       headers: headers,
                                                                       method: .get) { (response, resultModel) in
            if resultModel?.statusCode == 200 {
                self.profileArr.removeAll()
                self.profileArr.append(resultModel!.data)
                result("success")
            } else {
                showMessage(with: response?["message"] as? String ?? "")
            }
           // DispatchQueue.main.async { hideLoader() }
        }
    }
    
    // MARK: - API Call...
    func processForGetUserProfileData(_ result:@escaping([String: Any]?) -> Void) {
        //DispatchQueue.main.async { showLoader() }
        ApiManager.makeApiCall(APIUrl.UserApis.getUserProfileDetail,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .get) { response, _ in
            if !self.hasErrorIn(response) {
                let userResponseData = response![APIConstants.data] as! [String: Any]
                result(userResponseData)
                self.userResponse = userResponseData
                if let instagram = userResponseData["instagram"] as? String {
                    self.instagramLink = instagram
                }
                
                if let linkdin = userResponseData["linkdin"] as? String {
                    self.linkedInLink = linkdin
                }
                
                if let twitter = userResponseData["twitter"] as? String {
                    self.twiiterLink = twitter
                    
                }
                if self.tableView != nil { self.tableView.reloadData() }
               // hideLoader()
            }
        }
    }
    func proceedForBasicInfoScreen() {
        BasicInfoViewController.show(from: self.hostViewController, forcePresent: false, isComeFor: "Profile") { success in }
    }
    
    func proceedForOpenAddLinksScreen(index:Int){
        if index == 100 {
            if twiiterLink == "" {
                let swifter = Swifter(consumerKey: TwitterConstants.CONSUMER_KEY, consumerSecret: TwitterConstants.CONSUMER_SECRET_KEY)
               
                swifter.authorize(withCallback: URL(string: TwitterConstants.CALLBACK_URL)!, presentingFrom: self.hostViewController, success: { accessToken, _ in
                    var params = [String:Any]()
                    params[WebConstants.twitter] = accessToken?.userID ?? ""
                    params[WebConstants.id] = self.user.id
                    self.processForUpdateProfileApiData(params: params) { status in
                        self.twiiterLink = accessToken?.userID ?? ""
                        self.tableView.reloadData()
                        self.processForGetUserData { result in
                            self.processForGetUserProfileData { result in
                                hideLoader()
                            }
                        }
                    }
                }, failure: { error in
                    print("ERROR: Trying to authorize")
                })
            }
        }
        else if index == 101 {
            if instagramLink == "" {
                callAuthVC(selectedMedia: "instagram")
            }
        }
        else if index == 102 {
            if linkedInLink == "" {
                callAuthVC(selectedMedia: "linkedIn")
            }
        }
    }
    
    func proceedForRemoveAddLinksScreen(index:Int){
        if index == 200 {
            showLoader()
            var params = [String:Any]()
            params[WebConstants.twitter] = ""
            params[WebConstants.id] = self.user.id
            self.processForUpdateProfileApiData(params: params) { status in
                self.twiiterLink = ""
                self.tableView.reloadData()
                self.processForGetUserData { result in
                    self.processForGetUserProfileData { result in
                        hideLoader()
                    }
                }
            }
        }
        else if index == 201{
            showLoader()
            var params = [String:Any]()
            params[WebConstants.instagram] = ""
            params[WebConstants.id] = self.user.id
            self.processForUpdateProfileApiData(params: params) { status in
                self.instagramLink = ""
                self.tableView.reloadData()
                self.processForGetUserData { result in
                    self.processForGetUserProfileData { result in
                        hideLoader()
                    }
                }
            }
        }
        else if index == 202{
            showLoader()
            var params = [String:Any]()
            params[WebConstants.linkdin] = ""
            params[WebConstants.id] = self.user.id
            self.processForUpdateProfileApiData(params: params) { status in
                self.linkedInLink = ""
                self.tableView.reloadData()
                self.processForGetUserData { result in
                    self.processForGetUserProfileData { result in
                        hideLoader()
                    }
                }
            }
        }
    }
    
    func proceedToDetailScreen(profile: ProfilesModel, index:Int){
        PageFullViewVC.show(from: self.hostViewController, forcePresent: false, forceBackToHome: false, isFrom: "", isComeFor: "Profile", selectedProfile: profile, allProfiles: profileArr, selectedIndex: index) { success in
            
        }
    }
    
    // MARK: - API Call...
    func processForUpdateProfileApiData(params: [String: Any], _ result:@escaping(String?) -> Void) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.UserApis.updateProfile,
                               params: params,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .put) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [String: Any]
                                    showSuccessMessage(with: StringConstants.updatedProfile)
                                    self.user.updateWith(responseData)
                                    KUSERMODEL.setUserLoggedIn(true)
                                    result("success")
                                }
            
                                hideLoader()
        }
    }
    
}
    

extension AccountDetailViewModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cellFirst = tableView.dequeueReusableCell(withIdentifier: AccountDetailsFirstTableViewCell.identifier) as! AccountDetailsFirstTableViewCell
            
            cellFirst.labelName.text = "\(self.user.firstName) " + "\(self.user.lastName)"
            
            cellFirst.labelPhoneNumber.text = "\(self.user.countryCode) " + "\(self.user.phoneNumber)"
            
            if let email = self.userResponse["email"] as? String {
                cellFirst.labelEmail.text = email
            }
            
            if let isEmailVerified = self.userResponse["isEmailVerified"] as? Int {
                if isEmailVerified == 1 {
                    cellFirst.imageError.isHidden = true
                }else{
                    if cellFirst.labelEmail.text != ""{
                        cellFirst.imageError.isHidden = false
                    }else{
                        cellFirst.imageError.isHidden = true
                    }
                     // set true because email verification is not done yet from backend.
                }
            }
            
            if self.user.userImages.count != 0{
                for i in 0..<self.user.userImages.count{
                    if self.user.userImages[i].isDp == 1{
                        let userImage = self.user.userImages[i].file
                        if userImage != "" {
                            let imageUrl: String = KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + userImage
                            
                            cellFirst.imageProfile.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "Avatar"), options: .refreshCached)
                            
                        } else {
                            cellFirst.imageProfile.image = #imageLiteral(resourceName: "Avatar")
                        }
                    }
                }
            }
            
            cellFirst.imageProfile.layer.cornerRadius = cellFirst.imageProfile.frame.size.height / 2
            cellFirst.imageProfile.clipsToBounds = true
            cellFirst.imageProfile.contentMode = .scaleAspectFill
            
            return cellFirst
        }
        
        if indexPath.row == 1 {
            let cellSecond = tableView.dequeueReusableCell(withIdentifier: AccountDetailsSecondTableViewCell.identifier) as! AccountDetailsSecondTableViewCell
            
            cellSecond.callBackForPublicProfile = {
                if self.profileArr.count != 0{
                    self.proceedToDetailScreen(profile: self.profileArr[0], index: 0)
                }
            }
            
            cellSecond.callBackForEditBasicInfo = {
                self.proceedForBasicInfoScreen()
            }
            
            return cellSecond
        }
        
        if indexPath.row == 2 {
            let cellThird = tableView.dequeueReusableCell(withIdentifier: AccountDetailsThirdTableViewCell.identifier) as! AccountDetailsThirdTableViewCell
            
            if self.twiiterLink != ""{
                cellThird.buttonTwitter.setImage(UIImage(named: "ic_twitter 1"), for: .normal)
                // show the cross image
                cellThird.buttonCrossTwitter.isHidden = false
            } else {
                cellThird.buttonTwitter.setImage(UIImage(named: "Ic_twitter_disabled"), for: .normal)
                // hide the cross image
                cellThird.buttonCrossTwitter.isHidden = true
            }
            
            if self.instagramLink != ""{
                cellThird.buttonInstagram.setImage(UIImage(named: "ic_instagram 1"), for: .normal)
                // show the cross image
                cellThird.buttonCrossInstagram.isHidden = false
            } else {
                cellThird.buttonInstagram.setImage(UIImage(named: "ic_instagram_disabled"), for: .normal)
                // hide the cross image
                cellThird.buttonCrossInstagram.isHidden = true
            }
            
            if self.linkedInLink != ""{
                cellThird.buttonLinkedIn.setImage(UIImage(named: "ic_linkdien_selected"), for: .normal)
                // show the cross image
                cellThird.buttonCrossLinkedIn.isHidden = false
            } else {
                cellThird.buttonLinkedIn.setImage(UIImage(named: "ic_linkdien 1"), for: .normal)
                // hide the cross image
                cellThird.buttonCrossLinkedIn.isHidden = true
            }
            
            cellThird.callBackForSocialMediaButtons = { selectedIndex in
                print(selectedIndex)
                if selectedIndex == 100{
                    if self.twiiterLink == ""{
                        self.proceedForOpenAddLinksScreen(index: selectedIndex)
                    }
                } else if selectedIndex == 101{
                    if self.instagramLink == ""{
                        self.proceedForOpenAddLinksScreen(index: selectedIndex)
                    }
                } else if selectedIndex == 102{
                    if self.linkedInLink == ""{
                        self.proceedForOpenAddLinksScreen(index: selectedIndex)
                    }
                }
            }
            
            cellThird.callBackForRemoveSocialMediaButtons = { selectedIndex in
                print(selectedIndex)
                self.proceedForOpenRemoveAddLinksScreen(index: selectedIndex)
            }
            
            return cellThird
        }
        return UITableViewCell()
    }
    
    func proceedForOpenRemoveAddLinksScreen(index: Int){
        var socialType = ""
        switch index {
        case 200:
            socialType = "Twitter"
        case 201:
            socialType = "Instagram"
        case 202:
            socialType = "LinkedIn"
        default:
            print("")
        }
        
        let controller = RemoveSocialMedialPopUpViewController.getController(with: socialType) as! RemoveSocialMedialPopUpViewController
        controller.dismissCompletion = { value in
            if value == "yes"{
                self.proceedForRemoveAddLinksScreen(index: index)
            }
        }
        controller.show(over: self.hostViewController) { value  in }
    }
    
   
}

// Show the Authorization screen inside the app instead of opening Safari
extension AccountDetailViewModel: WKNavigationDelegate {
    func callAuthVC(selectedMedia: String) {
        let authVC = UIViewController()
        // Create WebView
        let webView = WKWebView()
        webView.navigationDelegate = self
        authVC.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: authVC.view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: authVC.view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: authVC.view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: authVC.view.trailingAnchor)
        ])
        
        let state = selectedMedia == "linkedIn" ? "linkedin\(Int(NSDate().timeIntervalSince1970))" : "instagram\(Int(NSDate().timeIntervalSince1970))"
        
        let authURLFull = selectedMedia == "linkedIn" ? LinkedInConstants.AUTHURL + "?response_type=code&client_id=" + LinkedInConstants.CLIENT_ID + "&scope=" + LinkedInConstants.SCOPE + "&state=" + state + "&redirect_uri=" + LinkedInConstants.REDIRECT_URI : InstagramConstants.AUTHURL + "?response_type=code&client_id=" + InstagramConstants.CLIENT_ID + "&scope=" + InstagramConstants.SCOPE + "&state=" + state + "&redirect_uri=" + InstagramConstants.REDIRECT_URI
        
        //instagram
        //      &scope=user_profile,user_media
        
        let urlRequest = URLRequest.init(url: URL.init(string: authURLFull)!)
        webView.load(urlRequest)
        
        // Create Navigation Controller
        let navController = UINavigationController(rootViewController: authVC)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelAction))
        authVC.navigationItem.leftBarButtonItem = cancelButton
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshAction))
        authVC.navigationItem.rightBarButtonItem = refreshButton
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navController.navigationBar.titleTextAttributes = textAttributes
        authVC.navigationItem.title = selectedMedia == "linkedIn" ? "linkedin.com" : "Instagram"
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.tintColor = UIColor.white
        navController.navigationBar.barTintColor = UIColor.black
       // navController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        navController.modalTransitionStyle = .coverVertical
        
        self.hostViewController.present(navController, animated: true, completion: nil)
    }
    
    @objc func cancelAction() {
        self.hostViewController.dismiss(animated: true, completion: nil)
    }
    
    @objc func refreshAction() {
        self.webView.reload()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        RequestForCallbackURL(request: navigationAction.request)
        
        //Close the View Controller after getting the authorization code
        if let urlStr = navigationAction.request.url?.absoluteString {
            if urlStr.contains("?code=") {
                self.hostViewController.dismiss(animated: true, completion: nil)
            }
        }
        decisionHandler(.allow)
    }
    
    func RequestForCallbackURL(request: URLRequest) {
        // Get the authorization code string after the '?code=' and before '&state='
        let requestURLString = (request.url?.absoluteString)! as String
        if (requestURLString.hasPrefix(LinkedInConstants.REDIRECT_URI) || (requestURLString.hasPrefix(InstagramConstants.REDIRECT_URI))) {
            if requestURLString.contains("?code=") {
                if let range = requestURLString.range(of: "=") {
                    let code = requestURLString[range.upperBound...]
                    if let range = code.range(of: "&state=") {
                        let codeFinal = code[..<range.lowerBound]
                        requestURLString.hasPrefix(LinkedInConstants.REDIRECT_URI) ? linkedinRequestForAccessToken(authCode: String(codeFinal)) : instagramRequest(authCode: String(codeFinal))
                    }
                }
            }
        }
    }
    
    func linkedinRequestForAccessToken(authCode: String) {
        let grantType = "authorization_code"
        
        // Set the POST parameters.
        let postParams = "grant_type=" + grantType + "&code=" + authCode + "&redirect_uri=" + LinkedInConstants.REDIRECT_URI + "&client_id=" + LinkedInConstants.CLIENT_ID + "&client_secret=" + LinkedInConstants.CLIENT_SECRET
        let postData = postParams.data(using: String.Encoding.utf8)
        let request = NSMutableURLRequest(url: URL(string: LinkedInConstants.TOKENURL)!)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode == 200 {
                let results = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [AnyHashable: Any]
                
                let accessToken = results?["access_token"] as! String
                print("accessToken is: \(accessToken)")
                
                let expiresIn = results?["expires_in"] as! Int
                print("expires in: \(expiresIn)")
                
                // Get user's id, first name, last name, profile pic url
                self.fetchLinkedInUserProfile(accessToken: accessToken)
            }
        }
        task.resume()
    }
    
    func fetchLinkedInUserProfile(accessToken: String) {
        let tokenURLFull = "https://api.linkedin.com/v2/me?projection=(id,firstName,lastName)&oauth2_access_token=\(accessToken)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let verify: NSURL = NSURL(string: tokenURLFull!)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error == nil {
                let linkedInProfileModel = try? JSONDecoder().decode(LinkedInProfileModel.self, from: data!)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
                    let params = [WebConstants.linkdin: linkedInProfileModel?.id ?? "",
                                  WebConstants.id: self.user.id]
                    
                    self.processForUpdateProfileApiData(params: params) { status in
                        self.linkedInLink = linkedInProfileModel?.id ?? ""
                        self.tableView.reloadData()
                        self.processForGetUserData { result in
                            self.processForGetUserProfileData { result in
                                hideLoader()
                            }
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    func instagramRequest(authCode: String) {
        let urlString = "https://api.instagram.com/oauth/access_token"
        let appendedURI = "client_id=\(InstagramConstants.CLIENT_ID)&client_secret=\(InstagramConstants.CLIENT_SECRET)&grant_type=authorization_code&redirect_uri=\(InstagramConstants.REDIRECT_URI)&code=\(authCode)"
        
        let url = URL(string: urlString)!
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "Post"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type");
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
        request.httpBody = appendedURI.data(using: .utf8)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                do {
                    if let accDetail = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any] {
//                        let accessToken = accDetail["access_token"] as? String ?? ""
                        let userID = accDetail["user_id"] as? Int ?? 0
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
                            let params = [WebConstants.instagram: "\(userID)",
                                          WebConstants.id: self.user.id]
                            
                            self.processForUpdateProfileApiData(params: params) { status in
                                self.instagramLink = "\(userID)"
                                self.tableView.reloadData()
                                self.processForGetUserData { result in
                                    self.processForGetUserProfileData { result in
                                        hideLoader()
                                    }
                                }
                            }
                        }
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
}


