//
//  navigator.swift
//  snuev-ios
//
//  Created by 이동현 on 01/03/2019.
//  Copyright © 2019 이동현. All rights reserved.
//

import UIKit

protocol LoginNavigator {
    func toLogin()
    func toSignup()
}

class DefaultLoginNavigator: LoginNavigator {
    private let storyboard: UIStoryboard
    private let navigationController: UINavigationController
    private let network: Network
    
    init(navigationController: UINavigationController, storyboard: UIStoryboard, network: Network) {
        self.navigationController = navigationController
        self.storyboard = storyboard
        self.network = network
    }
    
    func toLogin() {
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.reactor = LoginViewReactor(provider: network.makeLoginNetwork(), authManager: AuthManager(), navigator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toSignup() {
        
    }
}
