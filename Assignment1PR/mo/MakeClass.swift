//
//  MakeModel.swift
//  Assignment1PR
//
//  Created by Sanad Barjawi on 7/15/18.
//  Copyright © 2018 Sanad Barjawi. All rights reserved.
//

import Foundation
protocol CarNameable{
    var name:String?{get set}
}
protocol ImageDownloadable {
    var logoUri:String?{get set}
}



class MakeClass: Decodable ,CarNameable ,ImageDownloadable{
    

    var active:Bool?
    var createdAt:String?
    var id:String?
    var logoUri:String?
    var name:String?
    var updatedAt:String?

    private enum CodingKeys : String, CodingKey {
        case active
        case createdAt = "created_at"
        case id
        case logoUri = "logo_uri"
        case name
        case updatedAt = "updated_at"
    }
 
}

