//
//  HitModel.swift
//
//  Created by Aviram Netanel on 2/11/22.
//

import Foundation


struct HitModel :  Codable, Hashable {

    var id      : Int
    var pageURL : String?
    var type    : String?
    var tags     : String?
    var previewURL : String?
    var previewWidth : Int?
    var previewHeight: Int?
    var webformatURL : String?
    var webformatWidth : Int?
    var webformatHeight: Int?
    var largeImageURL : String?
    var fullHDURL : String?
    var imageURL : String?
    var imageWidth : Int?
    var imageHeight : Int?
    var imageSize : Int?
    var views : Int?
    var downloads : Int?
    var likes : Int?
    var comments : Int?
    var favorites : Int?
    var user_id : Int?
    var user : String?
    var userImageURL : String?
    
}
