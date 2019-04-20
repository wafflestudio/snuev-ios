//
//  LectureEndpoint.swift
//  snuev-ios
//
//  Created by 김동욱 on 10/04/2019.
//  Copyright © 2019 이동현. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxCocoa
import Japx
import ObjectMapper

enum MoyaLecture {
    case searchLectures(_ parameters: [String: Any])
}

extension MoyaLecture: TargetType {
    var headers: [String : String]? {
        switch self {
        case .searchLectures:
            return nil
        }
    }

    var baseURL: URL { return URL(string: Constants.BASE_URL)! }
    var path: String {
        switch self {
        case .searchLectures:
            return "/v1/lectures/search"
        }
    }
    var method: Moya.Method {
        switch self {
        case .searchLectures:
            return .get
        }
    }    

    var sampleData: Data {
        return "}".utf8Encoded
    }

    var task: Task {
        switch self {
        case .searchLectures(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
}

final class MoyaLectureNetwork: LectureNetwork {
    private let provider = MoyaProvider<MoyaLecture>()

    func searchLectures(_ parameters: [String: Any]) -> Observable<Response> {
        return provider.rx.request(MoyaLecture.searchLectures(parameters))
            .subscribeOn(MainScheduler.instance)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .asObservable()
    }
}



