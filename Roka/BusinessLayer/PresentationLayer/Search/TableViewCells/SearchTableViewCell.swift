//
//  SearchTableViewCell.swift
//  Roka
//
//  Created by  Developer on 08/11/22.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelProfiles: UILabel!
    @IBOutlet weak var labelNoData: UILabel!
    @IBOutlet weak var labelProfilesCount: UILabel!
    @IBOutlet weak var stackViewImages: UIStackView!
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var thirdImage: UIImageView!
    @IBOutlet weak var fourthImage: UIImageView!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var buttonAllProfiles: UIButton!
    @IBOutlet weak var buttonNewProfiles: UIButton!
    @IBOutlet weak var noProfileButton: UIButton!
    

    static let identifier = "SearchTableViewCell"
    var deleteActionCallBack: ((Int, String, String) -> ())?
    var editActionCallBack: ((Int) -> ())?
    var allProfilesCallback: ((Int, String, String) -> ())?
    var newProfilesCallback: ((Int, String, String) -> ())?

    var id: String = ""
    var name:String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        if GlobalVariables.shared.selectedProfileMode != "MatchMaking"{
            self.mainView.backgroundColor = UIColor(red: 0.835, green: 0.898, blue: 0.992, alpha: 1)
        } else {
            self.mainView.backgroundColor = UIColor(red: 0.871, green: 0.843, blue: 1, alpha: 1)
            buttonDelete.setImage(UIImage(named: "im_white_Delete"), for: .normal)
            buttonEdit.setImage(UIImage(named: "im_white_Edit"), for: .normal)
        }
        setupUI()
    }
    
    private func setupUI() {
        let size = 42.0
        firstImage.layer.cornerRadius = size / 2
        secondImage.layer.cornerRadius = size / 2
        thirdImage.layer.cornerRadius = size / 2
        fourthImage.layer.cornerRadius = size / 2
        labelProfilesCount.layer.cornerRadius = size / 2
        
        // At first all the images are hiden.
        firstImage.isHidden = true
        secondImage.isHidden = true
        thirdImage.isHidden = true
        fourthImage.isHidden = true
        labelProfilesCount.isHidden = true
    }
    
    func configure(id: String, index: Int, name:String) {
        self.buttonDelete.tag = index
        self.buttonAllProfiles.tag = index
        self.buttonEdit.tag = index
        self.id = id
        self.name = name
    }
    
    @IBAction func noProfileButtonAction(_ sender: UIButton) {
        allProfilesCallback?(sender.tag, id, name)
    }
    @IBAction func deleteClicked(_ sender: UIButton) {
        deleteActionCallBack?(sender.tag, id, name)
    }
    
    @IBAction func editClicked(_ sender: UIButton) {
        editActionCallBack?(sender.tag)
    }
    
    @IBAction func allProfilesClicked(_ sender: UIButton) {
        allProfilesCallback?(sender.tag, id, name)
    }
    
    @IBAction func newProfilesClicked(_ sender: UIButton) {
        newProfilesCallback?(sender.tag, id, name)
    }
    
    @IBAction func allProfileAction(_ sender: UIButton) {
        allProfilesCallback?(sender.tag, id, name)
    }
}
