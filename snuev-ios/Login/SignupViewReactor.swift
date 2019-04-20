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
    var useCase: LoginUseCase
    var authManager: AuthManager
    var navigator: LoginNavigator
    
    init(useCase: LoginUseCase, authManager: AuthManager, navigator: LoginNavigator) {
        self.useCase = useCase
        self.authManager = authManager
        self.navigator = navigator
    }
    
    enum Action {
        case signupRequest(username: String?, department: String?, nickname: String?, password: String?)
        case setDepartmentTable(searchText: String?)
    }
    
    enum Mutation {
        case setErrorMessage(String)
        case setIsLoading(Bool)
        case setDepartments([String: String])
        case setSignupSuccess(Bool)
        case setDepartmentTables([String])
    }
    
    struct State {
        var signup = ""
        var errorMessage: String?
        var isLoading = false
        var signupSuccess = false
        var departments = [String: String]()
        var d = ["csi", "com", "bbdb"]
        var searchText: String?
        var selectedDepartments: [String]?
    }
    
    let initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .setDepartmentTable(searchText):
            guard let searchText = searchText, !searchText.isEmpty else {
                return Observable.just(Mutation.setDepartmentTables(self.currentState.d))
            }
            let filteredDepts = self.currentState.d.filter {
                return $0.range(of: searchText) != nil
            }
            return Observable.just(Mutation.setDepartmentTables(filteredDepts))

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
                useCase.signup(["username": username, "password": password, "nickname": nickname, "department_id": department])
                    .map { response in
                        do {
                            let filteredResponse = try response.filterSuccessfulStatusCodes()
                            if let jsonRespose = try filteredResponse.mapJSON() as? [String: Any], let meta = jsonRespose["meta"] as? [String: Any], let token = meta["auth_token"] as? String {
                                self.authManager.setToken(token: token)
                            }
                            return Mutation.setSignupSuccess(true)
                        }
                        catch let error {
                            return Mutation.setErrorMessage("error")
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
        
        case let .setDepartmentTables(Departments):
            newState.selectedDepartments = Departments
        }
        
        return newState
    }
    
    func fetchDepartments() -> Driver<[Department]?> {
        return useCase.fetchDepartments()
    }
    // to view
    
    func toMain() {
        navigator.toMain()
    }
    
    func toLogin() {
        navigator.toLogin()
    }
    
    func toSearchDepartment(_ departments: [Department]?) {
        navigator.toSearchDepartment(departments)
    }
}

