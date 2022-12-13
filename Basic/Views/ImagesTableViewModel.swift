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
    
    let viewContext = PersistenceController.shared.viewContext
    
    @Published var allPhotos:[Photo] = PersistenceController.shared.fetchAllPhotos()
    
    @Published var subject : String =  ""
    @Published var category : String = "all"

//    private func addPhoto(hit : HitModel) { // do you ned this function?
//        withAnimation {
//            let newPhoto = Photo(context: viewContext)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
    
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
    
    fileprivate func handleSuccess(_ response: HitResponseModel) {
        allPhotos = response.hits.filter { hit in
                guard let likesCount = hit.likes,
                      let commentsCount = hit.comments,
                      likesCount > 51 && commentsCount > 21 else { return false }
                return true
        }.map { hitModel in
            Photo(withHitModel: hitModel,
                  context: self.viewContext)
        }.sorted {$0.likes > $1.likes}
        
        do{
            try self.viewContext.save()
        }catch{
            print("ERROR: saving viewContent!")
        }
    }
    
    func getHitsFromApiService() async {
//        API-SERVICE - sends GET request
//        APIService.category = category
//        APIService.q = subject // this an the line above are anti pattern, why do you use this global state just for a query text, its a bad practice, its not thread safe an not testable.
        
        let optionalParams = buildParamsDictionary()
        
        guard let urlWithParams = UrlWithParams(urlString: Constants.baseUrl, optionalParameters: optionalParams).urlComponents?.url else {return}
        
        do{
            let result = try await apiService.fetchData(withURL: urlWithParams)
                print("RESPONSE RESULT: \(result)\n")
                handleSuccess(result)
        }
        catch{
            print("Network error: \(error).")
        }
    }//getHitsFromApiService
        
    
    func buildParamsDictionary() -> [String: String]{
        var result : [String : String] = [:]
        
//        if !Constants.key.isEmpty{
//            result["key"] = Constants.key
//        }
        
        if category != "all"{
            result["category"] = category
        }
        if !subject.isEmpty {
            result["q"] = subject
        }
        
        return result
    }
    
}//ImagesTableViewModel



