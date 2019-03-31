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
    
    init(useCase: LoginUseCase, authManager: AuthManager, navigator: LoginNavigator) {
        self.useCase = useCase
        self.authManager = authManager
        self.navigator = navigator
    }
    
    enum Action {
        case updateQuery(String)
    }
    
    enum Mutation {
        case setQuery(String)
    }
    
    struct State {
        var query: String = ""
        var departments: [Department] = []
    }
    
    let initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateQuery(query):
            return Observable.just(Mutation.setQuery(query))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setQuery(query):
            var newState = state
            newState.query = query
            return newState
        }
    }
}

