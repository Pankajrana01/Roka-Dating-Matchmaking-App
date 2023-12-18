//
//  HeightViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 10/10/22.
//

import Foundation
import UIKit

class HeightViewModel: BaseViewModel {
    var completionHandler: ((String, String, Int) -> Void)?
    var isCome = ""
    var centimetreArr = [String]()
    var feetArr = [String]()
    var conversionArr = [String]()
    var isSelected = "feet"
    var isPrivate = 0
    var selectedCentimetre = ""
    var selectedFeet = ""
    var height = ""
    var heightType = "Feet"
    var isFriend = false
    
    weak var collectionView: UICollectionView! { didSet { configureCollectionView() } }
    
    private func configureCollectionView() {
        if let layout = collectionView.collectionViewLayout as? UPCarouselFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = false
           
            if UIDevice.current.userInterfaceIdiom  == .pad {
                layout.itemSize = CGSize(width: collectionView.frame.width, height: 100)
            }
            
            layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 120)
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = false
        collectionView.reloadData()
        
        //DispatchQueue.main.async {
            //self.scrollToCurrentPosition()
       // }
    }
    
    var previousCMPage = 0
    var previousFTPage = 0
    
    var currentPage: Int = 0 {
        didSet {
            if isSelected == "centimetre" {
                if self.centimetreArr.count != 0 {
                    self.selectedCentimetre = self.centimetreArr[self.currentPage]
                    self.previousCMPage = self.currentPage
                }
            } else {
                if self.feetArr.count != 0 {
                    self.selectedFeet = self.feetArr[self.currentPage]
                    self.previousFTPage = self.currentPage
                }
            }
        }
    }
    
    func saveButtonAction() {
        if isSelected == "centimetre" {
            completionHandler?("Centimetre", self.selectedCentimetre, isPrivate)
        } else {
            if self.selectedFeet != "" {
                let val = self.selectedFeet.components(separatedBy: "′")
                let val1 = val[1].components(separatedBy: "′′")
                let val2 = val1[0].components(separatedBy: " ")
                let val3 = val[0] + "." + val2[1]
                
                completionHandler?("Feet", val3, isPrivate)
            }
        }
    }
    
    fileprivate var orientation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }

    override func viewLoaded() {
        super.viewLoaded()
        
        if isSelected == "centimetre" {
            currentPage = 135
            previousCMPage = 135
        } else {
            currentPage = 48
            previousFTPage = 48
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(HeightViewModel.rotationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
        self.centimetreArr.append(contentsOf: K.heightMetric)
        self.feetArr.append(contentsOf: K.heightMetricImperial)
        self.conversionArr.append(contentsOf: K.heightMetricImperialForFeet1)
        print(K.heightMetric)
        print(K.heightMetricImperialForFeet)
        
    }
    
    fileprivate var pageSize: CGSize {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else { 
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    func scrollToCurrentPosition() {
        DispatchQueue.main.async {
            if self.currentPage > 0 {
                let indexPath = IndexPath(item: self.currentPage, section: 0)
                let scrollPosition: UICollectionView.ScrollPosition = !self.orientation.isPortrait ? .centeredHorizontally  : .centeredVertically
                if self.collectionView != nil {
                    self.collectionView.reloadData()
                    self.collectionView.layoutIfNeeded()
                    self.collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: false)

                   // self.collectionView.isPagingEnabled = true
                }
            }
        }
    }
    
    @objc fileprivate func rotationDidChange() {
        guard !orientation.isFlat else { return }
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        let direction: UICollectionView.ScrollDirection = orientation.isPortrait ? .horizontal : .vertical
        layout.scrollDirection = direction
        scrollToCurrentPosition()
    }
    
    
    // MARK: - API Call...
    func processForGetUserProfileData(_ result:@escaping([String: Any]?) -> Void) {
        showLoader()
        var url = ""
        var params = [String:Any]()
        
        if isFriend {
            url = APIUrl.UserMatchMaking.getUserMatchMakingProfileDetail
            params[WebConstants.id] = GlobalVariables.shared.selectedFriendProfileId
        } else {
            url = APIUrl.UserApis.getUserProfileDetail
            params = [:]
        }
        
        ApiManager.makeApiCall(url, params: params,
                               headers: [WebConstants.authorization: KUSERMODEL.authorizationToken],
                               method: .get) { response, _ in
            if !self.hasErrorIn(response) {
                if let userResponseData = response![APIConstants.data] as? [String: Any] {
                    if let heightType = userResponseData["heightType"] as? String {
                        self.heightType = heightType
                        if let height = userResponseData["height"] as? String {
                            self.height = height
                            
                            if heightType == "Centimetre" {
                                self.isSelected = "centimetre"
                                if let index = self.centimetreArr.firstIndex(where: {$0 == height}){
                                    print(index)
                                    self.currentPage = index
                                    self.previousCMPage = index
                                }
                            } else {
                                self.isSelected = "feet"
                                if height != "" {
                                    let val1 = height.components(separatedBy: ".")
                                    let val2 = "\(val1[0])′"
                                    let val3 = "\(val1[1])′′"
                                    let val4 = "\(val2)" + " " + "\(val3)"
                                    print(val4)
                                    if let index = self.feetArr.firstIndex(where: {$0 == val4}){
                                        print(index)
                                        self.currentPage = index
                                        self.previousFTPage = index
                                    }
                                }
                            }
                            
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                                self.collectionView.layoutIfNeeded()
                                self.scrollToCurrentPosition()
                            }
                            result(userResponseData)
                        }
                    } else {
                        DispatchQueue.main.async {
                            if self.isSelected == "centimetre" {
                                self.currentPage = 135
                                self.previousCMPage = 135
                            } else {
                                self.currentPage = 48
                                self.previousFTPage = 48
                            }
                            self.collectionView.reloadData()
                            self.collectionView.layoutIfNeeded()
                            self.scrollToCurrentPosition()
                        }
                    }
                }
            }
            hideLoader()
        }
    }
}

extension HeightViewModel : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - Card Collection Delegate & DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSelected == "centimetre" {
            return self.centimetreArr.count
        } else {
            return self.feetArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.identifier, for: indexPath) as! CarouselCollectionViewCell
        if isSelected == "centimetre" {
            cell.titleLable.text = self.centimetreArr[indexPath.row]
        } else {
            cell.titleLable.text = self.feetArr[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize.init(width: 100, height: 90)
        }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }
    
}


class K {
    static var heightMetric = {
        (30...243).map { ("\($0)") }
    }()
    
    static var heightMetricImperial = {
        (12...96).map { ("\($0 / 12)′ \($0 % 12)′′") }
    }()
    
    static var heightMetricImperialForFeet = {
        (12...96).map { ("\(Int(Float($0) * 2.54))", "\($0)", "\($0 / 12)′ \($0 % 12)′′") }
    }()
    
    static var heightMetricImperialForFeet1 = {
        (12...96).map { ("\(Int(Float($0) * 2.54))") }
    }()
    
    static var heightMetricImperialForFeet2 = {
        (12...96).map { ("\($0 / 12)′ \($0 % 12)′′") }
    }()
    
    static var heightMetricImperialForFeet3 = {
        (12...96).map { ("\($0)") }
    }()
}
