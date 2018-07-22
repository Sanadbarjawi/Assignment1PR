//
//  Networker.swift
//  Assignment1PR
//
//  Created by Sanad Barjawi on 7/19/18.
//  Copyright © 2018 Sanad Barjawi. All rights reserved.
//

import Foundation


class APIClient{
    
    //MARK: - MakeObjects API
    static func getMakeRequest(completion: @escaping (Bool,Data)->()) {
        Networker.dataTask(apiUrl: UrlsEnum.makeObjApi.rawValue, method: "GET") { (success, data) in
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
    
    //MARK: - GetModelObjects API
    static func getModelRequest(completion: @escaping (Bool,Data)->()) {
        Networker.dataTask(apiUrl: UrlsEnum.modelObjApi.rawValue, method: "GET") { (success, data) in
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
    
    
    //MARK: - GetSubModelObjects API
    static func getSubmodelRequest(completion: @escaping (Bool,Data)->()) {
        Networker.dataTask(apiUrl: UrlsEnum.subModelApi.rawValue, method: "GET") { (success, data) in
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
    
    //MARK: - GetTrims API
    static func getTrimsRequest(completion: @escaping (Bool,Data)->()) {
        Networker.dataTask(apiUrl: UrlsEnum.trimsObjApi.rawValue, method: "GET") { (success, data) in
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
    
    //MARK: - getPrice API
    static func getPrice(makeId:String,modelId:String,submodelId:String,trimId:String,completion: @escaping (Bool,Data)->()) {
        var urlComponents = URLComponents(string:UrlsEnum.calculationApi.rawValue)
        urlComponents?.queryItems = [
            URLQueryItem(name: "make_id", value: makeId),
            URLQueryItem(name: "model_id", value: modelId),
            URLQueryItem(name: "submodel_id", value: submodelId),
            URLQueryItem(name: "trim_id", value: trimId),
        ]
        let url:String = "\((urlComponents?.url)!)"
        Networker.dataTask(apiUrl: url, method: "GET") { (success, data) in
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





