//
//  AuthManager.swift
//  snuev-ios
//
//  Created by 이동현 on 20/01/2019.
//  Copyright © 2019 이동현. All rights reserved.
//

import Foundation
import KeychainSwift

protocol Auth {
    func setToken(token: String)

    func logout()
    // c
}

final class AuthManager: Auth {
    let keychain = KeychainSwift()
    
    func setToken(token: String) {
        keychain.set(token, forKey: "access_token")
    }
    
    func logout() {
        keychain.clear()
    }
}
