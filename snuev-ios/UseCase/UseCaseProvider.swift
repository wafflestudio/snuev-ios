//
//  UseCaseProvider.swift
//  snuev-ios
//
//  Created by 이동현 on 31/03/2019.
//  Copyright © 2019 이동현. All rights reserved.
//

import Foundation

protocol UseCaseProvider {
    func makeLoginUseCase() -> LoginUseCase
}

final class DefaultUseCaseProvider: UseCaseProvider {
    private let networkProvider: NetworkProvider
    
    public init() {
        networkProvider = DefaultNetworkProvider()
    }
    
    func makeLoginUseCase() -> LoginUseCase {
        return DefaultLoginUseCase(netWork: networkProvider.makeLoginNetwork())
    }
}

