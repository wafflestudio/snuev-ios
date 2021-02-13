
//
//  VerifyEmailViewReactor.swift
//  snuev-ios
//
//  Created by 김동욱 on 10/04/2019.
//  Copyright © 2019 이동현. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift
import Moya

final class VerifyEmailViewReactor: Reactor {
    var useCase: LoginUseCase
    
    init(useCase: LoginUseCase) {
        self.useCase = useCase
    }
    
    
    enum Action {
    }
    
    enum Mutation {
    }
    
    struct State {
    }
    
    let initialState = State()
}

