//
//  ResponseModel.swift
//  
//
//  Created by Aviram Netanel on 2/11/22.
//

import Foundation

struct ResponseModel: Codable {
    
    var total: Int
    var totalHits: Int
    var hits: [HitModel]
    
}
