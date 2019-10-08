//
//  FlickerRequest.swift
//  VirtualTourist
//
//  Created by Aly Essam on 10/1/19.
//  Copyright © 2019 Aly Essam. All rights reserved.
//

import Foundation
/*
struct GetImagesRequest {
    /*
    let api_key : String //= FlickerClient.APIKey
    let method : String //= FlickerClient.Method.getImages
    let safe_search: Int //= 1
    let lat: Double
    let lon: Double
    let extras: String //= "url_m"
    let format: String //= "json"
    let nojsoncallback: String //= "1"
    */
    var parameters: [String: Any]
    init(api_key: String, method : String, safe_search: Int, lat: Double, lon: Double, extras: String, format: String, nojsoncallback: String) {
        parameters = [
            "api_key" : api_key,
            "method" : method,
            "safe_search" : safe_search,
            "lat" : lat,
            "lon" : lon,
            "extras" : extras,
            "format" : format,
            "nojsoncallback" : nojsoncallback]
    }

}
*/
struct Constants {

    // MARK: Flickr
    struct Flickr {
        static let SearchBBoxHalfWidth = 1.0
        static let SearchBBoxHalfHeight = 1.0
        static let SearchLatRange = (-90.0, 90.0)
        static let SearchLonRange = (-180.0, 180.0)
        static let Flicker_URL = "https://www.flickr.com/services/rest/"

    }
    
// MARK: Flickr Parameter Keys
struct FlickrParameterKeys {
    static let Method = "method"
    static let APIKey = "api_key"
    static let GalleryID = "gallery_id"
    static let Extras = "extras"
    static let PerPage = "per_page"
    static let Format = "format"
    static let NoJSONCallback = "nojsoncallback"
    static let SafeSearch = "safe_search"
    static let Text = "text"
    static let BoundingBox = "bbox"
    static let Page = "page"
    static let latitude = "lat"
    static let longitude = "lon"
}


// MARK: Flickr Parameter Values
struct FlickrParameterValues {
    static let SearchMethod = "flickr.photos.search"
    static let APIKey = "9ebffc831227bbd3de780a6d5c758226"
    static let numberOfPhotos = "21"
    static let ResponseFormat = "json"
    static let DisableJSONCallback = "1" /* 1 means "yes" */
    static let GalleryPhotosMethod = "flickr.galleries.getPhotos"
    static let GalleryID = "5704-72157622566655097"
    static let MediumURL = "url_m"
    static let UseSafeSearch = "1"

}
}
/*
func searchByLatLon(_ sender: AnyObject) {
  
        let methodParameters = [
           // FlickrParameterKeys.Method: FlickrParameterValues.SearchMethod,
           // FlickrParameterKeys.APIKey: FlickrParameterValues.APIKey,
           // FlickrParameterKeys.BoundingBox: bboxString(),
           // FlickrParameterKeys.SafeSearch: FlickrParameterValues.UseSafeSearch,
           // FlickrParameterKeys.Extras: FlickrParameterValues.MediumURL,
            //FlickrParameterKeys.Format: FlickrParameterValues.ResponseFormat,
           // FlickrParameterKeys.NoJSONCallback: FlickrParameterValues.DisableJSONCallback
        ]
        displayImageFromFlickrBySearch(methodParameters as [String:AnyObject])
    }

}

private func bboxString() -> String {
    // ensure bbox is bounded by minimum and maximums
    if let latitude = Double(latitudeTextField.text!), let longitude = Double(longitudeTextField.text!) {
        let minimumLon = max(longitude - Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.0)
        let minimumLat = max(latitude - Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatRange.0)
        let maximumLon = min(longitude + Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.1)
        let maximumLat = min(latitude + Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatRange.1)
        return "\(minimumLon),\(minimumLat),\(maximumLon),\(maximumLat)"
    } else {
        return "0,0,0,0"
    }
 

}


*/
