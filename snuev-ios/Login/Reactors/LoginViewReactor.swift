//
//  IssueReactor.swift
//  snuev-ios
//
//  Created by 이동현 on 13/01/2019.
//  Copyright © 2019 이동현. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift
import Moya
import ObjectMapper

final class LoginViewReactor: Reactor {
    var loginUseCase: LoginUseCase
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
    
    enum Action {
        case loginRequest(username: String?, password: String?)
    }
    
    enum Mutation {
        case setLoginSuccess
        case setErrorMessage(String?)
        case setIsLoading
    }
    
    struct State {
        var errorMessage: String?
        var isLoading = false
        var loginSuccess = false
    }
    
    let initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .loginRequest(username, password):
            guard let username = username, !username.isEmpty else {
                return Observable.just(Mutation.setErrorMessage("마이스누 계정을 입력하세요."))
            }
            
            guard let password = password, !password.isEmpty else {
                return Observable.just(Mutation.setErrorMessage("비밀번호를 입력하세요."))
            }
            
            return loginUseCase.login(username: username, password: password)
                    .map { resource in
                        switch resource.status {
                        case .Loading:
                            return .setIsLoading
                        case .Success:
                            return .setLoginSuccess
                        default:
                            return .setErrorMessage("로그인에 실패했습니다.")
                        }
                    }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setIsLoading:
            newState.isLoading = true
            newState.errorMessage = nil
        case .setLoginSuccess:
            newState.loginSuccess = true
            newState.errorMessage = nil
            newState.isLoading = false
            
        case let .setErrorMessage(message):
            newState.errorMessage = message
            newState.isLoading = false
        }
        return newState
    }
    
    // to view
}
