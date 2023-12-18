//
//  NewSearchTableViewCell.swift
//  Roka
//
//  Created by  Developer on 03/11/22.
//

import UIKit

class NewSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageTickUntick: UIImageView!
    @IBOutlet weak var buttonTickUntick: UIButton!
    
    static let identifier = "NewSearchTableViewCell"
    
    var buttonClikced: ((Int, Int) -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureSmokingAndDrinking(model: GenderRow, id: String, index: Int) {
        buttonTickUntick.tag = index
        label.text = model.name
        if id == model.id {
            // selected image
            imageTickUntick.tag = 1
            self.imageTickUntick.image = UIImage(named: "ic_gender_Search_select") //UIImage(named: "ic_tick_selected")
        } else {
            // unselected image
            imageTickUntick.tag = 0
            self.imageTickUntick.image = UIImage(named: "ic_gender_Search") //UIImage(named: "ic_tick_unselected")
        }
    }

    func configure(model: GenderRow, index: Int, ids: [String]) {
        self.label.text = model.name
        self.buttonTickUntick.tag = index
        self.imageTickUntick.image = UIImage(named: "ic_gender_Search") //UIImage(named: "ic_tick_unselected")
        imageTickUntick.tag = 0
        for id in ids {
            if model.id == id {
                imageTickUntick.image = UIImage(named: "ic_gender_Search_select") //UIImage(named: "ic_tick_selected")
                imageTickUntick.tag = 1
            }
        }
    }
    
    @IBAction func tickUntickClicked(_ sender: UIButton) {//
        print("sender", sender.tag)
        print("imageTickUntick", imageTickUntick.tag)
        if imageTickUntick.tag == 1 {
            // do image unselected.
            self.imageTickUntick.image = UIImage(named: "ic_gender_Search") //UIImage(named: "ic_tick_unselected")
            imageTickUntick.tag = 0
        } else if imageTickUntick.tag == 0 {
            self.imageTickUntick.image = UIImage(named: "ic_gender_Search_select") //UIImage(named: "ic_tick_selected")
            imageTickUntick.tag = 1
        }
        buttonClikced?(sender.tag, imageTickUntick.tag)
    }
}
