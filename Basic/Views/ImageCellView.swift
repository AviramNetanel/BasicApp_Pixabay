//
//  ImageCellView.swift
//  
//
//  Created by Aviram Netanel on 2/11/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageCellView: View {
    
    @Binding var photo : Photo
    @State var isAnimating: Bool = true

    var body: some View {
       
        ZStack{
        
            WebImage(url: URL(string: photo.previewURL ?? ""), isAnimating: $isAnimating)
            // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
            .onSuccess { image, data, cacheType in
                // Success
                // Note: Data exist only when queried from disk cache or network.
                // Use `.queryMemoryData` if you really need data
            }
            .resizable()
            .placeholder(Image("BG_icon")) // Placeholder Image
            
            .indicator(.activity) // Activity Indicator
            .transition(.fade(duration: 0.5)) // Fade Transition with duration
            .scaledToFit()
            .frame(height: 300, alignment: .center)

            VStack{
                Spacer()
                HStack{
                    BubbleView(text: "Likes: ", number: Int(photo.likes))
                        .frame(alignment: .bottomLeading)
                        .padding(.leading,5)
                        .padding(.bottom,30)
                    
                    BubbleView(text: "Comments: ", number: Int(photo.comments))
                        .frame(alignment: .bottomTrailing)
                        .padding(.trailing,5)
                        .padding(.bottom,30)
                }
                .padding(.bottom,20)
            }
        }//ZStack
    }//body
}//ImageCellView

struct BubbleView : View{
    let text : String
    let number : Int
    var alignment : Alignment = .center
    
    var body: some View {
        Text( text + "\(number)")
            
            .frame(width: 135, height: 25, alignment: alignment)
            .background(Color.green)
            .opacity(0.66)
            .cornerRadius(11.0)
            .padding()
    }
}


//PREVIEW:
struct ImageViewCell_Previews: PreviewProvider {
    static var previews: some View {
        BubbleView(text: "Likes", number: 124)

    }
}
