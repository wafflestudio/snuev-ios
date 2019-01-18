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
    @IBOutlet weak var btnSignin: SNUEVButton!
    @IBOutlet weak var btnFindPassword: SNUEVButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor = LoginViewReactor()
        buttonLogin.setButtonType(.Square)
        btnSignin.setButtonType(.withRoundImage)
        btnFindPassword.setButtonType(.withRoundImage)
    }
    
    func bind(reactor: LoginViewReactor) {
        // Action
        buttonLogin.rx.tap
            .map { Reactor.Action.loginRequest(username: self.inputUsername.text, password: self.inputPassword.text) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // State
        
        reactor.state.map { $0.loginSuccess }
            .subscribe(onNext: { success in
                if success {
                    print("login success!!!")
                }
            }).disposed(by: disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .distinctUntilChanged()
            .subscribe(onNext: { error in
                if !error.isEmpty {
                    print(error)
                }
            }).disposed(by: disposeBag)
    }
}

