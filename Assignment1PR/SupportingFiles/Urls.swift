//
//  Urls.swift
//  Assignment1PR
//
//  Created by Sanad Barjawi on 7/15/18.
//  Copyright © 2018 Sanad Barjawi. All rights reserved.
//

import Foundation
class Urls{
    
    static var sharedInstance = Urls()
    
    private let baseUrl = "http://test-api.seez.co/static"
    
    lazy var subModelApi = self.baseUrl + "/submodels/"
    lazy var makeObjApi = self.baseUrl + "/makes/"
    lazy var modelObjApi = self.baseUrl + "/models/"
    lazy var trimsObjApi = self.baseUrl + "/trims/"
    
    
    ///params:make_id=<id>&model_id=<id>&submodel_id=<id>&trim_id=<id>
    lazy var calculationApi = "http://test-api.seez.co/ai/market-estimates/"
    
    private init(){
        
    }
}
