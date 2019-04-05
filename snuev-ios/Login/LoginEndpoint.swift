//
//  LoginEndpoint.swift
//  snuev-ios
//
//  Created by 이동현 on 15/01/2019.
//  Copyright © 2019 이동현. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxCocoa
import Japx
import ObjectMapper

enum Login {
    case login(_ parameters: [String: Any])
    case signup(_ parameters: [String: Any])
    case fetchDepartments
}

extension Login: TargetType {
    var headers: [String : String]? {
        switch self {
        case .login:
            return nil
        case .signup:
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
        case .signup:
            return "/v1/user"
        case .fetchDepartments:
            return "/v1/departments"
        }
    }
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case .signup:
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
        case .login(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .signup(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .fetchDepartments:
            return .requestPlain
        }
    }
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
}

final class MoyaLoginNetwork: LoginNetwork {
    private let provider = MoyaProvider<Login>()
    
    func login(_ parameters: [String: Any]) -> Observable<AuthResponse?> {
        return provider.rx.request(Login.login(parameters))
            .subscribeOn(MainScheduler.instance)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
//            .map { response in
//                do {
//                    let filteredResponse = try response.filterSuccessfulStatusCodes()
//                    if let jsonRespose = try filteredResponse.mapJSON() as? [String: Any], let meta = jsonRespose["meta"] as? [String: Any], let token = meta["auth_token"] as? String {
//                        print(jsonRespose)
//                    }
//                    return "asd"
//                }
//                catch _ {
//                    return ":asd"
//                }
//            }
            .mapResponse()
            .map {response in
                if let meta = response?.meta {
                    return Mapper<AuthResponse>().map(JSON: meta)
                }
                return nil
            }
            .asObservable()
    }
    
    func signup(_ parameters: [String: Any]) -> Observable<Response> {
        return provider.rx.request(Login.signup(parameters))
            .subscribeOn(MainScheduler.instance)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .asObservable()
    }
    
    func fetchDepartments() -> Driver<[Department]?> {
        return provider.rx.request(Login.fetchDepartments)
            .mapResponseToArray(Department.self)
            .asDriver(onErrorJustReturn: nil)
    }
}



