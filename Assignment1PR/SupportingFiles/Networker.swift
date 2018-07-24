//
//  Networker.swift
//  Assignment1PR
//
//  Created by Sanad Barjawi on 7/22/18.
//  Copyright © 2018 Sanad Barjawi. All rights reserved.
//

import Foundation
final class Networker{
   static private var task = URLSessionDataTask()

    static func dataTastRequest(url:URL,method: HttpMethodEnum,completion: @escaping (Error?,Data?) -> ()){
     
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
                completion(error, data)
                return
            }else{//success
                completion(nil, data)
            }
        })
        task.resume()
    }
    
    
    
    
    
    enum HttpMethodEnum:String{
        case post = "POST"
        case get = "GET"
    }
    
}
