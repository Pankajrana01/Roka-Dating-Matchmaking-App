//
//  FilterViewController.swift
//  Roka
//
//  Created by ios on 12/12/22.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblVwFIlters: UITableView!
    @IBOutlet weak var viewContainer: UIView!
    
    static let identifier = "FilterViewController"
    
   // var arrFilters = ["All", "Aligned", "Liked", "Groups", "Contact"]
    var arrFilters : [String] = []

    var filterApply: ((String) -> Void)?
    var selection = "All"

    override func viewDidLoad() {
        super.viewDidLoad()
        if GlobalVariables.shared.selectedProfileMode == "MatchMaking" {
            self.arrFilters = ["All","Not Aligned", "Aligned", "Liked", "Groups", "Contact","Others"]
        }else{
            self.arrFilters = ["All", "Aligned", "Liked", "Groups", "Contact"]
        }
        self.setUpUI()
    }
    
    private func setUpUI() {
        let nib = UINib(nibName: FilterTableViewCell.identifier, bundle: nil)
        self.tblVwFIlters.register(nib, forCellReuseIdentifier: FilterTableViewCell.identifier)
    }
    
    @IBAction func btnApplyAction(_ sender: Any) {
        filterApply?(selection)
        self.dismiss(animated: true)
    }
    
    @IBAction func btnCancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrFilters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.identifier) as! FilterTableViewCell
        let title  = self.arrFilters[indexPath.row]
        cell.setData(title: title, isSelected: title == selection)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title  = self.arrFilters[indexPath.row]
        selection = title
        tblVwFIlters.reloadData()
    }
}
