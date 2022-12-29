//
//  ImagesTableViewModel.swift
//  
//
//  Created by Aviram Netanel on 4/11/22.
//

import SwiftUI
import CoreData

@MainActor
final class ImagesTableViewModel: ObservableObject {
    
    let apiService = NetworkManager<HitResponseModel>()
    
    let persistenceController = PersistenceController.shared
    let viewContext = PersistenceController.shared.viewContext
    
    @Published var allPhotos:[Photo] = PersistenceController.shared.fetchAllPhotos()
    
    @Published var subject : String =  ""
    @Published var category : String = "all"

    func sendRequestAndReload() async{
        allPhotos = []
        print("All Photos BEFORE request: \(allPhotos.count)")
        print("Core-Data BEFOER request: \(persistenceController.fetchAllPhotos().count)")
        
        await getHitsFromApiService()
        
        allPhotos = persistenceController.fetchPhotosWith(filtersDic: getFiltersDic())
        print("All Photos AFTER request: \(allPhotos.count)")
        print("All Photos AFTER request: \(persistenceController.fetchAllPhotos().count)")
    }
    
    func getFiltersDic() -> [String : String] {
        var filtersDic : [String : String] = [:]
        if category != "all" { filtersDic["category"] = category }
        if subject != ""    { filtersDic["subject"] = subject.lowercased() }
        return filtersDic
    }
    
    func getHitsFromApiService() async {
//        API-SERVICE - sends GET request
//        APIService.category = category
//        APIService.q = subject // this an the line above are anti pattern, why do you use this global state just for a query text, its a bad practice, its not thread safe an not testable.
        
        let optionalParams = buildParamsDictionary()
        
        guard let urlWithParams = UrlWithParams(urlString: Constants.baseUrl, optionalParameters: optionalParams).urlComponents?.url else {return}
        
        do{
            let result = try await apiService.fetchData(withURL: urlWithParams)
            print("RESPONSE result.total: \(result.total) | result.hits.count: \(result.hits.count)")
                handleSuccess(result)
        }
        catch{
            print("Network error: \(error).")
        }
    }//getHitsFromApiService
    
    fileprivate func handleSuccess(_ response: HitResponseModel) {
        let _ :[Photo] = response.hits.filter { hit in
                guard let likesCount = hit.likes,
                      let commentsCount = hit.comments
//                      likesCount > 51 && commentsCount > 21
                    else { return false }
            if persistenceController.fetchPhoto(photoId: hit.id) != nil {
                print("photo \(hit.id) was filtered!")
                return false
            }
                return true
        }.map { hitModel in
            let photo = Photo(withHitModel: hitModel,
                  context: self.viewContext)
            if category != "all"{
                photo.category = category
            }
            return photo
            
        }.sorted {$0.likes > $1.likes}
        
        do{
            try self.viewContext.save()
        }catch{
            print("ERROR: saving viewContent!")
        }
    }
    

        
    
    func buildParamsDictionary() -> [String: String]{
        var result : [String : String] = [:]
        
//        if !Constants.key.isEmpty{
//            result["key"] = Constants.key
//        }
        
        if category != "all"{
            result["category"] = category
        }
        if !subject.isEmpty {
            result["q"] = subject.lowercased()
        }
        
        return result
    }
    
}//ImagesTableViewModel



