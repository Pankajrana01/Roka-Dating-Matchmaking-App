//
//  MoreDetailViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 06/10/22.
//

import Foundation
import UIKit
import GooglePlaces

class MoreDetailViewModel: BaseViewModel {
    var isComeFor = ""
    var segment = ""
    var completionHandler: ((Bool) -> Void)?
    var dob = ""
    var selectedDate = Date()
    var genderArray = [GenderRow]()
    var storedUser = KAPPSTORAGE.user
    let user = UserModel.shared.user
    var userResponseData = [String: Any]()
    var wishingArray = [GenderRow]()
    var wishingIds = [String]()
    var genderArrayIndex = [String]()
    var selectedMinValue = 18
    var selectedMaxValue = 99
    var selectedCMMinValue = 121
    var selectedCMMaxValue = 182
    var selectedFeetMinValue = "48"
    var selectedFeetMaxValue = "72"
    var preferedlat = ""
    var preferedlng = ""
    var preferedcity = ""
    var preferedcountry = ""
    var preferedstate = ""
    
    var aboutMe: [AboutMe] = {
        var aboutMe = [AboutMe]()
        aboutMe.append(AboutMe(name: "Questions about me", image: UIImage(named: "ic_releationship")!, subTitle: ""))
        aboutMe.append(AboutMe(name: "Location", image: UIImage(named: "ic_releationship")!, subTitle: ""))
        aboutMe.append(AboutMe(name: "Relationship Status", image: UIImage(named: "ic_releationship")!, subTitle: ""))
        aboutMe.append(AboutMe(name: "I wish to have", image: UIImage(named: "ic_releationship")!, subTitle: ""))
        aboutMe.append(AboutMe(name: "Sexual Orientation", image: UIImage(named: "ic_sexual")!, subTitle: ""))
        aboutMe.append(AboutMe(name: "Kids", image: UIImage(named: "ic_kids")!, subTitle: ""))
        aboutMe.append(AboutMe(name: "Height", image: UIImage(named: "Ic_height-1")!, subTitle: ""))
        aboutMe.append(AboutMe(name: "Ethnicity", image: UIImage(named: "Ic_ethencity-1")!, subTitle: ""))
        aboutMe.append(AboutMe(name: "Religion", image: UIImage(named: "ic_religion-1")!, subTitle: ""))
        aboutMe.append(AboutMe(name: "Education level", image: UIImage(named: "ic_education")!, subTitle: ""))
        aboutMe.append(AboutMe(name: "Work Industry", image: UIImage(named: "ic_work")!, subTitle: ""))
        aboutMe.append(AboutMe(name: "Zodiac", image: UIImage(named: "ic_zodiac")!, subTitle: ""))
        aboutMe.append(AboutMe(name: "Personality", image: UIImage(named: "ic_personality")!, subTitle: ""))
        aboutMe.append(AboutMe(name: "Drinking", image: UIImage(named: "drink")!, subTitle: ""))
        aboutMe.append(AboutMe(name: "Smoking", image: UIImage(named: "nonsmoking")!, subTitle: ""))
        aboutMe.append(AboutMe(name: "Workout", image: UIImage(named: "ic_workout")!, subTitle: ""))
        aboutMe.append(AboutMe(name: "Passions", image: UIImage(named: "ic_passions")!, subTitle: ""))
        aboutMe.append(AboutMe(name: "Movie/Tv Genre", image: UIImage(named: "ic_movies")!, subTitle: ""))
        aboutMe.append(AboutMe(name: "Music Genre", image: UIImage(named: "ic_music")!, subTitle: ""))
        aboutMe.append(AboutMe(name: "Books Genre", image: UIImage(named: "ic_book")!, subTitle: ""))
        aboutMe.append(AboutMe(name: "Sports", image: UIImage(named: "ic_sport")!, subTitle: ""))
        aboutMe.append(AboutMe(name: "Gender", image: UIImage(named: "Ic_gender")!, subTitle: ""))
       // aboutMe.append(AboutMe(name: "Date of Birth", image: UIImage(named: "Ic_dateofbirth")!, subTitle: ""))
        
        return aboutMe
    }()
    
    var aboutMeProfile: [AboutMe] = {
        var aboutMeProfile = [AboutMe]()
        aboutMeProfile.append(AboutMe(name: "Questions about me", image: UIImage(named: "ic_releationship")!, subTitle: ""))
        aboutMeProfile.append(AboutMe(name: "Location", image: UIImage(named: "ic_releationship")!, subTitle: ""))
        aboutMeProfile.append(AboutMe(name: "Relationship Status", image: UIImage(named: "ic_releationship")!, subTitle: ""))
        aboutMeProfile.append(AboutMe(name: "I wish to have", image: UIImage(named: "ic_releationship")!, subTitle: ""))
        aboutMeProfile.append(AboutMe(name: "Sexual Orientation", image: UIImage(named: "ic_sexual")!, subTitle: ""))
        aboutMeProfile.append(AboutMe(name: "Kids", image: UIImage(named: "ic_kids")!, subTitle: ""))
        aboutMeProfile.append(AboutMe(name: "Height", image: UIImage(named: "Ic_height-1")!, subTitle: ""))
        aboutMeProfile.append(AboutMe(name: "Ethnicity", image: UIImage(named: "Ic_ethencity-1")!, subTitle: ""))
        aboutMeProfile.append(AboutMe(name: "Religion", image: UIImage(named: "ic_religion-1")!, subTitle: ""))
        aboutMeProfile.append(AboutMe(name: "Education level", image: UIImage(named: "ic_education")!, subTitle: ""))
        aboutMeProfile.append(AboutMe(name: "Work Industry", image: UIImage(named: "ic_work")!, subTitle: ""))
        aboutMeProfile.append(AboutMe(name: "Zodiac", image: UIImage(named: "ic_zodiac")!, subTitle: ""))
        aboutMeProfile.append(AboutMe(name: "Personality", image: UIImage(named: "ic_personality")!, subTitle: ""))
        aboutMeProfile.append(AboutMe(name: "Drinking", image: UIImage(named: "drink")!, subTitle: ""))
        aboutMeProfile.append(AboutMe(name: "Smoking", image: UIImage(named: "nonsmoking")!, subTitle: ""))
        aboutMeProfile.append(AboutMe(name: "Workout", image: UIImage(named: "ic_workout")!, subTitle: ""))
        aboutMeProfile.append(AboutMe(name: "Passions", image: UIImage(named: "ic_passions")!, subTitle: ""))
        aboutMeProfile.append(AboutMe(name: "Movie/Tv Genre", image: UIImage(named: "ic_movies")!, subTitle: ""))
        aboutMeProfile.append(AboutMe(name: "Music Genre", image: UIImage(named: "ic_music")!, subTitle: ""))
        aboutMeProfile.append(AboutMe(name: "Books Genre", image: UIImage(named: "ic_book")!, subTitle: ""))
        aboutMeProfile.append(AboutMe(name: "Sports", image: UIImage(named: "ic_sport")!, subTitle: ""))
        aboutMeProfile.append(AboutMe(name: "Gender", image: UIImage(named: "Ic_gender")!, subTitle: ""))
      //  aboutMe.append(AboutMe(name: "Date of Birth", image: UIImage(named: "Ic_dateofbirth")!, subTitle: ""))
        
        return aboutMeProfile
    }()
    
    // aboutMe.append(AboutMe(name: "TV Series", image: UIImage(named: "Ic_dateofbirth")!))
    
    var preferences: [MyPreferences] = {
        var preferences = [MyPreferences]()
        preferences.append(MyPreferences(name: "Gender", image: UIImage(named: "Ic_gender")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Location", image: UIImage(named: "Ic_gender")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Distance", image: UIImage(named: "Ic_gender")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Age Range", image: UIImage(named: "Ic_dateofbirth")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Relationship Status", image: UIImage(named: "ic_releationship")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Kids", image: UIImage(named: "ic_kids")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Height", image: UIImage(named: "Ic_height-1")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Ethnicity", image: UIImage(named: "Ic_ethencity-1")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Religion", image: UIImage(named: "ic_religion-1")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Education level", image: UIImage(named: "ic_education")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Work Industry", image: UIImage(named: "ic_work")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Zodiac", image: UIImage(named: "ic_zodiac")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Personality", image: UIImage(named: "ic_personality")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Drinking", image: UIImage(named: "drink")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Smoking", image: UIImage(named: "nonsmoking")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Workout", image: UIImage(named: "ic_workout")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Passions", image: UIImage(named: "ic_passions")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Movie/Tv Genre", image: UIImage(named: "ic_movies")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Music Genre", image: UIImage(named: "ic_music")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Books Genre", image: UIImage(named: "ic_book")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Sports", image: UIImage(named: "ic_sport")!, subTitle: ""))
    
        return preferences
    }()
    
    var myFriendsPreferences: [MyPreferences] = {
        var preferences = [MyPreferences]()
        preferences.append(MyPreferences(name: "Gender", image: UIImage(named: "Ic_gender")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Age Range", image: UIImage(named: "Ic_dateofbirth")!, subTitle: ""))
        preferences.append(MyPreferences(name: "My friend wishes to have", image: UIImage(named: "ic_releationship")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Relationship Status", image: UIImage(named: "ic_releationship")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Kids", image: UIImage(named: "ic_kids")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Height", image: UIImage(named: "Ic_height-1")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Ethnicity", image: UIImage(named: "Ic_ethencity-1")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Religion", image: UIImage(named: "ic_religion-1")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Education level", image: UIImage(named: "ic_education")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Work Industry", image: UIImage(named: "ic_work")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Zodiac", image: UIImage(named: "ic_zodiac")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Personality", image: UIImage(named: "ic_personality")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Drinking", image: UIImage(named: "drink")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Smoking", image: UIImage(named: "nonsmoking")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Workout", image: UIImage(named: "ic_workout")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Passions", image: UIImage(named: "ic_passions")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Movie/Tv Genre", image: UIImage(named: "ic_movies")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Music Genre", image: UIImage(named: "ic_music")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Books Genre", image: UIImage(named: "ic_book")!, subTitle: ""))
        preferences.append(MyPreferences(name: "Sports", image: UIImage(named: "ic_sport")!, subTitle: ""))
    
        return preferences
    }()
    
    //   preferences.append(MyPreferences(name: "TV Series", image: UIImage(named: "Ic_dateofbirth")!))
    
    var tableView: UITableView! { didSet { configureTableView() } }
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.register(UINib(nibName: TableViewNibIdentifier.addMoreDetailCell, bundle: nil), forCellReuseIdentifier: TableViewCellIdentifier.addMoreDetailCell)
    }
    
    // MARK:- API Call...
    func processForGetUserData() {
        showLoader()
        ApiManager.makeApiCall(APIUrl.User.basePreFix,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .get) { response, _ in
            print(response!["message"])
            var abc = response?["message"]
            if abc! as? String == "success" {
                print("Dhiraj")
            }
//            if !self.hasErrorIn(response) {
            if abc! as? String == "success" {
//            if !self.hasErrorIn(response) {
                let responseData = response![APIConstants.data] as! [String: Any]
                self.user.updateWith(responseData)
                KUSERMODEL.setUserLoggedIn(true)
                
                DispatchQueue.main.async {
                    self.userResponseData = response![APIConstants.data] as! [String: Any]
                    
                    if let genders = self.userResponseData["Relationship"] as? [String:Any] {
                        if let name = genders["name"] as? String {
                            if let index =  self.aboutMe.firstIndex(where: {$0.name == "Relationship Status"}) {
                                self.aboutMe[index].subTitle = name
                                self.aboutMeProfile[index].subTitle = name
                            }
                            if let index =  self.aboutMeProfile.firstIndex(where: {$0.name == "Relationship Status"}) {
                                self.aboutMeProfile[index].subTitle = name
                            }
                        }
                    }
                    
                    if let genders = self.userResponseData["sexualOrientation"] as? [String:Any] {
                        if let name = genders["name"] as? String {
                            if let index =  self.aboutMe.firstIndex(where: {$0.name == "Sexual Orientation"}) {
                                self.aboutMe[index].subTitle = name
                            }
                            
                            if let index =  self.aboutMeProfile.firstIndex(where: {$0.name == "Sexual Orientation"}) {
                                self.aboutMeProfile[index].subTitle = name
                            }
                        }
                    }
                    
                    if let genders = self.userResponseData["kid"] as? [String:Any] {
                        if let name = genders["name"] as? String {
                            if let index =  self.aboutMe.firstIndex(where: {$0.name == "Kids"}) {
                                self.aboutMe[index].subTitle = name
                            }
                            if let index =  self.aboutMeProfile.firstIndex(where: {$0.name == "Kids"}) {
                                self.aboutMeProfile[index].subTitle = name
                            }
                        }
                    }
                    
                    if let genders = self.userResponseData["Ethnicity"] as? [String:Any] {
                        if let name = genders["name"] as? String {
                            if let index =  self.aboutMe.firstIndex(where: {$0.name == "Ethnicity"}) {
                                self.aboutMe[index].subTitle = name
                            }
                            if let index =  self.aboutMeProfile.firstIndex(where: {$0.name == "Ethnicity"}) {
                                self.aboutMeProfile[index].subTitle = name
                            }
                        }
                    }
                    
                    if let genders = self.userResponseData["Religion"] as? [String:Any] {
                        if let name = genders["name"] as? String {
                            if let index =  self.aboutMe.firstIndex(where: {$0.name == "Religion"}) {
                                self.aboutMe[index].subTitle = name
                            }
                            if let index =  self.aboutMeProfile.firstIndex(where: {$0.name == "Religion"}) {
                                self.aboutMeProfile[index].subTitle = name
                            }
                        }
                    }
                    
                    if let genders = self.userResponseData["Education"] as? [String:Any] {
                        if let name = genders["name"] as? String {
                            if let index =  self.aboutMe.firstIndex(where: {$0.name == "Education level"}) {
                                self.aboutMe[index].subTitle = name
                            }
                            
                            if let index =  self.aboutMeProfile.firstIndex(where: {$0.name == "Education level"}) {
                                self.aboutMeProfile[index].subTitle = name
                            }
                        }
                    }
                    
                    if let genders = self.userResponseData["WorkIndustry"] as? [String:Any] {
                        if let name = genders["name"] as? String {
                            if let index =  self.aboutMe.firstIndex(where: {$0.name == "Work Industry"}) {
                                self.aboutMe[index].subTitle = name
                            }
                            if let index =  self.aboutMeProfile.firstIndex(where: {$0.name == "Work Industry"}) {
                                self.aboutMeProfile[index].subTitle = name
                            }
                        }
                    }
                    
                    if let genders = self.userResponseData["zodiac"] as? [String:Any] {
                        if let name = genders["name"] as? String {
                            if let index =  self.aboutMe.firstIndex(where: {$0.name == "Zodiac"}) {
                                self.aboutMe[index].subTitle = name
                            }
                            if let index =  self.aboutMeProfile.firstIndex(where: {$0.name == "Zodiac"}) {
                                self.aboutMeProfile[index].subTitle = name
                            }
                        }
                    }
                    
                    if let genders = self.userResponseData["personality"] as? [String:Any] {
                        if let name = genders["name"] as? String {
                            if let index =  self.aboutMe.firstIndex(where: {$0.name == "Personality"}) {
                                self.aboutMe[index].subTitle = name
                            }
                            
                            if let index =  self.aboutMeProfile.firstIndex(where: {$0.name == "Personality"}) {
                                self.aboutMeProfile[index].subTitle = name
                            }
                        }
                    }
                    
                    if let genders = self.userResponseData["drinking"] as? [String:Any] {
                        if let name = genders["name"] as? String {
                            if let index =  self.aboutMe.firstIndex(where: {$0.name == "Drinking"}) {
                                self.aboutMe[index].subTitle = name
                            }
                            
                            if let index =  self.aboutMeProfile.firstIndex(where: {$0.name == "Drinking"}) {
                                self.aboutMeProfile[index].subTitle = name
                            }
                        }
                    }
                    
                    if let genders = self.userResponseData["smoking"] as? [String:Any] {
                        if let name = genders["name"] as? String {
                            if let index =  self.aboutMe.firstIndex(where: {$0.name == "Smoking"}) {
                                self.aboutMe[index].subTitle = name
                            }
                            if let index =  self.aboutMeProfile.firstIndex(where: {$0.name == "Smoking"}) {
                                self.aboutMeProfile[index].subTitle = name
                            }
                        }
                    }
                    
                    if let genders = self.userResponseData["workout"] as? [String:Any] {
                        if let name = genders["name"] as? String {
                            if let index =  self.aboutMe.firstIndex(where: {$0.name == "Workout"}) {
                                self.aboutMe[index].subTitle = name
                            }
                            if let index =  self.aboutMeProfile.firstIndex(where: {$0.name == "Workout"}) {
                                self.aboutMeProfile[index].subTitle = name
                            }
                        }
                    }
                    
                    if let genders = self.userResponseData["Gender"] as? [String:Any] {
                        if let name = genders["name"] as? String {
                            if let index =  self.aboutMe.firstIndex(where: {$0.name == "Gender"}) {
                                self.aboutMe[index].subTitle = name
                            }
                            if let index =  self.aboutMeProfile.firstIndex(where: {$0.name == "Gender"}) {
                                self.aboutMeProfile[index].subTitle = name
                            }
                        }
                    }
                    
                    if let height = self.userResponseData["height"] as? String {
                        if let heightType = self.userResponseData["heightType"] as? String {
                            if let index =  self.aboutMe.firstIndex(where: {$0.name == "Height"}) {
                                if heightType == "Feet" {
                                    self.aboutMe[index].subTitle = "\(height) ft"
                                } else {
                                    self.aboutMe[index].subTitle = "\(height) cm"
                                }
                            }
                            
                            if let index =  self.aboutMeProfile.firstIndex(where: {$0.name == "Height"}) {
                                if heightType == "Feet" {
                                    self.aboutMeProfile[index].subTitle = "\(height) ft"
                                } else {
                                    self.aboutMeProfile[index].subTitle = "\(height) cm"
                                }
                            }
                        }
                    }
                    
                    if let city = self.userResponseData["city"] as? String {
                        if let country = self.userResponseData["country"] as? String {
                            if let index =  self.aboutMe.firstIndex(where: {$0.name == "Location"}) {
                                    self.aboutMe[index].subTitle = "\(city), " + "\(country)"
                            }
                            
                            if let index =  self.aboutMeProfile.firstIndex(where: {$0.name == "Location"}) {
                                    self.aboutMeProfile[index].subTitle = "\(city), " + "\(country)"
                            }
                        }
                    }
                    
                    if let genders = self.userResponseData["userWishingToHavePreferences"] as? [[String:Any]] {
                        var names = [String]()
                        if genders.count == 0 {
                            if let index =  self.aboutMe.firstIndex(where: {$0.name == "I wish to have"}) {
                                self.aboutMe[index].subTitle = names.joined(separator: ", ")
                            }
                            
                            if let index =  self.aboutMeProfile.firstIndex(where: {$0.name == "I wish to have"}) {
                                self.aboutMeProfile[index].subTitle = names.joined(separator: ", ")
                            }
                        }
                        for gender in genders {
                            if let gen = gender["wishingToHave"] as? [String:Any] {
                                if let name = gen["name"] as? String {
                                    names.append(name)
                                    if let index =  self.aboutMe.firstIndex(where: {$0.name == "I wish to have"}) {
                                        self.aboutMe[index].subTitle = names.joined(separator: ", ")
                                    }
                                    
                                    if let index =  self.aboutMeProfile.firstIndex(where: {$0.name == "I wish to have"}) {
                                        self.aboutMeProfile[index].subTitle = names.joined(separator: ", ")
                                    }
                                }
                            }
                        }
                    }
                    
                    if let genders = self.userResponseData["userPassion"] as? [[String:Any]] {
                        var names = [String]()
                        if genders.count == 0 {
                            if let index =  self.aboutMe.firstIndex(where: {$0.name == "Passions"}) {
                                self.aboutMe[index].subTitle = names.joined(separator: ", ")
                            }
                            
                            if let index =  self.aboutMeProfile.firstIndex(where: {$0.name == "Passions"}) {
                                self.aboutMeProfile[index].subTitle = names.joined(separator: ", ")
                            }
                        }
                        for gender in genders {
                            if let gen = gender["passion"] as? [String:Any] {
                                if let name = gen["name"] as? String {
                                    names.append(name)
                                    if let index =  self.aboutMe.firstIndex(where: {$0.name == "Passions"}) {
                                        self.aboutMe[index].subTitle = names.joined(separator: ", ")
                                    }
                                    
                                    if let index =  self.aboutMeProfile.firstIndex(where: {$0.name == "Passions"}) {
                                        self.aboutMeProfile[index].subTitle = names.joined(separator: ", ")
                                    }
                                }
                            }
                        }
                    }
                    
                    if let genders = self.userResponseData["userMovies"] as? [[String:Any]] {
                        var names = [String]()
                        if genders.count == 0 {
                            if let index =  self.aboutMe.firstIndex(where: {$0.name == "Movie/Tv Genre"}) {
                                self.aboutMe[index].subTitle = names.joined(separator: ", ")
                            }
                            
                            if let index =  self.aboutMeProfile.firstIndex(where: {$0.name == "Movie/Tv Genre"}) {
                                self.aboutMeProfile[index].subTitle = names.joined(separator: ", ")
                            }
                        }
                        for gender in genders {
                            if let gen = gender["movie"] as? [String:Any] {
                                if let name = gen["name"] as? String {
                                    names.append(name)
                                    if let index =  self.aboutMe.firstIndex(where: {$0.name == "Movie/Tv Genre"}) {
                                        self.aboutMe[index].subTitle = names.joined(separator: ", ")
                                    }
                                    
                                    if let index =  self.aboutMeProfile.firstIndex(where: {$0.name == "Movie/Tv Genre"}) {
                                        self.aboutMeProfile[index].subTitle = names.joined(separator: ", ")
                                    }
                                }
                            }
                        }
                    }
                    
                    if let genders = self.userResponseData["userMusic"] as? [[String:Any]] {
                        var names = [String]()
                        if genders.count == 0 {
                            if let index =  self.aboutMe.firstIndex(where: {$0.name == "Music Genre"}) {
                                self.aboutMe[index].subTitle = names.joined(separator: ", ")
                            }
                            if let index =  self.aboutMeProfile.firstIndex(where: {$0.name == "Music Genre"}) {
                                self.aboutMeProfile[index].subTitle = names.joined(separator: ", ")
                            }
                        }
                        for gender in genders {
                            if let gen = gender["music"] as? [String:Any] {
                                if let name = gen["name"] as? String {
                                    names.append(name)
                                    if let index =  self.aboutMe.firstIndex(where: {$0.name == "Music Genre"}) {
                                        self.aboutMe[index].subTitle = names.joined(separator: ", ")
                                    }
                                    
                                    if let index =  self.aboutMeProfile.firstIndex(where: {$0.name == "Music Genre"}) {
                                        self.aboutMeProfile[index].subTitle = names.joined(separator: ", ")
                                    }
                                }
                            }
                        }
                    }
                    
                    if let genders = self.userResponseData["usersBooks"] as? [[String:Any]] {
                        var names = [String]()
                        if genders.count == 0 {
                            if let index =  self.aboutMe.firstIndex(where: {$0.name == "Books Genre"}) {
                                self.aboutMe[index].subTitle = names.joined(separator: ", ")
                            }
                            
                            if let index =  self.aboutMeProfile.firstIndex(where: {$0.name == "Books Genre"}) {
                                self.aboutMeProfile[index].subTitle = names.joined(separator: ", ")
                            }
                        }
                        for gender in genders {
                            if let gen = gender["book"] as? [String:Any] {
                                if let name = gen["name"] as? String {
                                    names.append(name)
                                    if let index =  self.aboutMe.firstIndex(where: {$0.name == "Books Genre"}) {
                                        self.aboutMe[index].subTitle = names.joined(separator: ", ")
                                    }
                                    
                                    if let index =  self.aboutMeProfile.firstIndex(where: {$0.name == "Books Genre"}) {
                                        self.aboutMeProfile[index].subTitle = names.joined(separator: ", ")
                                    }
                                }
                            }
                        }
                    }
                    
                    if let genders = self.userResponseData["usersSports"] as? [[String:Any]] {
                        var names = [String]()
                        if genders.count == 0 {
                            if let index =  self.aboutMe.firstIndex(where: {$0.name == "Sports"}) {
                                self.aboutMe[index].subTitle = names.joined(separator: ", ")
                            }
                            if let index =  self.aboutMeProfile.firstIndex(where: {$0.name == "Sports"}) {
                                self.aboutMeProfile[index].subTitle = names.joined(separator: ", ")
                            }
                        }
                        for gender in genders {
                            if let gen = gender["sport"] as? [String:Any] {
                                if let name = gen["name"] as? String {
                                    names.append(name)
                                    if let index =  self.aboutMe.firstIndex(where: {$0.name == "Sports"}) {
                                        self.aboutMe[index].subTitle = names.joined(separator: ", ")
                                    }
                                    if let index =  self.aboutMeProfile.firstIndex(where: {$0.name == "Sports"}) {
                                        self.aboutMeProfile[index].subTitle = names.joined(separator: ", ")
                                    }
                                }
                            }
                        }
                    }
                    
                    if let genders = self.userResponseData["userQuestionAnswer"] as? [[String:Any]] {
                        var names = [String]()
                        for gender in genders {
                            if let gen = gender["answer"] as? String {
                                names.append(gen)
                                if let index =  self.aboutMe.firstIndex(where: {$0.name == "Questions about me"}) {
                                    self.aboutMe[index].subTitle = names.joined(separator: ", ")
                                }
                                if let index =  self.aboutMeProfile.firstIndex(where: {$0.name == "Questions about me"}) {
                                    self.aboutMeProfile[index].subTitle = names.joined(separator: ", ")
                                }
                            }
                        }
                    }
                    if let dob = self.userResponseData["dob"] as? String {
                        if let index =  self.aboutMe.firstIndex(where: {$0.name == "Date of Birth"}) {
                            self.aboutMe[index].subTitle = "\(dob)"
                        }
                        
                        if let index =  self.aboutMeProfile.firstIndex(where: {$0.name == "Date of Birth"}) {
                            self.aboutMeProfile[index].subTitle = "\(dob)"
                        }
                    }
                    
                    if self.tableView != nil { self.tableView.reloadData() }
                }
            }
            hideLoader()
        }
    }
    
    func processForGetUserPreferenceProfileData() {
        showLoader()
        var url = ""
        var params = [String:Any]()
        
        if isComeFor == "Friend Preferences" {
            url = APIUrl.UserMatchMaking.getUserMatchMakingPreferenceDetail
            params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
            
        } else {
            url = APIUrl.UserApis.getUserPreferenceDetail
            params = [:]
        }
    
        ApiManager.makeApiCall(url, params: params,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .get) { response, _ in
            print(response!["message"])
            var abc = response?["message"]
            if abc! as? String == "success" {
                print("Dhiraj")
            }
//            if !self.hasErrorIn(response) {
            if abc! as? String == "success" {
                DispatchQueue.main.async {
                    self.userResponseData.removeAll()
                    self.userResponseData = response![APIConstants.data] as! [String: Any]
                    self.user.updateWith(self.userResponseData)
                    KUSERMODEL.setUserLoggedIn(true)
                    //Preference Gender
                    if let genders = self.userResponseData["userGenderPreferences"] as? [[String:Any]] {
                        var names = [String]()
                        if genders.count == 0 {
                            if let index =  self.preferences.firstIndex(where: {$0.name == "Gender"}) {
                                self.preferences[index].subTitle = names.joined(separator: ", ")
                            }
                        }
                        for gender in genders {
                            if let gen = gender["gender"] as? [String:Any] {
                                if let name = gen["name"] as? String {
                                    names.append(name)
                                    if let index =  self.preferences.firstIndex(where: {$0.name == "Gender"}) {
                                        self.preferences[index].subTitle = names.joined(separator: ", ")
                                    }
                                }
                            }
                        }
                    }
                    // Age Range
                    if let userPreferences = self.userResponseData["userPreferences"] as? [[String:Any]] {
                        let userPreference = userPreferences[0]
                        if let maxAge = userPreference["maxAge"] as? Int{
                            self.selectedMaxValue = maxAge
                        }
                        if let minAge = userPreference["minAge"] as? Int{
                            self.selectedMinValue = minAge
                        }
                        
                        if let index = self.preferences.firstIndex(where: {$0.name == "Age Range"}) {
                            self.preferences[index].subTitle = "\(self.selectedMinValue)-" + "\(self.selectedMaxValue)"
                        }
                        
                        if let index = self.preferences.firstIndex(where: {$0.name == "Location"}) {
                            self.preferences[index].subTitle = "\(userPreference["city"] as? String ?? ""), " + "\(userPreference["country"] as? String ?? "")"
                        }
                        
                        if let index = self.preferences.firstIndex(where: {$0.name == "Distance"}) {
                            self.preferences[index].subTitle = "with in \(userPreference["distance"] as? Int ?? 0) Km's"
                        }
                        
                    }
                    
                    // Height
                    if let userPreferences = self.userResponseData["userPreferences"] as? [[String:Any]] {
                        let userPreference = userPreferences[0]
                        if let heightType = userPreference["heightType"] as? String {
                            if heightType == "Centimetre" {
                                if let maxHeight = userPreference["maxHeight"] as? String{
                                    self.selectedCMMaxValue = Int(maxHeight) ?? 0
                                }
                                
                                if let minHeight = userPreference["minHeight"] as? String{
                                    self.selectedCMMinValue = Int(minHeight) ?? 0
                                }
                                
                                if let index = self.preferences.firstIndex(where: {$0.name == "Height"}) {
                                    self.preferences[index].subTitle = "\(self.selectedCMMinValue)cm - " + "\(self.selectedCMMaxValue)cm"
                                }
                            } else {
                                if let maxHeight = userPreference["maxHeight"] as? String {
                                    self.selectedFeetMaxValue = "\(maxHeight)"
                                }
                                if let minHeight = userPreference["minHeight"] as? String {
                                    self.selectedFeetMinValue = "\(minHeight)"
                                }
                                
                                if let index = self.preferences.firstIndex(where: {$0.name == "Height"}) {
                                    self.preferences[index].subTitle = "\(self.selectedFeetMinValue)ft - " + "\(self.selectedFeetMaxValue)ft"
                                }
                            }
                        }
                    }
                    //Preference Relationship
                    if let genders = self.userResponseData["userRelationshipPreferences"] as? [[String:Any]] {
                        var names = [String]()
                        if genders.count == 0 {
                            if let index =  self.preferences.firstIndex(where: {$0.name == "Relationship Status"}) {
                                self.preferences[index].subTitle = ""
                            }
                        }
                        for gender in genders {
                            if let gen = gender["relationship"] as? [String:Any] {
                                if let name = gen["name"] as? String {
                                    names.append(name)
                                    if let index =  self.preferences.firstIndex(where: {$0.name == "Relationship Status"}) {
                                        self.preferences[index].subTitle = names.joined(separator: ", ")
                                    }
                                }
                            }
                        }
                    }
                
                    //Preference PassionPreferences
                    if let genders = self.userResponseData["userKidsPreferences"] as? [[String:Any]] {
                        var names = [String]()
                        if genders.count == 0 {
                            if let index =  self.preferences.firstIndex(where: {$0.name == "Kids"}) {
                                self.preferences[index].subTitle = names.joined(separator: ", ")
                            }
                        }
                        for gender in genders {
                            if let gen = gender["kid"] as? [String:Any] {
                                if let name = gen["name"] as? String {
                                    names.append(name)
                                    if let index =  self.preferences.firstIndex(where: {$0.name == "Kids"}) {
                                        self.preferences[index].subTitle = names.joined(separator: ", ")
                                    }
                                }
                            }
                        }
                    }
                    
                    //Preference Ethnicity
                    if let genders = self.userResponseData["userEthnicityPreferences"] as? [[String:Any]] {
                        var names = [String]()
                        if genders.count == 0 {
                            if let index =  self.preferences.firstIndex(where: {$0.name == "Ethnicity"}) {
                                self.preferences[index].subTitle = names.joined(separator: ", ")
                            }
                        }
                        for gender in genders {
                            if let gen = gender["ethnicity"] as? [String:Any] {
                                if let name = gen["name"] as? String {
                                    names.append(name)
                                    if let index =  self.preferences.firstIndex(where: {$0.name == "Ethnicity"}) {
                                        self.preferences[index].subTitle = names.joined(separator: ", ")
                                    }
                                }
                            }
                        }
                    }
                    //Preference religion
                    if let genders = self.userResponseData["userReligionPreferences"] as? [[String:Any]] {
                        var names = [String]()
                        if genders.count == 0 {
                            if let index =  self.preferences.firstIndex(where: {$0.name == "Religion"}) {
                                self.preferences[index].subTitle = names.joined(separator: ", ")
                            }
                        }
                        for gender in genders {
                            if let gen = gender["religion"] as? [String:Any] {
                                if let name = gen["name"] as? String {
                                    names.append(name)
                                    if let index =  self.preferences.firstIndex(where: {$0.name == "Religion"}) {
                                        self.preferences[index].subTitle = names.joined(separator: ", ")
                                    }
                                }
                            }
                        }
                    }
                    //Preference educationQualification
                    if let genders = self.userResponseData["userQualificationPreferences"] as? [[String:Any]] {
                        var names = [String]()
                        if genders.count == 0 {
                            if let index =  self.preferences.firstIndex(where: {$0.name == "Education level"}) {
                                self.preferences[index].subTitle = names.joined(separator: ", ")
                            }
                        }
                        for gender in genders {
                            if let gen = gender["educationQualification"] as? [String:Any] {
                                if let name = gen["name"] as? String {
                                    names.append(name)
                                    if let index =  self.preferences.firstIndex(where: {$0.name == "Education level"}) {
                                        self.preferences[index].subTitle = names.joined(separator: ", ")
                                    }
                                }
                            }
                        }
                    }
                    //Preference WorkIndustriesPreferences
                    if let genders = self.userResponseData["userWorkIndustriesPreferences"] as? [[String:Any]] {
                        var names = [String]()
                        if genders.count == 0 {
                            if let index =  self.preferences.firstIndex(where: {$0.name == "Work Industry"}) {
                                self.preferences[index].subTitle = names.joined(separator: ", ")
                            }
                        }
                        for gender in genders {
                            if let gen = gender["workIndustry"] as? [String:Any] {
                                if let name = gen["name"] as? String {
                                    names.append(name)
                                    if let index =  self.preferences.firstIndex(where: {$0.name == "Work Industry"}) {
                                        self.preferences[index].subTitle = names.joined(separator: ", ")
                                    }
                                }
                            }
                        }
                    }
                    //Preference Zodiac Preferences
                    if let genders = self.userResponseData["userZodiacPreferences"] as? [[String:Any]] {
                        var names = [String]()
                        if genders.count == 0 {
                            if let index =  self.preferences.firstIndex(where: {$0.name == "Zodiac"}) {
                                self.preferences[index].subTitle = names.joined(separator: ", ")
                            }
                        }
                        for gender in genders {
                            if let gen = gender["zodiac"] as? [String:Any] {
                                if let name = gen["name"] as? String {
                                    names.append(name)
                                    if let index =  self.preferences.firstIndex(where: {$0.name == "Zodiac"}) {
                                        self.preferences[index].subTitle = names.joined(separator: ", ")
                                    }
                                }
                            }
                        }
                    }
                    //Preference Personality Preferences
                    if let genders = self.userResponseData["userPersonalityPrefrences"] as? [[String:Any]] {
                        var names = [String]()
                        if genders.count == 0 {
                            if let index =  self.preferences.firstIndex(where: {$0.name == "Personality"}) {
                                self.preferences[index].subTitle = names.joined(separator: ", ")
                            }
                        }
                        for gender in genders {
                            if let gen = gender["personality"] as? [String:Any] {
                                if let name = gen["name"] as? String {
                                    names.append(name)
                                    if let index =  self.preferences.firstIndex(where: {$0.name == "Personality"}) {
                                        self.preferences[index].subTitle = names.joined(separator: ", ")
                                    }
                                }
                            }
                        }
                    }
                    //Preference SmokingPreferences
                    if let genders = self.userResponseData["userSmokingPreferences"] as? [[String:Any]] {
                        var names = [String]()
                        if genders.count == 0 {
                            if let index =  self.preferences.firstIndex(where: {$0.name == "Smoking"}) {
                                self.preferences[index].subTitle = names.joined(separator: ", ")
                            }
                        }
                        for gender in genders {
                            if let gen = gender["smoking"] as? [String:Any] {
                                if let name = gen["name"] as? String {
                                    names.append(name)
                                    if let index =  self.preferences.firstIndex(where: {$0.name == "Smoking"}) {
                                        self.preferences[index].subTitle = names.joined(separator: ", ")
                                    }
                                }
                            }
                        }
                    }
                    //Preference Drinking Preferences
                    if let genders = self.userResponseData["userDrinkingPreferences"] as? [[String:Any]] {
                        var names = [String]()
                        if genders.count == 0 {
                            if let index =  self.preferences.firstIndex(where: {$0.name == "Drinking"}) {
                                self.preferences[index].subTitle = names.joined(separator: ", ")
                            }
                        }
                        for gender in genders {
                            if let gen = gender["drinking"] as? [String:Any] {
                                if let name = gen["name"] as? String {
                                    names.append(name)
                                    if let index =  self.preferences.firstIndex(where: {$0.name == "Drinking"}) {
                                        self.preferences[index].subTitle = names.joined(separator: ", ")
                                    }
                                }
                            }
                        }
                    }
                  
                    //Preference passionsPreferences
                    if let genders = self.userResponseData["userPassionPreferences"] as? [[String:Any]] {
                        var names = [String]()
                        if genders.count == 0 {
                            if let index =  self.preferences.firstIndex(where: {$0.name == "Passions"}) {
                                self.preferences[index].subTitle = names.joined(separator: ", ")
                            }
                        }
                        for gender in genders {
                            if let gen = gender["passion"] as? [String:Any] {
                                if let name = gen["name"] as? String {
                                    names.append(name)
                                    if let index =  self.preferences.firstIndex(where: {$0.name == "Passions"}) {
                                        self.preferences[index].subTitle = names.joined(separator: ", ")
                                    }
                                }
                            }
                        }
                    }
                    //Preference moviePreferences
                    if let genders = self.userResponseData["userMoviesPreferences"] as? [[String:Any]] {
                        var names = [String]()
                        if genders.count == 0 {
                            if let index =  self.preferences.firstIndex(where: {$0.name == "Movie/Tv Genre"}) {
                                self.preferences[index].subTitle = names.joined(separator: ", ")
                            }
                        }
                        for gender in genders {
                            if let gen = gender["movie"] as? [String:Any] {
                                if let name = gen["name"] as? String {
                                    names.append(name)
                                    if let index =  self.preferences.firstIndex(where: {$0.name == "Movie/Tv Genre"}) {
                                        self.preferences[index].subTitle = names.joined(separator: ", ")
                                    }
                                }
                            }
                        }
                    }
                    
                    //Preference moviePreferences
                    if let genders = self.userResponseData["userMusicPreferences"] as? [[String:Any]] {
                        var names = [String]()
                        if genders.count == 0 {
                            if let index =  self.preferences.firstIndex(where: {$0.name == "Music Genre"}) {
                                self.preferences[index].subTitle = names.joined(separator: ", ")
                            }
                        }
                        for gender in genders {
                            if let gen = gender["music"] as? [String:Any] {
                                if let name = gen["name"] as? String {
                                    names.append(name)
                                    if let index =  self.preferences.firstIndex(where: {$0.name == "Music Genre"}) {
                                        self.preferences[index].subTitle = names.joined(separator: ", ")
                                    }
                                }
                            }
                        }
                    }
                    
                    //Preference userWorkoutPreferences
                    if let genders = self.userResponseData["userWorkoutPreferences"] as? [[String:Any]] {
                        var names = [String]()
                        if genders.count == 0 {
                            if let index =  self.preferences.firstIndex(where: {$0.name == "Workout"}) {
                                self.preferences[index].subTitle = names.joined(separator: ", ")
                            }
                        }
                        for gender in genders {
                            if let gen = gender["workout"] as? [String:Any] {
                                if let name = gen["name"] as? String {
                                    names.append(name)
                                    if let index =  self.preferences.firstIndex(where: {$0.name == "Workout"}) {
                                        self.preferences[index].subTitle = names.joined(separator: ", ")
                                    }
                                }
                            }
                        }
                    }
                    
                    //Preference userSportsPreferences
                    if let genders = self.userResponseData["userSportsPreferences"] as? [[String:Any]] {
                        var names = [String]()
                        if genders.count == 0 {
                            if let index =  self.preferences.firstIndex(where: {$0.name == "Sports"}) {
                                self.preferences[index].subTitle = names.joined(separator: ", ")
                            }
                        }
                        for gender in genders {
                            if let gen = gender["sport"] as? [String:Any] {
                                if let name = gen["name"] as? String {
                                    names.append(name)
                                    if let index =  self.preferences.firstIndex(where: {$0.name == "Sports"}) {
                                        self.preferences[index].subTitle = names.joined(separator: ", ")
                                    }
                                }
                            }
                        }
                    }
                    
                    //Preference userBooksPreferences
                    if let genders = self.userResponseData["userBooksPreferences"] as? [[String:Any]] {
                        var names = [String]()
                        if genders.count == 0 {
                            if let index =  self.preferences.firstIndex(where: {$0.name == "Books Genre"}) {
                                self.preferences[index].subTitle = names.joined(separator: ", ")
                            }
                        }
                        for gender in genders {
                            if let gen = gender["book"] as? [String:Any] {
                                if let name = gen["name"] as? String {
                                    names.append(name)
                                    if let index =  self.preferences.firstIndex(where: {$0.name == "Books Genre"}) {
                                        self.preferences[index].subTitle = names.joined(separator: ", ")
                                    }
                                }
                            }
                        }
                    }
                    
                    if self.tableView != nil {
                        print("#######")
                        self.tableView.reloadData()
                    }
                }
            }
            hideLoader()
        }
    }
    
    func proceedForTabbar() {
        KAPPSTORAGE.isWalkthroughShown = "Yes"
        KAPPDELEGATE.updateRootController(TabBarController.getController(),
                                          transitionDirection: .fade,
                                          embedInNavigationController: true)
    }
    
    func openGooglePlacesController() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
    
        // Display the autocomplete view controller.
        self.hostViewController.present(autocompleteController, animated: true, completion: nil)
        
    }
    
    func proceedForSelectDistance() {
        let controller = PreferredDistanceViewController.getController() as! PreferredDistanceViewController
        controller.dismissCompletion = { value in
            self.processForGetUserPreferenceProfileData()
        }
        controller.show(over: self.hostViewController) { distance in
            var params = [String:Any]()
            params[WebConstants.id] = self.user.id
            params[WebConstants.preferredDistance] = distance
            self.processForUpdateProfileApiData(params: params, titleName: "Preferred Distance")
        }
    }
    
    
    func popBackToController() {
        for controller in self.hostViewController.navigationController!.viewControllers as Array {
            if controller.isKind(of: MatchMakingViewController.self) {
                UserModel.shared.refreshUser()
                user.userImages.removeAll()
                self.hostViewController.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    func proceedForSelectDateOfBrith() {
        let controller = CalendarViewController.getController() as! CalendarViewController
        controller.dismissCompletion = { _ in}
        var selectedDate = ""
        if self.hostViewController.title == "More about Friend" {
            selectedDate = GlobalVariables.shared.selectedFriendProfileDOB
        }
        else if self.hostViewController.title == "Friend's Preferences" {
            selectedDate = GlobalVariables.shared.selectedFriendProfileDOB
        } else {
            selectedDate = self.user.dob
        }
        controller.show(over: self.hostViewController, selectedDate: selectedDate , isCome: "MoreDetail", isFriend: false) { value, value2, value3  in
            self.dob = value2
            self.selectedDate = value3
            GlobalVariables.shared.selectedFriendProfileDOB = value2
            var params = [String: Any]()
            params[WebConstants.id] = self.user.id
            params[WebConstants.dob] = self.dob
            self.processForUpdateProfileApiData(params: params, titleName: "Date of Brith")
        }
    }
    
    func proceedForSelectQuestions() {
        let controller = QuestionsViewController.getController() as! QuestionsViewController
        controller.dismissCompletion = { value in
            self.processForGetUserData()
        }
        controller.show(over: self.hostViewController, isCome: "", isFriend: false) { dic in
            var params = [String:Any]()
            params[WebConstants.id] = self.user.id
            params[WebConstants.questionAbout] = dic
            self.processForUpdateProfileApiData(params: params, titleName: "Questions about me")
        }
    }
    // MARK:- API Call...
    func genderApiCall(params: [String: Any], _ result: @escaping(ResponseModel?) -> Void) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: KUSERMODEL.authorizationToken]
        
        ApiManagerWithCodable<ResponseModel>.makeApiCall(APIUrl.BasicApis.genders,
                                                         params: params,
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
    
    // MARK:- API Call...
    func processForUpdateProfileApiData(params: [String: Any], titleName: String) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.UserApis.updateProfile,
                               params: params,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .put) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [String: Any]
                                    showSuccessMessage(with: "\(titleName) " + "updated successfully")
                                    self.user.updateWith(responseData)
                                    KUSERMODEL.setUserLoggedIn(true)
                                }
            
                                hideLoader()
        }
    }
    
    func processForUpdateProfileApiData2(params: [String: Any], titleName: String, _ result: @escaping(String?) -> Void) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.UserApis.updateProfile,
                               params: params,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .put) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [String: Any]
                                    showSuccessMessage(with: "\(titleName) " + "updated successfully")
                                    self.user.updateWith(responseData)
                                    KUSERMODEL.setUserLoggedIn(true)
                                    result("success")
                                }
            
                                hideLoader()
        }
    }
    
    func processForUpdateProfilePreferenceApiData(params: [String: Any], titleName: String) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.UserApis.updateProfilePrefrences,
                               params: params,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .put) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [String: Any]
                                    showSuccessMessage(with: "\(titleName) " + "preference updated successfully")
                                    self.user.updateWith(responseData)
                                    KUSERMODEL.setUserLoggedIn(true)
                                }
            
                                hideLoader()
        }
    }
    func processForUpdateProfilePreferenceApiData2(params: [String: Any], titleName: String, _ result: @escaping(String?) -> Void) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.UserApis.updateProfilePrefrences,
                               params: params,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .put) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [String: Any]
                                    showSuccessMessage(with: "\(titleName) " + "preference updated successfully")
                                    self.user.updateWith(responseData)
                                    KUSERMODEL.setUserLoggedIn(true)
                                    result("success")
                                }
            
                                hideLoader()
        }
    }
   
    func processForUpdateFriendProfileApiData(params: [String: Any], titleName: String) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.UserMatchMaking.updateFriendsProfile,
                               params: params,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .put) { response, _ in
                                if !self.hasErrorIn(response) {
                                    _ = response![APIConstants.data] as! [String: Any]
                                    showSuccessMessage(with: "\(titleName) " + "updated successfully")
                                    
                                }
            
                                hideLoader()
        }
    }
    func processForUpdateFirendProfilePreferenceApiData(params: [String: Any], titleName: String) {
        showLoader()
        ApiManager.makeApiCall(APIUrl.UserMatchMaking.updateFriendsProfilePrefrences,
                               params: params,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .put) { response, _ in
                                if !self.hasErrorIn(response) {
                                    _ = response![APIConstants.data] as! [String: Any]
                                    showSuccessMessage(with: "\(titleName) " + "preference updated successfully")
                                    
                                }
            
                                hideLoader()
        }
    }
    func processForGetGenderData(type: String) {
        var params = [String: Any]()
        params["type"] = type
        if self.hostViewController.title == "Friend's Preferences" {
            params["friendsId"] = GlobalVariables.shared.selectedFriendProfileId
        }
        self.genderApiCall(params: params) { model in
            self.genderArray = model?.data ?? []
        }
    }
    
    func processForGetAboutMeGenderData(type: String) {
        var params = [String: Any]()
        params["type"] = type
        if self.hostViewController.title == "Friend's Preferences" {
            params["friendsId"] = GlobalVariables.shared.selectedFriendProfileId
        }
        self.genderApiCall(params: params) { model in
            self.genderArray = model?.data ?? []
            self.proceedForSelectGender()
        }
    }
    
   
    func processForGetFriendsGenderData(type: String) {
        var params = [String: Any]()
        params["type"] = type
        if self.hostViewController.title == "Friend's Preferences" {
            params["friendsId"] = GlobalVariables.shared.selectedFriendProfileId
        }
        self.genderApiCall(params: params) { model in
            self.genderArray = model?.data ?? []
            self.proceedForSelectPreferenceGender()
        }
    }
    
    func proceedForSelectReligion() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isComeFor: "Religion", isFriend: isFriend, genderArray: [], selectedGenderId: "") { id, value, value2 in
            var params = [String: Any]()
            
            params[WebConstants.religionId] = id
            params[WebConstants.isReligionPrivate] = value2
            
            if self.hostViewController.title == "More about Friend" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFriendProfileApiData(params: params, titleName: "Religion")
            } else {
                params[WebConstants.id] = self.user.id
                self.processForUpdateProfileApiData(params: params, titleName: "Religion")
            }
            
        } preferredCompletionHandler: { text, ids, priority  in
        }
    }
    
    func proceedForSelectEthencity() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = {  _ in
            self.processForGetUserData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isComeFor: "Ethencity", isFriend: isFriend, genderArray: [], selectedGenderId: "") { id, value, value2 in
            
            var params = [String: Any]()
           
            params[WebConstants.ethnicityId] = id
            params[WebConstants.isEthnicityPrivate] = value2
            if self.hostViewController.title == "More about Friend" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFriendProfileApiData(params: params, titleName: "Ethnicity")
            } else {
                params[WebConstants.id] = self.user.id
                self.processForUpdateProfileApiData(params: params, titleName: "Ethnicity")
            }
            
        } preferredCompletionHandler: { text, ids, priority  in
        }
    }
    
    func proceedForSelectGender() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserData() 
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        
        if genderArray.count != 0 {
            controller.show(over: self.hostViewController, isComeFor: "MoreDetailGender", isFriend: isFriend, genderArray: self.genderArray, selectedGenderId: "") { id, value, value2 in
                
                var params = [String: Any]()
                
                params[WebConstants.genderId] = id
                params[WebConstants.isGenderPrivate] = value2
                if self.hostViewController.title == "More about Friend" {
                    params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                    self.processForUpdateFriendProfileApiData(params: params, titleName: "Gender")
                } else {
                    params[WebConstants.id] = self.user.id
                    self.processForUpdateProfileApiData(params: params, titleName: "Gender")
                }
                
            } preferredCompletionHandler: { text, ids, priority  in
                
            }
        }
    }
    func proceedForSelectHeight() {
        let controller = HeightViewController.getController() as! HeightViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isCome: "Height", isFriend: isFriend) { value1, value2, priority   in
            
            var params = [String: Any]()
            
            params[WebConstants.height] = value2
            params[WebConstants.heightType] = value1
            params[WebConstants.isHeightPrivate] = priority
            if self.hostViewController.title == "More about Friend" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFriendProfileApiData(params: params, titleName: "Height")
            } else {
                params[WebConstants.id] = self.user.id
                self.processForUpdateProfileApiData(params: params, titleName: "Height")
            }
        }
    }
    func proceedForSelectRelationship() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isComeFor: "Relationships", isFriend: isFriend, genderArray: [], selectedGenderId: "") { id, value, value2 in
            var params = [String: Any]()
            params[WebConstants.relationshipId] = id
            params[WebConstants.isRelationshipPrivate] = value2
            if self.hostViewController.title == "More about Friend" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFriendProfileApiData(params: params, titleName: "Relationship status")
            } else {
                params[WebConstants.id] = self.user.id
                self.processForUpdateProfileApiData(params: params, titleName: "Relationship status")
            }
        } preferredCompletionHandler: { text, ids, priority  in
        }
    }
    
    func proceedForSelectEducation() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isComeFor: "Education", isFriend: isFriend, genderArray: [], selectedGenderId: "") { id, value, value2 in
            var params = [String: Any]()
            params[WebConstants.educationQualificationId] = id
            params[WebConstants.isEducationPrivate] = value2
            if self.hostViewController.title == "More about Friend" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFriendProfileApiData(params: params, titleName: "Education level")
            } else {
                params[WebConstants.id] = self.user.id

                self.processForUpdateProfileApiData(params: params, titleName: "Education level")
            }
        } preferredCompletionHandler: { text, ids, priority  in
        }
    }
    
    func proceedForSelectWishing() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { value in
            self.processForGetUserData()
        }
        controller.show(over: self.hostViewController, isComeFor: "AboutMeWishing", isFriend: false, genderArray: self.wishingArray, selectedGenderId: self.wishingIds.joined(separator: ",")) { id, value, value2 in
            
        } preferredCompletionHandler: { text, ids, priority  in
            self.wishingIds.removeAll()
            self.wishingIds = ids
            var params = [String: Any]()
            params[WebConstants.id] = self.user.id
            params[WebConstants.preferredWishingToHave] = self.wishingIds
            params["isWishingToHavePrivate"] = priority
            self.processForUpdateProfileApiData(params: params, titleName: "I wish to have")
        }
    }
    func proceedForSelectWorkIndustry() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isComeFor: "Work", isFriend: isFriend, genderArray: [], selectedGenderId: "") { id, value, value2 in
            var params = [String: Any]()
           
            params[WebConstants.workIndustryId] = id
            params[WebConstants.isWorkIndustryPrivate] = value2
            if self.hostViewController.title == "More about Friend" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFriendProfileApiData(params: params, titleName: "Work Industry")
            } else {
                params[WebConstants.id] = self.user.id
                self.processForUpdateProfileApiData(params: params, titleName: "Work Industry")
            }
        } preferredCompletionHandler: { text, ids, priority  in
        }
    }
    func proceedForSelectPassions() {
        let controller = MoviesViewController.getController() as! MoviesViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isCome: "Passion", isFriend: isFriend) { value,ids  in
            var params = [String: Any]()
           
            params[WebConstants.passions] = ids
            params[WebConstants.isPassionsPrivate] = value
            if self.hostViewController.title == "More about Friend" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFriendProfileApiData(params: params, titleName: "Passions")
            } else {
                params[WebConstants.id] = self.user.id
                self.processForUpdateProfileApiData(params: params, titleName: "Passions")
            }
        }
    }
    func proceedForSelectMovies() {
        let controller = MoviesViewController.getController() as! MoviesViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isCome: "Movies", isFriend: isFriend) { value,ids in
            var params = [String: Any]()
            params[WebConstants.movies] = ids
            params[WebConstants.isMoviesPrivate] = value
            if self.hostViewController.title == "More about Friend" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFriendProfileApiData(params: params, titleName: "Movie/Tv genre")
            } else {
                params[WebConstants.id] = self.user.id

                self.processForUpdateProfileApiData(params: params, titleName: "Movie/Tv genre")
            }
        }
    }
    func proceedForSelectMusics() {
        let controller = MoviesViewController.getController() as! MoviesViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isCome: "Music", isFriend: isFriend) { value,ids  in
            var params = [String: Any]()
            params[WebConstants.music] = ids
            params[WebConstants.isMusicPrivate] = value
            if self.hostViewController.title == "More about Friend" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFriendProfileApiData(params: params, titleName: "Music genre")
            } else {
                params[WebConstants.id] = self.user.id

                self.processForUpdateProfileApiData(params: params, titleName: "Music genre")
            }
        }
    }
    func proceedForSelectDrinking() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isComeFor: "Drinking", isFriend: isFriend, genderArray: [], selectedGenderId: "") { id, value, value2 in
            var params = [String: Any]()
           
            params[WebConstants.isDrinking] = 1
            params[WebConstants.drinkingId] = id
            params[WebConstants.isDrinkingPrivate] = value2
            if self.hostViewController.title == "More about Friend" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFriendProfileApiData(params: params, titleName: "Drinking")
            } else {
                params[WebConstants.id] = self.user.id
                self.processForUpdateProfileApiData(params: params, titleName: "Drinking")
            }
            
        } preferredCompletionHandler: { text, ids, priority  in
        }
    }
    
    func proceedForSelectSmokings() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isComeFor: "Smoking", isFriend: isFriend, genderArray: [], selectedGenderId: "") { id, value, value2 in
            var params = [String: Any]()
           
            params[WebConstants.isSmoking] = 1
            params[WebConstants.smokingId] = id
            params[WebConstants.isSmokingPrivate] = value2
            if self.hostViewController.title == "More about Friend" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFriendProfileApiData(params: params, titleName: "Smoking")
            } else {
                params[WebConstants.id] = self.user.id
                self.processForUpdateProfileApiData(params: params, titleName: "Smoking")
            }
        } preferredCompletionHandler: { text, ids, priority  in
        }
    }
    
    func proceedForSelectTV() {
        let controller = MoviesViewController.getController() as! MoviesViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isCome: "TV", isFriend: isFriend) { value,ids in
            var params = [String: Any]()
            params[WebConstants.tvSeries] = ids
            params[WebConstants.isTvSeriesPrivate] = value
            if self.hostViewController.title == "More about Friend" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFriendProfileApiData(params: params, titleName: "Movie/Tv genre")
            } else {
                params[WebConstants.id] = self.user.id
                self.processForUpdateProfileApiData(params: params, titleName: "Movie/Tv genre")
            }
        }
    }
    func proceedForSelectZodiac() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isComeFor: "Zodiac", isFriend: isFriend, genderArray: [], selectedGenderId: "") { id, value, value2 in
            var params = [String: Any]()
            params[WebConstants.zodiacId] = id
            params[WebConstants.isZodiacPrivate] = value2
            if self.hostViewController.title == "More about Friend" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFriendProfileApiData(params: params, titleName: "Zodiac")
            } else {
                params[WebConstants.id] = self.user.id

                self.processForUpdateProfileApiData(params: params, titleName: "Zodiac")
            }
        } preferredCompletionHandler: { text, ids, priority  in
        }
    }
    
    func proceedForSelectKids() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isComeFor: "Kids", isFriend: isFriend, genderArray: [], selectedGenderId: "") { id, value, value2 in
            var params = [String: Any]()
            params[WebConstants.kidsId] = id
            params[WebConstants.isKidsPrivate] = value2
            if self.hostViewController.title == "More about Friend" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFriendProfileApiData(params: params, titleName: "Kids")
            } else {
                params[WebConstants.id] = self.user.id

                self.processForUpdateProfileApiData(params: params, titleName: "Kids")
            }
        } preferredCompletionHandler: { text, ids, priority  in
        }
    }
    
    func proceedForSelectPersonality() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isComeFor: "Personality", isFriend: isFriend, genderArray: [], selectedGenderId: "") { id, value, value2 in
            var params = [String: Any]()
            params[WebConstants.personalityId] = id
            params[WebConstants.isPersonalityPrivate] = value2
            if self.hostViewController.title == "More about Friend" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFriendProfileApiData(params: params, titleName: "Personality")
            } else {
                params[WebConstants.id] = self.user.id

                self.processForUpdateProfileApiData(params: params, titleName: "Personality")
            }
        } preferredCompletionHandler: { text, ids, priority  in
        }
    }
    
    func proceedForSelectSexual() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isComeFor: "Sexual", isFriend: isFriend, genderArray: [], selectedGenderId: "") { id, value, value2 in
            var params = [String: Any]()
            params[WebConstants.sexualOrientationId] = id
            params[WebConstants.isSexualOrientationPrivate] = value2
            if self.hostViewController.title == "More about Friend" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFriendProfileApiData(params: params, titleName: "Sexual orientation")
            } else {
                params[WebConstants.id] = self.user.id

                self.processForUpdateProfileApiData(params: params, titleName: "Sexual orientation")
            }
        } preferredCompletionHandler: { text, ids, priority  in
        }
    }
    
    func proceedForSelectWorkout() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isComeFor: "Workout", isFriend: isFriend, genderArray: [], selectedGenderId: "") { id, value, value2 in
            var params = [String: Any]()
            params[WebConstants.workoutId] = id
            params[WebConstants.isWorkoutPrivate] = value2
            if self.hostViewController.title == "More about Friend" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFriendProfileApiData(params: params, titleName: "Workout")
            } else {
                params[WebConstants.id] = self.user.id

                self.processForUpdateProfileApiData(params: params, titleName: "Workout")
            }
        } preferredCompletionHandler: { text, ids, priority  in
        }
    }
    
    func proceedForSelectSports() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isComeFor: "Sports", isFriend: isFriend, genderArray: [], selectedGenderId: "") { id, value, value2 in
            var params = [String: Any]()
            params[WebConstants.sports] = id
            params[WebConstants.isSportsPrivate] = value2
            if self.hostViewController.title == "More about Friend" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFriendProfileApiData(params: params, titleName: "Sports")
            } else {
                params[WebConstants.id] = self.user.id

                self.processForUpdateProfileApiData(params: params, titleName: "Sports")
            }
        } preferredCompletionHandler: { text, ids, priority  in
            var params = [String: Any]()
            params[WebConstants.sports] = ids
            params[WebConstants.isSportsPrivate] = priority
            if self.hostViewController.title == "More about Friend" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFriendProfileApiData(params: params, titleName: "Sports")
            } else {
                params[WebConstants.id] = self.user.id

                self.processForUpdateProfileApiData(params: params, titleName: "Sports")
            }
        }
    }
    func proceedForSelectBooks() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isComeFor: "Books", isFriend: isFriend, genderArray: [], selectedGenderId: "") { id, value, value2 in
            var params = [String: Any]()
            params[WebConstants.books] = id
            params[WebConstants.isBooksPrivate] = value2
            if self.hostViewController.title == "More about Friend" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFriendProfileApiData(params: params, titleName: "Books genre")
            } else {
                params[WebConstants.id] = self.user.id

                self.processForUpdateProfileApiData(params: params, titleName: "Books genre")
            }
        } preferredCompletionHandler: { text, ids, priority  in
            var params = [String: Any]()
            params[WebConstants.books] = ids
            params[WebConstants.isBooksPrivate] = priority
            if self.hostViewController.title == "More about Friend" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFriendProfileApiData(params: params, titleName: "Books")
            } else {
                params[WebConstants.id] = self.user.id

                self.processForUpdateProfileApiData(params: params, titleName: "Books")
            }
        }
    }
    
   // MARK: - My Preferences ....
    func proceedForSelectAgeRange() {
        let controller = AgeRangeViewController.getController() as! AgeRangeViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserPreferenceProfileData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isCome: "PreferenceAge", isFriend: isFriend) { max,min,range in
            
            var params = [String: Any]()
            
            params[WebConstants.minAge] = min
            params[WebConstants.maxAge] = max
            params[WebConstants.ageRangePriority] = range
            GlobalVariables.shared.isAgeRangeApiCalled = true
            if self.hostViewController.title == "Friend's Preferences" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFirendProfilePreferenceApiData(params: params, titleName: "Age Range")
            } else {
                params[WebConstants.id] = self.user.id
                self.processForUpdateProfilePreferenceApiData(params: params, titleName: "Age Range")
            }
        }
    }
    
    func proceedForSelectPreferenceGender() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserPreferenceProfileData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        if genderArray.count != 0 {
            controller.show(over: self.hostViewController, isComeFor: "PreferenceGender", isFriend: isFriend, genderArray: self.genderArray, selectedGenderId: "") { id, value, value2 in
            } preferredCompletionHandler: { text, ids, priority  in
                var params = [String: Any]()
                
                params[WebConstants.gender] = ids
                params[WebConstants.genderPriority] = priority
                if self.hostViewController.title == "Friend's Preferences" {
                    params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                    self.processForUpdateFirendProfilePreferenceApiData(params: params, titleName: "Gender")
                } else {
                    params[WebConstants.id] = self.user.id
                    self.processForUpdateProfilePreferenceApiData(params: params, titleName: "Gender")
                }
            }
        }
    }

    
    func proceedForSelectPreferenceHeight() {
        let controller = PreferenceHeightViewController.getController() as! PreferenceHeightViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserPreferenceProfileData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isCome: "PreferenceHeight", isFriend: isFriend) { value1,value2,value3,value4   in
            var params = [String: Any]()
           
            params[WebConstants.heightType] = value1
            params[WebConstants.minHeight] = value2
            params[WebConstants.maxHeight] = value3
            params[WebConstants.heightPriority] = value4
            if self.hostViewController.title == "Friend's Preferences" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFirendProfilePreferenceApiData(params: params, titleName: "Height")
            } else {
                params[WebConstants.id] = self.user.id
                self.processForUpdateProfilePreferenceApiData(params: params, titleName: "Height")
            }
        }
    }
    
    func proceedForSelectPreferenceEthencity() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserPreferenceProfileData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isComeFor: "PreferenceEthencity", isFriend: isFriend, genderArray: [], selectedGenderId: "") { id, value, value2 in
        } preferredCompletionHandler: { text, ids, priority  in
            
            var params = [String: Any]()
            
            params[WebConstants.ethnicity] = ids
            params[WebConstants.ethnicityPriority] = priority
            if self.hostViewController.title == "Friend's Preferences" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFirendProfilePreferenceApiData(params: params, titleName: "Ethnicity")
            } else {
                params[WebConstants.id] = self.user.id
                self.processForUpdateProfilePreferenceApiData(params: params, titleName: "Ethnicity")
            }
        }
    }
    
    func proceedForSelectPreferenceWishing() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { value in
            self.processForGetUserPreferenceProfileData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        
        controller.show(over: self.hostViewController, isComeFor: "PreferenceAboutMeWishing", isFriend: isFriend, genderArray: [], selectedGenderId: "") { id, value, value2 in
        } preferredCompletionHandler: { text, ids, priority  in
            self.wishingIds.removeAll()
            var params = [String: Any]()

            params[WebConstants.preferredWishingToHave] = ids
            params["isWishingToHavePriority"] = priority
            if self.hostViewController.title == "Friend's Preferences" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFirendProfilePreferenceApiData(params: params, titleName: "My Friend wishes to have")
            } else {
                params[WebConstants.id] = self.user.id
                self.processForUpdateProfilePreferenceApiData(params: params, titleName: "My Friend wishes to have")
            }
        }

    }
    
    func proceedForSelectPreferenceReligion() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserPreferenceProfileData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isComeFor: "PreferenceReligion", isFriend: isFriend, genderArray: [], selectedGenderId: "") { id, value, value2 in
        } preferredCompletionHandler: { text, ids, priority  in
            var params = [String: Any]()
           
            params[WebConstants.religion] = ids
            params[WebConstants.religionPriority] = priority
            if self.hostViewController.title == "Friend's Preferences" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFirendProfilePreferenceApiData(params: params, titleName: "Religion")
            } else {
                params[WebConstants.id] = self.user.id
                self.processForUpdateProfilePreferenceApiData(params: params, titleName: "Religion")
            }
        }
    }
    
    func proceedForSelectPreferenceRelationship() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserPreferenceProfileData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isComeFor: "PreferenceRelationships", isFriend: isFriend, genderArray: [], selectedGenderId: "") { id, value, value2 in
        } preferredCompletionHandler: { text, ids,priority  in
            var params = [String: Any]()
           
            params[WebConstants.relationship] = ids
            params[WebConstants.relationshipPriority] = priority
            if self.hostViewController.title == "Friend's Preferences" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFirendProfilePreferenceApiData(params: params, titleName: "Relationship status")
            } else {
                params[WebConstants.id] = self.user.id
                self.processForUpdateProfilePreferenceApiData(params: params, titleName: "Relationship status")
            }
        }
    }
    
    func proceedForSelectPreferenceEducation() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserPreferenceProfileData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isComeFor: "PreferenceEducation", isFriend: isFriend, genderArray: [], selectedGenderId: "") { id, value, value2 in
        } preferredCompletionHandler: { text, ids, priority  in
            var params = [String: Any]()
            
            params[WebConstants.education] = ids
            params[WebConstants.educationPriority] = priority
            if self.hostViewController.title == "Friend's Preferences" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFirendProfilePreferenceApiData(params: params, titleName: "Education level")
            } else {
                params[WebConstants.id] = self.user.id
                self.processForUpdateProfilePreferenceApiData(params: params, titleName: "Education level")
            }
        }
    }
    
    func proceedForSelectPreferenceWorkIndustry() {
        let controller = MoviesViewController.getController() as! MoviesViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserPreferenceProfileData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isCome: "PreferenceWork", isFriend: isFriend) { value,ids  in
            var params = [String: Any]()
            
            params[WebConstants.workIndustry] = ids
            params[WebConstants.workIndustryPriority] = value
            if self.hostViewController.title == "Friend's Preferences" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFirendProfilePreferenceApiData(params: params, titleName: "Work Industry")
            } else {
                params[WebConstants.id] = self.user.id
                self.processForUpdateProfilePreferenceApiData(params: params, titleName: "Work Industry")
            }
        }
    }
    func proceedForSelectPreferencePassions() {
        let controller = MoviesViewController.getController() as! MoviesViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserPreferenceProfileData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isCome: "PreferencePassion", isFriend: isFriend) { value,ids  in
            var params = [String: Any]()
           
            params[WebConstants.passions] = ids
            params[WebConstants.passionsPriority] = value
            if self.hostViewController.title == "Friend's Preferences" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFirendProfilePreferenceApiData(params: params, titleName: "Passions")
            } else {
                params[WebConstants.id] = self.user.id
                self.processForUpdateProfilePreferenceApiData(params: params, titleName: "Passions")
            }
        }
    }
    
    func proceedForSelectPreferenceMovies() {
        let controller = MoviesViewController.getController() as! MoviesViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserPreferenceProfileData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isCome: "PreferenceMovies", isFriend: isFriend) { value,ids in
            var params = [String: Any]()
            
            params[WebConstants.movies] = ids
            params[WebConstants.moviesPriority] = value
            if self.hostViewController.title == "Friend's Preferences" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFirendProfilePreferenceApiData(params: params, titleName: "Moive/Tv genre")
            } else {
                params[WebConstants.id] = self.user.id
                self.processForUpdateProfilePreferenceApiData(params: params, titleName: "Moive/Tv genre")
            }
        }
    }
    func proceedForSelectPreferenceMusics() {
        let controller = MoviesViewController.getController() as! MoviesViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserPreferenceProfileData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isCome: "PreferenceMusic", isFriend: isFriend) { value,ids  in
            var params = [String: Any]()
            
            params[WebConstants.music] = ids
            params[WebConstants.musicPriority] = value
            if self.hostViewController.title == "Friend's Preferences" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFirendProfilePreferenceApiData(params: params, titleName: "Music genre")
            } else {
                params[WebConstants.id] = self.user.id
                self.processForUpdateProfilePreferenceApiData(params: params, titleName: "Music genre")
            }
        }
    }
    func proceedForSelectPreferenceDrinking() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserPreferenceProfileData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isComeFor: "PreferenceDrinking", isFriend: isFriend, genderArray: [], selectedGenderId: "") { id, value, value2 in
            var params = [String: Any]()
           
            params[WebConstants.isDrinking] = 1
            params[WebConstants.drinkingId] = id
            params[WebConstants.isDrinkingPriority] = value2
            GlobalVariables.shared.isDrinkingApiCalled = true
            if self.hostViewController.title == "Friend's Preferences" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFirendProfilePreferenceApiData(params: params, titleName: "Drinking")
            } else {
                params[WebConstants.id] = self.user.id
                self.processForUpdateProfilePreferenceApiData(params: params, titleName: "Drinking")
            }
        } preferredCompletionHandler: { text, ids, priority  in
            var params = [String: Any]()
            
            params[WebConstants.isDrinking] = 1
            params[WebConstants.drinkingIds] = ids
            params[WebConstants.isDrinkingPriority] = priority
            GlobalVariables.shared.isDrinkingApiCalled = true
            if self.hostViewController.title == "Friend's Preferences" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFirendProfilePreferenceApiData(params: params, titleName: "Drinking")
            } else {
                params[WebConstants.id] = self.user.id
                self.processForUpdateProfilePreferenceApiData(params: params, titleName: "Drinking")
            }
        }
    }
    
    func proceedForSelectPreferenceSmokings() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserPreferenceProfileData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isComeFor: "PreferenceSmoking", isFriend: isFriend, genderArray: [], selectedGenderId: "") { id, value, value2 in
            var params = [String: Any]()
            params[WebConstants.isSmoking] = 1
            params[WebConstants.smokingId] = id
            params[WebConstants.isSmokingPriority] = value2
            GlobalVariables.shared.isSmokingApiCalled = true
            if self.hostViewController.title == "Friend's Preferences" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFirendProfilePreferenceApiData(params: params, titleName: "Smoking")
            } else {
                params[WebConstants.id] = self.user.id
                self.processForUpdateProfilePreferenceApiData(params: params, titleName: "Smoking")
            }
        } preferredCompletionHandler: { text, ids, priority  in
            var params = [String: Any]()
            params[WebConstants.isSmoking] = 1
            params[WebConstants.smokingIds] = ids
            params[WebConstants.isSmokingPriority] = priority
            GlobalVariables.shared.isSmokingApiCalled = true
            if self.hostViewController.title == "Friend's Preferences" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFirendProfilePreferenceApiData(params: params, titleName: "Smoking")
            } else {
                params[WebConstants.id] = self.user.id
                self.processForUpdateProfilePreferenceApiData(params: params, titleName: "Smoking")
            }
        }
    }
    
    func proceedForSelectPreferenceTV() {
        let controller = MoviesViewController.getController() as! MoviesViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserPreferenceProfileData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isCome: "PreferenceTV", isFriend: isFriend) { value,ids in
            var params = [String: Any]()
           
            params[WebConstants.tvSeries] = ids
            params[WebConstants.televisionSeriesPriority] = value
            if self.hostViewController.title == "Friend's Preferences" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFirendProfilePreferenceApiData(params: params, titleName: "Movie/Tv genre")
            } else {
                params[WebConstants.id] = self.user.id
                self.processForUpdateProfilePreferenceApiData(params: params, titleName: "Movie/Tv genre")
            }
        }
    }
    
    func proceedForSelectPreferenceZodiac() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserPreferenceProfileData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isComeFor: "PreferenceZodiac", isFriend: isFriend, genderArray: [], selectedGenderId: "") { id, value, value2 in
        } preferredCompletionHandler: { text, ids, priority  in
            var params = [String: Any]()
            
            params[WebConstants.zodiacIds] = ids
            params[WebConstants.zodiacPriority] = priority
            if self.hostViewController.title == "Friend's Preferences" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFirendProfilePreferenceApiData(params: params, titleName: "Zodiac")
            } else {
                params[WebConstants.id] = self.user.id
                self.processForUpdateProfilePreferenceApiData(params: params, titleName: "Zodiac")
            }
        }
    }
    
    func proceedForSelectPreferencePersonality() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserPreferenceProfileData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isComeFor: "PreferencePersonality", isFriend: isFriend, genderArray: [], selectedGenderId: "") { id, value, value2 in
        } preferredCompletionHandler: { text, ids, priority  in
            var params = [String: Any]()
            
            params[WebConstants.personality] = ids
            params[WebConstants.personalityPriority] = priority
            if self.hostViewController.title == "Friend's Preferences" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFirendProfilePreferenceApiData(params: params, titleName: "Personality")
            } else {
                params[WebConstants.id] = self.user.id
                self.processForUpdateProfilePreferenceApiData(params: params, titleName: "Personality")
            }
        }
    }
    
    func proceedForSelectPreferenceKids() {
        let controller = GenderViewController.getController() as! GenderViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserPreferenceProfileData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isComeFor: "PreferenceKids", isFriend: isFriend, genderArray: [], selectedGenderId: "") { id, value, value2 in
        } preferredCompletionHandler: { text, ids, priority  in
            var params = [String: Any]()
            params[WebConstants.kidsIds] = ids
            params[WebConstants.kidsPriority] = priority
            
            if self.hostViewController.title == "Friend's Preferences" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFirendProfilePreferenceApiData(params: params, titleName: "Kids")
            } else {
                params[WebConstants.id] = self.user.id
                self.processForUpdateProfilePreferenceApiData(params: params, titleName: "Kids")
            }
        }
    }
    
    func proceedForSelectPreferenceBooks() {
        let controller = MoviesViewController.getController() as! MoviesViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserPreferenceProfileData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isCome: "PreferencesBooks", isFriend: isFriend) { value, ids in
            var params = [String: Any]()
            params[WebConstants.bookIds] = ids
            params["isBookPriority"] = value
            
            if self.hostViewController.title == "Friend's Preferences" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFirendProfilePreferenceApiData(params: params, titleName: "Books genre")
            } else {
                params[WebConstants.id] = self.user.id
                self.processForUpdateProfilePreferenceApiData(params: params, titleName: "Books genre")
            }
        }
    }
    
    func proceedForSelectPreferenceWorkout() {
        let controller = MoviesViewController.getController() as! MoviesViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserPreferenceProfileData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        
        controller.show(over: self.hostViewController, isCome: "PreferenceWorkout", isFriend: isFriend) { value, ids in
            var params = [String: Any]()
            params[WebConstants.workoutIds] = ids
            params["isWorkOutPriority"] = value
            if self.hostViewController.title == "Friend's Preferences" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFirendProfilePreferenceApiData(params: params, titleName: "Workout")
            } else {
                params[WebConstants.id] = self.user.id
                self.processForUpdateProfilePreferenceApiData(params: params, titleName: "Workout")
            }
        }
    }
    
    func proceedForSelectPreferenceSports() {
        let controller = MoviesViewController.getController() as! MoviesViewController
        controller.dismissCompletion = { _ in
            self.processForGetUserPreferenceProfileData()
        }
        var isFriend = false
        if self.hostViewController.title == "More about Friend" || self.hostViewController.title == "Friend's Preferences" {
            isFriend = true
        }
        controller.show(over: self.hostViewController, isCome: "PreferencesSports", isFriend: isFriend) { value, ids in
            var params = [String: Any]()
            params["sportIds"] = ids
            params["isSportPriority"] = value
            
            if self.hostViewController.title == "Friend's Preferences" {
                params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
                self.processForUpdateFirendProfilePreferenceApiData(params: params, titleName: "Sports")
            } else {
                params[WebConstants.id] = self.user.id
                self.processForUpdateProfilePreferenceApiData(params: params, titleName: "Sports")
            }
        }
    }
    
    func proceedForUpdateLocationMyPreference() {
        var params = [String: Any]()
        params["preferredLatitude"] = self.preferedlat
        params["preferredLongitude"] = self.preferedlng
        params["preferredCity"] = self.preferedcity
        params["preferredState"] = self.preferedstate
        params["preferredCountry"] = self.preferedcountry
        
        if self.hostViewController.title == "Friend's Preferences" {
            params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
            self.processForUpdateProfilePreferenceApiData2(params: params, titleName: "Location") { response in
                self.processForGetUserPreferenceProfileData()
            }
        } else {
            params[WebConstants.id] = self.user.id
            self.processForUpdateProfilePreferenceApiData2(params: params, titleName: "Location") { response in
                self.processForGetUserPreferenceProfileData()
            }
        }
    }
    
    func proceedForUpdateMyProfileLocation() {
        var params = [String: Any]()
        params["latitude"] = self.preferedlat
        params["longitude"] = self.preferedlng
        params["city"] = self.preferedcity
        params["state"] = self.preferedstate
        params["country"] = self.preferedcountry
        params[WebConstants.id] = self.user.id
        self.processForUpdateProfileApiData2(params: params, titleName: "Location") { response in
            self.processForGetUserData()
        }
    }
}

extension MoreDetailViewModel : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segment == "About me" {
            return aboutMe.count
        } else if segment == "AboutMeProfile" {
            return aboutMeProfile.count
        } else if self.hostViewController.title == "Friend's Preferences" {
            return myFriendsPreferences.count
        } else {
            return preferences.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.addMoreDetailCell, for: indexPath) as? AddMoreDetailTableViewCell {
            if segment == "About me" {
                cell.title = self.aboutMe[indexPath.row].name
                cell.image = self.aboutMe[indexPath.row].image
                cell.subtitle = self.aboutMe[indexPath.row].subTitle
            } else if segment == "AboutMeProfile" {
                cell.title = self.aboutMeProfile[indexPath.row].name
                cell.image = self.aboutMeProfile[indexPath.row].image
                cell.subtitle = self.aboutMeProfile[indexPath.row].subTitle
            } else if self.hostViewController.title == "Friend's Preferences" {
                cell.title = self.myFriendsPreferences[indexPath.row].name
                cell.image = self.myFriendsPreferences[indexPath.row].image
            } else {
                cell.title = self.preferences[indexPath.row].name
                cell.image = self.preferences[indexPath.row].image
                cell.subtitle = self.preferences[indexPath.row].subTitle
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segment == "About me" {
            switch indexPath.row {
            case 0:
                proceedForSelectQuestions()
            case 1:
                openGooglePlacesController()
            case 2:
                proceedForSelectRelationship()
            case 3:
                proceedForSelectWishing()
            case 4:
                proceedForSelectSexual()
            case 5:
                proceedForSelectKids()
            case 6:
                proceedForSelectHeight()
            case 7:
                proceedForSelectEthencity()
            case 8:
                proceedForSelectReligion()
            case 9:
                proceedForSelectEducation()
            case 10:
                proceedForSelectWorkIndustry()
            case 11:
                proceedForSelectZodiac()
            case 12:
                proceedForSelectPersonality()
            case 13:
                proceedForSelectDrinking()
            case 14:
                proceedForSelectSmokings()
            case 15:
                proceedForSelectWorkout()
            case 16:
                proceedForSelectPassions()
            case 17:
                proceedForSelectMovies()
            case 18:
                proceedForSelectMusics()
            case 19:
                proceedForSelectBooks()
            case 20:
                proceedForSelectSports()
            case 21:
                self.processForGetAboutMeGenderData(type: "1")
                
//            case 21:
//                proceedForSelectDateOfBrith()
            default: break
            }
        } else if segment == "AboutMeProfile" {
            switch indexPath.row {
            case 0:
                proceedForSelectQuestions()
            case 1:
                openGooglePlacesController()
            case 2:
                proceedForSelectRelationship()
            case 3:
                proceedForSelectWishing()
            case 4:
                proceedForSelectSexual()
            case 5:
                proceedForSelectKids()
            case 6:
                proceedForSelectHeight()
            case 7:
                proceedForSelectEthencity()
            case 8:
                proceedForSelectReligion()
            case 9:
                proceedForSelectEducation()
            case 10:
                proceedForSelectWorkIndustry()
            case 11:
                proceedForSelectZodiac()
            case 12:
                proceedForSelectPersonality()
            case 13:
                proceedForSelectDrinking()
            case 14:
                proceedForSelectSmokings()
            case 15:
                proceedForSelectWorkout()
            case 16:
                proceedForSelectPassions()
            case 17:
                proceedForSelectMovies()
            case 18:
                proceedForSelectMusics()
            case 19:
                proceedForSelectBooks()
            case 20:
                proceedForSelectSports()
            case 21:
                self.processForGetAboutMeGenderData(type: "1")
//            case 21:
//                proceedForSelectDateOfBrith()
            default: break
            }
        } else if self.hostViewController.title == "Friend's Preferences" {
            switch indexPath.row {
            case 0:
                self.processForGetFriendsGenderData(type: "2")
            case 1:
                proceedForSelectAgeRange()
            case 2:
                proceedForSelectPreferenceWishing()
            case 3:
                proceedForSelectPreferenceRelationship()
            case 4:
                proceedForSelectPreferenceKids()
            case 5:
                proceedForSelectPreferenceHeight()
            case 6:
                proceedForSelectPreferenceEthencity()
            case 7:
                proceedForSelectPreferenceReligion()
            case 8:
                proceedForSelectPreferenceEducation()
            case 9:
                proceedForSelectPreferenceWorkIndustry()
            case 10:
                proceedForSelectPreferenceZodiac()
            case 11:
                proceedForSelectPreferencePersonality()
            case 12:
                proceedForSelectPreferenceDrinking()
            case 13:
                proceedForSelectPreferenceSmokings()
            case 14:
                proceedForSelectPreferenceWorkout()
            case 15:
                proceedForSelectPreferencePassions()
            case 16:
                proceedForSelectPreferenceMovies()
            case 17:
                proceedForSelectPreferenceMusics()
            case 18:
                proceedForSelectPreferenceBooks()
            case 19:
                proceedForSelectPreferenceSports()
                
            default: break
            }
        } else {
            switch indexPath.row {
            case 0:
                self.processForGetFriendsGenderData(type: "2")
            case 1:
                openGooglePlacesController()
            case 2:
                proceedForSelectDistance()
            case 3:
                proceedForSelectAgeRange()
            case 4:
                proceedForSelectPreferenceRelationship()
            case 5:
                proceedForSelectPreferenceKids()
            case 6:
                proceedForSelectPreferenceHeight()
            case 7:
                proceedForSelectPreferenceEthencity()
            case 8:
                proceedForSelectPreferenceReligion()
            case 9:
                proceedForSelectPreferenceEducation()
            case 10:
                proceedForSelectPreferenceWorkIndustry()
            case 11:
                proceedForSelectPreferenceZodiac()
            case 12:
                proceedForSelectPreferencePersonality()
            case 13:
                proceedForSelectPreferenceDrinking()
            case 14:
                proceedForSelectPreferenceSmokings()
            case 15:
                proceedForSelectPreferenceWorkout()
            case 16:
                proceedForSelectPreferencePassions()
            case 17:
                proceedForSelectPreferenceMovies()
            case 18:
                proceedForSelectPreferenceMusics()
            case 19:
                proceedForSelectPreferenceBooks()
            case 20:
                proceedForSelectPreferenceSports()
                
            default: break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.hostViewController.title == "Friend's Preferences" {
            return 60.0
        } else {
            return 72.0
        }
    }
}
extension MoreDetailViewModel: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name ?? "")")
        print("Place ID: \(place.placeID ?? "")")
        // Show HouseAndFlat
        if place.name?.description != nil {
            print(place.name?.description ?? "")
        }
        
        // Show latitude
        if place.coordinate.latitude.description.count != 0 {
            print(place.coordinate.latitude)
            self.preferedlat = "\(place.coordinate.latitude)"
        }
        // Show longitude
        if place.coordinate.longitude.description.count != 0 {
            print(place.coordinate.longitude)
            self.preferedlng = "\(place.coordinate.longitude)"
        }
        var country = ""
        var state = ""
        // Show AddressComponents
        if place.addressComponents != nil {
            for addressComponent in (place.addressComponents)! {
                for type in (addressComponent.types){
                    switch(type){
                    case "sublocality_level_2":
                        print(addressComponent.name)
                    case "sublocality_level_1":
                        print(addressComponent.name)
                    case "administrative_area_level_2":
                        print(addressComponent.name)
                        
                    case "administrative_area_level_1":
                        print(addressComponent.name)
                        state = addressComponent.name
                    case "country":
                        print(addressComponent.name)
                        country = addressComponent.name
                    default:
                        break
                    }
                }
            }
        }
        
       // self.preferredLocationTextFiled.text = "\(place.name?.description ?? ""), " + "\(country)"
    
        self.preferedcity = "\(place.name?.description ?? "")"
        self.preferedstate = "\(state)"
        self.preferedcountry = "\(country)"
    
        if segment == "AboutMeProfile" || segment == "About me" {
            self.proceedForUpdateMyProfileLocation()
        } else {
            self.proceedForUpdateLocationMyPreference()
        }
        self.hostViewController.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.hostViewController.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    }
    
}
