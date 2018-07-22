//
//  Networker.swift
//  Assignment1PR
//
//  Created by Sanad Barjawi on 7/22/18.
//  Copyright © 2018 Sanad Barjawi. All rights reserved.
//

import Foundation
class Networker{
    static func dataTask(apiUrl: String, method: String,completion: @escaping (Bool,Data?) -> ()) {
        let urlString = apiUrl
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

}
