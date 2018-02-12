//
//  CollectionViewController.swift
//  Flicccckr
//
//  Created by Егор on 30.11.2017.
//  Copyright © 2017 Егор. All rights reserved.
//

import UIKit
import MWPhotoBrowser

class CollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let kCellNIB = UINib(nibName: "CustomCollectionViewCell", bundle: nil)
    let kCellReuseIdentifier = "CustomCollectionViewCellIdentifier"
    var photoArrayForBrowser = NSMutableArray()
    //переменная для разметки ячеек (отступы)
    let sectionInsets = UIEdgeInsets(top: 40.0, left: 20.0, bottom: 40.0, right: 20.0)
    let itemsPerRow: CGFloat = 3

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(kCellNIB, forCellWithReuseIdentifier: kCellReuseIdentifier)
        
        fillPhotoArray()
    }
}
   
    
// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension CollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataLayer.shared.dataSource.count
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellReuseIdentifier, for: indexPath) as! CustomCollectionViewCell
        cell.configureSelf(model: DataLayer.shared.dataSource[indexPath.row] as! Post)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize.init(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let browser = MWPhotoBrowser()
        browser.delegate = self
        browser.displayNavArrows = true
        browser.alwaysShowControls = true
        browser.enableGrid = true
        browser.setCurrentPhotoIndex(UInt(bitPattern: indexPath.row))
        
        navigationController?.pushViewController(browser, animated: true)
    }
}



//MARK: - MWPhotoBrowser
extension CollectionViewController: MWPhotoBrowserDelegate {
    
    private func fillPhotoArray () {
        for data in DataLayer.shared.photoUrlArray {
            let photoUrl = data as! String
            photoArrayForBrowser.add(MWPhoto(url: URL(string: photoUrl)))
        }
    }
    
    func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(bitPattern: photoArrayForBrowser.count)
    }
    
    //функция, которая из массива с урлами делает фотографии по индексу
    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol! {
        let kk = photoArrayForBrowser.object(at: Int(index)) as! MWPhoto
        return kk
    }
    
    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, thumbPhotoAt index: UInt) -> MWPhotoProtocol! {
        let kk = photoArrayForBrowser.object(at: Int(index)) as! MWPhoto
        return kk
    }
}
