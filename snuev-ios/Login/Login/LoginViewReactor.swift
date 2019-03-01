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
    var provider: LoginNetwork
    var authManager: AuthManager
    var navigator: LoginNavigator
    
    init(provider: LoginNetwork, authManager: AuthManager, navigator: LoginNavigator) {
        self.provider = provider
        self.authManager = authManager
        self.navigator = navigator
    }
    
    enum Action {
        case loginRequest(username: String?, password: String?)
    }
    
    enum Mutation {
        case setLoginSuccess(Bool)
        case setErrorMessage(String)
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
                provider.login(["username": username, "password": password])
                    .map { response in
                        do {
                            let filteredResponse = try response.filterSuccessfulStatusCodes()
                            if let jsonRespose = try filteredResponse.mapJSON() as? [String: Any], let meta = jsonRespose["meta"] as? [String: Any], let token = meta["auth_token"] as? String {
                                self.authManager.setToken(token: token)
                            }
                            return Mutation.setLoginSuccess(true)
                        }
                        catch let error {
                            return Mutation.setErrorMessage(error.localizedDescription)
                        }
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
}

