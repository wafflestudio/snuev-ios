//
//  ViewController.swift
//  snuev-ios
//
//  Created by 이동현 on 08/01/2019.
//  Copyright © 2019 이동현. All rights reserved.
//

import SafariServices

import UIKit
import ObjectMapper
import RxCocoa
import RxSwift
import Moya
import ReactorKit

class LoginViewController: UIViewController, StoryboardView {
    var disposeBag = DisposeBag()
    typealias Reactor = LoginViewReactor
    @IBOutlet weak var inputUsername: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var buttonLogin: SNUEVButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginViewReactor = LoginViewReactor()
        reactor = loginViewReactor
    }
    
    func bind(reactor: LoginViewReactor) {
        // Action
        inputUsername.rx.text
            .orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .map { Reactor.Action.updateUsername($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        inputPassword.rx.text
            .orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .map { Reactor.Action.updatePassword($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        buttonLogin.rx.tap
            .map { Reactor.Action.loginRequest() }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // State
        
        reactor.state.map { $0.loginSuccess }
            .subscribe(onNext: { success in
                if success {
                    print("login success!!!")
                }
            }).disposed(by: disposeBag)
    }
}

