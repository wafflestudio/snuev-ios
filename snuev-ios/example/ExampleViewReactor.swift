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

final class ExampleViewReactor: Reactor {
    var provider = MoyaProvider<Example>()
    
    enum Action {
        case updateQuery(String)
        case loadNextPage
    }
    
    enum Mutation {
        case setQuery(String)
        case setRepos([Repository], nextPage: Int?)
        case appendRepos([Repository], nextPage: Int?)
        case setLoadingNextPage(Bool)
    }
    
    struct State {
        var query: String = ""
        var repos: [Repository] = []
        var nextPage: Int?
        var isLoadingNextPage: Bool = false
    }
    
    let initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateQuery(query):
            return Observable.concat([
                // 1) set current state's query (.setQuery)
                Observable.just(Mutation.setQuery(query)),
                
                // 2) call API and set repos (.setRepos)
                self.search(query: query, page: 1)
                    // cancel previous request when the new `.updateQuery` action is fired
                    .takeUntil(self.action.filter(isUpdateQueryAction))
                    .map { repos in
                        if let repos = repos {
                            let nextPage = repos.incompleteResults ? nil : 2
                            return Mutation.setRepos(repos.items, nextPage: nextPage)
                        }
                        return Mutation.setRepos([], nextPage: nil)
                },
                ])
        case .loadNextPage:
            guard !self.currentState.isLoadingNextPage else { return Observable.empty() } // prevent from multiple requests
            guard let page = self.currentState.nextPage else { return Observable.empty() }
            return Observable.concat([
                // 1) set loading status to true
                Observable.just(Mutation.setLoadingNextPage(true)),
                
                // 2) call API and append repos
                self.search(query: self.currentState.query, page: page)
                    .takeUntil(self.action.filter(isUpdateQueryAction))
                    .map { repos in
                        if let repos = repos {
                            let nextPage = repos.incompleteResults ? nil : 2
                            return Mutation.appendRepos(repos.items, nextPage: nextPage)
                        }
                        return Mutation.appendRepos([], nextPage: nil)
                },
                // 3) set loading status to false
                Observable.just(Mutation.setLoadingNextPage(false)),
                ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setQuery(query):
            var newState = state
            newState.query = query
            return newState
            
        case let .setRepos(repos, nextPage):
            var newState = state
            newState.repos = repos
            newState.nextPage = nextPage
            return newState
            
        case let .appendRepos(repos, nextPage):
            var newState = state
            newState.repos.append(contentsOf: repos)
            newState.nextPage = nextPage
            return newState
            
        case let .setLoadingNextPage(isLoadingNextPage):
            var newState = state
            newState.isLoadingNextPage = isLoadingNextPage
            return newState
        }
    }
    
    private func url(for query: String?, page: Int) -> URL? {
        guard let query = query, !query.isEmpty else { return nil }
        return URL(string: "https://api.github.com/search/repositories?q=\(query)&page=\(page)")
    }
    
    private func search(query: String, page: Int) -> Observable<RepositorySearch?> {
        return provider.rx.request(Example.search(query: query, page: page))
            .debug()
            .subscribeOn(MainScheduler.instance)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .filterSuccessfulStatusCodes()
            .do(onSuccess: {response in
                let json = try response.mapJSON()
                if let a = json as? [String: Any] {
                    print(a)
                }
            })
            .mapJSON()
            .map { search in
                return Mapper<RepositorySearch>().map(JSONObject: search)
            }
            .asObservable()
            .observeOn(MainScheduler.instance)
            .do(onError: { error in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if case let .some(.httpRequestFailed(response, _)) = error as? RxCocoaURLError, response.statusCode == 403 {
                    print("⚠️ GitHub API rate limit exceeded. Wait for 60 seconds and try again.")
                }
            })
            .catchErrorJustReturn(nil)
    }
    
    private func isUpdateQueryAction(_ action: Action) -> Bool {
        if case .updateQuery = action {
            return true
        } else {
            return false
        }
    }
}

