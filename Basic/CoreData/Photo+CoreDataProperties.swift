//
//  Photo+CoreDataProperties.swift
//  
//
//  Created by Aviram Netanel on 24/11/22.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var comments: Int32
    @NSManaged public var downloads: Int32
    @NSManaged public var favorites: Int32
    @NSManaged public var id: Int32
    @NSManaged public var imageHeight: Int32
    @NSManaged public var imageSize: Int64
    @NSManaged public var imageURL: String?
    @NSManaged public var imageWidth: Int32
    @NSManaged public var largeImageURL: String?
    @NSManaged public var likes: Int32
    @NSManaged public var pageURL: String?
    @NSManaged public var previewHeight: Int32
    @NSManaged public var previewURL: String?
    @NSManaged public var previewWidth: Int32
    @NSManaged public var tags: String?
    @NSManaged public var type: String?
    @NSManaged public var user: String?
    @NSManaged public var userId: Int32
    @NSManaged public var userImageURL: String?
    @NSManaged public var views: Int32
    @NSManaged public var webformatHeight: Int32
    @NSManaged public var webformatURL: String?
    @NSManaged public var webformatWidth: Int32
    @NSManaged public var category: String?

}
