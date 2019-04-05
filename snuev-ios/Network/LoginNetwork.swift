//
//  LoginNetwork.swift
//  snuev-ios
//
//  Created by 이동현 on 01/03/2019.
//  Copyright © 2019 이동현. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

protocol LoginNetwork {
    func login(_ parameters: [String: Any]) -> Observable<AuthResponse?>
    func signup(_ parameters: [String: Any]) -> Observable<Response>
    func fetchDepartments() -> Driver<[Department]?>
}
