//
//  FlickerResponse.swift
//  VirtualTourist
//
//  Created by Aly Essam on 10/1/19.
//  Copyright © 2019 Aly Essam. All rights reserved.
//

import Foundation

/*
struct account : Codable {
    
    let registered : Bool
    let key : String
}

struct session : Codable {
    let id : String
    let expiration : String
}

struct loginResponse : Codable {
    let account : account
    let session : session
}

/*
 //JSON Response
 {
 "account":{
 "registered":true,
 "key":"3903878747"
 },
 "session":{
 "id":"1457628510Sc18f2ad4cd3fb317fb8e028488694088",
 "expiration":"2015-05-10T16:48:30.760460Z"
 }
 }
 
 */
{"photos":{"page":1,"pages":64,"perpage":250,"total":"15849","photo":[{"id":"48788868917","owner":"142275750@N02","secret":"474f051e76","server":"65535","farm":66,"title":"Egypt 93","ispublic":1,"isfriend":0,"isfamily":0,"url_m":"https:\/\/live.staticflickr.com\/65535\/48788868917_474f051e76.jpg","height_m":341,"width_m":500},{"id":"48788868882","owner":"142275750@N02","secret":"893c55e400","server":"65535","farm":66,"title":"Egitto 1993","ispublic":1,"isfriend":0,"isfamily":0,"url_m":"https:\/\/live.staticflickr.com\/65535\/48788868882_893c55e400.jpg","height_m":342,"width_m":500}]},"stat":"ok"}
 */
struct GetImagesResponse : Codable {
    let photos : photos
    let stat : String
}

struct photos : Codable {
    
    let page : Int
    let pages : Int
    let perpage : Int
    let total : String
    let photo : photo
}

struct photo : Codable {
    
    let id : String
    let owner : String
    let secret : String
    let server : String
    let farm : Int
    let title : String
    let ispublic : Int
    let isfriend : Int
    let isfamily : Int
    let url_m : URL
    let height_m : Int
    let width_m : Int
}

struct flickerResponseURL {
    let url_m : URL?
    //  let flickerImage : UIImage?
    // let title: String?
}
