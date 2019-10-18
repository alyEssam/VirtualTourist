//
//  FlickerRequest.swift
//  VirtualTourist
//
//  Created by Aly Essam on 10/1/19.
//  Copyright © 2019 Aly Essam. All rights reserved.
//

import Foundation

struct Constants {

    // MARK: Flickr
    struct Flickr {
        static let Flicker_URL = "https://www.flickr.com/services/rest/"
    }
    
// MARK: Flickr Parameter Keys
struct FlickrParameterKeys {
    static let Method = "method"
    static let APIKey = "api_key"
    static let Extras = "extras"
    static let PerPage = "per_page"
    static let Format = "format"
    static let NoJSONCallback = "nojsoncallback"
    static let SafeSearch = "safe_search"
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
    static let MediumURL = "url_m"
    static let UseSafeSearch = "1"
  }
    
}

