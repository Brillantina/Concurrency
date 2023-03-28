//
//  ContentView.swift
//  Concurrency
//
//  Created by Rita Marrano on 27/03/23.
//

import SwiftUI
import CoreData
import Firebase
import UIKit
import FirebaseStorage
import Combine


struct FirebaseImage: View {
    @ObservedObject var imageLoader: FirebaseImageLoader
    
    init(path: String) {
        imageLoader = FirebaseImageLoader(path: path)
    }
    
    var body: some View {
        
        
        Image(uiImage: UIImage(data: imageLoader.imageData) ?? UIImage())
            .resizable()
            .scaledToFit()
    }
}

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
}

struct ContentView: View {
    let storage = Storage.storage()
    let imagesRef = Storage.storage().reference().child("images/")
    @State var imagePaths = [String]()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(imagePaths, id: \.self) { path in
                    FirebaseImage(path: path)
                        .frame(height: 200)
                }
            }
            .padding()
        }
        .onAppear {
           
            DispatchQueue.global(qos: .background).async {
                imagesRef.listAll { (result, error) in
                    if let error = error {
                        print("Error listing images: \(error.localizedDescription)")
                    } else {
                        let paths = result?.items.map { $0.fullPath }
                        DispatchQueue.main.async {
                            imagePaths = paths ?? [String]()
                        }
                    }
                }
            }
        }
    }
}
