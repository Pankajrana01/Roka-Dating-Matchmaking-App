//
//  UserProfileTableViewCell.swift
//  Roka
//
//  Created by Pankaj Rana on 21/09/22.
//

import UIKit

class UserProfileTableViewCell: UITableViewCell {
    var titleName = ""
    var descName = ""
    var imageName = ""
    var selectedTableIndex = -1
    var timer1 = Timer()
    var timer2 = Timer()
    var timer3 = Timer()
    var counter1 = 0
    var counter2 = 0
    var counter3 = 0
    
    @IBOutlet weak var collectionView: UICollectionView! { didSet { configureCollectionView() } }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = true
        collectionView.layer.cornerRadius = 20
        collectionView.clipsToBounds = true
        
        collectionView.register(UINib(nibName: CollectionViewNibIdentifier.userProfileNib, bundle: nil), forCellWithReuseIdentifier: CollectionViewCellIdentifier.userProfileCell)
        
        DispatchQueue.main.async {
            if self.collectionView.tag == 0{
                self.timer1 = Timer.scheduledTimer(timeInterval: 2.7, target: self, selector: #selector(self.changeImage1), userInfo: nil, repeats: true)
            } else if self.collectionView.tag == 1{
                self.timer2 = Timer.scheduledTimer(timeInterval: 4.3, target: self, selector: #selector(self.changeImage2), userInfo: nil, repeats: true)
            } else{
                self.timer3 = Timer.scheduledTimer(timeInterval: 6.1, target: self, selector: #selector(self.changeImage3), userInfo: nil, repeats: true)
            }
        }
    }
    
    @objc func changeImage1() {
        if counter1 < 3 {
            let index = IndexPath.init(item: counter1, section: 0)
            self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            self.collectionView.layoutIfNeeded()
            
            counter1 += 1
        } else {
            counter1 = 0
            let index = IndexPath.init(item: counter1, section: 0)
            self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            counter1 = 1
            self.collectionView.layoutIfNeeded()
        }
    }
    
    @objc func changeImage2() {
        if counter2 < 3 {
            let index = IndexPath.init(item: counter2, section: 0)
            self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            counter2 += 1
            self.collectionView.layoutIfNeeded()
        } else {
            counter2 = 0
            let index = IndexPath.init(item: counter2, section: 0)
            self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            counter2 = 1
            self.collectionView.layoutIfNeeded()
        }
    }
    
    @objc func changeImage3() {
        if counter3 < 3 {
            let index = IndexPath.init(item: counter3, section: 0)
            self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            counter3 += 1
            self.collectionView.layoutIfNeeded()
        } else {
            counter3 = 0
            let index = IndexPath.init(item: counter3, section: 0)
            self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            counter3 = 1
            self.collectionView.layoutIfNeeded()
        }
    }
    var callBackForDidSelectProfile: ((_ selectedIndex:Int) ->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}

extension UserProfileTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.userProfileCell, for: indexPath) as? UserProfileCollectionViewCell {
//            cell.title = titleName
            cell.image = imageName
            cell.profileImage.layer.cornerRadius = 20
            cell.profileImage.clipsToBounds = true
            
//            cell.desc = descName
            cell.pageView.currentPage = indexPath.row
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let screenRect = UIScreen.main.bounds
        let screenHeight = screenRect.size.height
       
        if screenHeight >= 812{
            return  CGSize(width: collectionView.frame.size.width, height: screenHeight/3 - 40)
        } else {
            return  CGSize(width: collectionView.frame.size.width, height: screenHeight/3 - 20)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.callBackForDidSelectProfile?(self.selectedTableIndex)
    }
}

