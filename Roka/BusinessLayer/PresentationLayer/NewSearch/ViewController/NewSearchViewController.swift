//
//  NewSearchViewController.swift
//  Roka
//
//  Created by  Developer on 02/11/22.
//

import UIKit

class NewSearchViewController: BaseViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.newSearch
        
    }
    override class func identifier() -> String {
        return ViewControllerIdentifier.newSearch
    }
    
    lazy var viewModel: NewSearchViewModel = NewSearchViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(from viewController: UIViewController,
                    forcePresent: Bool = true,
                    isComeFor:String,
                    preferenceId: String,
                    completionHandler: @escaping (Bool) -> Void) {
        let controller = self.getController() as! NewSearchViewController
        controller.viewModel.completionHandler = completionHandler
        controller.viewModel.isComeFor = isComeFor
        controller.viewModel.preferenceId = preferenceId
        controller.show(from: viewController, forcePresent: forcePresent)
    }
    
    
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var topNavigationView: UIView!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var detailTableView: UITableView!
    
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if self.viewModel.preferenceId.isEmpty {
            self.labelTitle.text = StringConstants.newSearch
        }
        else {
            self.labelTitle.text = StringConstants.editPreferences
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if GlobalVariables.shared.selectedProfileMode != "MatchMaking"{
            self.topNavigationView.backgroundColor = UIColor(hex: "#031634")
            self.labelTitle.textColor = .white
            self.crossButton.setImage(UIImage(named: "ic_crosss"), for: .normal)
            self.applyButton.setTitleColor(.white, for: .normal)
            self.applyButton.backgroundColor = UIColor(hex: "#031634")
        } else {
            self.topNavigationView.backgroundColor = UIColor(hex: "#AD9BFB")
            self.labelTitle.textColor = UIColor(hex: "#031634")
            self.crossButton.setImage(UIImage(named: "im_filterCross_Ma"), for: .normal)
            self.applyButton.setTitleColor(UIColor(hex: "#031634"), for: .normal)
            self.applyButton.setTitle("Apply", for: .normal)
            self.applyButton.backgroundColor = UIColor(hex: "#AD9BFB")
        }
        viewModel.getPreferenceData {
            if self.viewModel.preferenceId.isEmpty {
                self.labelTitle.text = StringConstants.newSearch
            }
            else {
                self.labelTitle.text = StringConstants.editPreferences
            }
            self.menuTableView.reloadData()
            //self.detailTableView.reloadData()
            self.detailTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            
        }
    }
    
    private func setupUI() {
        setupMenuTableView()
        setupDetailTableView()
    }
    
    private func setupMenuTableView() {
//        menuTableView.register(UINib(nibName: ProfileTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProfileTableViewCell.identifier)
        menuTableView.register(UINib(nibName: NewSearchMenuTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NewSearchMenuTableViewCell.identifier)
        menuTableView.delegate = self
        menuTableView.dataSource = self
    }
    
    private func setupDetailTableView() {
        detailTableView.register(UINib(nibName: NewSearchTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NewSearchTableViewCell.identifier)
        detailTableView.register(UINib(nibName: NewSearchAgeTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NewSearchAgeTableViewCell.identifier)
        detailTableView.register(UINib(nibName: NewSearchHeightTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NewSearchHeightTableViewCell.identifier)

        detailTableView.separatorStyle = .none
        detailTableView.delegate = self
        detailTableView.dataSource = self
    }
    
    @IBAction func dissMissClicked(_ sender: UIButton) {
        // action here
        KAPPSTORAGE.searchBackCheck = true
        self.dismiss(animated: true)
    }
    
    @IBAction func clearAllClicked(_ sender: UIButton) {
        // action here
        viewModel.tempGender.removeAll()
        viewModel.tempMusic.removeAll()
        viewModel.tempMovies.removeAll()
        viewModel.tempPassions.removeAll()
        viewModel.tempReligion.removeAll()
        viewModel.tempEducation.removeAll()
        viewModel.tempEthencity.removeAll()
        viewModel.tempWorkIndustry.removeAll()
        viewModel.tempRelationship.removeAll()
        viewModel.tempSmoking.removeAll()
        viewModel.tempDriking.removeAll()
        viewModel.tempZodiaces.removeAll()
        viewModel.tempKids.removeAll()
        viewModel.tempPersonalities.removeAll()
        viewModel.tempMinAge = 18
        viewModel.tempMaxAge = 99
        viewModel.tempMinHeight = 4
        viewModel.tempMaxHeight = 6
        viewModel.updateFilteredData()
        self.detailTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        self.detailTableView.reloadData()
    }
    
    @IBAction func applyClicked(_ sender: UIButton) {
        // action here
        let vc = NewSearchApplyViewController.storyboard().instantiateViewController(withIdentifier: NewSearchApplyViewController.identifier()) as! NewSearchApplyViewController
        vc.viewModel.preferenceId = viewModel.preferenceId
        vc.viewModel.filteredData = viewModel.filteredData
        present(vc, animated: true)
    }
}

extension NewSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == menuTableView {
            return viewModel.modelArray.count
            
        } else if tableView == detailTableView {
            switch selectedIndex {
            case 0: return 1                                              // AGE
            case 1: return viewModel.genders.count                       // GENDDER
            case 2: return 1                                            // HEIGHT
            case 3: return viewModel.ethencities.count                 // ETHENCITY
            case 4: return viewModel.religions.count                  // RELIGION
//            case 5: return viewModel.relationships.count             // RELATIONSHIP STATUS
            case 5: return viewModel.educations.count               // EDUCATION
            case 6: return viewModel.workIndustries.count          // WORK INDUSTRY
            case 7: return viewModel.passions.count               // PASSIONS
            case 8: return viewModel.movies.count                // MOVIES/TV
            case 9: return viewModel.musics.count              // MUSIC
            case 10: return viewModel.smokings.count           // SMOCKING
            case 11: return viewModel.drinkings.count         // DRIKING
            case 13: return viewModel.zodiaces.count         // ZODIAC
            case 14: return viewModel.kids.count            // KIDS
            case 15: return viewModel.personalities.count  // PERSONALITY
            default:
                break
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == menuTableView {
            if let menuCell = tableView.dequeueReusableCell(withIdentifier: NewSearchMenuTableViewCell.identifier) as? NewSearchMenuTableViewCell {
                menuCell.configure(model: viewModel.modelArray[indexPath.row])
                if GlobalVariables.shared.selectedProfileMode != "MatchMaking"{
                    if selectedIndex == indexPath.row {
                        menuCell.backgroundColor = UIColor(hex: "#E7F0FF") //.white
                    } else {
                        menuCell.backgroundColor = UIColor(hex: "#F7F7F7")
                    }
                } else {
                    if selectedIndex == indexPath.row {
                        menuCell.backgroundColor = UIColor(hex: "#EFEBFF") //.white
                    } else {
                        menuCell.backgroundColor = UIColor(hex: "#F7F7F7")
                    }
                }
                menuCell.selectionStyle = .none
                return menuCell
            }
        } else if tableView == detailTableView {
            switch selectedIndex {
                
            case 0: // AGE
                if let detailCell = tableView.dequeueReusableCell(withIdentifier: NewSearchAgeTableViewCell.identifier) as? NewSearchAgeTableViewCell {
                    detailCell.selectionStyle = .none
                    detailCell.configure(selectedMinValue: viewModel.tempMinAge, selectedMaxValue: viewModel.tempMaxAge)
                    // call back
                    detailCell.ageCallBack = { [weak self] (min, max) in
                        guard let strongSelf = self else { return }
                        strongSelf.viewModel.tempMinAge = CGFloat(min)
                        strongSelf.viewModel.tempMaxAge = CGFloat(max)
                        strongSelf.viewModel.filteredData["minAge"] = strongSelf.viewModel.tempMinAge
                        strongSelf.viewModel.filteredData["maxAge"] = strongSelf.viewModel.tempMaxAge
                    }
                    return detailCell
                }
            case 1: // GENDERS
                if let detailCell = tableView.dequeueReusableCell(withIdentifier: NewSearchTableViewCell.identifier) as? NewSearchTableViewCell {
                    detailCell.configure(model: viewModel.genders[indexPath.row], index: indexPath.row, ids: viewModel.tempGender)
                    detailCell.selectionStyle = .none
                    detailCell.buttonClikced = { [weak self] (senderTag, imageTag) in //tick or untick
                        guard let strongSelf = self else { return }
                        if imageTag == 1 { // selected
                            let model = strongSelf.viewModel.genders[senderTag]
                            strongSelf.viewModel.tempGender.append(model.id)
                        } else {
                            let model = strongSelf.viewModel.genders[senderTag]
                            strongSelf.viewModel.tempGender = strongSelf.viewModel.tempGender.filter { $0 != model.id }
                        }
                        strongSelf.viewModel.filteredData["gender"] = strongSelf.viewModel.tempGender
                    }
                    return detailCell
                }
                
            case 2: // HEIGHT
                if let detailCell = tableView.dequeueReusableCell(withIdentifier: NewSearchHeightTableViewCell.identifier) as? NewSearchHeightTableViewCell {
                    detailCell.selectionStyle = .none
                    detailCell.configure(selectedMinValue: viewModel.tempMinHeight, selectedMaxValue: viewModel.tempMaxHeight, heightType: viewModel.tempHeightType)
                    
                    detailCell.heightCallBack = { [weak self] (min, max, type) in
                        guard let strongSelf = self else { return }
                        strongSelf.viewModel.filteredData["minHeight"] = "\(min)"
                        strongSelf.viewModel.filteredData["maxHeight"] = "\(max)"
                        strongSelf.viewModel.filteredData["heightType"] = "\(type)"
                        
                        if let n = NumberFormatter().number(from: min) {
                            strongSelf.viewModel.tempMinHeight = CGFloat(truncating: n)
                        }
                        if let p = NumberFormatter().number(from: max) {
                            strongSelf.viewModel.tempMaxHeight = CGFloat(truncating: p)
                        }
                        strongSelf.viewModel.tempHeightType = type
                    }
                    return detailCell
                }
                
            case 3: // ETHENCITY
                if let detailCell = tableView.dequeueReusableCell(withIdentifier: NewSearchTableViewCell.identifier) as? NewSearchTableViewCell {
                    detailCell.configure(model: viewModel.ethencities[indexPath.row], index: indexPath.row, ids: viewModel.tempEthencity)
                    detailCell.selectionStyle = .none
                    detailCell.buttonClikced = { [weak self] (senderTag, imageTag) in
                        guard let strongSelf = self else { return }
                        //                    strongSelf.viewModel.filteredData["ethnicity"] = [tagButton]
                        if imageTag == 1 {
                            let model = strongSelf.viewModel.ethencities[senderTag]
                            strongSelf.viewModel.tempEthencity.append(model.id)
                        } else {
                            let model = strongSelf.viewModel.ethencities[senderTag]
                            strongSelf.viewModel.tempEthencity = strongSelf.viewModel.tempEthencity.filter { $0 != model.id }
                        }
                        strongSelf.viewModel.filteredData["ethnicity"] = strongSelf.viewModel.tempEthencity
                    }
                    return detailCell
                }
                
                
            case 4: // RELIGION
                if let detailCell = tableView.dequeueReusableCell(withIdentifier: NewSearchTableViewCell.identifier) as? NewSearchTableViewCell {
                    detailCell.configure(model: viewModel.religions[indexPath.row], index: indexPath.row, ids: viewModel.tempReligion)
                    detailCell.selectionStyle = .none
                    detailCell.buttonClikced = { [weak self] (senderTag, imageTag) in
                        guard let strongSelf = self else { return }
                        if imageTag == 1 {
                            let model = strongSelf.viewModel.religions[senderTag]
                            strongSelf.viewModel.tempReligion.append(model.id)
                        } else {
                            let model = strongSelf.viewModel.religions[senderTag]
                            strongSelf.viewModel.tempReligion = strongSelf.viewModel.tempReligion.filter { $0 != model.id }
                        }
                        strongSelf.viewModel.filteredData["religion"] = strongSelf.viewModel.tempReligion
                    }
                    return detailCell
                }
//            case 5: // RELATIONSHIP STATUS
//                if let detailCell = tableView.dequeueReusableCell(withIdentifier: NewSearchTableViewCell.identifier) as? NewSearchTableViewCell {
//                    detailCell.configure(model: viewModel.relationships[indexPath.row], index: indexPath.row, ids: viewModel.tempRelationship)
//                    detailCell.selectionStyle = .none
//                    detailCell.buttonClikced = { [weak self] (senderTag, imageTag) in
//                        guard let strongSelf = self else { return }
//                        if imageTag == 1 {
//                            let model = strongSelf.viewModel.relationships[senderTag]
//                            strongSelf.viewModel.tempRelationship.append(model.id)
//                        } else {
//                            let model = strongSelf.viewModel.relationships[senderTag]
//                            strongSelf.viewModel.tempRelationship = strongSelf.viewModel.tempRelationship.filter { $0 != model.id }
//                        }
//                        strongSelf.viewModel.filteredData["relationship"] = strongSelf.viewModel.tempRelationship
//                    }
//                    return detailCell
//                }
            case 5: // EDUCATION
                if let detailCell = tableView.dequeueReusableCell(withIdentifier: NewSearchTableViewCell.identifier) as? NewSearchTableViewCell {
                    detailCell.configure(model: viewModel.educations[indexPath.row], index: indexPath.row, ids: viewModel.tempEducation)
                    detailCell.selectionStyle = .none
                    detailCell.buttonClikced = { [weak self] (senderTag, imageTag) in
                        guard let strongSelf = self else { return }
                        if imageTag == 1 {
                            let model = strongSelf.viewModel.educations[senderTag]
                            strongSelf.viewModel.tempEducation.append(model.id)
                        } else {
                            let model = strongSelf.viewModel.educations[senderTag]
                            strongSelf.viewModel.tempEducation = strongSelf.viewModel.tempEducation.filter { $0 != model.id }
                        }
                        strongSelf.viewModel.filteredData["education"] = strongSelf.viewModel.tempEducation
                    }
                    return detailCell
                }
            case 6: // WORK INDUSTRY
                if let detailCell = tableView.dequeueReusableCell(withIdentifier: NewSearchTableViewCell.identifier) as? NewSearchTableViewCell {
                    detailCell.configure(model: viewModel.workIndustries[indexPath.row], index: indexPath.row, ids: viewModel.tempWorkIndustry)
                    detailCell.selectionStyle = .none
                    detailCell.buttonClikced = { [weak self] (senderTag, imageTag) in
                        guard let strongSelf = self else { return }
                        if imageTag == 1 {
                            let model = strongSelf.viewModel.workIndustries[senderTag]
                            strongSelf.viewModel.tempWorkIndustry.append(model.id)
                        } else {
                            let model = strongSelf.viewModel.workIndustries[senderTag]
                            strongSelf.viewModel.tempWorkIndustry = strongSelf.viewModel.tempWorkIndustry.filter { $0 != model.id }
                        }
                        strongSelf.viewModel.filteredData["workIndustry"] = strongSelf.viewModel.tempWorkIndustry
                    }
                    return detailCell
                }
            case 7: // PASSIONS
                if let detailCell = tableView.dequeueReusableCell(withIdentifier: NewSearchTableViewCell.identifier) as? NewSearchTableViewCell {
                    detailCell.configure(model: viewModel.passions[indexPath.row], index: indexPath.row, ids: viewModel.tempPassions)
                    detailCell.selectionStyle = .none
                    detailCell.buttonClikced = { [weak self] (senderTag, imageTag) in
                        guard let strongSelf = self else { return }
                        if imageTag == 1 {
                            let model = strongSelf.viewModel.passions[senderTag]
                            strongSelf.viewModel.tempPassions.append(model.id)
                        } else {
                            let model = strongSelf.viewModel.passions[senderTag]
                            strongSelf.viewModel.tempPassions = strongSelf.viewModel.tempPassions.filter { $0 != model.id }
                        }
                        strongSelf.viewModel.filteredData["passions"] = strongSelf.viewModel.tempPassions
                    }
                    return detailCell
                }
            case 8: // MOVIES/TV
                if let detailCell = tableView.dequeueReusableCell(withIdentifier: NewSearchTableViewCell.identifier) as? NewSearchTableViewCell {
                    detailCell.configure(model: viewModel.movies[indexPath.row], index: indexPath.row, ids: viewModel.tempMovies)
                    detailCell.selectionStyle = .none
                    detailCell.buttonClikced = { [weak self] (senderTag, imageTag) in
                        guard let strongSelf = self else { return }
                        if imageTag == 1 {
                            let model = strongSelf.viewModel.movies[senderTag]
                            strongSelf.viewModel.tempMovies.append(model.id)
                        } else {
                            let model = strongSelf.viewModel.movies[senderTag]
                            strongSelf.viewModel.tempMovies = strongSelf.viewModel.tempMovies.filter { $0 != model.id }
                        }
                        strongSelf.viewModel.filteredData["movies"] = strongSelf.viewModel.tempMovies
                    }
                    return detailCell
                }
            case 9: // MUSIC
                if let detailCell = tableView.dequeueReusableCell(withIdentifier: NewSearchTableViewCell.identifier) as? NewSearchTableViewCell {
                    detailCell.configure(model: viewModel.musics[indexPath.row], index: indexPath.row, ids: viewModel.tempMusic)
                    detailCell.selectionStyle = .none
                    detailCell.buttonClikced = { [weak self] (senderTag, imageTag) in
                        guard let strongSelf = self else { return }
                        if imageTag == 1 {
                            let model = strongSelf.viewModel.musics[senderTag]
                            strongSelf.viewModel.tempMusic.append(model.id)
                        } else {
                            let model = strongSelf.viewModel.musics[senderTag]
                            strongSelf.viewModel.tempMusic = strongSelf.viewModel.tempMusic.filter { $0 != model.id }
                        }
                        strongSelf.viewModel.filteredData["music"] = strongSelf.viewModel.tempMusic
                    }
                    return detailCell
                }
                
            case 10: // SMOCKING
                if let detailCell = tableView.dequeueReusableCell(withIdentifier: NewSearchTableViewCell.identifier) as? NewSearchTableViewCell {
                    detailCell.configure(model: viewModel.smokings[indexPath.row], index: indexPath.row, ids: viewModel.tempSmoking)
                    detailCell.selectionStyle = .none
                    detailCell.buttonClikced = { [weak self] (senderTag, imageTag) in
                        guard let strongSelf = self else { return }
                        if imageTag == 1 {
                            let model = strongSelf.viewModel.smokings[senderTag]
                            strongSelf.viewModel.tempSmoking.append(model.id)
                        } else {
                            let model = strongSelf.viewModel.smokings[senderTag]
                            strongSelf.viewModel.tempSmoking = strongSelf.viewModel.tempSmoking.filter { $0 != model.id }
                        }
                        strongSelf.viewModel.filteredData["smokingIds"] = strongSelf.viewModel.tempSmoking
                    }
                    return detailCell
                }

                //            case 11: // SMOCKING
                //                if let detailCell = tableView.dequeueReusableCell(withIdentifier: NewSearchTableViewCell.identifier) as? NewSearchTableViewCell {
                //                    detailCell.configureSmokingAndDrinking(model: viewModel.smokings[indexPath.row], id: viewModel.smokingId, index: indexPath.row)
                //                    detailCell.selectionStyle = .none
                //                    detailCell.buttonClikced = { [weak self] (senderTag, imageTag) in
                //                        guard let strongSelf = self else { return }
                //                        if imageTag == 1 {
                //                            strongSelf.viewModel.smokingId = strongSelf.viewModel.smokings[senderTag].id
                //                        } else {
                //                            strongSelf.viewModel.smokingId = ""
                //                        }
                //                        strongSelf.viewModel.filteredData["smokingId"] = strongSelf.viewModel.smokingId
                //                        strongSelf.detailTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                //                    }
                //                    return detailCell
                //                }

            case 11: // DRIKING
                if let detailCell = tableView.dequeueReusableCell(withIdentifier: NewSearchTableViewCell.identifier) as? NewSearchTableViewCell {
                    detailCell.configure(model: viewModel.drinkings[indexPath.row], index: indexPath.row, ids: viewModel.tempDriking)
                    detailCell.selectionStyle = .none
                    detailCell.buttonClikced = { [weak self] (senderTag, imageTag) in
                        guard let strongSelf = self else { return }
                        if imageTag == 1 {
                            let model = strongSelf.viewModel.drinkings[senderTag]
                            strongSelf.viewModel.tempDriking.append(model.id)
                        } else {
                            let model = strongSelf.viewModel.drinkings[senderTag]
                            strongSelf.viewModel.tempDriking = strongSelf.viewModel.tempDriking.filter { $0 != model.id }
                        }
                        strongSelf.viewModel.filteredData["drinkingIds"] = strongSelf.viewModel.tempDriking
                    }
                    return detailCell
                }
                
//            case 12: // DRIKING
//                if let detailCell = tableView.dequeueReusableCell(withIdentifier: NewSearchTableViewCell.identifier) as? NewSearchTableViewCell {
//                    detailCell.configureSmokingAndDrinking(model: viewModel.drinkings[indexPath.row], id: viewModel.drinkingId, index: indexPath.row)
//                    detailCell.selectionStyle = .none
//                    detailCell.buttonClikced = { [weak self] (senderTag, imageTag) in
//                        guard let strongSelf = self else { return }
//                        if imageTag == 1 {
//                            strongSelf.viewModel.drinkingId = strongSelf.viewModel.drinkings[senderTag].id
//                        } else {
//                            strongSelf.viewModel.drinkingId = ""
//                        }
//                        strongSelf.viewModel.filteredData["drinkingId"] = strongSelf.viewModel.drinkingId
//                        strongSelf.detailTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
//                    }
//                    return detailCell
//                }
                
            case 13: // ZODIAC
                if let detailCell = tableView.dequeueReusableCell(withIdentifier: NewSearchTableViewCell.identifier) as? NewSearchTableViewCell {
                    detailCell.configure(model: viewModel.zodiaces[indexPath.row], index: indexPath.row, ids: viewModel.tempZodiaces)
                    detailCell.selectionStyle = .none
                    detailCell.buttonClikced = { [weak self] (senderTag, imageTag) in
                        guard let strongSelf = self else { return }
                        if imageTag == 1 {
                            let model = strongSelf.viewModel.zodiaces[senderTag]
                            strongSelf.viewModel.tempZodiaces.append(model.id)
                        } else {
                            let model = strongSelf.viewModel.zodiaces[senderTag]
                            strongSelf.viewModel.tempZodiaces = strongSelf.viewModel.tempZodiaces.filter { $0 != model.id }
                        }
                        strongSelf.viewModel.filteredData["zodiacIds"] = strongSelf.viewModel.tempZodiaces
                    }
                    return detailCell
                }
                
            case 14: // KIDS
                if let detailCell = tableView.dequeueReusableCell(withIdentifier: NewSearchTableViewCell.identifier) as? NewSearchTableViewCell {
                    detailCell.configure(model: viewModel.kids[indexPath.row], index: indexPath.row, ids: viewModel.tempKids)
                    detailCell.selectionStyle = .none
                    detailCell.buttonClikced = { [weak self] (senderTag, imageTag) in
                        guard let strongSelf = self else { return }
                        if imageTag == 1 {
                            let model = strongSelf.viewModel.kids[senderTag]
                            strongSelf.viewModel.tempKids.append(model.id)
                        } else {
                            let model = strongSelf.viewModel.kids[senderTag]
                            strongSelf.viewModel.tempKids = strongSelf.viewModel.tempKids.filter { $0 != model.id }
                        }
                        strongSelf.viewModel.filteredData["kidsIds"] = strongSelf.viewModel.tempKids
                    }
                    return detailCell
                }
                
            case 15: // PERSONALITY
                if let detailCell = tableView.dequeueReusableCell(withIdentifier: NewSearchTableViewCell.identifier) as? NewSearchTableViewCell {
                    detailCell.configure(model: viewModel.personalities[indexPath.row], index: indexPath.row, ids: viewModel.tempPersonalities)
                    detailCell.selectionStyle = .none
                    detailCell.buttonClikced = { [weak self] (senderTag, imageTag) in
                        guard let strongSelf = self else { return }
                        if imageTag == 1 {
                            let model = strongSelf.viewModel.personalities[senderTag]
                            strongSelf.viewModel.tempPersonalities.append(model.id)
                        } else {
                            let model = strongSelf.viewModel.personalities[senderTag]
                            strongSelf.viewModel.tempPersonalities = strongSelf.viewModel.tempPersonalities.filter { $0 != model.id }
                        }
                        strongSelf.viewModel.filteredData["personality"] = strongSelf.viewModel.tempPersonalities
                    }
                    return detailCell
                }
            default: break
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == menuTableView {
            return 52
        } else if tableView == detailTableView {
            switch selectedIndex {
            case 0 :
                return 150
            case 2 :
                return UITableView.automaticDimension
            default:
                return 52
            }
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == menuTableView {
            selectedIndex = indexPath.row
            print("menuTableView: \(selectedIndex)")
            
            switch indexPath.row {
            case 1:
                if viewModel.genders.count == 0 {
                    viewModel.processForGetGenderData(type: "3") {  self.detailTableView.reloadData() }
                }
            case 3:
                if viewModel.ethencities.count == 0 {
                    viewModel.processForGetEthentcityData(type: "3") {  self.detailTableView.reloadData() }
                }
            case 4:
                if viewModel.religions.count == 0 {
                    viewModel.processForGetReligionData(type: "3") { self.detailTableView.reloadData() }
                }
//            case 5:
//                if viewModel.relationships.count == 0 {
//                    viewModel.processForGetRelationshipsData(type: "3") { self.detailTableView.reloadData() }
//                }
            case 5:
                if viewModel.educations.count == 0 {
                    viewModel.processForGetEducationData(type: "3") { self.detailTableView.reloadData() }
                }
            case 6:
                if viewModel.workIndustries.count == 0 {
                    viewModel.processForGetWorkIndustryData(type: "3") { self.detailTableView.reloadData() }
                }
            case 7:
                if viewModel.passions.count == 0 {
                    viewModel.processForGetPassionData(type: "3") { self.detailTableView.reloadData() }
                }
            case 8:
                if viewModel.movies.count == 0 {
                    viewModel.processForGetMovieData(type: "3") { self.detailTableView.reloadData() }
                }
            case 9:
                if viewModel.musics.count == 0 {
                    viewModel.processForGetMusicData(type: "3") { self.detailTableView.reloadData() }
                }
            case 10:
                if viewModel.smokings.count == 0 {
                    viewModel.processForGetSmokingData(type: "3") { self.detailTableView.reloadData() }
                }
            case 11:
                if viewModel.drinkings.count == 0 {
                    viewModel.processForGetDrinkingData(type: "3") { self.detailTableView.reloadData() }
                }
            case 12:
                if viewModel.zodiaces.count == 0 {
                    viewModel.processForGetZodiacData(type: "3") { self.detailTableView.reloadData() }
                }
            case 14:
                if viewModel.kids.count == 0 {
                    viewModel.processForGetKidsData(type: "3") { self.detailTableView.reloadData() }
                }
            case 15:
                if viewModel.personalities.count == 0 {
                    viewModel.processForGetPersonalityData(type: "3") { self.detailTableView.reloadData() }
                }
            default: break
            }
            menuTableView.reloadData()
            detailTableView.reloadData()
        } else if tableView == detailTableView {
            if let cell = tableView.cellForRow(at: indexPath) as? NewSearchTableViewCell {
                if cell.imageTickUntick.tag == 0 { // selected image
                    cell.imageTickUntick.image = UIImage(named: "ic_gender_Search_select") //UIImage(named: "ic_tick_selected")
                } else {
                    cell.imageTickUntick.image = UIImage(named: "ic_gender_Search") //UIImage(named: "ic_tick_unselected")
                }
                switch selectedIndex {
                case 1: // Genders
                    if cell.imageTickUntick.tag == 0 {
                        viewModel.tempGender.append(viewModel.genders[indexPath.row].id)
                        cell.imageTickUntick.tag = 1
                    } else {
                        let value = viewModel.genders[indexPath.row].id
                        viewModel.tempGender = viewModel.tempGender.filter { $0 != value }
                        cell.imageTickUntick.tag = 0
                    }
                    viewModel.filteredData["gender"] = viewModel.tempGender
                    
                case 3: // Ethencity
                    if cell.imageTickUntick.tag == 0 {
                        viewModel.tempEthencity.append(viewModel.ethencities[indexPath.row].id)
                        cell.imageTickUntick.tag = 1
                    } else {
                        viewModel.tempEthencity = viewModel.tempEthencity.filter { $0 != viewModel.ethencities[indexPath.row].id }
                        cell.imageTickUntick.tag = 0
                    }
                    viewModel.filteredData["ethnicity"] = viewModel.tempEthencity
                    
                case 4: // RELIGION
                    if cell.imageTickUntick.tag == 0 {
                        viewModel.tempReligion.append(viewModel.religions[indexPath.row].id)
                        cell.imageTickUntick.tag = 1
                    } else {
                        viewModel.tempReligion = viewModel.tempReligion.filter { $0 != viewModel.religions[indexPath.row].id }
                        cell.imageTickUntick.tag = 0
                    }
                    viewModel.filteredData["religion"] = viewModel.tempReligion

//                case 5: // RELATIONSHIP STATUS
//                    if cell.imageTickUntick.tag == 0 {
//                        viewModel.tempRelationship.append(viewModel.relationships[indexPath.row].id)
//                        cell.imageTickUntick.tag = 1
//                    } else {
//                        viewModel.tempRelationship = viewModel.tempRelationship.filter { $0 != viewModel.relationships[indexPath.row].id }
//                        cell.imageTickUntick.tag = 0
//                    }
//                    viewModel.filteredData["relationship"] = viewModel.tempRelationship

                case 5: // EDUCATION
                    if cell.imageTickUntick.tag == 0 {
                        viewModel.tempEducation.append(viewModel.educations[indexPath.row].id)
                        cell.imageTickUntick.tag = 1
                    } else {
                        viewModel.tempEducation = viewModel.tempEducation.filter { $0 != viewModel.educations[indexPath.row].id }
                        cell.imageTickUntick.tag = 0
                    }
                    viewModel.filteredData["education"] = viewModel.tempEducation

                case 6: // WORK INDUSTRY
                    if cell.imageTickUntick.tag == 0 {
                        viewModel.tempWorkIndustry.append(viewModel.workIndustries[indexPath.row].id)
                        cell.imageTickUntick.tag = 1
                    } else {
                        viewModel.tempWorkIndustry = viewModel.tempWorkIndustry.filter { $0 != viewModel.workIndustries[indexPath.row].id }
                        cell.imageTickUntick.tag = 0
                    }
                    viewModel.filteredData["workIndustry"] = viewModel.tempWorkIndustry

                case 7: // PASSIONS
                    if cell.imageTickUntick.tag == 0 {
                        viewModel.tempPassions.append(viewModel.passions[indexPath.row].id)
                        cell.imageTickUntick.tag = 1
                    } else {
                        viewModel.tempPassions = viewModel.tempPassions.filter { $0 != viewModel.passions[indexPath.row].id }
                        cell.imageTickUntick.tag = 0
                    }
                    viewModel.filteredData["passions"] = viewModel.tempPassions

                case 8: // MOVIES/TV
                    if cell.imageTickUntick.tag == 0 {
                        viewModel.tempMovies.append(viewModel.movies[indexPath.row].id)
                        cell.imageTickUntick.tag = 1
                    } else {
                        viewModel.tempMovies = viewModel.tempMovies.filter { $0 != viewModel.movies[indexPath.row].id }
                        cell.imageTickUntick.tag = 0
                    }
                    viewModel.filteredData["movies"] = viewModel.tempMovies

                case 9: // MUSIC
                    if cell.imageTickUntick.tag == 0 {
                        viewModel.tempMusic.append(viewModel.musics[indexPath.row].id)
                        cell.imageTickUntick.tag = 1
                    } else {
                        viewModel.tempMusic = viewModel.tempMusic.filter { $0 != viewModel.musics[indexPath.row].id }
                        cell.imageTickUntick.tag = 0
                    }
                    viewModel.filteredData["music"] = viewModel.tempMusic
                    
                case 10: // SMOCKING
                    if cell.imageTickUntick.tag == 0 {
                        viewModel.tempSmoking.append(viewModel.smokings[indexPath.row].id)
                        cell.imageTickUntick.tag = 1
                    } else {
                        viewModel.tempSmoking = viewModel.tempSmoking.filter { $0 != viewModel.smokings[indexPath.row].id }
                        cell.imageTickUntick.tag = 0
                    }
                    viewModel.filteredData["smokingIds"] = viewModel.tempSmoking
                    
                case 11: // DRIKING
                    if cell.imageTickUntick.tag == 0 {
                        viewModel.tempDriking.append(viewModel.drinkings[indexPath.row].id)
                        cell.imageTickUntick.tag = 1
                    } else {
                        viewModel.tempDriking = viewModel.tempDriking.filter { $0 != viewModel.drinkings[indexPath.row].id }
                        cell.imageTickUntick.tag = 0
                    }
                    viewModel.filteredData["drinkingIds"] = viewModel.tempDriking
                    
                case 13: // ZODIAC
                    if cell.imageTickUntick.tag == 0 {
                        viewModel.tempZodiaces.append(viewModel.zodiaces[indexPath.row].id)
                        cell.imageTickUntick.tag = 1
                    } else {
                        viewModel.tempZodiaces = viewModel.tempZodiaces.filter { $0 != viewModel.zodiaces[indexPath.row].id }
                        cell.imageTickUntick.tag = 0
                    }
                    viewModel.filteredData["zodiacIds"] = viewModel.tempZodiaces
                  //  detailTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                    
                case 14: // KIDS
                    if cell.imageTickUntick.tag == 0 {
                        viewModel.tempKids.append(viewModel.kids[indexPath.row].id)
                        cell.imageTickUntick.tag = 1
                    } else {
                        viewModel.tempKids = viewModel.tempKids.filter { $0 != viewModel.kids[indexPath.row].id }
                        cell.imageTickUntick.tag = 0
                    }
                    viewModel.filteredData["kidsIds"] = viewModel.tempKids
                 //   detailTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                    
                case 15: // PERSONALITY
                    if cell.imageTickUntick.tag == 0 {
                        viewModel.tempPersonalities.append(viewModel.personalities[indexPath.row].id)
                        cell.imageTickUntick.tag = 1
                    } else {
                        viewModel.tempPersonalities = viewModel.tempPersonalities.filter { $0 != viewModel.personalities[indexPath.row].id }
                        cell.imageTickUntick.tag = 0
                    }
                    viewModel.filteredData["personality"] = viewModel.tempPersonalities
                default: print("others")
                }
                
            }
        }
    }
}

