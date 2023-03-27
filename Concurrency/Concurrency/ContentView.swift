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

struct ContentView: View{
    
    var controller = ViewController()
 
    
    var body: some View {
        
        var photos = controller.images
        
        VStack{
            
            ForEach(photos, id: \.self){ image in
                Image(uiImage: image )
            }
        }
       

    }
}
