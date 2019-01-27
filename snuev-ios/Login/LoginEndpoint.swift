//
//  LoginEndpoint.swift
//  snuev-ios
//
//  Created by 이동현 on 15/01/2019.
//  Copyright © 2019 이동현. All rights reserved.
//

import Foundation
import Moya

enum Login {
    case login(username: String, password: String)
    case fetchDepartments
}

extension Login: TargetType {
    var headers: [String : String]? {
        switch self {
        case .login:
            return nil
        case .fetchDepartments:
            return nil
        }
    }
    
    var baseURL: URL { return URL(string: Constants.BASE_URL)! }
    var path: String {
        switch self {
        case .login:
            return "/v1/user/sign_in"
        case .fetchDepartments:
            return "/v1/departments"
        }
    }
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case .fetchDepartments:
            return .get
        }
    }
    
    var sampleData: Data {
        return "}".utf8Encoded
    }
    
    var task: Task {
        switch self {
        case .login(let username, let password):
            return .requestParameters(parameters: ["username": username, "password": password], encoding: JSONEncoding.default)
        case .fetchDepartments:
            return .requestPlain
        }
    }
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
}

