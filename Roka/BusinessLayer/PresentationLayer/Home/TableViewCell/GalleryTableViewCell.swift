//
//  GalleryTableViewCell.swift
//  Roka
//
//  Created by Pankaj Rana on 18/10/22.
//

import UIKit

class GalleryTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: DynamicHeightCollectionView! { didSet { configureCollectionView() } }
    
    var userImages: [ProfilesImages]?
    var images = [LightboxImage]()
    var callBackForPreviewImages: ((_ images:[LightboxImage], _ _index: Int) ->())?

    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
          layout.delegate = self

        }
        collectionView?.backgroundColor = .clear
        collectionView?.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        collectionView.register(UINib(nibName: CollectionViewNibIdentifier.galleryCell, bundle: nil),
                                forCellWithReuseIdentifier: CollectionViewCellIdentifier.galleryCell)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}

// MARK: - CollectionView Delegate , DataSource..
extension GalleryTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userImages?.count ?? 0
    }
    

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.galleryCell,
                                                           for: indexPath) as! GalleryCollectionViewCell
        if userImages?.count != 0 {
            if userImages!.indices.contains(indexPath.row) {
                imageCell.userImage = userImages?[indexPath.row]
            }
        }
        return imageCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
      return CGSize(width: itemSize, height: itemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        self.images.removeAll()
        for i in 0..<(self.userImages?.count ?? 0){
            let urlstring = self.userImages?[i].file ?? ""
            let trimmedString = urlstring.replacingOccurrences(of: " ", with: "%20")

            let image =  LightboxImage(imageURL: URL(string: (KAPPSTORAGE.s3Url + KAPPSTORAGE.userPicDirectoryName + trimmedString))!, text: self.userImages?[i].title ?? "")
            self.images.append(image)
        }
        
        callBackForPreviewImages?(self.images, indexPath.row)
    }
    

}

extension GalleryTableViewCell: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 230.0
        } else {
            return 230.0
        }
    }
}
