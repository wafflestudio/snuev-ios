//
//  Lectures.swift
//  snuev-ios
//
//  Created by 김동욱 on 10/04/2019.
//  Copyright © 2019 이동현. All rights reserved.
//

import ObjectMapper

class Lecture: Mappable, Codable {
    var bookmarked: Bool!
    var createdAt: Date!
    var easiness: Int!
    var evaluated: Bool!
    var evaluationsCount: Int!
    var grading: Int!
    var id: Int!
    var name: String!
    var score: Int!
    var updatedAt: Date!
    var viewCount: Int!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        id <- map["id"]
        bookmarked <- map["bookmarked"]
        createdAt <- map["created_at"]
        easiness <- map["easiness"]
        evaluated <- map["evaluated"]
        evaluationsCount <- map["evaluations_count"]
        grading <- map["grading"]
        id <- map["id"]
        name <- map["name"]
        score <- map["score"]
        updatedAt <- map["updated_at"]
        viewCount <- map["view_count"]
    }
}

class Course: Mappable, Codable {
    var id: String!
    var name: String!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        id <- map["id"]
    }
}

class Professor: Mappable, Codable {
    var id: String!
    var name: String!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        id <- map["id"]
    }
}

class Semester: Mappable, Codable {
    var id: String!
    var name: String!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        id <- map["id"]
    }
}
