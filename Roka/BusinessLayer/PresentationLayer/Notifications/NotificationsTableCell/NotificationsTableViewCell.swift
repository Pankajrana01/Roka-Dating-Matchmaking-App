//
//  NotificationsTableViewCell.swift
//  Roka
//
//  Created by  Developer on 26/10/22.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {

    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var imageToggle: UIImageView!

    static let identifier = "NotificationsTableViewCell"
    var onSwitchClicked: ((Int, Int) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        toggleAction()
    }
    
    private func  toggleAction() {
        imageToggle.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleTapped(_:)))
        imageToggle.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @IBAction func onImageClick(_ sender: UIButton) {
        var value = 0
        if let image = imageToggle.image, image == UIImage(named: "Ic_toggle_onPrivate") {
            value = 0
        } else if let image = imageToggle.image, image == UIImage(named: "im_switch_off") {
            value = 1
        }
        onSwitchClicked?(toggleButton.tag,value)
    }
    
    @objc func toggleTapped(_ sender: UITapGestureRecognizer) {
        let value = imageToggle.image == UIImage(named: "Ic_toggle_onPrivate") ? 1 : 0
        onSwitchClicked?(imageToggle.tag,value)
    }
    
    func configure(model: NotificationsModel, indexPath: IndexPath) {
        self.labelStatus.text = model.status
        self.labelDescription.text = model.description
        imageToggle.tag = indexPath.row
        toggleButton.tag = indexPath.row
        if model.isOn == 1 {
            imageToggle.image = UIImage(named: "Ic_toggle_onPrivate") // on
        } else {
            imageToggle.image = UIImage(named: "im_switch_off") // off
        }
    }
}
