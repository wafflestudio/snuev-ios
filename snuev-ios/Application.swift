//
//  Application.swift
//  snuev-ios
//
//  Created by 이동현 on 01/03/2019.
//  Copyright © 2019 이동현. All rights reserved.
//
import Foundation
import UIKit

final class Application {
    static let shared = Application()
    
    private let network: Network
    
    private init() {
        self.network = Network()
    }
    
    func configureMainInterface(in window: UIWindow) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        let navigator = DefaultLoginNavigator(navigationController: navigationController, storyboard: storyboard, network: network)

        window.rootViewController = navigationController
        navigator.toLogin()
    }
}
