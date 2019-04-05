//
//  Auth.swift
//  snuev-ios
//
//  Created by 이동현 on 2019. 4. 2..
//  Copyright © 2019년 이동현. All rights reserved.
//

import ObjectMapper

class AuthResponse: Mappable, Codable {
    var token: String!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        token <- map["auth_token"]
    }
}
