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

protocol LoginUseCase {
    func login(_ parameters: [String: Any]) -> Observable<Bool>
    func signup(_ parameters: [String: Any]) -> Observable<Response>
    func fetchDepartments() -> Driver<[Department]?>
}

class DefaultLoginUseCase: LoginUseCase {
    let netWork: LoginNetwork
    let authManager: AuthManager
    
    init(netWork: LoginNetwork, authManager: AuthManager) {
        self.netWork = netWork
        self.authManager = authManager
    }
    
    func login(_ parameters: [String : Any]) -> Observable<Bool> {
        return netWork.login(parameters).map { response in
            if let token = response?.token {
                self.authManager.setToken(token: token)
                return true
            }
            return false
        }
    }
    
    func signup(_ parameters: [String : Any]) -> Observable<Response> {
        return netWork.signup(parameters)
    }
    
    func fetchDepartments() -> Driver<[Department]?> {
        return netWork.fetchDepartments()
    }
}
