//
//  ContentView.swift
//  
//
//  Created by Aviram Netanel on 2/11/22.
//

import UIKit
import SwiftUI
import CoreData

struct ImagesTableView: View {

    @ObservedObject var viewModel: ImagesTableViewModel
    
    var body: some View {
                
        NavigationView {
            VStack{

                SettingsPanelView(viewModel: viewModel)
                List {
                    
                    ForEach($viewModel.allPhotos, id: \.id) { photo in
                        NavigationLink {
                            ImageDetailsView(photo: photo)

                        } label: {
                            ImageCellView(photo: photo)
                        }
                    }
                }//List
                    .listStyle(PlainListStyle())
                    .task {
                        await viewModel.getHitsFromApiService()
                    }
            }//VStack
            
            .onAppear {
                    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation") // Forcing the rotation to portrait
                    AppDelegate.orientationLock = .portrait // And making sure it stays that way
            }
            .onDisappear {
                    AppDelegate.orientationLock = .all // Unlocking the rotation when leaving the view
            }
            
            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading){
                                        Image("TitleIcon").resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50, alignment: .leading)
                                    }
                                ToolbarItem(placement: .principal) {
                                        Text("Pixabay Images")
                                            .font(.title)
                                    }
                                }
            
        
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addPhoto) {
//                        Label("GET Photos", systemImage: "plus")
//                    }
//                }
//            }
        }//NavigationView
        
        
    }//body
        
}//ImagesTableView struct


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
//    }
//}



