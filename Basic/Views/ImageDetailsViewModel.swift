//
//  ImageDetailsViewModel.swift
//  Basic
//
//  Created by Aviram Netanel on 25/11/22.
//

import Foundation
import SwiftUI

final class ImageDetailsViewModel: ObservableObject {

    
    func uiImageFrom(urlString: String?) -> UIImage? {
        guard let urlString = urlString,
                let url = URL(string: urlString),
                let imageData = try? Data(contentsOf: url) else { return nil }
       
        return UIImage(data: imageData)
        
    }
    
    func getUIImageFromUrl(urlString: String?) -> UIImage?{
        guard urlString != nil else {return nil}
        guard let url = NSURL(string: urlString!) as? URL else {return nil}
        
        if let imageData: NSData = NSData(contentsOf: url) {
            return UIImage(data: imageData as Data)
        }
        return nil
    }
    
    
}//class
