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
            .subscribeOn(MainScheduler.instance)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { response in
                guard let response = response as? Response else {
                    return nil
                }
                do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()
                    let decodedResponse = try Japx.Decoder.jsonObject(withJSONAPIObject: filteredResponse.mapJSON() as! Parameters)
                    if let data = decodedResponse["data"] as? [[String: Any]] {
                        return Mapper<T>().mapArray(JSONArray: data)
                    }
                    return []
                } catch _ {
                    return nil
                }
        }
    }
}
