//
//  Urls.swift
//  Assignment1PR
//
//  Created by Sanad Barjawi on 7/15/18.
//  Copyright © 2018 Sanad Barjawi. All rights reserved.
//

import Foundation

enum UrlsEnum:String{
    case baseUrl = "http://test-api.seez.co/static"
    case makeObjApi = "http://test-api.seez.co/static/makes/"
    case modelObjApi = "http://test-api.seez.co/static/models/"
    case subModelApi = "http://test-api.seez.co/static/submodels/"
    case trimsObjApi = "http://test-api.seez.co/static/trims/"
    
    ///params:make_id=<id>&model_id=<id>&submodel_id=<id>&trim_id=<id>
    case calculationApi = "http://test-api.seez.co/ai/market-estimates/"
}
// public class Urls{

//    var baseUrl:String {
//        get {
//            return "http://test-api.seez.co/static"
//        }
//    }
//    var makeObjApi:String{
//        get{
//            return baseUrl + "/makes/"
//        }
//    }
//    var modelObjApi:String{
//        get{
//            return baseUrl + "/models/"
//        }
//    }
//    var subModelApi:String{
//        get{
//            return baseUrl + "/submodels/"
//        }
//    }
//    var trimsObjApi:String{
//        get{
//            return baseUrl + "/trims/"
//        }
//    }
    
//    var calculationApi:String{
//        get{
//            return "http://test-api.seez.co/ai/market-estimates/"
//        }
//    }
//}
