//
//  ResponseModel.swift
//  
//
//  Created by Aviram Netanel on 2/11/22.
//

import Foundation

struct HitResponseModel: Decodable {
    
    var total: Int
    var totalHits: Int
    var hits: [HitModel]
    
}
