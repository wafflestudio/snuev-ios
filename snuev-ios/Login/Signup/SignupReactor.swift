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
import Japx

final class SignupViewReactor: Reactor {
    var provider = MoyaProvider<Login>()
    
    enum Action {
        case updateUsername(String)
        case updatePassword(String)
        case fetchDepartments
    }
    
    enum Mutation {
        case setUsername(String)
        case setPassword(String)
        case setErrorMessage(String)
        case setIsLoading(Bool)
        case setDepartments([String: String])
    }
    
    struct State {
        var username = ""
        var password = ""
        var nickname = ""
        var signup = ""
        var errorMessage = ""
        var isLoading = false
        var signupSuccess = false
        var departments: [String: String] = [:]
    }
    
    let initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateUsername(username):
            return Observable.just(Mutation.setUsername(username))
        case let .updatePassword(password):
            return Observable.just(Mutation.setPassword(password))
        case let .fetchDepartments:
            return Observable.concat([
                Observable.just(Mutation.setIsLoading(true)),
                fetchDepartments()
                    .map { response in
                        do {
                            let filteredResponse = try response.filterSuccessfulStatusCodes()
                            let x = try Japx.Decoder.jsonObject(withJSONAPIObject: response.mapJSON() as! Parameters)
                            let departments = x["data"] as! [[String: Any]]
                            let y = departments.makeIterator()
                            var departmentDictionary = [String: String]()
                            let depts = departments.makeIterator()
                            for index in depts {
                                departmentDictionary.updateValue(index["name"] as! String, forKey: index["id"] as! String)
                            }
                            let sortedDepartment = departmentDictionary.sorted(by: { $0.key < $1.key })
                            return Mutation.setDepartments(departmentDictionary)
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
        case let .setUsername(username):
            newState.username = username
            print(username)
            
        case let .setPassword(password):
            newState.password = password
            print(password)
            
        case let .setIsLoading(isLoading):
            newState.isLoading = isLoading
            
        case let .setErrorMessage(message):
            newState.errorMessage = message
            
        case let .setDepartments(departments):
            newState.departments = departments
        }
        return newState
    }
    
    private func fetchDepartments() -> Observable<Response> {
        return provider.rx.request(Login.fetchDepartments)
            .debug()
            .subscribeOn(MainScheduler.instance)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .asObservable()
    }
    
}

