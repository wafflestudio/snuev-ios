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
    private let loginUseCase: LoginUseCase
    private let departmentUseCase: DepartmentUseCase
    
    let initialState: State
    
    init(loginUseCase: LoginUseCase, departmentUseCase: DepartmentUseCase) {
        self.loginUseCase = loginUseCase
        self.departmentUseCase = departmentUseCase
        self.initialState = State()
    }
    
    enum Action {
        case signupRequest(username: String?, department: String?, nickname: String?, password: String?)
        case fetchDepartment
    }
    
    enum Mutation {
        case setErrorMessage(String)
        case setIsLoading
        case setDepartments([Department])
        case setSignupSuccess
    }
    
    struct State {
        var signup = ""
        var errorMessage: String?
        var isLoading = false
        var signupSuccess = false
        
        var departments: [Department] = []
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchDepartment:
            return departmentUseCase.fetchDepartments().flatMap { resource -> Observable<Mutation> in
                switch resource.status {
                case .Success:
                    guard let departments = resource.data else {
                        return .empty()
                    }
                    return .just(.setDepartments(departments))
                default:
                    return .empty()
                }
            }
        case let .signupRequest(username, department, nickname, password):
            guard let username = username, !username.isEmpty else {
                return Observable.just(Mutation.setErrorMessage("마이스누 계정을 입력하세요."))
            }
            
            guard let department = department, !department.isEmpty else {
                return Observable.just(Mutation.setErrorMessage("학과명을 선택하세요."))
            }
            
            guard let nickname = nickname, !nickname.isEmpty else {
                return Observable.just(Mutation.setErrorMessage("별명을 입력하세요."))
            }
            
            guard let password = password, !password.isEmpty else {
                return Observable.just(Mutation.setErrorMessage("비밀번호를 입력하세요."))
            }
            
            if password.count < 8 {
                return Observable.just(Mutation.setErrorMessage("비밀번호가 너무 짧습니다."))
            }
            return loginUseCase.signup(username: username, password: password, nickname: nickname, department: department)
                    .map { resource in
                        switch resource.status {
                        case .Success:
                            return .setSignupSuccess
                        case .Loading:
                            return .setIsLoading
                        case .Failure:
                            return .setErrorMessage(Constants.GENERAL_ERROR)
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
            
        case let .setErrorMessage(message):
            newState.errorMessage = message
            newState.isLoading = false
        case let .setDepartments(departments):
            newState.departments = departments
            
        case .setSignupSuccess:
            newState.signupSuccess = true
            newState.errorMessage = nil
            newState.isLoading = false
        }
        return newState
    }
}

