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

class LoginViewController: SNUEVBaseViewController, StoryboardView {
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
            .filter { $0 != nil }
            .subscribe(onNext: { success in
                if success == true {
                    self.showToast(message: "Login success!!!")
                } else {
                    self.showToast(message: "Login Error")
                }
            }).disposed(by: disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .filter { $0 != nil }
            .subscribe(onNext: { error in
                if let error = error, !error.isEmpty {
                    self.showToast(message: error)
                }
            }).disposed(by: disposeBag)
    }
}
