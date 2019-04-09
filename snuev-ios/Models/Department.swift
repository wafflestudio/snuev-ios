//
//  Department.swift
//  snuev-ios
//
//  Created by 이동현 on 02/03/2019.
//  Copyright © 2019 이동현. All rights reserved.
//

import ObjectMapper

class Department: Mappable, Codable {
    var id: String!
    var name: String!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        id <- map["id"]
    }
}
