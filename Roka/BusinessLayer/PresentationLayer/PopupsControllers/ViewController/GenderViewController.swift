//
//  GenderViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 22/09/22.
//

import UIKit

class GenderViewController: BaseAlertViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.popups
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.gender
    }

    lazy var viewModel: GenderViewModel = GenderViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(over host: UIViewController,
                    isComeFor : String,
                    isFriend : Bool,
                    genderArray : [GenderRow],
                    selectedGenderId : String,
                    completionHandler: @escaping ((String, String, Int) -> Void),
                    preferredCompletionHandler: @escaping ((String, [String], Int) -> Void)) {
        let controller = self.getController() as! GenderViewController
       
        controller.show(over: host,isComeFor: isComeFor, isFriend:isFriend, genderArray:genderArray, selectedGenderId: selectedGenderId, completionHandler: completionHandler, preferredCompletionHandler: preferredCompletionHandler)
    }
    
    func show(over host: UIViewController,
              isComeFor : String,
              isFriend : Bool,
              genderArray : [GenderRow],
              selectedGenderId : String,
              completionHandler: @escaping ((String, String, Int) -> Void),
              preferredCompletionHandler: @escaping ((String, [String], Int) -> Void)) {
                  viewModel.completionHandler = completionHandler
                  viewModel.preferredCompletionHandler = preferredCompletionHandler
                  viewModel.isComeFor = isComeFor
                  viewModel.isFriend = isFriend
                  viewModel.selectedGenderId = selectedGenderId
                  viewModel.genderArray = genderArray
        show(over: host)
    }
    
    func showBasic(over host: UIViewController,
              isComeFor : String,
              isBasicPrivate : Bool,
              genderArray : [GenderRow],
              selectedGenderId : String,
              completionHandler: @escaping ((String,String, Int) -> Void),
              preferredCompletionHandler: @escaping ((String, [String], Int) -> Void)) {
                  viewModel.completionHandler = completionHandler
                  viewModel.preferredCompletionHandler = preferredCompletionHandler
                  viewModel.isComeFor = isComeFor
                  viewModel.isBasicPrivate = isBasicPrivate
                  viewModel.selectedGenderId = selectedGenderId
                  viewModel.genderArray = genderArray
        show(over: host)
    }
    
    
    @IBOutlet weak var sliderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var rangeSlider1: RangeSeekSlider!
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var popupTitleLable: UILabel!
    @IBOutlet weak var privateStackView: UIStackView!
    @IBOutlet weak var privateButton: UIButton!
    @IBOutlet weak var popupViewHeight: NSLayoutConstraint!
    @IBOutlet weak var privateLineImage: UIImageView!
    @IBOutlet weak var tableViewTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sliderView.isHidden = true
        viewModel.tableView = tableView
        viewModel.privateButton = privateButton
        viewModel.popupViewHeight = popupViewHeight
        viewModel.sliderView = sliderView
        viewModel.rangeSlider1 = rangeSlider1
        viewModel.tableViewBottom = tableViewBottom
        viewModel.sliderViewHeight = sliderViewHeight
        viewModel.rangeSlider1Initialize()
        self.privateButton.setImage(UIImage(named: "ic_toggle_active_generic"), for: .normal)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
        if viewModel.isComeFor == "Ethencity" ||
            viewModel.isComeFor == "Religion" ||
            viewModel.isComeFor == "Relationships" ||
            viewModel.isComeFor == "Education" ||
            viewModel.isComeFor == "Work" ||
            viewModel.isComeFor == "Passion" ||
            viewModel.isComeFor == "Movies" ||
            viewModel.isComeFor == "Music" ||
            viewModel.isComeFor == "Drinking" ||
            viewModel.isComeFor == "Smoking" ||
            viewModel.isComeFor == "TV" ||
            viewModel.isComeFor == "Zodiac" ||
            viewModel.isComeFor == "Kids" ||
            viewModel.isComeFor == "Personality" ||
            viewModel.isComeFor == "Sexual" ||
            viewModel.isComeFor == "Workout" ||
            viewModel.isComeFor == "Sports" ||
            viewModel.isComeFor == "Books" ||
            viewModel.isComeFor == "AboutMeWishing"
        {
            privateStackView.isHidden = false
            privateLineImage.isHidden = false
            tableViewTop.constant = 75
        } else {
            privateStackView.isHidden = true
            privateLineImage.isHidden = true
            tableViewTop.constant = 20
        }
    }
    
    func updateUI() {
        if viewModel.isComeFor == "MoreDetailGender" || viewModel.isComeFor == "Gender" {
            if GlobalVariables.shared.selectedProfileMode != "MatchMaking"{
                popupTitleLable.text = StringConstants.selectGender
            } else {
                popupTitleLable.text = StringConstants.selectFGender
            }
            viewModel.refreshPopupHeight(arr: viewModel.genderArray)
            viewModel.refreshUI()
        } else if viewModel.isComeFor == "PreferredGender" {
            popupTitleLable.text = StringConstants.selectPrefGender
            viewModel.refreshUI()
            viewModel.refreshPopupHeight(arr: viewModel.genderArray)
        } else if viewModel.isComeFor == "Wishing" {
            popupTitleLable.text = StringConstants.selectWishing
            viewModel.processForGetWishingData(type: "2")
        } else if viewModel.isComeFor == "PreferenceGender" {
            popupTitleLable.text = StringConstants.selectPrefGender
            viewModel.refreshUI()
            viewModel.refreshPopupHeight(arr: viewModel.genderArray)
        } else if viewModel.isComeFor == "Ethencity" {
            popupTitleLable.text = StringConstants.selectEthencity
            viewModel.processForGetEthentcityData(type: "1")
        } else if viewModel.isComeFor == "PreferenceEthencity" {
            popupTitleLable.text = StringConstants.selectPreferredEthencity
            viewModel.processForGetEthentcityData(type: "2")
        } else if viewModel.isComeFor == "PreferenceAboutMeWishing" {
            popupTitleLable.text = StringConstants.selectPreferedWishing
            viewModel.processForGetWishingData(type: "2")
        } else if viewModel.isComeFor == "Religion" {
            popupTitleLable.text = StringConstants.selectReligion
            viewModel.processForGetReligionData(type: "1")
        } else if viewModel.isComeFor == "PreferenceReligion" {
            popupTitleLable.text = StringConstants.selectPreferredReligion
            viewModel.processForGetReligionData(type: "2")
        } else if viewModel.isComeFor == "Relationships" {
            popupTitleLable.text = StringConstants.relationship
            viewModel.processForGetRelationshipsData(type: "1")
        } else if viewModel.isComeFor == "PreferenceRelationships" {
            popupTitleLable.text = StringConstants.selectRelationship
            viewModel.processForGetRelationshipsData(type: "2")
        } else if viewModel.isComeFor == "Education" {
            popupTitleLable.text = StringConstants.selectEducation
            viewModel.processForGetEducationData(type: "1")
        } else if viewModel.isComeFor == "PreferenceEducation" {
            popupTitleLable.text = StringConstants.selectPreferredEducation
            viewModel.processForGetEducationData(type: "2")
        } else if viewModel.isComeFor == "Work" {
            popupTitleLable.text = StringConstants.selectWork
            viewModel.processForGetWorkIndustryData(type: "1")
        } else if viewModel.isComeFor == "PreferenceWork" {
            popupTitleLable.text = StringConstants.selectPreferredWork
            viewModel.processForGetWorkIndustryData(type: "2")
        } else if viewModel.isComeFor == "Passion" {
            popupTitleLable.text = StringConstants.selectPassion
            viewModel.processForGetPassionData(type: "1")
        } else if viewModel.isComeFor == "PreferencePassion" {
            popupTitleLable.text = StringConstants.selectPreferredPassion
            viewModel.processForGetPassionData(type: "2")
        } else if viewModel.isComeFor == "Movies" {
            popupTitleLable.text = StringConstants.selectMovies
            viewModel.processForGetMovieData(type: "1")
        } else if viewModel.isComeFor == "Music" {
            popupTitleLable.text = StringConstants.selectMusic
            viewModel.processForGetMusicData(type: "1")
        } else if viewModel.isComeFor == "Drinking" {
            popupTitleLable.text = StringConstants.selectDrinking
            viewModel.processForGetDrinkingData(type: "1")
        } else if viewModel.isComeFor == "PreferenceDrinking" {
            popupTitleLable.text = StringConstants.selectPreferredDrinking
            viewModel.processForGetDrinkingData(type: "2")
        } else if viewModel.isComeFor == "Smoking" {
            popupTitleLable.text = StringConstants.selectSmoking
            viewModel.processForGetSmokingData(type: "1")
        } else if viewModel.isComeFor == "PreferenceSmoking" {
            popupTitleLable.text = StringConstants.selectPreferredSmoking
            viewModel.processForGetSmokingData(type: "2")
        } else if viewModel.isComeFor == "TV" {
            popupTitleLable.text = StringConstants.selectTV
            viewModel.processForGetTVData(type: "1")
        } else if viewModel.isComeFor == "sexualPreference" {
            popupTitleLable.text = StringConstants.selectSexualPreference
            viewModel.sexualArray = viewModel.genderArray
            viewModel.refreshUI()
        } else if viewModel.isComeFor == "sexualPreference2" {
            popupTitleLable.text = StringConstants.selectPrefGender
            viewModel.sexualArray = viewModel.genderArray
            viewModel.refreshUI()
        } else if viewModel.isComeFor == "Zodiac" {
            popupTitleLable.text = StringConstants.selectZodiac
            viewModel.processForGetZodiacData(type: "1")
        } else if viewModel.isComeFor == "PreferenceZodiac" {
            popupTitleLable.text = StringConstants.selectPreferredZodiac
            viewModel.processForGetZodiacData(type: "2")
        } else if viewModel.isComeFor == "Kids" {
            popupTitleLable.text = StringConstants.selectKids
            viewModel.processForGetKidsData(type: "1")
        } else if viewModel.isComeFor == "PreferenceKids" {
            popupTitleLable.text = StringConstants.selectPreferredKids
            viewModel.processForGetKidsData(type: "2")
        } else if viewModel.isComeFor == "Personality" {
            popupTitleLable.text = StringConstants.selectPersonality
            viewModel.processForGetPersonalityData(type: "1")
        } else if viewModel.isComeFor == "PreferencePersonality" {
            popupTitleLable.text = StringConstants.selectPreferredPersonality
            viewModel.processForGetPersonalityData(type: "2")
        } else if viewModel.isComeFor == "Sexual" {
            popupTitleLable.text = StringConstants.selectSexual
            viewModel.processForGetSexualOrientationData(type: "1")
        } else if viewModel.isComeFor == "Workout" {
            popupTitleLable.text = StringConstants.selectWorkout
            viewModel.processForGetWorkoutData(type: "1")
        } else if viewModel.isComeFor == "Sports" {
            popupTitleLable.text = StringConstants.selectSports
            viewModel.processForGetSportsData(type: "1")
        } else if viewModel.isComeFor == "Books" {
            popupTitleLable.text = StringConstants.selectBooks
            viewModel.processForGetBooksData(type: "1")
        } else if viewModel.isComeFor == "PreferenceBooks" {
            popupTitleLable.text = StringConstants.selectBooks
            viewModel.processForGetBooksData(type: "2")
        } else if viewModel.isComeFor == "AboutMeWishing" {
            popupTitleLable.text = StringConstants.selectWishing
            viewModel.processForGetWishingData(type: "2")
        } else if viewModel.isComeFor == "BasicRelationships" {
            popupTitleLable.text = StringConstants.selectRelationship
            viewModel.refreshPopupHeight(arr: viewModel.genderArray)
            viewModel.refreshUI()
        }
    }
    
    @IBAction func privateButtonAction(_ sender: UIButton) {
        if self.privateButton.currentImage == UIImage(named: "ic_toggle_active_generic") {
            self.privateButton.setImage(UIImage(named: "ic_toggle_off_generic"), for: .normal)
            self.viewModel.isPrivate = 0
        } else{
            self.privateButton.setImage(UIImage(named: "ic_toggle_active_generic"), for: .normal)
            self.viewModel.isPrivate = 1
        }
    }
    
    @IBAction func saveButtonActiob(_ sender: UIButton) {
        viewModel.saveButtonAction()
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss()
    }
}
