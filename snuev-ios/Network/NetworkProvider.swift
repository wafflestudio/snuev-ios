//
//  NetworkProvider.swift
//  snuev-ios
//
//  Created by 이동현 on 01/03/2019.
//  Copyright © 2019 이동현. All rights reserved.
//

import Foundation

final class Network {
    public func makeLoginNetwork() -> LoginNetwork {
        let provider = MoyaLoginNetwork()
        return LoginNetwork(provider)
    }
}
