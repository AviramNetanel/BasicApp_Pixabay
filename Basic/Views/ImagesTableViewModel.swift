//
//  ImagesTableViewModel.swift
//  
//
//  Created by Aviram Netanel on 4/11/22.
//

import SwiftUI
import CoreData

final class ImagesTableViewModel: ObservableObject {
    
    let apiService = APIService()
    let viewContext = PersistenceController.shared.viewContext
    
    @Published var allPhotos:[Photo] = PersistenceController.shared.fetchAllPhotos()
    
    @Published var subject : String =  ""
    @Published var category : String = "all"

    private func addPhoto(hit : HitModel) { // do you ned this function?
        withAnimation {
            let newPhoto = Photo(context: viewContext)
            populatePhoto(photo: newPhoto, With: hit)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    
    /*
     //Delete Photo:
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { allPhotos[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
     */
    // This logic is not needed
    private func populatePhoto(photo: Photo, With hit: HitModel){ // looks like a logic that could go into an extension of `Photo`class
        photo.id = Int32(hit.id)
        photo.likes = Int32(hit.likes ?? 0)
        photo.comments = Int32(hit.comments ?? 0)
        photo.imageURL = hit.imageURL
        photo.previewURL = hit.previewURL
        photo.downloads = Int32(hit.downloads ?? 0)
        photo.favorites = Int32(hit.favorites ?? 0)
        photo.imageHeight = Int32(hit.imageHeight ?? 0)
        photo.imageSize = Int64(hit.imageSize ?? 0)
        photo.imageWidth = Int32(hit.imageWidth ?? 0)
        photo.largeImageURL = hit.largeImageURL
        photo.pageURL = hit.pageURL
        photo.previewHeight = Int32(hit.previewHeight ?? 0)
        photo.previewWidth = Int32(hit.previewWidth ?? 0)
        photo.tags = hit.tags
        photo.type = hit.type
        photo.user = hit.user
        photo.userId = Int32(hit.user_id ?? 0)
        photo.userImageURL = hit.userImageURL
        photo.views = Int32(hit.views ?? 0)
        photo.webformatURL = hit.webformatURL
        photo.webformatHeight = Int32(hit.webformatHeight ?? 0)
        photo.webformatWidth = Int32(hit.webformatWidth ?? 0)
        
        if category != "all" { photo.category = category }
    }
    
    func sendRequestAndReload() async{
        allPhotos = []
        await getHitsFromApiService()
        
        allPhotos = PersistenceController.shared.fetchPhotosWith(filtersDic: getFiltersDic())
    }
    
    func getFiltersDic() -> [String : String] {
        var filtersDic : [String : String] = [:]
        if category != "all" { filtersDic["category"] = category }
        if subject != ""    { filtersDic["subject"] = subject }
        return filtersDic
    }
    
    fileprivate func handleSuccess(_ response: ResponseModel) {
        allPhotos = response.hits.filter { hit in
                guard let likesCount = hit.likes,
                      let commentsCount = hit.comments,
                      likesCount > 51 && commentsCount > 21 else { return false }
                return true
        }.map { hitModel in
            Photo(withHitModel: hitModel ,
                  context: self.viewContext)
        }.sorted {$0.likes > $1.likes}
        
        
        do{
            try self.viewContext.save()
        }catch{
            print("ERROR: saving viewContent!")
        }
        
    
//        for hit in response.hits {
//
//            //if photo exists in the core-data:
//            if PersistenceController.shared.fetchPhoto(photoId: hit.id) != nil {
//                print("photo \(hit.id) already exists...")
//                continue
//            }
//
//            guard let likesCount = hit.likes else { continue }
//            guard let commentsCount = hit.comments else { continue }
//
//            if likesCount < 51 || commentsCount < 21{
//                continue
//            }
//
//            let photo = Photo(context: self.viewContext)
//            self.populatePhoto(photo: photo, With: hit)
//
//            self.allPhotos.insert(photo, at: self.allPhotos.count)
//            self.allPhotos.sort(by: {$0.likes > $1.likes})
//
//            do{
//                try self.viewContext.save()
//                print("Photo: \(hit.id) saved!")
//            }catch{
//                print("ERROR: saving viewContent!")
//            }
//        }
//
//        print("RESPONSE HITS:")
//        print(response.hits)
    }
    
    func getHitsFromApiService() async {
//        API-SERVICE - sends GET request
        APIService.category = category
        APIService.q = subject // this an the line above are anti pattern, why do you use this global state just for a query text, its a bad practice, its not thread safe an not testable.
        
        await apiService.getDataWith { [weak self] result  in
        
            
            switch result {
                case .success(let response):

                self?.handleSuccess(response)

            case .failure(let error):
                //TODO: show error message
                print("ERROR: \(error)")
            }
        }
    }//getHitsFromApiService
        
}//ImagesTableViewModel


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
