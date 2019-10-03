//
//  FlickerClient.swift
//  VirtualTourist
//
//  Created by Aly Essam on 10/1/19.
//  Copyright © 2019 Aly Essam. All rights reserved.
//

import Foundation
import UIKit
class FlickerClient  {
   
  
  /*  enum Method {
                
        case getImages
  
        var stringValue: String {
            switch self {
            case .getImages:
                return "flickr.photos.search"
                
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }

    */
    

    
    
     class func searchByLatLon(latitude: Double, longitude: Double, completion: @escaping (photo, Error?) -> Void) {
        let methodParameters = [
            Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.SearchMethod,
            Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
            Constants.FlickrParameterKeys.BoundingBox: bboxString(lat: latitude, lon: longitude),
            Constants.FlickrParameterKeys.SafeSearch: Constants.FlickrParameterValues.UseSafeSearch,
            Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL,
            Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
            Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback
            ]
        taskForGETRequest(url: flickrURLFromParameters(methodParameters as [String : AnyObject]), responseType:  GetImagesResponse.self, udacityApiFlag: false) { (responseType, error) in
            if let responseType = responseType {
                completion(responseType.photos.photo, nil)
            } else {
                completion(responseType!.photos.photo, error)
            }
        }
    }
    
    
    private class func flickrURLFromParameters(_ methodParameters: [String:AnyObject]) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.Flickr.APIScheme
        components.host = Constants.Flickr.APIHost
        components.path = Constants.Flickr.APIPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in methodParameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }

private class func bboxString(lat: Double!, lon: Double!) -> String {
    // ensure bbox is bounded by minimum and maximums
    if let latitude = lat, let longitude = lon {
        let minimumLon = max(longitude - Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.0)
        let minimumLat = max(latitude - Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatRange.0)
        let maximumLon = min(longitude + Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.1)
        let maximumLat = min(latitude + Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatRange.1)
        return "\(minimumLon),\(minimumLat),\(maximumLon),\(maximumLat)"
    } else {
        return "0,0,0,0"
    }
    
    
}


    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, udacityApiFlag:Bool, completion: @escaping (ResponseType?, Error?) -> Void){
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            func displayError(_ error: String) {
                print(error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                displayError("There was an error with your request: \(String(describing: error))")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }

            let decoder = JSONDecoder()
            
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                    print("Good get data")
                completion(responseObject, nil)
            }
                catch {
                        completion(nil, error)
                }
            }
        task.resume()
    }


}





