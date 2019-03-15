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
        let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        
        let mainNavigator = DefaultMainNavigator(navigationController: navigationController, storyboard: mainStoryboard, network: network)
        let loginNavigator = DefaultLoginNavigator(navigationController: navigationController, storyboard: loginStoryboard, network: network)
        
        loginNavigator.mainNavigator = mainNavigator

        window.rootViewController = navigationController
        loginNavigator.toLogin()
    }
}