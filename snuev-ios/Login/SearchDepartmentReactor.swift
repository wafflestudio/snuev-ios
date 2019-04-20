//
//  SearchDepartmentReactor.swift
//  snuev-ios
//
//  Created by easi6 on 2019. 3. 2..
//  Copyright © 2019년 김동욱. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift
import Moya
import ObjectMapper

final class SearchDepartmentViewReactor: Reactor {
    var useCase: LoginUseCase
    var authManager: AuthManager
    var navigator: LoginNavigator
    var departments: [Department] = []
    
    init(useCase: LoginUseCase, authManager: AuthManager, navigator: LoginNavigator, departments: [Department]?) {
        self.useCase = useCase
        self.authManager = authManager
        self.navigator = navigator
        self.initialState = State(departments: departments)
    }
    
    enum Action {
        case updateQuery(String)
    }
    
    enum Mutation {
        case setQuery(String)
        case setDepartments([Department])
    }
    
    struct State {
        var query: String = ""
        var departments: [Department]
        
        init(departments: [Department]?) {
            self.departments = departments ?? []
        }
    }
    
    let initialState: State
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateQuery(query):
            return Observable.concat([
                Observable.just(Mutation.setQuery(query)),
                Observable.just(Mutation.setDepartments(initialState.departments.filter{
                    $0.name.hasPrefix(query)
                }))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setQuery(query):
            var newState = state
            newState.query = query
            return newState
        case let .setDepartments(departments):
            var newState = state
            newState.departments = departments
            return newState
        }
    }
    
    func popToSignup(department: Department) {
        navigator.popToSignup(department: department)
    }
}

