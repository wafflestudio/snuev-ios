//
//  GithubEndpoint.swift
//  GitHubSearch
//
//  Created by 이동현 on 12/01/2019.
//  Copyright © 2019 Suyeol Jeon. All rights reserved.
//

import Foundation
import Moya

enum Example {
    case userProfile(username: String)
    case repos(username: String)
    case repo(fullName: String)
    case issues(repositoryFullName: String)
    case search(query: String, page: Int)
}

extension Example: TargetType {
    var headers: [String : String]? {
        return nil
    }
    
    var baseURL: URL { return URL(string: "https://api.github.com")! }
    var path: String {
        switch self {
        case .repos(let name):
            return "/users/\(name.URLEscapedString)/repos"
        case .userProfile(let name):
            return "/users/\(name.URLEscapedString)"
        case .repo(let name):
            return "/repos/\(name)"
        case .issues(let repositoryName):
            return "/repos/\(repositoryName)/issues"
        case .search(_, _):
            return "/search/repositories"
        }
    }
    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        switch self {
        case .repos(_):
            return "}".utf8Encoded
        case .userProfile(let name):
            return "{\"login\": \"\(name)\", \"id\": 100}".utf8Encoded
        case .repo(_):
            return "{\"id\": \"1\", \"language\": \"Swift\", \"url\": \"https://api.github.com/repos/mjacko/Router\", \"name\": \"Router\"}".utf8Encoded
        case .issues(_):
            return "{\"id\": 132942471, \"number\": 405, \"title\": \"Updates example with fix to String extension by changing to Optional\", \"body\": \"Fix it pls.\"}".utf8Encoded
        case .search(_, _):
            return "}".utf8Encoded
        }
    }
    var task: Task {
        switch self {
        case .search(let query, let page):
            return .requestParameters(parameters: ["q": query, "page": page], encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
