//
//  Networker.swift
//  Assignment1PR
//
//  Created by Sanad Barjawi on 7/19/18.
//  Copyright © 2018 Sanad Barjawi. All rights reserved.
//

import Foundation
final class APIClient{
   
    
    //MARK: - GetRequest(GetMakeObjects, GetModelObjects, GetSubModelObjects, GetSubModelObjects, GetTrims) APIs
    ///Request
    static func apiRequest(url:URL,method:Networker.HttpMethodEnum,completion: @escaping (Error?,Data?)->()) {
        Networker.dataTastRequest(url: url, method: method) { (error, data) in
            guard let dataResponse = data else { return }
            DispatchQueue.main.async {
                if error == nil{
                    completion(nil, dataResponse)
                }else{
                    completion(error, dataResponse)
                }
            }
        }
    }
    
    

}





