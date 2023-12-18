//
//  ReportViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 14/10/22.
//

import Foundation
import UIKit

class reportTableViewCell:UITableViewCell{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tickImage: UIImageView!
}

class ReportViewModel: BaseViewModel {
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    var isComeFor = ""
    var completionHandler: ((Bool) -> Void)?
    var reportArrayIndex = [String]()
    var reportIdArray = [String]()
    var reportReasonsArray = [GenderRow]()
    var id: String = ""
    var selectedIds = [String]()

    weak var reportTextField: UnderlinedTextField!
    weak var reportButton: UIButton!
    
    weak var tableView: UITableView! { didSet { configureTableView() } }
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func enableDisableNextButton() {
        if selectedIds.count == 0 {
            reportButton.alpha = 0.5
            reportButton.isUserInteractionEnabled = false
        } else {
            reportButton.alpha = 1.0
            reportButton.isUserInteractionEnabled = true
        }
    }
    
    func processForGetReportData() {
        self.reportApiCall { model in
            self.reportReasonsArray = model?.data.rows ?? []
            for _ in 0..<self.reportReasonsArray.count {
                self.reportArrayIndex.append("NO")
            }
            self.tableView.reloadData()
        }
    }
    
    func reportPofileButtonAction() {
        for i in 0..<reportArrayIndex.count {
            if self.reportArrayIndex[i] == "YES"{
                selectedIds.append(self.reportReasonsArray[i].id)
            }
        }
        
        if selectedIds.count == 0 {
            showMessage(with: ValidationError.selectProblem)
        } else {
            var params = [String:Any]()
            params[WebConstants.profileId] = id
            if reportTextField.text != ""{
                params[WebConstants.description] = reportTextField.text ?? ""
            }
            params[WebConstants.reasons] = selectedIds
            processForReportProfileData(params: params)
        }
    }
    
    // MARK: - API Call...
    func reportApiCall(_ result:@escaping(ReportListResponseModel?) -> Void) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        
        ApiManagerWithCodable<ReportListResponseModel>.makeApiCall(APIUrl.BasicApis.reportReasons,
                                                         params: [:],
                                                         headers: headers,
                                                         method: .get) { (response, resultModel) in
            hideLoader()
            if resultModel?.statusCode == 200 {
                result(resultModel)
            } else {
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    // MARK: - API Call...
    func processForReportProfileData(params: [String: Any]) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        ApiManager.makeApiCall(APIUrl.LandingApis.reportProfile,
                               params: params,
                               headers: headers,
                               method: .post) { response, _ in
            if !self.hasErrorIn(response) {
                _ = response![APIConstants.data] as! [String: Any]
                
                showSuccessMessage(with: StringConstants.reportSuccess)
                delay(3) {
                    
                   // self.hostViewController.dismiss(animated: true)
                    for controller in self.hostViewController.navigationController!.viewControllers as Array {
                        if controller.isKind(of: PagerController.self) {
                            self.hostViewController.navigationController!.popToViewController(controller, animated: false)
                            break
                        }
                        if controller.isKind(of: MatchMakingDetailsPagerController.self) {
                            self.hostViewController.navigationController!.popToViewController(controller, animated: false)
                            break
                        }
                        if controller.isKind(of: ChatViewController.self) {
                            self.hostViewController.navigationController!.popToViewController(controller, animated: false)
                            break
                        }
                    }
                }
            }
            hideLoader()
        }
    }
}

extension ReportViewModel : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportReasonsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.reportCell, for: indexPath) as? reportTableViewCell{
            cell.titleLabel.text = self.reportReasonsArray[indexPath.row].name
            
            if self.reportArrayIndex[indexPath.row] == "YES"{
                cell.tickImage.isHidden = false
                cell.tickImage.image = UIImage(named: "SelectRectangle")
            }else{
                cell.tickImage.isHidden = false
                cell.tickImage.image = UIImage(named: "UnSelectRectangle")
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.reportArrayIndex[indexPath.row] == "YES"{
            self.reportArrayIndex[indexPath.row] = "NO"
        } else {
            self.reportArrayIndex[indexPath.row] = "YES"
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension 
    }
}
