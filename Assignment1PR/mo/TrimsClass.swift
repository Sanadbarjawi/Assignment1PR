//
//  TrimsClass.swift
//  Assignment1PR
//
//  Created by Sanad Barjawi on 7/15/18.
//  Copyright © 2018 Sanad Barjawi. All rights reserved.
//

import Foundation
class TrimsClass:Decodable{
    
    var active:Bool?
    var createdAt:String?
    var id:String?
    var makeId:String?
    var name:String?
    var updatedAt:String?

    private enum CodingKeys:String, CodingKey{
        case active
        case createdAt = "created_at"
        case id
        case makeId = "make_id"
        case name
        case updatedAt = "updated_at"
    }
}
