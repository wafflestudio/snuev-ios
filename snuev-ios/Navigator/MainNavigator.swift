//
//  MainNavigator.swift
//  snuev-ios
//
//  Created by 이동현 on 01/03/2019.
//  Copyright © 2019 이동현. All rights reserved.
//

import UIKit

protocol MainNavigator {
    func toMain()
}

class DefaultMainNavigator: MainNavigator {
    private let storyboard: UIStoryboard
    private let navigationController: UINavigationController
    private let network: NetworkProvider
    
    init(navigationController: UINavigationController, storyboard: UIStoryboard, network: NetworkProvider) {
        self.navigationController = navigationController
        self.storyboard = storyboard
        self.network = network
    }
    
    func toMain() { // test, 다시짜야함
        let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! SNUEVBaseViewController
        navigationController.pushViewController(vc, animated: true)
    }
}
