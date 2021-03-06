//
//  Service.swift
//  snuev-ios
//
//  Created by 이동현 on 2019. 4. 11..
//  Copyright © 2019년 이동현. All rights reserved.
//

import RxSwift
import ObjectMapper
import Alamofire
import Japx

enum ResourceStatus {
    case Loading
    case Success
    case Failure
}

struct Resource<T> {
    let status: ResourceStatus
    let data: T?
    var meta: [String: Any]?
    
    static func loading() -> Resource {
        return Resource(status: .Loading, data: nil, meta: nil)
    }
    
    static func success(_ data: T? = nil, meta: [String: Any]?) -> Resource {
        return Resource(status: .Success, data: data, meta: meta)
    }
    
    static func failure(_ data: T? = nil, meta: [String: Any]? = nil) -> Resource {
        return Resource(status: .Failure, data: data, meta: meta)
    }
}

struct NoData {
    // for resource with no data
}

protocol Service {
    func get<T: Mappable>(_ path: String, parameters: [String: Any]?, responseType: T.Type) -> Observable<Resource<T>>
    func post<T: Mappable>(_ path: String, parameters: [String: Any]?, responseType: T.Type) -> Observable<Resource<T>>
    func put<T: Mappable>(_ path: String, parameters: [String: Any]?, responseType: T.Type) -> Observable<Resource<T>>
    func delete<T: Mappable>(_ path: String, parameters: [String: Any]?, responseType: T.Type) -> Observable<Resource<T>>
    
    func get<T: Mappable>(_ path: String, parameters: [String: Any]?, responseArrayType: T.Type) -> Observable<Resource<[T]>>
    func post<T: Mappable>(_ path: String, parameters: [String: Any]?, responseArrayType: T.Type) -> Observable<Resource<[T]>>
    func put<T: Mappable>(_ path: String, parameters: [String: Any]?, responseArrayType: T.Type) -> Observable<Resource<[T]>>
    func delete<T: Mappable>(_ path: String, parameters: [String: Any]?, responseArrayType: T.Type) -> Observable<Resource<[T]>>
    
    func get(_ path: String, parameters: [String: Any]?) -> Observable<Resource<NoData>>
    func post(_ path: String, parameters: [String: Any]?) -> Observable<Resource<NoData>>
}

class DefaultService: Service {
    private func request(_ path: String, method: HTTPMethod, parameters: [String: Any]?) -> Observable<Resource<NoData>> {
        return Observable.create { observer in
            observer.onNext(Resource.loading())
            Alamofire.request("\(Constants.BASE_URL)\(path)", method: method, parameters: parameters).responseJSON { response in
                guard let json = response.value as? [String: Any] else {
                    observer.onNext(Resource.failure())
                    observer.onCompleted()
                    return
                }
                let jsonApiResponse = Mapper<JSONApiResponse>().map(JSON: json)
                    guard response.filterSuccessCode() else {
                        observer.onNext(Resource.failure())
                        observer.onCompleted()
                        return
                    }
                    observer.onNext(Resource.success(jsonApiResponse?.data as? NoData, meta: jsonApiResponse?.meta))
                    observer.onCompleted()
                    return
            }
            return Disposables.create()
        }
    }
    private func request<T: Mappable>(_ path: String, method: HTTPMethod, parameters: [String: Any]?, responseType: T.Type) -> Observable<Resource<T>> {
        return Observable.create { observer in
            observer.onNext(Resource.loading())
            Alamofire.request("\(Constants.BASE_URL)\(path)", method: method, parameters: parameters).responseJSON { response in
                guard let json = response.value as? [String: Any] else {
                    observer.onNext(Resource.failure())
                    observer.onCompleted()
                    return
                }
                do {
                    let decodedResponse = try Japx.Decoder.jsonObject(withJSONAPIObject: json)
                    let jsonApiResponse = Mapper<JSONApiResponse>().map(JSON: decodedResponse)
                    guard response.filterSuccessCode(), let value = jsonApiResponse?.getObjectResponse(T.self) else {
                        observer.onNext(Resource.failure(jsonApiResponse?.data as? T))
                        observer.onCompleted()
                        return
                    }
                    observer.onNext(Resource.success(value, meta: jsonApiResponse?.meta))
                    observer.onCompleted()
                    return
                } catch _ {
                    observer.onNext(Resource.failure())
                    observer.onCompleted()
                    return
                }
            }
            return Disposables.create()
        }
    }
    
    
    
    private func requestArray<T: Mappable>(_ path: String, method: HTTPMethod, parameters: Parameters?, responseType: T.Type) -> Observable<Resource<[T]>> {
        return Observable.create { observer in
            observer.onNext(Resource.loading())
            Alamofire.request("\(Constants.BASE_URL)\(path)", method: method, parameters: parameters).responseJSON { response in
                guard let json = response.value as? [String: Any] else {
                    observer.onNext(Resource.failure())
                    observer.onCompleted()
                    return
                }
                do {
                    let decodedResponse = try Japx.Decoder.jsonObject(withJSONAPIObject: json)
                    let jsonApiResponse = Mapper<JSONApiResponse>().map(JSON: decodedResponse)
                    guard response.filterSuccessCode(), let value = jsonApiResponse?.getArrayResponse(T.self) else {
                        observer.onNext(Resource.failure(jsonApiResponse?.data as? [T]))
                        observer.onCompleted()
                        return
                    }
                    observer.onNext(Resource.success(value, meta: jsonApiResponse?.meta))
                    observer.onCompleted()
                    return
                } catch _ {
                    observer.onNext(Resource.failure())
                    observer.onCompleted()
                    return
                }
            }
            return Disposables.create()
        }
    }
    
    func get<T: Mappable>(_ path: String, parameters: [String: Any]?, responseType: T.Type) -> Observable<Resource<T>> {
        return request(path, method: .get, parameters: parameters, responseType: T.self)
    }
    
    func post<T: Mappable>(_ path: String, parameters: [String: Any]?, responseType: T.Type) -> Observable<Resource<T>> {
        return request(path, method: .post, parameters: parameters, responseType: T.self)
    }
    
    func put<T: Mappable>(_ path: String, parameters: [String: Any]?, responseType: T.Type) -> Observable<Resource<T>> {
        return request(path, method: .put, parameters: parameters, responseType: T.self)
    }
    
    func delete<T: Mappable>(_ path: String, parameters: [String: Any]?, responseType: T.Type) -> Observable<Resource<T>> {
        return request(path, method: .delete, parameters: parameters, responseType: T.self)
    }
    
    func get<T: Mappable>(_ path: String, parameters: [String: Any]?, responseArrayType: T.Type) -> Observable<Resource<[T]>> {
        return requestArray(path, method: .get, parameters: parameters, responseType: T.self)
    }
    
    func post<T: Mappable>(_ path: String, parameters: [String: Any]?, responseArrayType: T.Type) -> Observable<Resource<[T]>> {
        return requestArray(path, method: .post, parameters: parameters, responseType: T.self)
    }
    
    func put<T: Mappable>(_ path: String, parameters: [String: Any]?, responseArrayType: T.Type) -> Observable<Resource<[T]>> {
        return requestArray(path, method: .put, parameters: parameters, responseType: T.self)
    }
    
    func delete<T: Mappable>(_ path: String, parameters: [String: Any]?, responseArrayType: T.Type) -> Observable<Resource<[T]>> {
        return requestArray(path, method: .delete, parameters: parameters, responseType: T.self)
    }
    
    func get(_ path: String, parameters: [String: Any]?) -> Observable<Resource<NoData>> {
        return request(path, method: .get, parameters: parameters)
    }
    
    func post(_ path: String, parameters: [String: Any]?) -> Observable<Resource<NoData>> {
        return request(path, method: .post, parameters: parameters)
    }
}

extension DataResponse {
    func filterSuccessCode() -> Bool {
        guard let response = self.response else {
            return false
        }
        return response.statusCode >= 200 && response.statusCode < 300
    }
}

