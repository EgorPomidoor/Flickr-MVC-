//
//  ViewController.swift
//  Flicccckr
//
//  Created by Егор on 20.11.2017.
//  Copyright © 2017 Егор. All rights reserved.
//

import UIKit
import SDWebImage
import MWPhotoBrowser

class ViewController: UIViewController {
    
    
    var dataSource = NSArray()
    @IBOutlet weak var tableView: UITableView!
    let kCellNIB = UINib(nibName: "CustomCell", bundle: nil)
    let kCellReuseIdentifier = "kCellReuseIdentifier"
    var photoArrayForBrowser = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(kCellNIB, forCellReuseIdentifier: kCellReuseIdentifier)

        DataLayer.shared.getData {post, photoUrl in
            DataLayer.shared.dataSource = post
            DataLayer.shared.photoUrlArray = photoUrl
            self.fillPhotoArray()
            self.tableView.reloadData()
        }
    }
}



//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataLayer.shared.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellReuseIdentifier, for: indexPath) as! CustomCell
        cell.configureSelf(model: DataLayer.shared.dataSource[indexPath.row] as! Post)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = DataLayer.shared.dataSource[indexPath.row] as! Post
        if model.downloadedSize != nil {
            return model.downloadedSize!.height
        } else {
            getSize (model: model, indexPath: indexPath)
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //так как объект браузера нельзя использовать повторно, то создаем его при нажатии на ячейку (а не в свойстве класса)
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
extension ViewController: MWPhotoBrowserDelegate {
    
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
}



//MARK:- загружаем размеры картинок
extension ViewController {
    func getSize (model: Post, indexPath: IndexPath) {
        let urlString = "https://www.flickr.com/services/rest?method=flickr.photos.getSizes&api_key=3988023e15f45c8d4ef5590261b1dc53&photo_id=\(model.id)&format=json&nojsoncallback=?#sizes/size/7"
        let url = URL(string: urlString )!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data,response,error) in
            if data != nil {
                let jsonResponse = JSON (data!)
                
                let sizesArray = jsonResponse["sizes"]["size"].arrayValue
                for size in sizesArray {
                    let label = size["label"]
                    if label == "Large" {
                        let width = CGFloat(size["width"].floatValue)
                        let hight = CGFloat(size["height"].floatValue)
                        let screenWidth = self.view.frame.size.width
                        let k = width/hight
                        let trueHeight = screenWidth / k
                        let sizeStructure = CGSize(width: screenWidth, height: trueHeight)
                        let largeURL = size["source"].stringValue
                        
                        model.photoURL = largeURL
                        model.downloadedSize = sizeStructure
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadRows(at: [indexPath], with: .fade)
                        }
                        break
                    }
                }
            }
        })
        task.resume()
    }
}

