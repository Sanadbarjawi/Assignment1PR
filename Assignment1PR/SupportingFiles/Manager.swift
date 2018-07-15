//
//  Manager.swift
//  Assignment1PR
//
//  Created by Sanad Barjawi on 7/15/18.
//  Copyright © 2018 Sanad Barjawi. All rights reserved.
//

import Foundation
class Manager {
    
    static var sharedInstance = Manager()
    
    var makeClassObj = [MakeClass]()
    var modelClassObj = [ModelClass]()
    var SubModelClassObj = [SubModelClass]()
    var TrimClassObj = [TrimsClass]()
    
    var make_id = ""
    var model_id = ""
    var submodel_id = ""
    var trim_id = ""
    
    
    private init(){
    }
}
