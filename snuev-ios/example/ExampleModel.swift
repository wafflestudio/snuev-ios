//
//  IssueTrackerModel.swift
//  snuev-ios
//
//  Created by 이동현 on 12/01/2019.
//  Copyright © 2019 이동현. All rights reserved.
//

import Foundation
import Moya
import RxOptional
import RxSwift
import RxCocoa
import ObjectMapper

struct Repository: Mappable, Codable {
    var identifier: Int!
    var fullName: String!
    var name: String!
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        identifier <- map["id"]
        fullName <- map["full_name"]
        name <- map["name"]
    }
}


class Issue: Mappable {
    
    var identifier: Int!
    var number: Int!
    var title: String!
    var body: String!
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        identifier <- map["id"]
        number <- map["number"]
        title <- map["title"]
        body <- map["body"]
    }
}

struct RepositorySearch: Mappable, Codable {
    
    var totalCount: Int!
    var incompleteResults: Bool!
    var items: [Repository] = []
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        totalCount <- map["total_count"]
        incompleteResults <- map["incomplete_results"]
        items <- map["items"]
    }
}
