//
//  SearchLocationVC.swift
//  Roka
//
//  Created by ios on 13/09/23.
//

import UIKit
import GooglePlaces
import CoreLocation

class SearchLocationVC: BaseViewController, UITextFieldDelegate {

    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.basicInfo
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.locationSearch
    }
    
    lazy var viewModel: SearchLocationModel = SearchLocationModel(hostViewController: self)
    
    var places: [Place] = []
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    // MARK: Outlets
    @IBOutlet weak var locationTableview: UITableView!
    @IBOutlet weak var searchTextField: UITextField!

    // MARK: Variable
    var locationAddress = ""
    var lat = ""
    var long = ""
    var city = ""
    var state = ""
    var country = ""
    var callBacktoMainScreen : (() -> ())?

    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let clearButton = searchTextField.value(forKeyPath: "_clearButton") as? UIButton {
            clearButton.setImage(UIImage(named:"ic_cross_png"), for: .normal)
        }
        searchTextField.delegate = self
        locationTableview.delegate = self
        locationTableview.dataSource = self
        self.locationTableview.register(UINib.init(nibName: "searchCellTableViewCell", bundle: nil), forCellReuseIdentifier: "searchCellTableViewCell")
        self.updateSearchresult()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.updateSearchresult()
        return true
    }
    
    func updateSearchresult() {
        guard let query = searchTextField.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        GooglePlaceManager.shared.findPlace(query: query) { result in
            
            switch result {
            case .success(let places):
                print(places)
                self.places = places
            case .failure(let error):
                print(error)
            }
            self.locationTableview.reloadData()
        }
    }

    // MARK: BackButton Action
    @IBAction func backbuttonAction(_ sender: UIButton) {
        self.dismiss(animated: false)
//        self.navigationController?.popViewController(animated : true)
    }
}

extension SearchLocationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchCellTableViewCell", for: indexPath) as? searchCellTableViewCell else {return UITableViewCell()}
        cell.substitleLabel.text = places[indexPath.row].name
        cell.titleLabel.text = places[indexPath.row].identifier
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let placeID = places[indexPath.row].placeId
        GooglePlaceManager.client.fetchPlace(fromPlaceID: placeID, placeFields: [.coordinate], sessionToken: nil) { (place, error) in
                if let error = error {
                    print("Error fetching place details: \(error.localizedDescription)")
                    self.dismiss(animated: false)
                    return
                }
                
                if let coordinate = place?.coordinate {
                    self.locationAddress = self.places[indexPath.row].name
                    // Use the coordinate (latitude and longitude) of the selected place
                    let latitude = coordinate.latitude
                    let longitude = coordinate.longitude
                    self.lat = "\(latitude)"
                    self.long = "\(longitude)"
                    print("Latitude: \(latitude), Longitude: \(longitude)")
                    let location = CLLocation(latitude: latitude, longitude: longitude)
                    let geocoder = CLGeocoder()
                    geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                        if let error = error {
                            print("Reverse geocoding error: \(error.localizedDescription)")
                            return
                        }

                        if let placemark = placemarks?.first {
                            let city = placemark.locality ?? ""
                            let country = placemark.country ?? ""
                            let state = placemark.administrativeArea ?? ""

                            self.city = city
                            self.state = state
                            self.country = country
                            print("City: \(city)")
                            print("Country: \(country)")
                            print("State: \(state)")

                            self.dismiss(animated: false) {
                                self.callBacktoMainScreen?()
                            }
                        } else {
                            print("No placemark found")
                        }
                    }
            }
        }
    }
}


class SearchLocationModel: BaseViewModel {
    var completionHandler: (() -> Void)?
}

struct Place {
    let name: String
    let identifier: String
    let placeId: String
}

class GooglePlaceManager {
    static let shared = GooglePlaceManager()
    
    static let client = GMSPlacesClient.shared()
    
    private init() {}
    
    public func findPlace(query: String, completion: @escaping (Result<[Place], Error>) -> Void) {
        let filter = GMSAutocompleteFilter()
        filter.type = .geocode
        GooglePlaceManager.client.findAutocompletePredictions(fromQuery: query, filter: filter, sessionToken: nil) { results, error in
            guard let results = results, error == nil else {
                return
            }
            
            let places: [Place] = results.compactMap({
                Place(name: $0.attributedFullText.string, identifier: $0.attributedPrimaryText.string, placeId: $0.placeID)
            })
            completion(.success(places))
        }
    }
}
