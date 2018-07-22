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
    ///GetRequest
    static func GetRequest(apiUrl:UrlsEnum?,apiUrlWithQueryComponents:URL?,completion: @escaping (Bool,Data)->()) {
        Networker.dataTask(apiUrl: apiUrl, apiUrlWithQueryComponents: apiUrlWithQueryComponents, method: "GET") { (success, data) in
            guard let dataResponse = data else { return }
            DispatchQueue.main.async {//main thread
                if success{
                    completion(success, dataResponse)
                }else{
                    completion(success, dataResponse)
                }
            }
        }
    }

}





