//
//  Observable.swift
//  snuev-ios
//
//  Created by 이동현 on 12/01/2019.
//  Copyright © 2019 이동현. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper
import Moya

extension Observable {
    func mapObject<T: Mappable>(type: T.Type) -> Observable<T?> {
        return self.map { response in
            //if response is a dictionary, then use ObjectMapper to map the dictionary
            //if not throw an error
            guard let dict = response as? [String: Any] else {
                return nil
            }
            return Mapper<T>().map(JSON: dict)
        }
    }
    
    func mapArray<T: Mappable>(type: T.Type) -> Observable<[T]?> {
        return self.map { response in
            //if response is an array of dictionaries, then use ObjectMapper to map the dictionary
            //if not, throw an error
            guard let array = response as? [[String: Any]] else {
                return nil
            }
            return Mapper<T>().mapArray(JSONArray: array)
        }
    }
}
