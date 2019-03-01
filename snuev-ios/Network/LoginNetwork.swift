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

protocol LoginNetworkProvider {
    func login(_ parameters: [String: Any]) -> Observable<Response>
}

final class LoginNetwork {
    private let provider: LoginNetworkProvider
    
    init(_ provider: LoginNetworkProvider) {
        self.provider = provider
    }
    
    func login(_ parameters: [String: Any]) -> Observable<Response> {
        return provider.login(parameters)
    }
}
