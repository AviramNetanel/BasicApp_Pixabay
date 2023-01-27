//
//  FiltersPanelViewModel.swift
//  Basic
//
//  Created by Aviram on 25/1/23.
//
import SwiftUI
import Foundation

@MainActor
final class FiltersPanelViewModel : ObservableObject {
    
    static let shared = FiltersPanelViewModel()
    private init(){}
    
    @Published var subject : String =  ""
    @Published var category : String = "all"
    
    func getFiltersDic() -> [String : String] {
        var filtersDic : [String : String] = [:]
        if category != "all" { filtersDic["category"] = category }
        if subject != "" { filtersDic["subject"] = subject.lowercased() }
        return filtersDic
    }
    
    
}

