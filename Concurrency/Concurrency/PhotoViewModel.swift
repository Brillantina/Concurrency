//
//  PhotoViewModel.swift
//  Concurrency
//
//  Created by Rita Marrano on 02/04/23.
//

import Foundation
import UIKit
import CoreData
import SwiftUI
class PhotoViewModel: ObservableObject {
    
    @Published var image: UIImage?
    private var context = CoreManager.shared.persistentContainer.viewContext
    
    
    
    
    init(){
        
//        let request: NSFetchRequest<Photo> = NSFetchRequest(entityName: "Photo")
    
//        let request = FetchRequest(entity: <#T##CoreData.NSEntityDescription#>, sortDescriptors: <#T##[Foundation.NSSortDescriptor]#>)
        
        @FetchRequest(
            entity: ImageEntity.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Photo.id, ascending: false)
            ],
            predicate: NSPredicate(format: "url NOT IN %@", argumentArray: [fetchExistingImageUrls()]))
         var images: FetchedResults<ImageEntity>

        
        
        
//        do {
//            let photos : [Photo] = try context.fetch(request)
//            if let photo = photos.first {
//                self.image = photo.content
//            }
//        } catch {
//            print(error)
//        }
    }
    
    
        func fetchExistingImageUrls() -> [String] {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
            request.resultType = .dictionaryResultType
            request.propertiesToFetch = ["url"]
    
            do {
                let results = try context.fetch(request) as! [[String:Any]]
                return results.compactMap { $0["url"] as? String }
            } catch {
                print("Error fetching image URLs: \(error.localizedDescription)")
                return []
            }
        }
}
