//
//  SelectCountryViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 23/09/22.
//

import Foundation
import UIKit

class SelectCountryViewModel:BaseViewModel {
    var completionHandler: ((String) -> Void)?
    var tableView: UITableView! { didSet { configureTableView() } }
    var counrtyList = ["+91 India", "+44 United Kingdom", "+1 United States"]
    var isSelectedIndex = -1
    var selectedValue = ""
    var isCurrentCountryCode = ""
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func saveButtonAction() {
        if selectedValue == ""{
            self.selectedValue = isCurrentCountryCode
        }
        completionHandler?(selectedValue)
        (self.hostViewController as! BaseAlertViewController).dismiss()
    }
    
    func getIndex(options:[String], id : Int){
        if let index = options.firstIndex(where: { $0.components(separatedBy: " ").last == "\(id)" }) {
            print(index, options[index])
        }
    }
    
}

extension SelectCountryViewModel : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return counrtyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.genderCell, for: indexPath) as? genderTableViewCell{
            cell.titleLabel.text = self.counrtyList[indexPath.row]
            
            if let index = self.counrtyList.firstIndex(where: { $0.components(separatedBy: " ").first == isCurrentCountryCode }) {
                print(index, self.counrtyList[index])
                self.isSelectedIndex = index
            }
            
            if isSelectedIndex == indexPath.row{
                cell.tickImage.isHidden = false
            }else{
                cell.tickImage.isHidden = true
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.isSelectedIndex = indexPath.row
        let val = self.counrtyList[indexPath.row].components(separatedBy: " ")
        self.selectedValue = val[0]
        self.isCurrentCountryCode = val[0]
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
