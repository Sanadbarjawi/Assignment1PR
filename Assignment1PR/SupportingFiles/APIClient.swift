//
//  Networker.swift
//  Assignment1PR
//
//  Created by Sanad Barjawi on 7/19/18.
//  Copyright © 2018 Sanad Barjawi. All rights reserved.
//

import Foundation

class APIClient{
     func dataTask(apiUrl: String, method: String, completion: @escaping (Bool,Data?) -> ()) {
        let urlString = UrlsEnum.makeObjApi.rawValue
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            if error != nil {
                print(error.debugDescription)
                completion(false, data)
                return
            }else{//success
                completion( true,  data)
            }
            }.resume()
    }
    
    
    
    static func getMakeRequest(completion: @escaping (Bool,Data)->()) {

        self.dataTask(apiUrl: UrlsEnum.makeObjApi.rawValue, method: "GET") { (success, data) in
            guard let dataResponse = data else { return }

            if success{
              
                print(dataResponse)
                completion(success, dataResponse)
            }else{
                completion(success, dataResponse)
            }
        }
    }
}
    
/*USE THIS CODE ON SUNDAY(REPLACE MAINVIEWCONTROLLER SERVICES WITH THIS SHORTENED CODE)
 APIClient.getMakeRequest { (success, data) in
 print(data)
 do {
 let makeData = try JSONDecoder().decode([MakeClass].self, from: data)
 self.dataArray = makeData
 }
 catch{
 
 }
 }
 */





