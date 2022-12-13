//
//  PhotoExtension.swift
//  Basic
//
//  Created by Aviram on 11/12/22.
//

import Foundation
import CoreData


extension Photo {
    
    convenience init(withHitModel hit: HitModel, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = Int32(hit.id)
        self.likes = Int32(hit.likes ?? 0)
        self.comments = Int32(hit.comments ?? 0)
        self.imageURL = hit.imageURL
        self.previewURL = hit.previewURL
        self.downloads = Int32(hit.downloads ?? 0)
        self.favorites = Int32(hit.favorites ?? 0)
        self.imageHeight = Int32(hit.imageHeight ?? 0)
        self.imageSize = Int64(hit.imageSize ?? 0)
        self.imageWidth = Int32(hit.imageWidth ?? 0)
        self.largeImageURL = hit.largeImageURL
        self.pageURL = hit.pageURL
        self.previewHeight = Int32(hit.previewHeight ?? 0)
        self.previewWidth = Int32(hit.previewWidth ?? 0)
        self.tags = hit.tags
        self.type = hit.type
        self.user = hit.user
        self.userId = Int32(hit.user_id ?? 0)
        self.userImageURL = hit.userImageURL
        self.views = Int32(hit.views ?? 0)
        self.webformatURL = hit.webformatURL
        self.webformatHeight = Int32(hit.webformatHeight ?? 0)
        self.webformatWidth = Int32(hit.webformatWidth ?? 0)
        
        if category != "all" { self.category = category }
        
    }

}


