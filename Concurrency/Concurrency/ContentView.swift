//
//  ContentView.swift
//  Concurrency
//
//  Created by Rita Marrano on 30/03/23.
//

import SwiftUI
import CoreData
import Firebase

struct ContentView: View {

    @State private var isUserCurrentlyLoggedOut: Bool = false //qua
    
    var body: some View {
        NavigationView{
            if self.isUserCurrentlyLoggedOut{
            TabView {
                
                
                
                
                
                UploadView()
                    .tabItem(){
                        Image(systemName: "figure.soccer")
                        Text("A")
                    }
                

                
                DownloadView()
                    .tabItem(){
                        Image(systemName: "star.fill")
                        Text("Faved")
                    }
                

            }
        } else {
            content
        }
    }
    
}
    
 
    var content: some View{
        LoginRegister(isUserCurrentlyLoggedOut: $isUserCurrentlyLoggedOut)
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



extension View {
    
    func placeholder<Content: View> (
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment){
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}


