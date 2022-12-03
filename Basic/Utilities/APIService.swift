//
//  APIService.swift
//  
//
//  Created by Aviram Netanel on 2/11/22.
//

import Foundation
import SwiftUI
import CoreData


class APIService { // This class should only dispatch network requests and return parsed json models( and even this is arguable), the function add params shouldn't be in this class
    // I'd rather use a different util class to construct you URL with query parameters using URLComponents (see this: https://cocoacasts.com/working-with-nsurlcomponents-in-swift)

    static var q = "" // static variable is a bad practice, you can't save a global state!
    static var category = "" // here as well
    
    // It shouldn't be here either, and it shouldn't be lazy
    lazy var endPoint: String = { return Constants.baseUrl + "?key=" + Constants.key + "&per_page=50"}()
    
    func addParams() -> String{  // as mentioned above, this function is not supposed to be here and the logic inside of it could be done by URLComponents (foundations class)
        var result = ""
        if APIService.q.count > 0{ // you can check if the string is empty, by using `isEmpty` it reads better and efficient O(1), as the `count` property running in O(n) (https://stackoverflow.com/questions/50568726/what-is-the-bigo-of-swifts-string-count)
            let clean_q = APIService.q.replacingOccurrences(of: " ", with: "+") // this is an error prone code, since there are other unsafe characters like , or ?, hence using URLComponents together with URLQueryItem should be safer and should solve this issue for you
            result = "&q=\(clean_q)"
        }
        if APIService.category != "all" {
            result = result + "&category=\(APIService.category)"
        }
        return result
    }
    
    func getDataWith(completion: @escaping (Result<ResponseModel, Error>) -> Void) async { // why is this function async? does it calls some internal async function or does implement withCheckedContinuation? (look here https://www.hackingwithswift.com/quick-start/concurrency/how-to-use-continuations-to-convert-completion-handlers-into-async-functions)
        print("GET Request: " + endPoint + addParams())
        guard let url = URL(string: endPoint + addParams()) else {
            print("URL Error!")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in // its a bad practice to use URLSession.shard instance, this is really hard to write unit tests this way please see NewApiService
            guard error == nil else { return }

            guard let data = data else { return }
               do {

                   let response = try JSONDecoder().decode(ResponseModel.self, from: data)
                   
                   DispatchQueue.main.async { // You don't have to do it here, you can specify the queue where the completion block should execute when initiating the URLSession, for
                                              // example : URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
                       
                        completion(.success(response))
                   }

              } catch let error {
                  return completion(.failure(error))
              }
        }.resume()
        

        
    }
}


