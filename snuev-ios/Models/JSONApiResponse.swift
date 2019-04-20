//
//  JSONApiResponse.swift
//  snuev-ios
//
//  Created by 이동현 on 2019. 4. 2..
//  Copyright © 2019년 이동현. All rights reserved.
//

import ObjectMapper

class JSONApiResponse<T>: Mappable {
    var data: T?
    var meta: [String: Any]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        data <- map["data"]
        meta <- map["meta"]
    }
    
    func getObjectResponse<T: Mappable>(_ type: T.Type) -> T? {
        if let data = data as? [String: Any] {
            return Mapper<T>().map(JSON: data)
        }
        return nil
    }
    
    func getArrayResponse<T: Mappable>(_ type: T.Type) -> [T]? {
        if let data = data as? [[String: Any]] {
            return Mapper<T>().mapArray(JSONArray: data)
        }
        return nil
    }
}

