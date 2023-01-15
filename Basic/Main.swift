//
//  BasicApp.swift
//  Basic
//
//  Created by Aviram Netanel on 22/11/22.
//

import SwiftUI


@main
struct BasicApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ImagesTableView()
        }
    }
}
