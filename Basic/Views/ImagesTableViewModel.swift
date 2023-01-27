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
    
    @ObservedObject var filtersPanelVM : FiltersPanelViewModel
    
    let apiService = NetworkManager<HitResponseModel>()
    
    let persistenceController = PersistenceController.shared
    let viewContext = PersistenceController.shared.viewContext
    
    var page = 1
    var total_pages = 1
    var results_per_page = 20
        
    @State var isLoading = false
    
    @Published var photosVisible:[Photo]

    init(){
        photosVisible = PersistenceController.shared.fetchAllPhotos()
        filtersPanelVM = FiltersPanelViewModel.shared
    }
    
    func sendRequestAndReload() async{
        photosVisible = []
        await sendRequestAndLoad()
    }
    
    func sendRequestAndLoad() async{
        isLoading = true
//        photosVisible = []
        print("All Photos BEFORE request: \(photosVisible.count)")
        print("Core-Data BEFOER request: \(persistenceController.fetchAllPhotos().count)")
        
        await getHitsFromApiService()
        
        photosVisible = persistenceController.fetchPhotosWith(filtersDic: filtersPanelVM.getFiltersDic())
        print("All Photos AFTER request: \(photosVisible.count)")
        print("All Photos AFTER request: \(persistenceController.fetchAllPhotos().count)")
    }
    
    
    
    func getHitsFromApiService() async {
        
        let optionalParams = buildParamsDictionary()
        
        guard let urlWithParams = URLParamsBuilder(urlString: Constants.baseUrl, optionalParameters: optionalParams).urlComponents?.url else {return}
        
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
        self.total_pages = response.totalHits / self.results_per_page
        print("page: \(self.page)\\\(self.total_pages) || \(self.results_per_page)X\(self.page)\\\(response.totalHits)")
        
        let _ :[Photo] = response.hits.filter { hit in
                guard let likesCount = hit.likes,
                      let commentsCount = hit.comments,
                      likesCount >= 0 && commentsCount >= 0 //EDIT HERE FOR Likes\Comments filtering!
                    else { return false }
            if persistenceController.fetchPhoto(photoId: hit.id) != nil {
                print("photo \(hit.id) already exists in core-data!")
                return false
            }
                return true
        }.map { hitModel in
            let photo = Photo(withHitModel: hitModel,
                  context: self.viewContext)
            if filtersPanelVM.category != "all"{
                photo.category = filtersPanelVM.category
            }
            return photo
            
        }.sorted {$0.likes > $1.likes}
        
        self.page += 1
        self.isLoading = false
        
        do{
            try self.viewContext.save()
        }catch{
            print("ERROR: saving viewContent!")
        }
    }
    
    func buildParamsDictionary() -> [String: String]{
        var result : [String : String] = [:]
        
        result["page"] = "\(self.page)"
        
        if filtersPanelVM.category != "all"{
            result["category"] = filtersPanelVM.category
        }
        if !filtersPanelVM.subject.isEmpty {
            result["q"] = filtersPanelVM.subject.lowercased()
        }
        
        return result
    }
    
    
    //MARK: - PAGINATION
        func loadMoreContent(currentItemIndex itemIndex: Int) async{
            let thresholdIndex = self.photosVisible.index(self.photosVisible.endIndex, offsetBy: -1)
            print("itemIndex#\(itemIndex)")
            if thresholdIndex == itemIndex,
               page <= self.total_pages {
                page += 1
                print("requesting for page#\(page)")
                await sendRequestAndLoad()
            }
        }
    
}//ImagesTableViewModel



