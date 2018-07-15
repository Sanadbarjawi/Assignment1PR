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
    var created_at:String?
    var engine_ids = [String]()
    var id:String?
    var model_id:String?
    var name:String?
    var trim_ids = [String]()
    var updated_at:String?
    
}
