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
    var provider = MoyaProvider<Login>()
    
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
        var loginSuccess: Bool?
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
                login(username: username, password: password)
                    .map { response in
                        do {
                            let filteredResponse = try response.filterSuccessfulStatusCodes()
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
    
    private func url(for query: String?, page: Int) -> URL? {
        guard let query = query, !query.isEmpty else { return nil }
        return URL(string: "https://api.github.com/search/repositories?q=\(query)&page=\(page)")
    }
    
    private func login(username: String, password: String) -> Observable<Response> {
        return provider.rx.request(Login.login(username: username, password: password))
            .debug()
            .subscribeOn(MainScheduler.instance)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .asObservable()
    }
}

