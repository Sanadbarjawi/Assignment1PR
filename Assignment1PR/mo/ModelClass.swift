//
//  ModelClass.swift
//  Assignment1PR
//
//  Created by Sanad Barjawi on 7/15/18.
//  Copyright © 2018 Sanad Barjawi. All rights reserved.
//

import Foundation
class ModelClass:Decodable , CarNameable{


    var active:Bool?
    var bodyTypeId:String?
    var bodyTypeIds : [String]?
    var createdAt:String?
    var discontinuedYear:Int?
    var id:String?
    var makeId:String?
    var name:String?
    var updatedAt:String?
  
    private enum CodingKeys:String, CodingKey{
        case active
        case bodyTypeId = "body_type_id"
        case bodyTypeIds = "body_type_ids"
        case createdAt = "created_at"
        case discontinuedYear = "discontinued_year"
        case id = "id"
        case makeId = "make_id"
        case name 
        case updatedAt = "updatedAt"
    }
}

