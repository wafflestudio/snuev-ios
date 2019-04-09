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
    var useCase: LoginUseCase
    var navigator: LoginNavigator
    
    init(useCase: LoginUseCase, navigator: LoginNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }
    
    enum Action {
        case loginRequest(username: String?, password: String?)
    }
    
    enum Mutation {
        case setLoginSuccess(Bool)
        case setErrorMessage(String?)
        case setIsLoading(Bool)
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
                return Observable.just(Mutation.setErrorMessage("Enter username"))
            }
            
            guard let password = password, !password.isEmpty else {
                return Observable.just(Mutation.setErrorMessage("Enter password"))
            }
            
            return Observable.concat([
                Observable.just(Mutation.setIsLoading(true)),
                useCase.login(["username": username, "password": password])
                    .map { response in
                        if response {
                            return Mutation.setLoginSuccess(true)
                        }
                        return Mutation.setErrorMessage("로그인에 실패했습니다.")
                    }
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setIsLoading(isLoading):
            newState.isLoading = isLoading
            newState.errorMessage = nil
            
        case let .setLoginSuccess(success):
            newState.loginSuccess = success
            newState.errorMessage = nil
            
        case let .setErrorMessage(message):
            newState.errorMessage = message
        }
        return newState
    }
    
    // to view
    
    func toMain() {
        navigator.toMain()
    }
    
    func toSignup() {
        navigator.toSignup()
    }
}
