//
//  ModelClass.swift
//  Assignment1PR
//
//  Created by Sanad Barjawi on 7/15/18.
//  Copyright © 2018 Sanad Barjawi. All rights reserved.
//

import Foundation
class ModelClass:Decodable{//array of objects

    var active:Bool?
    var body_type_id:String?
    var body_type_ids = [String]()
    var created_at:String?
    var discontinued_year:Int?
    var id:String?
    var make_id:String?
    var name:String?
    var updated_at:String?
}

