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
    func toMain()
    func toSearchDepartment(_: [Department]?)
}

class DefaultLoginNavigator: LoginNavigator {
    private let storyboard: UIStoryboard
    private let navigationController: UINavigationController
    private let network: Network
    
    var mainNavigator: MainNavigator?
    
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
        let vc = storyboard.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        vc.reactor = SignupViewReactor(provider: network.makeLoginNetwork(), authManager: AuthManager(), navigator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toMain() {
        mainNavigator?.toMain()
    }
    
    func toSearchDepartment(_ departments: [Department]?) {
        let vc = storyboard.instantiateViewController(withIdentifier: "SearchDepartmentViewController") as! SearchDepartmentViewController
        vc.reactor = SearchDepartmentViewReactor(provider: network.makeLoginNetwork(), authManager: AuthManager(), navigator: self)
        vc.departments = departments
        navigationController.pushViewController(vc, animated: true)
    }
}
