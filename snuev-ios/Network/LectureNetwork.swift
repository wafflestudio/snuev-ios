//
//  LectureNetwork.swift
//  snuev-ios
//
//  Created by 김동욱 on 01/03/2019.
//  Copyright © 2019 김동욱. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

protocol LectureNetwork {
    func searchLectures(_ parameters: [String: Any]) -> Observable<Response>
}
