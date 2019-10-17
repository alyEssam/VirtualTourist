//
//  FlickerClient.swift
//  VirtualTourist
//
//  Created by Aly Essam on 10/1/19.
//  Copyright © 2019 Aly Essam. All rights reserved.
//
import MapKit
import SwiftyJSON
import CoreData
import Foundation
import UIKit
import Alamofire

class FlickerClient  {
     static let appDelegate = UIApplication.shared.delegate as! AppDelegate
     static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        class func saveItems(){
            do{
                try context.save()
            } catch {
                print("Error saving context \(error)")
            }
        }

        
        
    class func getImagesFromFlickr(_ selectedPin: Pin, _ page: Int, completion: @escaping (_ photosArray: [Photo]?, _ error: Error?) -> Void) {
        let methodParameters = [
            
            Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.SearchMethod,
            Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
            Constants.FlickrParameterKeys.latitude: selectedPin.latitude,
            Constants.FlickrParameterKeys.longitude: selectedPin.longitude,
            Constants.FlickrParameterKeys.Page: "\(page)",
            Constants.FlickrParameterKeys.SafeSearch: Constants.FlickrParameterValues.UseSafeSearch,
            Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL,
            Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
            Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback,
            Constants.FlickrParameterKeys.PerPage: Constants.FlickrParameterValues.numberOfPhotos
            ] as [String : Any]

        Alamofire.request(Constants.Flickr.Flicker_URL, method: .get, parameters: methodParameters).responseJSON { (response) in
            if response.result.isSuccess  {
                DispatchQueue.main.async{
                let photosDictionary: JSON = JSON(response.result.value!)
                let photosArray: JSON = updateResult(json: photosDictionary)
                // print("Successful request Flicker Dictionairy!")
                let context = appDelegate.getContext()
        
                    var imageUrlStrings = [Photo]()
                    for item in photosArray.arrayValue {
                    //print(item[Constants.FlickrParameterValues.MediumURL].stringValue)
                    let urlString = item[Constants.FlickrParameterValues.MediumURL].stringValue

                    let photo:Photo = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: context ) as! Photo
                    photo.urlString = urlString
                    photo.pin = selectedPin
                        
                    imageUrlStrings.append(photo)
                    saveItems()
                   }
                        completion(imageUrlStrings, nil)
                   }
                }
            else {
                DispatchQueue.main.async{
                print("Request Flicker Dictionairy Failure!")
                    completion(nil, response.error)
                }
            }
          }
  
        }
        class func updateResult(json: JSON)-> JSON{
        return json["photos"]["photo"]
    }
    
    
    class func requestImagePhoto(url: URL, completionHandler: @escaping (Data?, Error?) -> Void) {
        Alamofire.request(url, method: .get).response { (response) in
        guard response.error == nil else {
            completionHandler(nil, response.error)
            return
        }
        DispatchQueue.main.async {
        //print("Get Data!")
            completionHandler(response.data, nil)
        }
            
    }
}
//        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//            guard error == nil else {
//                completionHandler(nil, error?.localizedDescription as? Error)
//                return
//            }
//            DispatchQueue.main.async {
//            //print("Get Data!")
//            completionHandler(data, nil)
//            }
//
//        })
//        task.resume()
//   }

}
