//
//  PrimitiveSequence.swift
//  snuev-ios
//
//  Created by 이동현 on 15/03/2019.
//  Copyright © 2019 이동현. All rights reserved.
//

import RxSwift
import Moya
import ObjectMapper
import Japx

extension PrimitiveSequence where PrimitiveSequence.TraitType == RxSwift.SingleTrait {
    func mapResponseToArray<T: Mappable>(_ type: T.Type) -> RxSwift.PrimitiveSequence<RxSwift.SingleTrait, [T]?> {
        return self
            .mapResponse()
            .map { response in
                return response?.getArrayResponse(T.self)
        }
    }
    
    func mapResponseToObject<T: Mappable>(_ type: T.Type) -> RxSwift.PrimitiveSequence<RxSwift.SingleTrait, T?> {
        return self
            .mapResponse()
            .map { response in
                return response?.getObjectResponse(T.self)
            }
    }
    
    func mapResponse() -> RxSwift.PrimitiveSequence<RxSwift.SingleTrait, JSONApiResponse?> {
        return self
            .subscribeOn(MainScheduler.instance)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { response in
                guard let response = response as? Response else {
                    return nil
                }
                do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()
                    let decodedResponse = try Japx.Decoder.jsonObject(withJSONAPIObject: filteredResponse.mapJSON() as! Parameters)
                    return Mapper<JSONApiResponse>().map(JSON: decodedResponse)
                } catch _ {
                    return nil
                }
        }
    }
}
