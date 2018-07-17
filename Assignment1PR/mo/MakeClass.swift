//
//  MakeModel.swift
//  Assignment1PR
//
//  Created by Sanad Barjawi on 7/15/18.
//  Copyright © 2018 Sanad Barjawi. All rights reserved.
//

import Foundation
class MakeClass:Codable{//array of objects

    var active:Bool?
    var createdAt:String?
    var id:String?
    var logoUri:String?
    var name:String?
    var updatedAt:String?
/*active
     created_at
     id
     logo_uri
     name
     updated_at
 */
    private enum CodingKeys : String, CodingKey {
        case active
        case createdAt = "created_at"
        case id
        case logoUri = "logo_uri"
        case name
        case updatedAt = "updated_at"
    }
 
}

