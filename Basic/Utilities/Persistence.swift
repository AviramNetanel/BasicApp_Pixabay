//
//  Persistence.swift
//  Basic
//
//  Created by Aviram Netanel on 22/11/22.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
//    static var preview: PersistenceController = {
//        let result = PersistenceController(inMemory: true)
//        let viewContext = result.container.viewContext
//
//
//        do {
//            try viewContext.save()
//        } catch {
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//        return result
//    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: Constants.coreDataModelName)
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: Constants.coreDataURL)
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func fetchAllPhotos() -> [Photo]{
        print("fetchAllPhotos")
        let request : NSFetchRequest<Photo> = Photo.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Photo.likes, ascending: false)]
        
        do{
            return try viewContext.fetch(request)
        }catch {
            return []
        }
    }
    
    func fetchPhoto(photoId : Int) -> Photo? {
        print("fetchPhoto : \(photoId)")
        let request : NSFetchRequest<Photo> = Photo.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %d", photoId)
        
        do{
            let result = try viewContext.fetch(request)
            return result.first
        }catch {
            return nil
        }
    }
    
    func fetchPhotosWith(filtersDic: [String:String]) -> [Photo]
    {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        var subPredicates : [NSPredicate] = []
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Photo.likes, ascending: false)]

        //Category filter:
        if let category = filtersDic["category"]{
            let categoryPredicate = NSPredicate(
                format: "category = %@", category
            )
            subPredicates.append(categoryPredicate)
        }
        
        //subject filter:
        if let subject = filtersDic["subject"]{
            let subjectPredicate = NSPredicate(
                format: "tags CONTAINS %@" , subject
            )
            subPredicates.append(subjectPredicate)
        }
        
        fetchRequest.predicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: subPredicates
        )
                
        do{
            let objects = try viewContext.fetch(fetchRequest)
            return objects
        }catch {
            print("Error fetching Photos With parameters")
            return []
        }
    }
    
}
