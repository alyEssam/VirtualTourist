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
        

    static let dogURL: String = "https://live.staticflickr.com/7208/6785886468_cd0fcb9095.jpg"
        let dogURL2: String = "https://upload.wikimedia.org/wikipedia/commons/thumb/0/06/Kitten_in_Rizal_Park%2C_Manila.jpg/460px-Kitten_in_Rizal_Park%2C_Manila.jpg"
     static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        class func saveItems(){
            do{
                try context.save()
            } catch {
                print("Error saving context \(error)")
            }
            //self.tableView.reloadData()
        }

        
        
    class func getImagesFromFlickr(_ selectedPin: Pin, _ page: Int, completion: @escaping (_ photosArray: [Photo]?, _ error: NSError?) -> Void) {
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
                let photosDictionary: JSON = JSON(response.result.value!)
                let photosArray: JSON = updateResult(json: photosDictionary)
                print("Successful request Flicker Dictionairy!")
               // print(photoArray)

                 DispatchQueue.main.async{
                    var imageUrlStrings = [Photo]()
                    for item in photosArray.arrayValue {
                    print(item[Constants.FlickrParameterValues.MediumURL].stringValue)
                    let urlString = item[Constants.FlickrParameterValues.MediumURL].stringValue

                    let photo:Photo = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: context ) as! Photo
                    photo.urlString = urlString
                    photo.pin = selectedPin
                    imageUrlStrings.append(photo)
                        print("The summ is : \(imageUrlStrings.count)")
                    saveItems()
                }
                        completion(imageUrlStrings, nil)
                   }
                }
            else {
                print("Request Flicker Dictionairy Failure!")
                completion([], nil)
            }
          }
  
        }
    
      
        class func updateResult(json: JSON)-> JSON{
        return json["photos"]["photo"]
    }
 
        class func requestImage(photoUrlString: String, completion: @escaping (Data?, Error?) -> Void){
     
            let imageURL = URL(string: photoUrlString)
            let request = URLRequest(url: imageURL!)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else {
                    print("no data, or there was an error")
                    completion(nil, error)
                    return
                }
                //let imageRequested = UIImage(data: data)
                
                DispatchQueue.main.async {
              //  appDelegate.photosImage.append(PhotosImageModel(requestedFlickerImage: downloadedImage!))
                    print("Good Job!")
                    completion(data, nil)
                }
            }
            task.resume()
            
        }

    class func requestImageFile(url: URL, completionHandler: @escaping (Data?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            completionHandler(data, nil)
        })
        task.resume()
    }


}





