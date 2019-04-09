//
//  NetworkProvider.swift
//  snuev-ios
//
//  Created by 이동현 on 01/03/2019.
//  Copyright © 2019 이동현. All rights reserved.
//

import Foundation

protocol NetworkProvider {
    func makeLoginNetwork() -> LoginNetwork
}

final class DefaultNetworkProvider: NetworkProvider {
    public func makeLoginNetwork() -> LoginNetwork {
        return MoyaLoginNetwork()
    }
}
