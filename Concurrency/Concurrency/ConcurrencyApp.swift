//
//  ConcurrencyApp.swift
//  Concurrency
//
//  Created by Rita Marrano on 27/03/23.
//

import SwiftUI
import Firebase

@main
struct ConcurrencyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
    init(){
        FirebaseApp.configure()
    }
}
