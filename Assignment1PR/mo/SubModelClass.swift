//
//  SubModelClass.swift
//  Assignment1PR
//
//  Created by Sanad Barjawi on 7/15/18.
//  Copyright © 2018 Sanad Barjawi. All rights reserved.
//

import Foundation
class SubModelClass:Decodable{
    
    var active:Bool?
    var createdAt:String?
    var id:String?
    var modelId:String?
    var name:String?
    var trimIds:[String]?
    var updatedAt:String?

    private enum CodingKeys:String, CodingKey{
        case active
        case createdAt = "created_at"
        case id = "id"
        case modelId = "model_id"
        case name = "name"
        case trimIds = "trim_ids"
        case updatedAt = "updated_at"
    }
}
