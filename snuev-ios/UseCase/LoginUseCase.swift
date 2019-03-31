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
    func login(_ parameters: [String: Any]) -> Observable<Response>
    func signup(_ parameters: [String: Any]) -> Observable<Response>
    func fetchDepartments() -> Driver<[Department]?>
}

class DefaultLoginUseCase: LoginUseCase {
    let netWork: LoginNetwork
    
    init(netWork: LoginNetwork) {
        self.netWork = netWork
    }
    
    func login(_ parameters: [String : Any]) -> Observable<Response> {
        return netWork.login(parameters)
    }
    
    func signup(_ parameters: [String : Any]) -> Observable<Response> {
        return netWork.signup(parameters)
    }
    
    func fetchDepartments() -> Driver<[Department]?> {
        return netWork.fetchDepartments()
    }
}
