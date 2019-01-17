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
        case updateUsername(String)
        case updatePassword(String)
        case loginRequest()
    }
    
    enum Mutation {
        case setUsername(String)
        case setPassword(String)
        case setLoginSuccess(Bool)
        case setErrorMessage(String)
        case setIsLoading(Bool)
    }
    
    struct State {
        var query: String = ""
        var repos: [Repository] = []
        var nextPage: Int?
        var isLoadingNextPage: Bool = false
        
        var username = ""
        var password = ""
        var errorMessage = ""
        var isLoading = false
        var loginSuccess = false
    }
    
    let initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateUsername(username):
            return Observable.just(Mutation.setUsername(username))
        case let .updatePassword(password):
            return Observable.just(Mutation.setPassword(password))
        case .loginRequest():
            return Observable.concat([
                    Observable.just(Mutation.setIsLoading(true)),
                    login(username: currentState.username, password: currentState.password)
                        .map { (response: Response) in
                        if response.statusCode == 200 {
                            return Mutation.setLoginSuccess(true)
                        } else {
                            if let json = try response.mapJSON() as? [String: Any], let message = json["erros"] as? String {
                                return Mutation.setErrorMessage(message)
                            }
                            return Mutation.setErrorMessage("Login Failure")
                        }
                    }
                ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setUsername(username):
            newState.username = username
            print(username)
            
        case let .setPassword(password):
            newState.password = password
            print(password)
            
        case let .setIsLoading(isLoading):
            newState.isLoading = isLoading
            
        case let .setLoginSuccess(success):
            newState.loginSuccess = success
            
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

