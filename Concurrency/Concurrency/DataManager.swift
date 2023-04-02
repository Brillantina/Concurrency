//
//  DataManager.swift
//  Concurrency
//
//  Created by Rita Marrano on 01/04/23.
//

import SwiftUI
import CoreData
import Firebase
import UIKit
import FirebaseStorage
import Combine
import Foundation



class FirebaseImageLoader: ObservableObject {
    
    
    
    
    @Published var imageData = Data()
    private var downloadTask: StorageDownloadTask?

    init(path: String) {
      

        let storageRef = Storage.storage().reference(withPath: path)
        let _: () = storageRef.downloadURL { (url, error) in
            if let error = error{
                // gestisci l'errore
                print("Errore durante il download dell'immagine: \(error.localizedDescription)")
            }
            else if let url = url {
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    guard let data = data else {
                        print("Error downloading image: \(error?.localizedDescription ?? "")")
                        return
                    }

                    // save the image data to Core Data
//                    self.coreManager.addImage(data: data, url: url.absoluteString, createdAt: Date())
                    
                    DispatchQueue.main.async {
                        print("ciao non fun")
                        self.imageData = data
                        
                    }
                }
                .resume()
            } else {
                print("Error getting download URL: \(error?.localizedDescription ?? "")")
            }
        }
    }
    
    
    
    
    
    
    
    
//    func fetchExistingImageUrls() -> [String] {
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageEntity")
//        request.resultType = .dictionaryResultType
//        request.propertiesToFetch = ["url"]
//
//        do {
//            let results = try viewContext.fetch(request) as! [[String:Any]]
//            return results.compactMap { $0["url"] as? String }
//        } catch {
//            print("Error fetching image URLs: \(error.localizedDescription)")
//            return []
//        }
//    }
    
    
    
    func uploadImageToFirebaseStorage(image: UIImage, completion: @escaping (String?, Error?) -> ()) {
        let storageRef = Storage.storage().reference().child("images/")
        let imageName = "\(UUID().uuidString).jpg"
        let imageRef = storageRef.child(imageName)

        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(nil, NSError(domain: "Invalid image data", code: 0, userInfo: nil))
            return
        }

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        imageRef.putData(imageData, metadata: metadata) { (metadata, error) in
            if let error = error {
                completion(nil, error)
            } else {
                imageRef.downloadURL { (url, error) in
                    guard let url = url else {
                        completion(nil, error)
                        return
                    }
                    completion(url.absoluteString, nil)
                }
            }
        }
    }


}
