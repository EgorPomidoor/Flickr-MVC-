//
//  DataLayer.swift
//  Flicccckr
//
//  Created by Егор on 29.11.2017.
//  Copyright © 2017 Егор. All rights reserved.
//

import UIKit
import MWPhotoBrowser


class DataLayer {
   static let shared = DataLayer()
    var dataSource = NSArray()
    var photoUrlArray = NSArray()
    //var photoIndex: Int?
    
    func getData( completion: @escaping (NSArray,NSArray) -> Void ) {
        getRawData {response in
            let photosObject = response["photos"]
            let photosArray = photosObject["photo"].arrayValue
            let outArray = NSMutableArray()
            let photoOutArray = NSMutableArray()
            
            for i in 0..<photosArray.count {
                let photo = photosArray[i]
                
                let id = photo["id"].stringValue
                let farmId = photo["farm"].int64Value
                let serverId = photo["server"].int64Value
                let secret = photo["secret"].stringValue
                let photoURL = "https://farm\(farmId).staticflickr.com/\(serverId)/\(id)_\(secret).jpg"
                let title = photo["title"].stringValue
                
                let post = Post(id: id, photoURL: photoURL, title: title)
                outArray.add(post)
                photoOutArray.add(photoURL)
            }
            
            DispatchQueue.main.async {
                completion(outArray, photoOutArray)
            }
        }
    }
    
    private func getRawData(completion: @escaping (JSON) -> Void) {
        let urlString = "https://www.flickr.com/services/rest?method=flickr.interestingness.getList&api_key=3988023e15f45c8d4ef5590261b1dc53&per_page=20&page=1&format=json&nojsoncallback=1"
        /* oбъект класса URL - передаем строчку */
        let url = URL(string: urlString)!
        /* конструируем запрос в интернет - объект URLRequest */
        let request = URLRequest(url: url)
        /* отправляем запрос в интернет 1 стадия - получаем объект URLSessionDataTask */
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
            if data != nil {
                let jsonResponse = JSON(data!)
                completion(jsonResponse)
            }
        })
        /* отправляем запрос в интернет 2 стадия - у объекта URLSessionDataTask вызываем процедуру resume */
        task.resume()
    }
}
