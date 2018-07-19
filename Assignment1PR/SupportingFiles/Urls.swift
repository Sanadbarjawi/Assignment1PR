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

