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
    var authManager: AuthManager
    
    init(provider: MoyaProvider<Login>, authManager: AuthManager) {
        self.provider = provider
        self.authManager = authManager
    }
    
    enum Action {
        case fetchDepartments
        case signupRequest(username: String?, department: String?, nickname: String?, password: String?)
    }
    
    enum Mutation {
        case setErrorMessage(String)
        case setIsLoading(Bool)
        case setDepartments([String: String])
        case setSignupSuccess(Bool)
    }
    
    struct State {
        var signup = ""
        var errorMessage: String?
        var isLoading = false
        var signupSuccess = false
        var departments: [String: String] = [:]
    }
    
    let initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .signupRequest(username, department, nickname, password):
            guard let username = username, !username.isEmpty else {
                return Observable.just(Mutation.setErrorMessage("Enter username"))
            }
            
            guard let department = department, !department.isEmpty else {
                return Observable.just(Mutation.setErrorMessage("Enter department"))
            }
            
            guard let nickname = nickname, !nickname.isEmpty else {
                return Observable.just(Mutation.setErrorMessage("Enter nickname"))
            }
            
            guard let password = password, !password.isEmpty else {
                return Observable.just(Mutation.setErrorMessage("Enter password"))
            }
            
            if password.count < 8 {
                return Observable.just(Mutation.setErrorMessage("Password too short"))
            }
        
            return Observable.concat([
                Observable.just(Mutation.setIsLoading(true)),
                signup(username: username, password: password, nickname: nickname, department: department)
                    .map { response in
                        do {
                            let filteredResponse = try response.filterSuccessfulStatusCodes()
                            if let jsonRespose = try filteredResponse.mapJSON() as? [String: Any], let meta = jsonRespose["meta"] as? [String: Any], let token = meta["auth_token"] as? String {
                                self.authManager.setToken(token: token)
                            }
                            return Mutation.setSignupSuccess(true)
                        }
                        catch let error {
                            let decodedResponse = try Japx.Decoder.jsonObject(withJSONAPIObject: response.mapJSON() as! Parameters)
                            let errors = decodedResponse["errors"] as! [[String: Any]]
                            let errors2 = errors[0] as! [String: String]
                            let errorTitle = errors2["title"]
                            return Mutation.setErrorMessage(errorTitle!)
                        }
                }
            ])
        case let .fetchDepartments:
            return Observable.concat([
                Observable.just(Mutation.setIsLoading(true)),
                fetchDepartments()
                    .map { response in
                        do {
                            let filteredResponse = try response.filterSuccessfulStatusCodes()
                            let decodedResponse = try Japx.Decoder.jsonObject(withJSONAPIObject: response.mapJSON() as! Parameters)
                            let departments = decodedResponse["data"] as! [[String: Any]]
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
        case let .setIsLoading(isLoading):
            newState.isLoading = isLoading
            
        case let .setErrorMessage(message):
            newState.errorMessage = message
            
        case let .setDepartments(departments):
            newState.departments = departments
            
        case let .setSignupSuccess(success):
            newState.signupSuccess = success
            newState.errorMessage = nil
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
    
    private func signup(username: String, password: String, nickname: String, department: String) -> Observable<Response> {
        return provider.rx.request(Login.signup(username: username, password: password, nickname: nickname, department: department))
            .subscribeOn(MainScheduler.instance)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .asObservable()
    }
}
