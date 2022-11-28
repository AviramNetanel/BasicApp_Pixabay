//
//  APIService.swift
//  
//
//  Created by Aviram Netanel on 2/11/22.
//

import Foundation
import SwiftUI
import CoreData

class APIService {

    static var q = ""
    static var category = ""
    
    lazy var endPoint: String = { return Constants.baseUrl + "?key=" + Constants.key + "&per_page=50"}()
    
    func addParams() -> String{
        var result = ""
        if APIService.q.count > 0{
            let clean_q = APIService.q.replacingOccurrences(of: " ", with: "+")
            result = "&q=\(clean_q)"
        }
        if APIService.category != "all" {
            result = result + "&category=\(APIService.category)"
        }
        return result
    }
    
    func getDataWith(completion: @escaping (Result<ResponseModel, Error>) -> Void) async {
        print("GET Request: " + endPoint + addParams())
        guard let url = URL(string: endPoint + addParams()) else {
            print("URL Error!")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { return }

            guard let data = data else { return }
               do {

                   let response = try JSONDecoder().decode(ResponseModel.self, from: data)
                   
                   DispatchQueue.main.async {
                       
                        completion(.success(response))
                   }

              } catch let error {
                  return completion(.failure(error))
              }
        }.resume()
        
        
    }
    
}
