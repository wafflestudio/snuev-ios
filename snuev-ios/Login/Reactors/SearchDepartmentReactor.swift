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
    init(departments: [Department]) {
        self.initialState = State(departments: departments)
    }
    
    enum Action {
        case updateQuery(String)
    }
    
    enum Mutation {
        case setDepartments([Department])
    }
    
    struct State {
        var departments: [Department] = []
    }
    
    let initialState: State
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateQuery(query):
            let filteredDepartments = initialState.departments.filter {
                $0.name.hasPrefix(query)
            }
            return Observable.just(Mutation.setDepartments(filteredDepartments))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setDepartments(departments):
            newState.departments = departments
        }
        return newState
    }
}

