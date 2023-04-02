//
//  CoreManager.swift
//  Concurrency
//
//  Created by Rita Marrano on 02/04/23.
//

import Foundation
import CoreData

class CoreManager {
    
    let persistentContainer: NSPersistentContainer
    static let shared : CoreManager = CoreManager ()
    
    private init(){
        
        ValueTransformer.setValueTransformer(UIImageTransformer(), forName: NSValueTransformerName("UIImageTransformer"))
        
        persistentContainer = NSPersistentContainer(name: "ImageContainer")
        persistentContainer.loadPersistentStores{ descpription, error in
            if let error = error {
                fatalError("unable to initialize core data \(error)")
            }
            
        }
    }
}
