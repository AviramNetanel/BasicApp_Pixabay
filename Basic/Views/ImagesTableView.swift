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

    @StateObject var viewModel = ImagesTableViewModel()
    
    var body: some View {
                
        NavigationView {
            VStack{

                SettingsPanelView(viewModel: viewModel)
                List {
                    ForEach(0..<$viewModel.photosVisible.count, id:\.self) { i in
                        NavigationLink {
                            ImageDetailsView(photo: $viewModel.photosVisible[i])
                        } label: {
                            ImageCellView(photo: $viewModel.photosVisible[i])
                            
                        }.onAppear(){
                            Task{
                                await self.viewModel.loadMoreContent(currentItemIndex: i)
                                print("photo index:\(i)")
                            }
                        }
                    }
                }//List
                    .listStyle(PlainListStyle())
                    .task {
                        if viewModel.photosVisible.count == 0{
                            await viewModel.sendRequestAndReload()
                        }
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
        }//NavigationView
        
        
    }//body
        
}//ImagesTableView struct


//PREVIEW: (unmark to enable canvas)
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImagesTableView(viewModel: <#T##ImagesTableViewModel#>)
//    }
//}



