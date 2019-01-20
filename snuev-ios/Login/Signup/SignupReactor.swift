//
//  IssueReactor.swift
//  snuev-ios
//
//  Created by 김동욱 on 20/01/2019.
//  Copyright © 2019 이동현. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift
import Moya
import ObjectMapper

final class SingupViewReactor: Reactor {
    var provider = MoyaProvider<Login>()
    
    enum Action {
        case updateUsername(String)
        case updatePassword(String)
        case updateNickname(String)
        case searchDepartment
        case signupRequest()
    }
    
    enum Mutation {
        case setUsername(String)
        case setPassword(String)
        case setNickname(String)
        case setSignupSuccess(Bool)
        case setErrorMessage(String)
        case setIsLoading(Bool)
    }
    
    struct State {
        var username = ""
        var password = ""
        var nickname = ""
        var signup = ""
        var errorMessage = ""
        var isLoading = false
        var singupSuccess = false
    }
    
    let initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateUsername(username):
            return Observable.just(Mutation.setUsername(username))
        case let .updatePassword(password):
            return Observable.just(Mutation.setPassword(password))
        case let .updateNickname(nickname):
            return Observable.just(Mutation.setNickname(nickname))
        case .signupRequest():
            return Observable.concat([
                Observable.just(Mutation.setIsLoading(true)),
                signup(username: currentState.username, password: currentState.password, nickname: currentState.nickname, department_id: currentState.department_id)
                    .map { (response: Response) in
                        if response.statusCode == 200 {
                            return Mutation.setSignupSuccess(true)
                        } else {
                            if let json = try response.mapJSON() as? [String: Any], let message = json["erros"] as? String {
                                return Mutation.setErrorMessage(message)
                            }
                            return Mutation.setErrorMessage("Signup Failure")
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
    
    private func signup(username: String, password: String, nickname: String, deparment_id: String) -> Observable<Response> {
        return provider.rx.request(Login.signup(username: username, password: password, nickname: nickname, department_id: deparment_id))
            .debug()
            .subscribeOn(MainScheduler.instance)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .asObservable()
    }
}

