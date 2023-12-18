//
//  MoviesViewController.swift
//  Roka
//
//  Created by Pankaj Rana on 11/10/22.
//

import UIKit
import TagListView

class MoviesViewController: BaseAlertViewController {
    
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.popups
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.movies
    }
    
    lazy var viewModel: MovieViewModel = MovieViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(over host: UIViewController,
                    isCome:String,
                    isFriend : Bool,
                    completionHandler: @escaping ((Int, [String]) -> Void)) {
        let controller = self.getController() as! MoviesViewController
        controller.viewModel.isCome = isCome
        controller.show(over: host, isCome: isCome, isFriend: isFriend, completionHandler: completionHandler)
    }
    
    func show(over host: UIViewController,
              isCome:String,
              isFriend : Bool,
              completionHandler: @escaping ((Int, [String]) -> Void)) {
        viewModel.completionHandler = completionHandler
        viewModel.isCome = isCome
        viewModel.isFriend = isFriend
        show(over: host)
    }
    @IBOutlet weak var privateStackView: UIStackView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var privateButton: UIButton!
    
    @IBOutlet weak var movieTextFields: SearchTextField!
    @IBOutlet weak var addMovieLable: UILabel!
    @IBOutlet weak var tagListView: TagListView!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var rangeSlider2: RangeSeekSlider!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var privateLine: UIImageView!
    @IBOutlet weak var tableViewTop: NSLayoutConstraint!
    
    var selectedMoviesName = [String]()
    var selectedMusicsName = [String]()
    var selectedPassionName = [String]()
    var selectedTVName = [String]()
    var selectedBooksName = [String]()
    var selectedSportsName = [String]()
    var selectedWorkIndustryName = [String]()
    var selectedWorkoutName = [String]()
    var selectedMoviesids = [String]()
    var selectedMusicsids = [String]()
    var selectedPassionids = [String]()
    var selectedSportsids = [String]()
    var selectedBooksids = [String]()
    var selectedTVids = [String]()
    var selectedWorkIndustryids = [String]()
    var selectedWorkoutids = [String]()
    var genderArrayIndex = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.rangeSlider2 = rangeSlider2
        viewModel.rangeSlider2Initialize()
        setupTitleName()
        if viewModel.isCome == "PreferenceMovies" ||
            viewModel.isCome == "PreferenceMusic" ||
            viewModel.isCome == "PreferenceTV" ||
            viewModel.isCome == "PreferencePassion" ||
            viewModel.isCome == "PreferenceWorkout" ||
            viewModel.isCome == "PreferencesBooks" ||
            viewModel.isCome == "PreferencesSports" ||
            viewModel.isCome == "PreferenceWork" { 
            bottomView.isHidden = false
            bottomViewHeight.constant = 90
            privateStackView.isHidden = true
            privateLine.isHidden = true
            tableViewTop.constant = 30
            updateUserPerferenceData()
        } else{
            bottomView.isHidden = true
            bottomViewHeight.constant = 0
            tableViewTop.constant = 75
            privateStackView.isHidden = false
            privateLine.isHidden = false
            updateUserData()
        }
    
        self.privateButton.setImage(UIImage(named: "ic_toggle_active_generic"), for: .normal)
        // Do any additional setup after loading the view.
    }
    

    func updateUserData() {
        viewModel.processForGetUserProfileData { userData in
           if self.viewModel.isCome == "Passion" {
                // Passion
                if let userPassion = userData?["userPassion"] as? [[String:Any]] {
                    for val in userPassion {
                        if let passion = val["passion"] as? [String:Any]{
                            self.selectedPassionName.append(passion["name"] as? String ?? "")
                            self.selectedPassionids.append(passion["id"] as? String ?? "")
                        }
                    }
                }
               
               if userData?["isPassionsPrivate"] as? Int == 0 {
                   self.privateButton.setImage(UIImage(named: "ic_toggle_off_generic"), for: .normal)
                   self.viewModel.isPrivate = 0
               } else {
                   self.privateButton.setImage(UIImage(named: "ic_toggle_active_generic"), for: .normal)
                   self.viewModel.isPrivate = 1
               }
            }
            else if self.viewModel.isCome == "Movies" {
                // userMovies
                if let userMovies = userData?["userMovies"] as? [[String:Any]] {
                    for val in userMovies {
                        if let movie = val["movie"] as? [String:Any]{
                            self.selectedMoviesName.append(movie["name"] as? String ?? "")
                            self.selectedMoviesids.append(movie["id"] as? String ?? "")
                        }
                    }
                }
                if userData?["isMoviesPrivate"] as? Int == 0 {
                    self.privateButton.setImage(UIImage(named: "ic_toggle_off_generic"), for: .normal)
                    self.viewModel.isPrivate = 0
                } else {
                    self.privateButton.setImage(UIImage(named: "ic_toggle_active_generic"), for: .normal)
                    self.viewModel.isPrivate = 1
                }
            }
            else if self.viewModel.isCome == "TV" {
                // userTelevisionSeries
                if let userMusic = userData?["userTelevisionSeries"] as? [[String:Any]] {
                    for val in userMusic {
                        if let music = val["televisionSery"] as? [String:Any]{
                            self.selectedTVName.append(music["name"] as? String ?? "")
                            self.selectedTVids.append(music["id"] as? String ?? "")
                        }
                    }
                }
                if userData?["isTvSeriesPrivate"] as? Int == 0 {
                    self.privateButton.setImage(UIImage(named: "ic_toggle_off_generic"), for: .normal)
                    self.viewModel.isPrivate = 0
                } else {
                    self.privateButton.setImage(UIImage(named: "ic_toggle_active_generic"), for: .normal)
                    self.viewModel.isPrivate = 1
                }
            } else {
                // userMusic
                if let userMusic = userData?["userMusic"] as? [[String:Any]] {
                    for val in userMusic {
                        if let music = val["music"] as? [String:Any]{
                            self.selectedMusicsName.append(music["name"] as? String ?? "")
                            self.selectedMusicsids.append(music["id"] as? String ?? "")
                        }
                    }
                }
                
                if userData?["isMusicPrivate"] as? Int == 0 {
                    self.privateButton.setImage(UIImage(named: "ic_toggle_off_generic"), for: .normal)
                    self.viewModel.isPrivate = 0
                } else {
                    self.privateButton.setImage(UIImage(named: "ic_toggle_active_generic"), for: .normal)
                    self.viewModel.isPrivate = 1
                }
            }
            
            self.setupUI()
        }
    }
    func updateUserPerferenceData() {
        viewModel.processForGetUserPreferenceProfileData { userData in
            if self.viewModel.isCome == "PreferencePassion" {
                // Passion
                if let userPassion = userData?["userPassionPreferences"] as? [[String:Any]] {
                    for val in userPassion {
                        if let passion = val["passion"] as? [String:Any] {
                            self.selectedPassionName.append(passion["name"] as? String ?? "")
                            self.selectedPassionids.append(passion["id"] as? String ?? "")
                        }
                    }
//                    self.tagListView.removeAllTags()
//                    self.tagListView.addTags(self.selectedPassionName)
                    if userPassion.count != 0 {
                        if let userPreferences = userData?["userPreferences"] as? [[String:Any]] {
                            let userPreference = userPreferences[0]
                            if let workIndustryPriority = userPreference["passionPriority"] as? Int {
                                self.viewModel.selectedPriority = workIndustryPriority
                                self.viewModel.rangeSlider2Initialize()
                                self.viewModel.rangeSlider2.layoutSubviews()
                            }
                        }
                    }
                }
            }
            else if self.viewModel.isCome == "PreferenceMovies" {
                // userMovies
                if let userMovies = userData?["userMoviesPreferences"] as? [[String:Any]] {
                    for val in userMovies {
                        if let movie = val["movie"] as? [String:Any] {
                            self.selectedMoviesName.append(movie["name"] as? String ?? "")
                            self.selectedMoviesids.append(movie["id"] as? String ?? "")
                        }
                    }
//                    self.tagListView.removeAllTags()
//                    self.tagListView.addTags(self.selectedMoviesName)
                    if userMovies.count != 0 {
                        if let userPreferences = userData?["userPreferences"] as? [[String:Any]] {
                            let userPreference = userPreferences[0]
                            if let workIndustryPriority = userPreference["moviesPriority"] as? Int {
                                self.viewModel.selectedPriority = workIndustryPriority
                                self.viewModel.rangeSlider2Initialize()
                                self.viewModel.rangeSlider2.layoutSubviews()
                            }
                        }
                    }
                }
            }
            else if self.viewModel.isCome == "PreferenceWork" {
                // userTelevisionSeries
                if let userMusic = userData?["userWorkIndustriesPreferences"] as? [[String:Any]] {
                    for val in userMusic {
                        if let music = val["workIndustry"] as? [String:Any] {
                            self.selectedWorkIndustryName.append(music["name"] as? String ?? "")
                            self.selectedWorkIndustryids.append(music["id"] as? String ?? "")
                        }
                    }
                    if userMusic.count != 0 {
                        if let userPreferences = userData?["userPreferences"] as? [[String:Any]] {
                            let userPreference = userPreferences[0]
                            if let workIndustryPriority = userPreference["workIndustryPriority"] as? Int {
                                self.viewModel.selectedPriority = workIndustryPriority
                                self.viewModel.rangeSlider2Initialize()
                                self.viewModel.rangeSlider2.layoutSubviews()
                            }
                        }
                    }
                }
            } else if self.viewModel.isCome == "PreferenceWorkout" {
                // PreferenceWorkout
                if let userMusic = userData?["userWorkoutPreferences"] as? [[String:Any]] {
                    for val in userMusic {
                        if let music = val["workout"] as? [String:Any]{
                            self.selectedWorkoutName.append(music["name"] as? String ?? "")
                            self.selectedWorkoutids.append(music["id"] as? String ?? "")
                        }
                    }
                    if userMusic.count != 0{
                        if let userPreferences = userData?["userPreferences"] as? [[String:Any]] {
                            let userPreference = userPreferences[0]
                            if let workIndustryPriority = userPreference["isWorkOutPriority"] as? Int{
                                self.viewModel.selectedPriority = workIndustryPriority
                                self.viewModel.rangeSlider2Initialize()
                                self.viewModel.rangeSlider2.layoutSubviews()
                            }
                        }
                    }
                }
                
            } else if self.viewModel.isCome == "PreferencesBooks" {
                // PreferencesBooks
                if let userMusic = userData?["userBooksPreferences"] as? [[String:Any]] {
                    for val in userMusic {
                        if let music = val["book"] as? [String:Any] {
                            self.selectedBooksName.append(music["name"] as? String ?? "")
                            self.selectedBooksids.append(music["id"] as? String ?? "")
                        }
                    }
//                    self.tagListView.removeAllTags()
//                    self.tagListView.addTags(self.selectedTVName)
                    if userMusic.count != 0{
                        
                        if let userPreferences = userData?["userPreferences"] as? [[String:Any]] {
                            let userPreference = userPreferences[0]
                            if let workIndustryPriority = userPreference["isBookPriority"] as? Int{
                                self.viewModel.selectedPriority = workIndustryPriority
                                self.viewModel.rangeSlider2Initialize()
                                self.viewModel.rangeSlider2.layoutSubviews()
                            }
                        }
                    }
                }
            } else if self.viewModel.isCome == "PreferencesSports" {
                // PreferencesBooks
                if let userMusic = userData?["userSportsPreferences"] as? [[String:Any]] {
                    for val in userMusic {
                        if let music = val["sport"] as? [String:Any]{
                            self.selectedSportsName.append(music["name"] as? String ?? "")
                            self.selectedSportsids.append(music["id"] as? String ?? "")
                        }
                    }
//                    self.tagListView.removeAllTags()
//                    self.tagListView.addTags(self.selectedTVName)
                    if userMusic.count != 0{
                        
                        if let userPreferences = userData?["userPreferences"] as? [[String:Any]] {
                            let userPreference = userPreferences[0]
                            if let workIndustryPriority = userPreference["isSportPriority"] as? Int{
                                self.viewModel.selectedPriority = workIndustryPriority
                                self.viewModel.rangeSlider2Initialize()
                                self.viewModel.rangeSlider2.layoutSubviews()
                            }
                        }
                    }
                }
            } else if self.viewModel.isCome == "PreferenceTV" {
                // userTelevisionSeries
                if let userMusic = userData?["userTelevisionSeriesPreferances"] as? [[String:Any]] {
                    for val in userMusic {
                        if let music = val["televisionSery"] as? [String:Any]{
                            self.selectedTVName.append(music["name"] as? String ?? "")
                            self.selectedTVids.append(music["id"] as? String ?? "")
                        }
                    }
//                    self.tagListView.removeAllTags()
//                    self.tagListView.addTags(self.selectedTVName)
                    if userMusic.count != 0{
                        
                        if let userPreferences = userData?["userPreferences"] as? [[String:Any]] {
                            let userPreference = userPreferences[0]
                            if let workIndustryPriority = userPreference["televisionSeriesPriority"] as? Int{
                                self.viewModel.selectedPriority = workIndustryPriority
                                self.viewModel.rangeSlider2Initialize()
                                self.viewModel.rangeSlider2.layoutSubviews()
                            }
                        }
                    }
                }
            } else {
                // userMusic
                if let userMusic = userData?["userMusicPreferences"] as? [[String:Any]] {
                    for val in userMusic {
                        if let music = val["music"] as? [String:Any]{
                            self.selectedMusicsName.append(music["name"] as? String ?? "")
                            self.selectedMusicsids.append(music["id"] as? String ?? "")
                        }
                    }
    //                    self.tagListView.removeAllTags()
    //                    self.tagListView.addTags(self.selectedMusicsName)
                    if userMusic.count != 0{
                        if let userPreferences = userData?["userPreferences"] as? [[String:Any]] {
                            let userPreference = userPreferences[0]
                            if let workIndustryPriority = userPreference["musicPriority"] as? Int{
                                self.viewModel.selectedPriority = workIndustryPriority
                                self.viewModel.rangeSlider2Initialize()
                                self.viewModel.rangeSlider2.layoutSubviews()
                            }
                        }
                    }
                }
            }
            
            self.setupUI()
        }
    }
    func setupTitleName() {
        if viewModel.isCome == "Movies" {
            titleLable.text = "Movie/TV genre"
        } else if viewModel.isCome == "PreferenceMovies" {
            titleLable.text = "Select preferred movie/tv genre"
        } else if viewModel.isCome == "Passion" {
            titleLable.text = "Passion"
        } else if viewModel.isCome == "PreferencePassion" {
            titleLable.text = StringConstants.selectPreferredPassion
        } else if viewModel.isCome == "TV" {
            titleLable.text = "TV Series"
        } else if  viewModel.isCome == "PreferenceTV" {
            titleLable.text = "Select preferred tv series"
        } else if viewModel.isCome == "PreferenceWork" {
            titleLable.text = StringConstants.selectPreferredWork
        } else if self.viewModel.isCome == "PreferenceWorkout" {
            titleLable.text = StringConstants.selectPreferredWorkout
        } else if viewModel.isCome == "PreferenceMusic" {
            titleLable.text = "Select preferred music genre"
        } else if viewModel.isCome == "PreferencesBooks" {
            titleLable.text = "Select preferred books genre"
        } else if self.viewModel.isCome == "PreferencesSports" {
            titleLable.text = StringConstants.selectPreferredSport
        } else {
            titleLable.text = "Music genre"
        }
    }
    
    func setupUI() {
        if viewModel.isCome == "Movies" {
            titleLable.text = "Movie/TV genre"
            viewModel.processForGetMovieData(type: "1") { success in
                if success == true {
                    for _ in 0..<self.viewModel.moviesArray.count {
                        self.genderArrayIndex.append("NO")
                    }
                    
                    let ids = self.selectedMoviesids
                    for id in ids {
                        for i in 0..<self.viewModel.moviesArray.count {
                            if id == self.viewModel.moviesArray[i].id {
                                self.genderArrayIndex[i] = "YES"
                            }
                        }
                    }
                }
                self.tableView.reloadData()
            }
        } else if viewModel.isCome == "PreferenceMovies" {
            titleLable.text = "Select preferred movie/tv genre"
            viewModel.processForGetMovieData(type: "2") { success in
                if success == true {
                    for _ in 0..<self.viewModel.moviesArray.count {
                        self.genderArrayIndex.append("NO")
                    }
                    
                    let ids = self.selectedMoviesids
                    for id in ids {
                        for i in 0..<self.viewModel.moviesArray.count {
                            if id == self.viewModel.moviesArray[i].id {
                                self.genderArrayIndex[i] = "YES"
                            }
                        }
                    }
                }
                self.tableView.reloadData()

            }
        } else if viewModel.isCome == "Passion" {
            titleLable.text = "Passion"
            viewModel.processForGetPassionData(type: "1") { success in
                if success == true {
                    for _ in 0..<self.viewModel.passionArray.count {
                        self.genderArrayIndex.append("NO")
                    }
                    
                    let ids = self.selectedPassionids
                    for id in ids {
                        for i in 0..<self.viewModel.passionArray.count {
                            if id == self.viewModel.passionArray[i].id {
                                self.genderArrayIndex[i] = "YES"
                            }
                        }
                    }
                }
                self.tableView.reloadData()
            }
        } else if viewModel.isCome == "PreferencePassion" {
            titleLable.text = StringConstants.selectPreferredPassion
            viewModel.processForGetPassionData(type: "2") { success in
                if success == true {
                    for _ in 0..<self.viewModel.passionArray.count {
                        self.genderArrayIndex.append("NO")
                    }
                    
                    let ids = self.selectedPassionids
                    for id in ids {
                        for i in 0..<self.viewModel.passionArray.count {
                            if id == self.viewModel.passionArray[i].id {
                                self.genderArrayIndex[i] = "YES"
                            }
                        }
                    }
                }
                self.tableView.reloadData()
            }
        } else if viewModel.isCome == "TV" {
            titleLable.text = "TV Series"
            viewModel.processForGetTVData(type: "1") { success in
                if success == true {
                    for _ in 0..<self.viewModel.tvSeriesArray.count {
                        self.genderArrayIndex.append("NO")
                    }
                    
                    let ids = self.selectedTVids
                    for id in ids {
                        for i in 0..<self.viewModel.tvSeriesArray.count {
                            if id == self.viewModel.tvSeriesArray[i].id {
                                self.genderArrayIndex[i] = "YES"
                            }
                        }
                    }
                }
                self.tableView.reloadData()
            }
        } else if  viewModel.isCome == "PreferenceTV" {
            titleLable.text = "Select preferred tv series"
            ////addMovieLable.text = "Add TV series"
            viewModel.processForGetTVData(type: "2") { success in
                if success == true {
                    for _ in 0..<self.viewModel.tvSeriesArray.count {
                        self.genderArrayIndex.append("NO")
                    }
                    
                    let ids = self.selectedTVids
                    for id in ids {
                        for i in 0..<self.viewModel.tvSeriesArray.count {
                            if id == self.viewModel.tvSeriesArray[i].id {
                                self.genderArrayIndex[i] = "YES"
                            }
                        }
                    }
                }
                self.tableView.reloadData()
            }
        } else if viewModel.isCome == "PreferenceWork" {
            titleLable.text = StringConstants.selectPreferredWork
            ////addMovieLable.text = "Add work industry"
            viewModel.processForGetWorkData(type: "2") { success in
                if success == true {
                    for _ in 0..<self.viewModel.workArray.count {
                        self.genderArrayIndex.append("NO")
                    }
                    
                    let ids = self.selectedWorkIndustryids
                    for id in ids {
                        for i in 0..<self.viewModel.workArray.count {
                            if id == self.viewModel.workArray[i].id {
                                self.genderArrayIndex[i] = "YES"
                            }
                        }
                    }
                    
                    self.tableView.reloadData()
                }
            }
        } else if self.viewModel.isCome == "PreferenceWorkout" {
            titleLable.text = StringConstants.selectPreferredWorkout
            viewModel.processForGetWorkoutData(type: "2") { success in
                if success == true {
                    for _ in 0..<self.viewModel.workoutArray.count {
                        self.genderArrayIndex.append("NO")
                    }
                    
                    let ids = self.selectedWorkoutids
                    for id in ids {
                        for i in 0..<self.viewModel.workoutArray.count {
                            if id == self.viewModel.workoutArray[i].id {
                                self.genderArrayIndex[i] = "YES"
                            }
                        }
                    }
                    
                    self.tableView.reloadData()
                }
            }
        } else if viewModel.isCome == "PreferenceMusic" {
            titleLable.text = "Select preferred music genre"
            ////addMovieLable.text = "Add music genre"
            viewModel.processForGetMusicData(type: "2") { success in
                if success == true {
                    for _ in 0..<self.viewModel.musicArray.count {
                        self.genderArrayIndex.append("NO")
                    }
                    
                    let ids = self.selectedMusicsids
                    for id in ids {
                        for i in 0..<self.viewModel.musicArray.count {
                            if id == self.viewModel.musicArray[i].id {
                                self.genderArrayIndex[i] = "YES"
                            }
                        }
                    }
                }
                self.tableView.reloadData()
            }
        } else if viewModel.isCome == "PreferencesBooks" {
            titleLable.text = "Select preferred books genre"
            ////addMovieLable.text = "Add music genre"
            viewModel.processForGetBooksData(type: "2") { success in
                if success == true {
                    for _ in 0..<self.viewModel.booksArray.count {
                        self.genderArrayIndex.append("NO")
                    }
                    
                    let ids = self.selectedBooksids
                    for id in ids {
                        for i in 0..<self.viewModel.booksArray.count {
                            if id == self.viewModel.booksArray[i].id {
                                self.genderArrayIndex[i] = "YES"
                            }
                        }
                    }
                }
                self.tableView.reloadData()
            }
        } else if self.viewModel.isCome == "PreferencesSports" {
            titleLable.text = StringConstants.selectPreferredSport
            viewModel.processForGetSportsData(type: "2") { success in
                if success == true {
                    for _ in 0..<self.viewModel.sportsArray.count {
                        self.genderArrayIndex.append("NO")
                    }
                    
                    let ids = self.selectedSportsids
                    for id in ids {
                        for i in 0..<self.viewModel.sportsArray.count {
                            if id == self.viewModel.sportsArray[i].id {
                                self.genderArrayIndex[i] = "YES"
                            }
                        }
                    }
                    
                    self.tableView.reloadData()
                }
            }
        } else {
            titleLable.text = "Music genre"
            ////addMovieLable.text = "Add music genre"
            viewModel.processForGetMusicData(type: "1") { success in
                if success == true {
                    for _ in 0..<self.viewModel.musicArray.count {
                        self.genderArrayIndex.append("NO")
                    }
                    
                    let ids = self.selectedMusicsids
                    for id in ids {
                        for i in 0..<self.viewModel.musicArray.count {
                            if id == self.viewModel.musicArray[i].id {
                                self.genderArrayIndex[i] = "YES"
                            }
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    func setupTagsView() {
        tagListView.delegate = self
        self.tagListView.removeAllTags()
        tagListView.textFont = UIFont(name: "SFProDisplay-Regular", size: 15.0)!
        
        if viewModel.isCome == "Movies" || viewModel.isCome == "PreferenceMovies" {
            tagListView.addTags(self.selectedMoviesName)
        } else if viewModel.isCome == "Passion" || viewModel.isCome == "PreferencePassion" {
            tagListView.addTags(self.selectedPassionName)
        } else if viewModel.isCome == "TV" || viewModel.isCome == "PreferenceTV" {
            tagListView.addTags(self.selectedTVName)
        } else if viewModel.isCome == "PreferenceWork" {
            tagListView.addTags(self.selectedWorkIndustryName)
        } else{
            tagListView.addTags(self.selectedMusicsName)
        }
    }
  
    // - Configure a simple search text view
    fileprivate func configureMoviesSearchTextField() {
        // Start visible even without user's interaction as soon as created - Default: false
        
        movieTextFields.startVisibleWithoutInteraction = false
        movieTextFields.theme.font = UIFont.systemFont(ofSize: 14)
        movieTextFields.theme.bgColor = UIColor.white
        movieTextFields.theme.cellHeight = 50
        movieTextFields.theme.separatorColor = UIColor.lightGray.withAlphaComponent(0.2)
        movieTextFields.theme.borderColor = UIColor.lightGray.withAlphaComponent(0.2)
        movieTextFields.theme.placeholderColor = UIColor.lightGray.withAlphaComponent(0.2)
       
        // Customize highlight attributes - Default: Bold
        movieTextFields.highlightAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
        
        // Max results list height - Default: No limit
        movieTextFields.maxResultsListHeight = 200
        
        // Set data source
        var name = [String]()
        var ids = [String]()
        if viewModel.isCome == "Movies" || viewModel.isCome == "PreferenceMovies"{
            for i in 0..<viewModel.moviesArray.count {
                name.append(viewModel.moviesArray[i].name)
                ids.append(viewModel.moviesArray[i].id)
            }
            movieTextFields.filterStrings(name, ids)
        } else if viewModel.isCome == "Passion" || viewModel.isCome == "PreferencePassion" {
            for i in 0..<viewModel.passionArray.count {
                name.append(viewModel.passionArray[i].name)
                ids.append(viewModel.passionArray[i].id)
            }
            movieTextFields.filterStrings(name, ids)
        } else if viewModel.isCome == "TV" || viewModel.isCome == "PreferenceTV" {
            for i in 0..<viewModel.tvSeriesArray.count {
                name.append(viewModel.tvSeriesArray[i].name)
                ids.append(viewModel.tvSeriesArray[i].id)
            }
            movieTextFields.filterStrings(name, ids)
        } else if viewModel.isCome == "PreferenceWork" {
            for i in 0..<viewModel.workArray.count {
                name.append(viewModel.workArray[i].name)
                ids.append(viewModel.workArray[i].id)
            }
            movieTextFields.filterStrings(name, ids)
        } else {
            for i in 0..<viewModel.musicArray.count {
                name.append(viewModel.musicArray[i].name)
                ids.append(viewModel.musicArray[i].id)
            }
            movieTextFields.filterStrings(name, ids)
        }
        // Handle item selection - Default behaviour: item title set to the text field
        
        movieTextFields.itemSelectionHandler = { filteredResults, itemPosition in
            // Just in case you need the item position
            let item = filteredResults[itemPosition]
            print("Item at position \(itemPosition): \(item.title)")
            
            if self.viewModel.isCome == "Movies" || self.viewModel.isCome == "PreferenceMovies" {
                if self.selectedMoviesName.count < 5 {
                    if !self.selectedMoviesName.contains(item.title) {
                        self.selectedMoviesName.append(item.title)
                        self.selectedMoviesids.append(item.id)
                        self.tagListView.removeAllTags()
                        self.tagListView.addTags(self.selectedMoviesName)
                    }
                    // Do whatever you want with the picked item
                    self.movieTextFields.text = ""
                } else {
                    showMessage(with: "max limit is 5")
                }
            }
            else if self.viewModel.isCome == "Passion" || self.viewModel.isCome == "PreferencePassion" {
                if self.selectedPassionName.count < 5 {
                    if !self.selectedPassionName.contains(item.title) {
                        self.selectedPassionName.append(item.title)
                        self.selectedPassionids.append(item.id)
                        self.tagListView.removeAllTags()
                        self.tagListView.addTags(self.selectedPassionName)
                    }
                    // Do whatever you want with the picked item
                    self.movieTextFields.text = ""
                } else {
                    showMessage(with: "max limit is 5")
                }
            } else if self.viewModel.isCome == "TV" || self.viewModel.isCome == "PreferenceTV" {
                if self.selectedTVName.count < 5 {
                    if !self.selectedTVName.contains(item.title) {
                        self.selectedTVName.append(item.title)
                        self.selectedTVids.append(item.id)
                        self.tagListView.removeAllTags()
                        self.tagListView.addTags(self.selectedTVName)
                    }
                    // Do whatever you want with the picked item
                    self.movieTextFields.text = ""
                } else {
                    showMessage(with: "max limit is 5")
                }
            } else if self.viewModel.isCome == "PreferenceWork" {
                if self.selectedTVName.count < 5 {
                    if !self.selectedWorkIndustryName.contains(item.title) {
                        self.selectedWorkIndustryName.append(item.title)
                        self.selectedWorkIndustryids.append(item.id)
                        self.tagListView.removeAllTags()
                        self.tagListView.addTags(self.selectedWorkIndustryName)
                    }
                    // Do whatever you want with the picked item
                    self.movieTextFields.text = ""
                } else {
                    showMessage(with: "max limit is 5")
                }
            }
            else{
                if self.selectedMusicsName.count < 5 {
                    if !self.selectedMusicsName.contains(item.title) {
                        self.selectedMusicsName.append(item.title)
                        self.selectedMusicsids.append(item.id)
                        self.tagListView.removeAllTags()
                        self.tagListView.addTags(self.selectedMusicsName)
                    }
                    // Do whatever you want with the picked item
                    self.movieTextFields.text = ""
                } else {
                    showMessage(with: "max limit is 5")
                }
            }
            self.view.endEditing(true)
        }
    }
    
    
    @IBAction func saveButtonActiob(_ sender: UIButton) {
        self.selectedMoviesids.removeAll()
        self.selectedPassionids.removeAll()
        self.selectedMusicsids.removeAll()
        self.selectedTVids.removeAll()
        self.selectedWorkIndustryids.removeAll()
        
        if viewModel.isCome == "Movies" {
            for i in 0..<genderArrayIndex.count {
                if self.genderArrayIndex[i] == "YES" {
                    selectedMoviesids.append(self.viewModel.moviesArray[i].id)
                }
            }
            if self.selectedMoviesids.count == 0 {
//                showMessage(with: StringConstants.selectValue)
                // Remove Check
                viewModel.completionHandler?(viewModel.isPrivate, self.selectedMoviesids)
                self.dismiss()
                // ----
            } else {
                viewModel.completionHandler?(viewModel.isPrivate, self.selectedMoviesids)
                self.dismiss()
            }
        } else if viewModel.isCome == "PreferenceMovies" {
            for i in 0..<genderArrayIndex.count {
                if self.genderArrayIndex[i] == "YES" {
                    selectedMoviesids.append(self.viewModel.moviesArray[i].id)
                }
            }
            if self.selectedMoviesids.count == 0 {
//                showMessage(with: StringConstants.selectValue)
                // Remove Check
                viewModel.completionHandler?(viewModel.priority, self.selectedMoviesids)
                self.dismiss()
                // ---
            } else {
                viewModel.completionHandler?(viewModel.priority, self.selectedMoviesids)
                self.dismiss()
            }
        } else if viewModel.isCome == "Passion" {
            for i in 0..<genderArrayIndex.count {
                if self.genderArrayIndex[i] == "YES" {
                    selectedPassionids.append(self.viewModel.passionArray[i].id)
                }
            }
            if self.selectedPassionids.count == 0 {
//                showMessage(with: StringConstants.selectValue)
                // Remove Check
                viewModel.completionHandler?(viewModel.isPrivate, self.selectedPassionids)
                self.dismiss()
                // ---
            } else {
                viewModel.completionHandler?(viewModel.isPrivate, self.selectedPassionids)
                self.dismiss()
            }
        } else if viewModel.isCome == "PreferencePassion" {
            for i in 0..<genderArrayIndex.count {
                if self.genderArrayIndex[i] == "YES" {
                    selectedPassionids.append(self.viewModel.passionArray[i].id)
                }
            }
            
            if self.selectedPassionids.count == 0 {
//                showMessage(with: StringConstants.selectValue)
                // Remove Check
                viewModel.completionHandler?(viewModel.priority, self.selectedPassionids)
                self.dismiss()
                // ----
            } else {
                viewModel.completionHandler?(viewModel.priority, self.selectedPassionids)
                self.dismiss()
            }
        } else if viewModel.isCome == "TV" {
            
            for i in 0..<genderArrayIndex.count {
                if self.genderArrayIndex[i] == "YES" {
                    selectedTVids.append(self.viewModel.tvSeriesArray[i].id)
                }
            }
            if self.selectedTVids.count == 0 {
                showMessage(with: StringConstants.selectValue)
            } else {
                viewModel.completionHandler?(viewModel.isPrivate, self.selectedTVids)
                self.dismiss()
            }
        }  else if viewModel.isCome == "PreferenceTV" {
            for i in 0..<genderArrayIndex.count {
                if self.genderArrayIndex[i] == "YES" {
                    selectedTVids.append(self.viewModel.tvSeriesArray[i].id)
                }
            }
            if self.selectedTVids.count == 0 {
                showMessage(with: StringConstants.selectValue)
            } else {
                viewModel.completionHandler?(viewModel.priority, self.selectedTVids)
                self.dismiss()
            }
        } else if viewModel.isCome == "PreferenceMusic" {
            for i in 0..<genderArrayIndex.count {
                if self.genderArrayIndex[i] == "YES" {
                    selectedMusicsids.append(self.viewModel.musicArray[i].id)
                }
            }
            if self.selectedMusicsids.count == 0 {
//                showMessage(with: StringConstants.selectValue)
                // Remove Check
                viewModel.completionHandler?(viewModel.priority, self.selectedMusicsids)
                self.dismiss()
                // ---
            } else {
                viewModel.completionHandler?(viewModel.priority, self.selectedMusicsids)
                self.dismiss()
            }
        } else if self.viewModel.isCome == "PreferenceWork" {
            for i in 0..<genderArrayIndex.count {
                if self.genderArrayIndex[i] == "YES" {
                    selectedWorkIndustryids.append(self.viewModel.workArray[i].id)
                }
            }
            if self.selectedWorkIndustryids.count == 0 {
//                showMessage(with: StringConstants.selectValue)
                viewModel.completionHandler?(viewModel.priority, self.selectedWorkIndustryids)
                self.dismiss()
            } else {
                viewModel.completionHandler?(viewModel.priority, self.selectedWorkIndustryids)
                self.dismiss()
            }
        } else if self.viewModel.isCome == "PreferenceWorkout" {
            self.selectedWorkoutids.removeAll()
            for i in 0..<genderArrayIndex.count {
                if self.genderArrayIndex[i] == "YES" {
                    selectedWorkoutids.append(self.viewModel.workoutArray[i].id)
                }
            }
            if self.selectedWorkoutids.count == 0 {
//                showMessage(with: StringConstants.selectValue)
                // remove check
                viewModel.completionHandler?(viewModel.priority, self.selectedWorkoutids)
                self.dismiss()
                // ---
            } else {
                viewModel.completionHandler?(viewModel.priority, self.selectedWorkoutids)
                self.dismiss()
            }
        } else if self.viewModel.isCome == "PreferencesBooks" {
            self.selectedBooksids.removeAll()
            for i in 0..<genderArrayIndex.count {
                if self.genderArrayIndex[i] == "YES" {
                    selectedBooksids.append(self.viewModel.booksArray[i].id)
                }
            }
            if self.selectedBooksids.count == 0 {
//                showMessage(with: StringConstants.selectValue)
                // Remove Check
                viewModel.completionHandler?(viewModel.priority, self.selectedBooksids)
                self.dismiss()
                // -----
            } else {
                viewModel.completionHandler?(viewModel.priority, self.selectedBooksids)
                self.dismiss()
            }
        } else if self.viewModel.isCome == "PreferencesSports" {
            self.selectedSportsids.removeAll()
            for i in 0..<genderArrayIndex.count {
                if self.genderArrayIndex[i] == "YES" {
                    selectedSportsids.append(self.viewModel.sportsArray[i].id)
                }
            }
            if self.selectedSportsids.count == 0 {
//                showMessage(with: StringConstants.selectValue)
                // Remove Check
                viewModel.completionHandler?(viewModel.priority, self.selectedSportsids)
                self.dismiss()
                // ----
            } else {
                viewModel.completionHandler?(viewModel.priority, self.selectedSportsids)
                self.dismiss()
            }
        } else {
            for i in 0..<genderArrayIndex.count {
                if self.genderArrayIndex[i] == "YES" {
                    selectedMusicsids.append(self.viewModel.musicArray[i].id)
                }
            }
            if self.selectedMusicsids.count == 0 {
//                showMessage(with: StringConstants.selectValue)
                // Remove Check
                viewModel.completionHandler?(viewModel.isPrivate, self.selectedMusicsids)
                self.dismiss()
                // ---
            } else {
                viewModel.completionHandler?(viewModel.isPrivate, self.selectedMusicsids)
                self.dismiss()
            }
        }
        
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss()
    }
    
    
    @IBAction func privateButtonAction(_ sender: UIButton) {
        if self.privateButton.currentImage == UIImage(named: "ic_toggle_active_generic"){
            self.privateButton.setImage(UIImage(named: "ic_toggle_off_generic"), for: .normal)
            viewModel.isPrivate = 0
        } else {
            self.privateButton.setImage(UIImage(named: "ic_toggle_active_generic"), for: .normal)
            viewModel.isPrivate = 1
        }
    }
}

extension MoviesViewController: TagListViewDelegate {
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
        if self.viewModel.isCome == "Movies" || viewModel.isCome == "PreferenceMovies" {
            if let index = self.selectedMoviesName.firstIndex(of: title) {
                self.selectedMoviesName.remove(at: index)
                self.selectedMoviesids.remove(at: index)
                self.tagListView.removeAllTags()
                self.tagListView.addTags(self.selectedMoviesName)
            }
        } else if self.viewModel.isCome == "Passion" || viewModel.isCome == "PreferencePassion" {
            if let index = self.selectedPassionName.firstIndex(of: title) {
                self.selectedPassionName.remove(at: index)
                self.selectedPassionids.remove(at: index)
                self.tagListView.removeAllTags()
                self.tagListView.addTags(self.selectedPassionName)
            }
        } else if self.viewModel.isCome == "TV" || viewModel.isCome == "PreferenceTV" {
            if let index = self.selectedTVName.firstIndex(of: title) {
                self.selectedTVName.remove(at: index)
                self.selectedTVids.remove(at: index)
                self.tagListView.removeAllTags()
                self.tagListView.addTags(self.selectedTVName)
            }
        } else if self.viewModel.isCome == "PreferenceWork"  {
            if let index = self.selectedWorkIndustryName.firstIndex(of: title) {
                self.selectedWorkIndustryName.remove(at: index)
                self.selectedWorkIndustryids.remove(at: index)
                self.tagListView.removeAllTags()
                self.tagListView.addTags(self.selectedWorkIndustryName)
            }
        } else {
            if let index = self.selectedMusicsName.firstIndex(of: title) {
                self.selectedMusicsName.remove(at: index)
                self.selectedMusicsids.remove(at: index)
                self.tagListView.removeAllTags()
                self.tagListView.addTags(self.selectedMusicsName)
            }
        }
    }
    
}


extension MoviesViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.isCome == "Movies" || viewModel.isCome == "PreferenceMovies" {
            return viewModel.moviesArray.count
        } else if self.viewModel.isCome == "Passion" || viewModel.isCome == "PreferencePassion" {
            return viewModel.passionArray.count
        } else if self.viewModel.isCome == "TV" || viewModel.isCome == "PreferenceTV" {
            return viewModel.tvSeriesArray.count
        } else if self.viewModel.isCome == "PreferenceWork" {
            return viewModel.workArray.count
        } else if self.viewModel.isCome == "PreferenceWorkout" {
            return viewModel.workoutArray.count
        } else if self.viewModel.isCome == "PreferencesBooks" {
            return viewModel.booksArray.count
        } else if self.viewModel.isCome == "PreferencesSports" {
            return viewModel.sportsArray.count
        }
        else {
            return viewModel.musicArray.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.genderCell, for: indexPath) as? genderTableViewCell {
           
            if viewModel.isCome == "Movies" || viewModel.isCome == "PreferenceMovies" {
                cell.titleLabel.text = self.viewModel.moviesArray[indexPath.row].name
                if self.genderArrayIndex[indexPath.row] == "YES" {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "SelectRectangle")
                } else {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "UnSelectRectangle")
                }
            } else if self.viewModel.isCome == "Passion" || viewModel.isCome == "PreferencePassion" {
                cell.titleLabel.text = self.viewModel.passionArray[indexPath.row].name
                if self.genderArrayIndex[indexPath.row] == "YES" {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "SelectRectangle")
                } else {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "UnSelectRectangle")
                }
            } else if self.viewModel.isCome == "TV" || viewModel.isCome == "PreferenceTV" {
                cell.titleLabel.text = self.viewModel.tvSeriesArray[indexPath.row].name
                if self.genderArrayIndex[indexPath.row] == "YES" {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "SelectRectangle")
                } else {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "UnSelectRectangle")
                }
            } else if self.viewModel.isCome == "PreferenceWork" {
                cell.titleLabel.text = self.viewModel.workArray[indexPath.row].name
                if self.genderArrayIndex[indexPath.row] == "YES" {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "SelectRectangle")
                } else {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "UnSelectRectangle")
                }
            } else if self.viewModel.isCome == "PreferenceWorkout" {
                cell.titleLabel.text = self.viewModel.workoutArray[indexPath.row].name
                if self.genderArrayIndex[indexPath.row] == "YES" {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "SelectRectangle")
                } else {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "UnSelectRectangle")
                }
            } else if self.viewModel.isCome == "PreferencesBooks" {
                cell.titleLabel.text = self.viewModel.booksArray[indexPath.row].name
                if self.genderArrayIndex[indexPath.row] == "YES" {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "SelectRectangle")
                } else {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "UnSelectRectangle")
                }
            } else if self.viewModel.isCome == "PreferencesSports" {
                cell.titleLabel.text = self.viewModel.sportsArray[indexPath.row].name
                if self.genderArrayIndex[indexPath.row] == "YES" {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "SelectRectangle")
                } else {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "UnSelectRectangle")
                }
            } else {
                cell.titleLabel.text = self.viewModel.musicArray[indexPath.row].name
                if self.genderArrayIndex[indexPath.row] == "YES" {
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "SelectRectangle")
                }else{
                    cell.tickImage.isHidden = false
                    cell.tickImage.image = UIImage(named: "UnSelectRectangle")
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.isCome == "Movies" || viewModel.isCome == "PreferenceMovies" {
            if self.genderArrayIndex[indexPath.row] == "YES" {
                self.genderArrayIndex[indexPath.row] = "NO"
            } else {
                self.genderArrayIndex[indexPath.row] = "YES"
            }
        } else if self.viewModel.isCome == "Passion" || viewModel.isCome == "PreferencePassion" {
            if self.genderArrayIndex[indexPath.row] == "YES" {
                self.genderArrayIndex[indexPath.row] = "NO"
            } else {
                self.genderArrayIndex[indexPath.row] = "YES"
            }
        } else if self.viewModel.isCome == "TV" || viewModel.isCome == "PreferenceTV" {
            if self.genderArrayIndex[indexPath.row] == "YES" {
                self.genderArrayIndex[indexPath.row] = "NO"
            } else {
                self.genderArrayIndex[indexPath.row] = "YES"
            }
        } else if self.viewModel.isCome == "PreferenceWork" {
            if self.genderArrayIndex[indexPath.row] == "YES" {
                self.genderArrayIndex[indexPath.row] = "NO"
            } else {
                self.genderArrayIndex[indexPath.row] = "YES"
            }
        } else if self.viewModel.isCome == "PreferenceWorkout" {
            if self.genderArrayIndex[indexPath.row] == "YES" {
                self.genderArrayIndex[indexPath.row] = "NO"
            } else {
                self.genderArrayIndex[indexPath.row] = "YES"
            }
        } else if self.viewModel.isCome == "PreferencesSports" {
            if self.genderArrayIndex[indexPath.row] == "YES" {
                self.genderArrayIndex[indexPath.row] = "NO"
            } else {
                self.genderArrayIndex[indexPath.row] = "YES"
            }
        } else if self.viewModel.isCome == "PreferencesBooks" {
            if self.genderArrayIndex[indexPath.row] == "YES" {
                self.genderArrayIndex[indexPath.row] = "NO"
            } else {
                self.genderArrayIndex[indexPath.row] = "YES"
            }
        }
        else {
            if self.genderArrayIndex[indexPath.row] == "YES" {
                self.genderArrayIndex[indexPath.row] = "NO"
            } else {
                self.genderArrayIndex[indexPath.row] = "YES"
            }
        }
        self.tableView.reloadData()
    }
}


