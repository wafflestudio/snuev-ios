//
//  LoginUseCase.swift
//  snuev-ios
//
//  Created by 이동현 on 31/03/2019.
//  Copyright © 2019 이동현. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import KeychainSwift

protocol LoginUseCase {
    func login(username: String, password: String) -> Observable<Resource<AuthResponse>>
    func signup(username: String, password: String, nickname: String, department: String) -> Observable<Resource<AuthResponse>>

    func setToken(token: String)
    func logout()
}

class DefaultLoginUseCase: LoginUseCase {
    let service: Service
    let keychain = KeychainSwift()
    
    init(service: Service) {
        self.service = service
    }
    
    func login(username: String, password: String) -> Observable<Resource<AuthResponse>> {
        let parameters = ["username": username, "password": password]
        return service.post("/v1/user/sign_in", parameters: parameters, responseType: AuthResponse.self)
    }
    
    func signup(username: String, password: String, nickname: String, department: String) -> Observable<Resource<AuthResponse>> {
        let parameters = ["username": username, "password": password, "nickname": nickname, "department": department]
        return service.post("/v1/user", parameters: parameters, responseType: AuthResponse.self)
    }

    func setToken(token: String) {
        keychain.set(token, forKey: "access_token")
    }
    
    func logout() {
        keychain.clear()
    }
}
