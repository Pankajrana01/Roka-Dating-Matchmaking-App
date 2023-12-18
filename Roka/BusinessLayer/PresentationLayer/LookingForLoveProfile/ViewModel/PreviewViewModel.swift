//
//  PreviewViewModel.swift
//  Roka
//
//  Created by Pankaj Rana on 28/09/22.
//

import Foundation
import UIKit

class previewCollectionViewCell : UICollectionViewCell{
    @IBOutlet weak var previewImage: UIImageView!
    
}
class PreviewViewModel : BaseViewModel {
    var completionHandler: ((Bool) -> Void)?
    var nextButton: UIButton!
    var selectedImages = [ImageModel]()
    var copySelectedImages = [ImageModel]()
    var selectedIndex = 0
    var previewImage: UIImageView!
    var selectedPreview = 0
    var scrollView: UIScrollView!
    var imageTitleTextField: UITextField!

    var imageScrollView: ImageScrollView! { didSet { configureImageScrollView() } }
    private func configureImageScrollView() {
        imageScrollView.setup()
        imageScrollView.imageScrollViewDelegate = self
        imageScrollView.imageContentMode = .aspectFill
        imageScrollView.initialOffset = .center
    }
        
    var collectionView: UICollectionView! { didSet { configureCollectionView() } }
    private func configureCollectionView() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = false
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.isPagingEnabled = false
        collectionView.contentInsetAdjustmentBehavior = .never
        
        self.selectedPreview = self.selectedIndex
        self.updateTitlesText(index: selectedPreview)
    }
    
    func proceedForCreateProfileStepThree() {
//        StepThreeViewController.show(from: self.hostViewController, forcePresent: false, selectedImages: self.selectedImages, selectedImagesText: self.selectedImagesText, isComeFor: "Preview", basicDetailsDictionary : [:], preferredDetailsDictionary:[:]) { success in
//        }
//
        GlobalVariables.shared.selectedImages = self.selectedImages
        GlobalVariables.shared.isComeFor = "Preview"
        self.hostViewController.navigationController?.popViewController(animated: true)

    }
    
    
    func updateTitlesText(index:Int) {
        if self.selectedImages.count != 0{
            if index != -1{
                self.imageTitleTextField.text = self.selectedImages[index].title
            }
        }
    }
    
    func deleteButtonTapped() {
        if self.selectedImages.count != 0 {
            if self.selectedImages.firstIndex(where: {$0.image == self.selectedImages[self.selectedPreview].image!}) != nil {
                self.selectedImages.remove(at: self.selectedPreview)
                self.selectedPreview = 0
                self.updateTitlesText(index:selectedPreview)
                self.collectionView.reloadData()
                if self.selectedImages.count == 0 {
                    GlobalVariables.shared.cameraCancel = ""
                    proceedForCreateProfileStepThree()
                }
            }
        } else {
            GlobalVariables.shared.cameraCancel = ""
            proceedForCreateProfileStepThree()
        }
        
    }
}

extension PreviewViewModel : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - Collection Delegate & DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedImages.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "previewCollectionViewCell", for: indexPath) as! previewCollectionViewCell
        
        cell.previewImage.image = self.selectedImages[indexPath.row].image
        self.imageTitleTextField.tag = indexPath.row
       
        if self.selectedPreview == indexPath.row {
            cell.previewImage.layer.borderWidth = 2
            cell.previewImage.layer.borderColor = UIColor.loginBlueColor.cgColor
            cell.previewImage.clipsToBounds = true
            imageScrollView.display(image: self.selectedImages[self.selectedPreview].image!)
//            self.collectionView.layoutIfNeeded()
//            self.collectionView.scrollToItem(at: IndexPath(row: indexPath.row, section: 0), at: .left, animated: true)

        } else {
            cell.previewImage.layer.borderWidth = 0
            cell.previewImage.clipsToBounds = true
        }
        return cell
    }
    
    
    func scrollToCurrentPosition() {
        DispatchQueue.main.async {
            if self.selectedPreview > 0 {
                let indexPath = IndexPath(item: self.selectedPreview, section: 0)
                let scrollPosition: UICollectionView.ScrollPosition = .left
                if self.collectionView != nil {
                    self.collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: false)
                    self.collectionView.setNeedsLayout()
                    self.collectionView.layoutSubviews()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 60, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedPreview = indexPath.row
        self.updateTitlesText(index: selectedPreview)
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let edgeInsets = (collectionView.frame.size.width - (CGFloat(self.selectedImages.count) * 50) - (CGFloat(self.selectedImages.count) * 10)) / 2
        return UIEdgeInsets(top: 0, left: edgeInsets, bottom: 0, right: 0);
    }
}

extension PreviewViewModel: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
//        self.selectedImagesText[self.selectedPreview] = textField.text ?? ""
       // self.selectedImagesText.insert(textField.text ?? "", at: self.selectedPreview)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 30
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        self.selectedImages[self.selectedPreview].title = newString

        return newString.count <= maxLength
    }
}
extension PreviewViewModel: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return previewImage
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image = previewImage.image {
                let ratioW = previewImage.frame.width / image.size.width
                let ratioH = previewImage.frame.height / image.size.height
                
                let ratio = ratioW < ratioH ? ratioW : ratioH
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                let conditionLeft = newWidth*scrollView.zoomScale > previewImage.frame.width
                let left = 0.5 * (conditionLeft ? newWidth - previewImage.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
                let conditioTop = newHeight*scrollView.zoomScale > previewImage.frame.height
                
                let top = 0.5 * (conditioTop ? newHeight - previewImage.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
                
            }
        } else {
            scrollView.contentInset = .zero
        }
    }
}


extension PreviewViewModel: ImageScrollViewDelegate {
    func imageScrollViewDidChangeOrientation(imageScrollView: ImageScrollView) {
        print("Did change orientation")
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("scrollViewDidEndZooming at scale \(scale)")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll at offset \(scrollView.contentOffset)")
    }
}
