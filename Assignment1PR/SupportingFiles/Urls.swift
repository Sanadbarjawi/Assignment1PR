//
//  Urls.swift
//  Assignment1PR
//
//  Created by Sanad Barjawi on 7/15/18.
//  Copyright © 2018 Sanad Barjawi. All rights reserved.
//

import Foundation

 public class Urls{
    
    var baseUrl:String {
        get {
            return "http://test-api.seez.co/static"
        }
    }
    var makeObjApi:String{
        get{
            return baseUrl + "/makes/"
        }
    }
    var modelObjApi:String{
        get{
            return baseUrl + "/models/"
        }
    }
    var subModelApi:String{
        get{
            return baseUrl + "/submodels/"
        }
    }
    var trimsObjApi:String{
        get{
            return baseUrl + "/trims/"
        }
    }
    
    ///params:make_id=<id>&model_id=<id>&submodel_id=<id>&trim_id=<id>
    var calculationApi:String{
        get{
            return "http://test-api.seez.co/ai/market-estimates/"
        }
    }
}
