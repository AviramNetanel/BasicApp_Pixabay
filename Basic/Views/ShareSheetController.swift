//
//  ShareSheetController.swift
//  Basic
//
//  Created by Aviram Netanel on 25/11/22.
//

import Foundation
import SwiftUI


struct ShareSheetController: UIViewControllerRepresentable {
    
    var items: [Any]
        
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items,
                                                  applicationActivities: nil)
                
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
}


