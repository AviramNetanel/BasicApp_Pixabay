//
//  ImageDetailsView.swift
//  
//
//  Created by Aviram Netanel on 5/11/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageDetailsView: View {
    
    @State var items : [Any] = []
    @State var isSheetPresented = false
    
    @StateObject var viewModel = ImageDetailsViewModel()
    @ObservedObject var imageManager = ImageManager()
    
    @Binding var photo : Photo
    @State var isAnimating: Bool = true
    @State private var orientation = UIDeviceOrientation.unknown
    
    var body: some View {
        
        let webImageView = initImageManagerAndGetWebImage(urlString: photo.largeImageURL)
        
            VStack{
                    
                    Button(action: {
                        print("share button tap")
                        if imageManager.image != nil {
                            items.removeAll()
                            items.append(imageManager.image!)
                            isSheetPresented.toggle()
                        }
                    }){
                        HStack{
//                            Image("TitleIcon")
                            Text("Share Image")
                            Image(systemName: "square.and.arrow.up")
//                                .foregroundColor(.black)
                        }
                    }
                .sheet(isPresented: $isSheetPresented, content: {
                    ShareSheetController(items: items)
                })
                if !orientation.isLandscape {
                    HStackKeyValueText(key: "Views:", value: "\(photo.views)")//views
                    HStackKeyValueText(key: "Downloads:", value: "\(photo.downloads)") //downloads
                    HStackKeyValueText(key: "Image Tags:", value: photo.tags ?? "") //tags
                    HStackKeyValueText(key: "User Name:", value: photo.user ?? "") //user name
                }
                
                //WebImage :
                webImageView
                
                //For DEMO
//                HStackKeyValueText(key: "Image Views:", value: "1231221")//views
//                HStackKeyValueText(key: "Downloads:", value: "33333") //downloads
//                HStackKeyValueText(key: "Image Tags:", value: "blue, sky, white, ass") //tags
//                HStackKeyValueText(key: "User Name:", value: "Aviram") //user name
//
//                WebImage(url: URL(string: Constants.baseUrl))
                
                // Supports options and context,
                // like `.delayPlaceholder` to show placeholder only when error
                .onSuccess { image, data, cacheType in
                    // Success
                    // Note: Data exist only when queried from disk cache or network.
                    // Use `.queryMemoryData` if you really need data
                }
                .resizable()
                .placeholder(Image("BG_icon")) // Placeholder Image
                .indicator(.activity) // Activity Indicator
                .transition(.fade(duration: 0.7)) // Fade Transition with duration
                .scaledToFit()
                .frame(height: 300, alignment: .center)
                
                
                Spacer()
                
            }//VStack
             
            .onRotate { newOrientation in
                orientation = newOrientation
            }
        
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                        Image("TitleIcon").resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50, alignment: .center)
                    }
                ToolbarItem(placement: .principal) {
                        Text("Image Details")
                            .font(.title)
                    }
                }
        .navigationViewStyle(StackNavigationViewStyle())
    }//body
    
    func initImageManagerAndGetWebImage(urlString: String?) -> WebImage{
        let url = URL(string: photo.largeImageURL ?? "")
        imageManager.load(url: url)
        return WebImage(url: url, isAnimating: $isAnimating)
    }
    
}//ImageDetailsView


struct HStackKeyValueText : View{
    
    var key : String = "KEY"
    var value : String = "value"
    
    var body: some View {
        HStack{
            Text(key)
                .frame(alignment: .leading)
                .padding(5)
                .padding(.leading, 15)
                .font(Font.body.bold())
            
            Spacer()
            
            Text(value)
                .padding(5)
                .padding(.trailing, 20)
        }
    }
}

//struct ImageDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
////        ImageDetailsView()
//        HStackKeyValueText()
//    }
//}
